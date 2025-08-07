// Just use this line in all modern FPC sources.
{$ifdef FPC} {$mode objfpc}{$H+}{$J-} {$endif}
// Needed for console programs on Windows,
// otherwise (with Delphi) the default is GUI program without console.
{$ifdef MSWINDOWS} {$apptype CONSOLE} {$endif}

program day8;

uses
  //crt,
  Classes,
  SysUtils,
  Generics.Collections,
  RegExpr;

type
  TRegisters = specialize TDictionary<string, integer>;

  TOp = record
    dreg: string;
    operation: string;
    amount: integer;
    test_register: string;
    test: string;
    test_value: integer;
  end;

const
  IN_TEST = false;
  PART = 1;

  function GetDef(var regs: TRegisters; Register: string): integer;
  begin
    if not regs.containskey(Register) then
      regs.add(Register, 0);
    Result := regs[Register];
  end;

  procedure IncRegister(var regs: TRegisters; Register: string; amount: integer);
  begin
    if not regs.containskey(Register) then
      regs.add(Register, 0);
    regs[Register] := regs[Register] + amount;

  end;

  procedure DecRegister(var regs: TRegisters; Register: string; amount: integer);
  begin
    if not regs.containskey(Register) then
      regs.add(Register, 0);
    regs[Register] := regs[Register] - amount;
  end;

  function read_data_file(fname: string): TStringList;
  begin
    Result := TStringList.Create;
    try
      Result.loadfromfile(fname);
    except
      on E: Exception do
        WriteLn('Error reading file: ', E.ClassName, ': ', E.Message);
    end;
  end;

  function parse_line1(l: string): TOp;
  var
    r: TRegExpr;
  begin
    r := TregExpr.Create;
    try

      //r.expression := '^(\w+)\s+\((\d+)\)(?:\s+->\s+(.+))?$';
      r.expression :=
        '^(\w+)\s+(\w{3})\s+(-?\d+)\s+if\s+(\w+)\s+(<=|>=|!=|==|<|>)\s+(-?\d+)';

      if r.exec(l) then
      begin
        Result.dreg := r.match[1];
        Result.operation := r.match[2];
        Result.amount := StrToInt(r.match[3]);
        Result.test_register := r.match[4];
        Result.test := r.match[5];
        Result.test_value := StrToInt(r.match[6]);
      end
      else
        writeln('Failed to parse "', l, '"');
    finally
      r.Free;
    end;
  end;



  procedure print_op(op: TOp);
  begin
    writeln('   Target: ', op.dreg);
    writeln('Operation: ', op.operation);
    writeln('   Amount: ', op.amount);
    writeln(' Test Reg: ', op.test_register);
    writeln('     Test: ', op.test);
    writeln(' Test Val: ', op.test_value);
    writeln;
  end;

  function optest1(var regs: TRegisters; op: TOp): boolean;
  begin
    case op.test of
      '>': Result := getdef(regs, op.test_register) > op.test_value;
      '<': Result := getdef(regs, op.test_register) < op.test_value;
      '>=': Result := getdef(regs, op.test_register) >= op.test_value;
      '==': Result := getdef(regs, op.test_register) = op.test_value;
      '<=': Result := getdef(regs, op.test_register) <= op.test_value;
      '!=': Result := getdef(regs, op.test_register) <> op.test_value;
      else
        writeln('Unknown operation! "', op.test, '"');
    end;
  end;

  procedure apply_op1(var regs: TRegisters; op: TOp);
  begin
    if optest1(regs, op) then
      if op.operation = 'inc' then
        incregister(regs, op.dreg, op.amount)
      else
        decregister(regs, op.dreg, op.amount);
  end;

  procedure print_registers(regs: TRegisters);
  var
    reg: string;
  begin
    for reg in regs.Keys do
      writeln('Register: ', reg, ' has value: ', regs[reg]);
    writeln;
  end;


  function max_register1(regs: TRegisters; prev: integer): integer;
  var
    i: integer;
  begin
    Result := prev;
    for i in regs.Values do
      if i > Result then Result := i;
  end;

  procedure part1(infile: string);
  var
    datain: TStringList;
    registers: TRegisters;
    next_op: TOp;
    line: string;
    reg_val, biggest: integer;
    max_ever: integer;
  begin
    registers := TRegisters.Create;
    datain := read_data_file(infile);
    max_ever := 0;

    for line in datain do
    begin
      next_op := parse_line1(line);
      //print_op(next_op);
      apply_op1(registers, next_op);
      //print_registers(registers);
      max_ever := max_register1(registers, max_ever);
    end;

    biggest := 0;
    for reg_val in registers.values do
      if reg_val > biggest then biggest := reg_val;
    writeln('The largest value is: ', biggest);
    writeln('The largest value ever was: ', max_ever);
  end;

  procedure part2(infile: string);
  begin
  end;


var
  infile: string;
begin
  if IN_TEST then
    infile := 'day8test.txt'
  else
    infile := 'day8input.txt';

  if PART = 1 then
    part1(infile)
  else
    part2(infile);

  readln;
end.
