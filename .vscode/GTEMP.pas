// Just use this line in all modern FPC sources.
{$ifdef FPC} {$mode objfpc}{$H+}{$J-} {$endif}
// Needed for console programs on Windows,
// otherwise (with Delphi) the default is GUI program without console.
{$ifdef MSWINDOWS} {$apptype CONSOLE} {$endif}


// https://adventofcode.com/2017/day/14

program day14;

uses
  //crt,
  Classes,
  SysUtils,
  Generics.Collections,
  RegExpr;

const
  IN_TEST = True;
  PART = 1;


type
  TIntArray255 = array[0..255] of integer;
  TIntArray = array of integer;

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

  function get_ops2(datain: string): TIntArray;
    // 17, 31, 73, 47, 23
  var
    din: TStringList;
    i: integer;
    dlen: integer;
  begin
    //din := read_data_file(fname);
    dlen := length(datain);

    setlength(Result, dlen);
    //writeln(datain);
    for i := 0 to length(datain) - 1 do
    begin
      Result[i] := Ord(datain[i + 1]);
      //Write('"', datain[i + 1], '" ');
    end;
    //Result[dlen] := 17;
    //Result[dlen + 1] := 31;
    //Result[dlen + 2] := 73;
    //Result[dlen + 3] := 47;
    //Result[dlen + 4] := 23;
  end;

  function get_knot_hash(a: TIntArray255): string;
  var
    offset, i, j: integer;
    temphash: integer;
  begin
    Result := '';
    for i := 0 to 15 do
    begin
      offset := i * 16;
      temphash := 0;
      for j := 0 to 15 do
      begin
        temphash := temphash xor a[offset + j];
      end;
      Result := Result + hexstr(temphash, 2);
    end;
    Result := lowercase(Result);
  end;

  function fold_array(a: TIntArray255; start_pos: integer; move: integer): TIntArray255;
  var
    i: integer;
    from_pos, to_pos: integer;
  begin
    //setlength(Result, length(a));

    // First, just copy everything into the new array
    for i := 0 to high(a) do
      Result[i] := a[i];

    // Now, loop through just the part that's changing
    for i := 0 to move do
    begin
      // The -1 is to adjust for the 0-index array
      from_pos := (i + start_pos) mod length(a);
      to_pos := (start_pos + move - i) mod length(a);
      //writeln('    from index: ', from_pos, ' to index:', to_pos);
      Result[to_pos] := a[from_pos];
    end;
  end;

  function fold_knots_return_hash(moves: TIntArray): string;
  const
    ITERATIONS = 64;
  var
    pos, skip, i, mov: integer;
    knots: TIntArray255;
  begin
    for i := 0 to high(knots) do
      knots[i] := i;
    pos := 0;
    skip := 0;
    for i := 1 to ITERATIONS do
    begin
      for mov in moves do
      begin
        knots := fold_array(knots, pos, mov - 1);
        pos := pos + mov + skip;
        skip := skip + 1;
      end;
    end;
    Result := get_knot_hash(knots);
  end;

  function active_cells(hash: string): integer;
  var
    c: char;
    i, j: integer;
    n: integer;
  begin
    Result := 0;
    for j := 1 to length(hash) do
    begin
      n := strtoint('$'+ hash[j]);
      for i := 0 to 3 do
      begin
        if ((n shr i) and 1) = 1 then
          Inc(Result);
      end;
    end;

  end;

  procedure part1(infilename: string);
  var
    fold_ops: TIntArray;
    hash: string;
    row: integer;
    rowkey: string;
    squares: integer;
    h: TStringList;
  begin
    writeln('PART 1 ----------------');
    squares := 0;
    for  row := 0 to 127 do
    begin
      rowkey := infilename + '-' + IntToStr(row);
      fold_ops := get_ops2(rowkey);
      hash := fold_knots_return_hash(fold_ops);
      writeln(row, ' -- ', hash);
      squares := squares + active_cells(hash);
    end;
    writeln('Found ', squares, ' active squares');

    h:= TStringList.create;
    h.add('$cd');
    h.add('$42');
    h.add('$4c');
    h.add('$33');
    h.add('$58');
    h.add('$d3');
    h.add('$02');
    h.add('$2a');


    (*
    ##.#.#..
    1101 0100
    d4

    0 = 0000
    1 = 0001
    2 = 0010
    3 = 0011
    4 = 0100
    5 = 0101
    6 = 0110
    7 = 0111
    8 = 1000
    9 = 1001
    a = 1010
    b = 1011
    c = 1100
    d = 1101
    e = 1110
    f = 1111

    *)


  end;

  procedure part2(infilename: string);
  begin
    writeln('PART 2 ----------------');

  end;

var
  fname: string;

begin
  if IN_TEST then
    fname := 'flqrgnkx'
  else
    fname := 'hxtvlmkl';

  writeln('DAY 14');
  if PART = 1 then part1(fname);
  if PART = 2 then part2(fname);

  readln;
end.
