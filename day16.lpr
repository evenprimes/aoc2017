// Just use this line in all modern FPC sources.
{$ifdef FPC} {$mode objfpc}{$H+}{$J-} {$endif}
// Needed for console programs on Windows,
// otherwise (with Delphi) the default is GUI program without console.
{$ifdef MSWINDOWS} {$apptype CONSOLE} {$endif}

// https://adventofcode.com/2017/day/16

program day16;

uses
  //crt,
  Classes,
  SysUtils,
  Generics.Collections,
  RegExpr;

type
  TCharArray = array of char;

const
  IN_TEST = False;
  PART = 1;



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

  function parse_input(d: TStringList): TStringList;
  begin
    Result := TStringList.Create;
    Result.delimiter := ',';
    Result.delimitedText := d[0];
  end;

  function spin(l: TCharArray; op: string): TCharArray;
  var
    i, len, Count, offset: integer;
  begin
    //writeln('Spin started: ', op);
    Count := StrToInt(copy(op, 2, length(op) - 1));
    //writeln('  spinning ', Count, ' chars');
    len := length(l);
    offset := len - Count;
    setlength(Result, len);
    for i := 0 to high(l) do
      Result[i] := l[(i + offset) mod len];
  end;

  function swap_index(l: TChararray; op: string): TChararray;
  var
    i1, i2, len: integer;
    temp: char;
    parts: TStringList;
  begin
    len := length(l);
    setlength(Result, len);
    for i1 := 0 to high(l) do
      Result[i1] := l[i1];
    parts := TStringList.Create;
    parts.delimiter := '/';
    parts.delimitedText := copy(op, 2, length(op) - 1);
    i1 := StrToInt(parts[0]);
    i2 := StrToInt(parts[1]);
    //writeln('Swapping ', i1, ' / ', i2);
    temp := Result[i1];
    Result[i1] := Result[i2];
    Result[i2] := temp;
    parts.Free;
  end;

  function swap_values(l: TChararray; op: string): TChararray;
  var
    i1, i2, len, i: integer;
    v1, v2, temp: char;
    parts: TStringList;
  begin
    len := length(l);
    setlength(Result, len);
    parts := TStringList.Create;
    parts.delimiter := '/';
    parts.delimitedText := copy(op, 2, length(op) - 1);
    v1 := parts[0][1];
    v2 := parts[1][1];
    //writeln('Swapping ', v1, ' / ', v2);
    for i := 0 to high(l) do
    begin
      Result[i] := l[i];
      if l[i] = v1 then i1 := i;
      if l[i] = v2 then i2 := i;
    end;
    Result[i1] := v2;
    Result[i2] := v1;
    parts.Free;

    //temp := result[i1];
    //result[i1] := result[i2];
    //result[i2] := temp;
  end;

  procedure printarray(a: TCharArray);
  var
    i: integer;
  begin
    for i := 0 to high(A) do
      Write(a[i]);
    writeln;
  end;

  function isatstart(dance: TCHararray): boolean;
  var
    a, i: integer;
  begin
    a := Ord('a');
    Result := True;
    for i := 0 to high(dance) do
      if dance[i] <> chr(a + i) then Result := False;
  end;

  procedure part1(infilename: string);
  const
    ITERS = 1000000000;
  var
    oplist: TStringList;
    op: string;
    lineup: TCharArray;
    i, a: integer;
    rep, needed_reps: integer;
  begin
    writeln('Part 1 --------------------------');
    oplist := parse_input(read_data_file(infilename));

    // Create the lineup.
    if IN_TEST then
      setlength(lineup, 5)
    else
      setlength(lineup, 16);
    a := Ord('a');
    for i := 0 to high(lineup) do
      lineup[i] := chr(A + i);

    // Perform the operations
    for rep := 1 to iters do
    begin
      for op in oplist do
      begin
        //printarray(lineup);
        case op[1] of
          's': lineup := spin(lineup, op);
          'x': lineup := swap_index(lineup, op);
          'p': lineup := swap_values(lineup, op);
          else
            writeln('Unknown operation! "', op, '"');
        end;
      end;
      if isatstart(lineup) then
      begin
        needed_reps := rep;
        break;
      end;
    end;
    writeln('needed ', needed_reps, ' to repeat');

    for rep := 1 to (ITERS mod needed_reps) do
      for op in oplist do
      begin
        //printarray(lineup);
        case op[1] of
          's': lineup := spin(lineup, op);
          'x': lineup := swap_index(lineup, op);
          'p': lineup := swap_values(lineup, op);
          else
            writeln('Unknown operation! "', op, '"');
        end;
      end;

    printarray(lineup);

  end;

  procedure part2(infilename: string);
  begin
    writeln('Part 2 --------------------------');

  end;

var
  fname: string;
  dlength: integer;

begin
  if IN_TEST then
    fname := 'day16test.txt'
  else
    fname := 'day16input.txt';

  writeln('DAY 14');
  if PART = 1 then part1(fname);
  if PART = 2 then part2(fname);

  readln;
end.
