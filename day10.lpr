// Just use this line in all modern FPC sources.
{$ifdef FPC} {$mode objfpc}{$H+}{$J-} {$endif}
// Needed for console programs on Windows,
// otherwise (with Delphi) the default is GUI program without console.
{$ifdef MSWINDOWS} {$apptype CONSOLE} {$endif}



program day10;
// From:  https://adventofcode.com/2017/day/10

uses
  //crt,
  Classes,
  SysUtils,
  Generics.Collections,
  RegExpr;

const
  IN_TEST = false;
  PART = 2;

type
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

  function get_ops(fname: string): TIntArray;
  var
    din, ops: TStringList;
    i: integer;
  begin
    din := read_data_file(fname);
    ops := TStringList.Create;
    ops.delimiter := ',';
    ops.delimitedText := din[0];

    setlength(Result, ops.Count);
    for i := 0 to high(Result) do
      Result[i] := StrToInt(ops[i]);
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

    setlength(Result, dlen + 5);
    //writeln(datain);
    for i := 0 to length(datain) - 1 do
    begin
      Result[i] := Ord(datain[i + 1]);
      //Write('"', datain[i + 1], '" ');
    end;
    Result[dlen] := 17;
    Result[dlen + 1] := 31;
    Result[dlen + 2] := 73;
    Result[dlen + 3] := 47;
    Result[dlen + 4] := 23;

  end;

  procedure print_array(a: TIntArray);
  var
    i: integer;
  begin
    for i := 0 to high(a) do
      Write(a[i], ' ');
    writeln;
  end;

  function fold_array(a: TIntArray; start_pos: integer; move: integer): TIntArray;
  var
    i: integer;
    from_pos, to_pos: integer;
  begin
    setlength(Result, length(a));

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

  procedure part1(infile: string);
  var
    skip, pos: integer;
    len: integer;
    knots: TIntArray;
    moves: TIntArray;
    i, tmp: integer;
  begin
    writeln('Part 1 ---------------------------');
    if IN_TEST then
      len := 5
    else
      len := 256;
    setlength(knots, len);

    for i := 0 to high(knots) do
      knots[i] := i;

    writeln('Knots:');
    print_array(knots);

    moves := get_ops(infile);
    writeln('Moves:');
    print_array(moves);

    pos := 0;
    skip := 0;
    for i in moves do
    begin
      writeln('Current pos: ', pos, ' skip: ', skip);
      knots := fold_array(knots, pos, i - 1);
      writeln('Move: ', i);
      print_array(knots);
      writeln;
      pos := pos + i + skip;
      skip := skip + 1;
    end;
    writeln;
    writeln('The check value is: ', knots[0] * knots[1]);

  end;

  function get_knot_hash(a: TIntArray): string;
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

  procedure p2testhash;
  const
    tarray: array[0..15] of integer =
      (65, 27, 9, 1, 4, 3, 40, 50, 91, 7, 6, 0, 2, 5, 68, 22);
  var

    th: integer;
    i: integer;
  begin
    th := 0;
    for  i := 0 to 15 do
      th := th xor tarray[i];
    if th = 64 then
      Write('PASSED ')
    else
      Write('FAILED ');
    writeln('Expect 64, got ', th);
  end;

  procedure part2(infile: string);
  const
    ITERATIONS = 64;
  var
    skip, pos: integer;
    len: integer;
    knots: TIntArray;
    moves: TIntArray;
    i, iteration, tmp: integer;
    test_cases: specialize TDictionary<string, string>;
    test_moves: string;
    knot_hash: string;
    real_moves: TStringList;
  begin

    writeln('part 2 ----------------------');
    //if IN_TEST then
    //  len := 5
    //else
    len := 256;
    setlength(knots, len);
    for i := 0 to high(knots) do
      knots[i] := i;

    test_cases := specialize TDictionary<string, string>.Create;
    test_cases.add('', 'a2582a3a0e66e6e86e3812dcb672a272');
    test_cases.add('AoC 2017', '33efeb34ea91902bb2f59c9920caa6cd');
    test_cases.add('1,2,3', '3efbe78a8d82f29979031a4aa0b16a9d');
    test_cases.add('1,2,4', '63960835bcdc130f0b66d7ff4f6a5a8e');

     real_moves := read_data_file(infile);
     test_cases.add(real_moves[0], 'REAL RUN');

    for  test_moves in test_cases.Keys do
    begin
      for i := 0 to high(knots) do
        knots[i] := i;
      moves := get_ops2(test_moves);
      //writeln('Moves:');
      //print_array(moves);

      // Run the iterations
      pos := 0;
      skip := 0;
      for iteration := 1 to ITERATIONS do
      begin
        //writeln('Iteration: ', iteration);
        for i in moves do
        begin
          //writeln('Current pos: ', pos, ' skip: ', skip);
          knots := fold_array(knots, pos, i - 1);
          //writeln('Move: ', i);
          //print_array(knots);
          //writeln;
          pos := pos + i + skip;
          skip := skip + 1;
        end;
        //writeln;
      end;

      // Get the hash
      knot_hash := get_knot_hash(knots);
      if knot_hash = test_cases[test_moves] then
        writeln('PASSED for ', test_moves)
      else
      begin
        writeln('FAILED for ', test_moves);
        writeln('  Expected: ', test_cases[test_moves], ' recieved ', knot_hash);
        writeln(length(test_cases[test_moves]),'   ',length(knot_hash));
      end;
    end;

  end;


var
  infile: string;
begin
  if IN_TEST then
    infile := 'day10test.txt'
  else
    infile := 'day10input.txt';

  if PART = 1 then
    part1(infile)
  else
    part2(infile);

  readln;
end.
