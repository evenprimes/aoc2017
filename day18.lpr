
// Just use this line in all modern FPC sources.
{$ifdef FPC} {$mode objfpc}{$H+}{$J-} {$endif}
// Needed for console programs on Windows,
// otherwise (with Delphi) the default is GUI program without console.
{$ifdef MSWINDOWS} {$apptype CONSOLE} {$endif}

// https://adventofcode.com/2017/day/17

program day18;

uses
  //crt,
  Classes,
  SysUtils,
  Generics.Collections,
  RegExpr;

const
  IN_TEST = false;
  PART = 1;

type
  TSecOp = class
    isReg: boolean;
    reg: integer;
    val: integer;
  end;

  TOp = class
    op: string;
    regi: integer;
    val: TSecOp;
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

  function IsSignedIntegerString(const s: string): boolean;
  var
    i: integer;
  begin
    if s = '' then
      Exit(False);

    // Handle optional leading + or -
    i := 1;
    if s[1] in ['+', '-'] then
    begin
      if Length(s) = 1 then
        Exit(False); // string is just "+" or "-", not valid
      i := 2;
    end;

    // Check remaining characters are digits
    for i := i to Length(s) do
      if not (s[i] in ['0'..'9']) then
        Exit(False);

    Result := True;
  end;

  function parse_op(s: string): Top;
  var
    parts: TStringList;
  begin
    Result := TOp.Create;
    parts := TStringList.Create;
    parts.Delimiter := ' ';
    parts.DelimitedText := s;
    writeln(s);
    Write(s, ' [0]: ', parts[0], ' [1]: "', parts[1], '"');


    Result.op := parts[0];

    Result.regi := Ord(parts[1][1]) - Ord('a');
    if not ((parts[0] = 'snd') or (parts[0] = 'rcv')) then
    begin
      Result.val := TSecOp.Create;
      if IsSignedIntegerString(parts[2]) then
      begin
        Result.val.isReg := False;
        Result.val.val := StrToInt(parts[2]);
      end
      else
      begin
        Result.val.isReg := True;
        Write('  [2-reg]: ', parts[2]);
        Result.val.reg := Ord(parts[2][1]) - Ord('a');
      end;

    end;
    writeln;
    parts.Free;
  end;

  procedure print_registers(regs: array of integer);
  var
    i: integer;
    chara: integer;
  begin
    chara := Ord('a');
    for i := low(regs) to high(regs) do
    begin
      writeln(chr(chara + i), ' : ', regs[i]);
    end;
  end;

var
  registers: array[0..25] of integer;
  ipointer: integer;
  last_played, recovered: integer;
  ilist: TStringList;
  fname: string;
  i: integer;
  op: TOp;



begin
  if IN_TEST then
    fname := 'day18test.txt'
  else
    fname := 'day18input.txt';

  writeln('DAY 18');
  for i := 0 to high(registers) do
    registers[i] := 0;

  ilist := read_data_file(fname);
  ipointer := 0;

  while ipointer < ilist.Count do
  begin
    op := parse_op(ilist[ipointer]);
    case op.op of
      'snd': last_played := registers[op.regi];
      'set': begin
        if op.val.isReg then
          registers[op.regi] := registers[op.val.reg]
        else
          registers[op.regi] := op.val.val;
      end;
      'add': begin
        if op.val.isReg then
          registers[op.regi] := registers[op.regi] + registers[op.val.reg]
        else
          registers[op.regi] := registers[op.regi] + op.val.val;
      end;
      'mul': begin
        if op.val.isReg then
          registers[op.regi] := registers[op.regi] * registers[op.val.reg]
        else
          registers[op.regi] := registers[op.regi] * op.val.val;
      end;
      'mod': begin
        if op.val.isReg then
          registers[op.regi] := registers[op.regi] mod registers[op.val.reg]
        else
          registers[op.regi] := registers[op.regi] mod op.val.val;
      end;
      'rcv': begin
        if registers[op.regi] <> 0 then
        begin
          recovered := last_played;
          writeln('Recovered sound: ', recovered);
          break;
        end;
      end;
      'jgz': begin

        if registers[op.regi] > 0 then
        begin
          writeln('Instruction pointer before: ', ipointer);
          writeln(Registers[op.regi]);
          if op.val.isReg then
            ipointer := ipointer + registers[op.val.reg]
          else
            ipointer := ipointer + op.val.val;
          writeln('Instruction pointer after: ', ipointer);
          //readln;
          continue;
        end;
      end;
      else
        writeln('Unknown op: ', ilist[ipointer]);
    end;
    print_registers(registers);
    Inc(ipointer);
    writeln('Instruction pointer: ', ipointer);
    //readln;
  end;

  writeln;
  writeln('Recovered sound: ', recovered);

  readln;

end.
