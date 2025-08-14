
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
      val: int64;
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

// function get(s: string; r: array of integer): integer;
// var 

// begin
// end;

function parse_op(s: string; r: array of int64): TOp2;
var 
  parts: TStringList;

begin
  Result := TOp2.create;
  parts := tstringlist.create;
  parts.Delimiter := ' ';
  parts.DelimitedText := s;
  writeln('in parse_op: ', s);

  Result.op := parts[0];
  if result.op = 'jgz' then
    begin
      if IsSignedIntegerString(parts[1]) then
        begin
          result.regi :=  StrToInt(parts[1])
        end
      else
        begin
          Result.regi := r[Ord(parts[1][1]) - Ord('a')];
        end;
    end
  else
    begin
      Result.regi := Ord(parts[1][1]) - Ord('a');
    end;
  result.val := 0;
  if not ((Result.op = 'snd') or (Result.op = 'rcv')) then
    begin
      if IsSignedIntegerString(parts[2]) then
        Result.val := StrToInt(parts[2])
      else
        Result.val := r[ord(parts[2][1]) - ord('a')];
    end;
  writeln('    resulting instruction: ', result.op, ' register: ', result.regi, ' value: '
          ,
          result.val);


end;

procedure print_registers(regs: array of int64);
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
  registers: array[0..25] of int64;
  ipointer: integer;
  last_played, recovered: int64;
  ilist: TStringList;
  fname: string;
  i: integer;
  op: TOp2;
  current_op: string;

begin
  write('DAY 18');
  if IN_TEST then
    begin
      fname := 'day18test.txt';
      writeln('  testing -----');
    end
  else
    begin
      fname := 'day18input.txt';
      writeln('  PROD ***************************************');
    end;

  ipointer := 0;
  recovered := -999;
  for i := 0 to high(registers) do
    registers[i] := 0;
  ilist := read_data_file(fname);

  while (ipointer >= 0) and (ipointer < ilist.Count) do
    begin
      op := parse_op(ilist[ipointer], registers);

      case op.op of 
        'jgz':
               begin
                 if op.regi > 0 then
                   begin
                     writeln('-- -- JGZ triggered by ', op.val);
                     write('-- -- -- ipointer from ', ipointer);
                     ipointer := ipointer + op.val;
                     writeln(' to ', ipointer);
                     print_registers(registers);
                     readln;
                     continue;
                   end;
               end;
        'snd':
               begin
                 writeln('-- -- SND at tone ', registers[op.regi]);
                 last_played := registers[op.regi];
               end;
        'set': registers[op.regi] := op.val;
        'add': registers[op.regi] := registers[op.regi] + op.val;
        'mul': registers[op.regi] := registers[op.regi] * op.val;
        'mod': registers[op.regi] := registers[op.regi] mod op.val;
        'rcv':
               begin
                 writeln('rcv ', op.regi);
                 if registers[op.regi] <> 0 then
                   begin
                     writeln('-- -- valid rcv');
                     recovered := last_played;
                     break;
                   end;
               end;
        else writeln('unknown operation! ', op.op);
      end;
      if registers[15] < 0 then writeln('register p went negative: ', registers[15]);
      inc(ipointer);
      op.Free;
    end;
  writeln;
  writeln('Recovered ', recovered);

end.
