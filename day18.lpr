
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

    TOp2 = class
      op: string;
      // index of the register for first operand
      regi: integer;
      // value of the second operand, may need to lookup current register value
      val: integer;
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
        Exit(False);
      // string is just "+" or "-", not valid
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
  //Write(s, ' [0]: ', parts[0], ' [1]: "', parts[1], '"');


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
          //Write('  [2-reg]: ', parts[2]);
          Result.val.reg := Ord(parts[2][1]) - Ord('a');
        end;

    end;
  //writeln;
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

procedure part1_try1;
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

  write('DAY 18');
  if IN_TEST then
    writeln('   TEST')
  else
    writeln('    PROD *********************');
  writeln;

  for i := 0 to high(registers) do
    registers[i] := 0;

  ilist := read_data_file(fname);
  ipointer := 0;

  while (ipointer >= 0) and (ipointer < ilist.Count) do
    begin
      writeln('Starting instruction pointer: ', ipointer);
      op := parse_op(ilist[ipointer]);
      case op.op of 
        'snd':
               begin
                 last_played := registers[op.regi];
                 writeln('    Sound played from register "', op.regi, '" and frequency ',
                         registers[op.regi])
               end;
        'set':
               begin
                 if op.val.isReg then
                   registers[op.regi] := registers[op.val.reg]
                 else
                   registers[op.regi] := op.val.val;
               end;
        'add':
               begin
                 if op.val.isReg then
                   registers[op.regi] := registers[op.regi] + registers[op.val.reg]
                 else
                   registers[op.regi] := registers[op.regi] + op.val.val;
               end;
        'mul':
               begin
                 if op.val.isReg then
                   registers[op.regi] := registers[op.regi] * registers[op.val.reg]
                 else
                   registers[op.regi] := registers[op.regi] * op.val.val;
               end;
        'mod':
               begin
                 if op.val.isReg then
                   registers[op.regi] := registers[op.regi] mod registers[op.val.reg]
                 else
                   registers[op.regi] := registers[op.regi] mod op.val.val;
               end;
        'rcv':
               begin
                 if registers[op.regi] <> 0 then
                   begin
                     recovered := last_played;
                     writeln('Recovered sound: ', recovered);
                     print_registers(registers);
                     break;
                   end
                 else
                   writeln('No sound recovered');
               end;
        'jgz':
               begin

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
                     // Skip the rest of the loop since this is a jump
                   end;
               end;
        else
          writeln('Unknown op: ', ilist[ipointer]);
      end;
      //print_registers(registers);
      Inc(ipointer);
      writeln('Ending instruction pointer: ', ipointer);
      writeln;
      //readln;
    end;

  writeln;
  writeln('Recovered sound: ', recovered);

  readln;
end;

begin

end.
