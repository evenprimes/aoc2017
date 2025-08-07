// Just use this line in all modern FPC sources.
{$ifdef FPC} {$mode objfpc}{$H+}{$J-} {$endif}
// Needed for console programs on Windows,
// otherwise (with Delphi) the default is GUI program without console.
{$ifdef MSWINDOWS} {$apptype CONSOLE} {$endif}

program day11;

uses
  //crt,
  Math,
  Classes,
  SysUtils,
  Generics.Collections,
  RegExpr;

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


  function get_hex_distance(s: string): integer;
  var
    moves: TStringList;
    x, y, z: integer;
    cur_move: string;
  begin
    x := 0;
    y := 0;
    z := 0;

    moves := TStringList.Create;
    moves.delimiter := ',';
    moves.delimitedText := s;

    for cur_move in moves do
    begin
      case cur_move of
        'n': begin
          y := y + 1;
          z := z - 1;
        end;
        'ne': begin
          x := x + 1;
          z := z - 1;
        end;
        'nw': begin
          x := x - 1;
          y := y + 1;
        end;
        's': begin
          y := y - 1;
          z := z + 1;
        end;
        'se': begin
          x := x + 1;
          y := y - 1;
        end;
        'sw': begin
          x := x - 1;
          z := z + 1;
        end;
        else
          writeln('Unknown direction "', cur_move, '"')
      end;
    end;
    Result := floor((abs(x) + abs(y) + abs(z)) / 2);
  end;

  function get_max_distance(s: string): integer;
  var
    moves: TStringList;
    x, y, z: integer;
    cur_move: string;
    cur_dist: integer;
  begin
    x := 0;
    y := 0;
    z := 0;
    Result := 0;

    moves := TStringList.Create;
    moves.delimiter := ',';
    moves.delimitedText := s;

    for cur_move in moves do
    begin
      case cur_move of
        'n': begin
          y := y + 1;
          z := z - 1;
        end;
        'ne': begin
          x := x + 1;
          z := z - 1;
        end;
        'nw': begin
          x := x - 1;
          y := y + 1;
        end;
        's': begin
          y := y - 1;
          z := z + 1;
        end;
        'se': begin
          x := x + 1;
          y := y - 1;
        end;
        'sw': begin
          x := x - 1;
          z := z + 1;
        end;
        else
          writeln('Unknown direction "', cur_move, '"')
      end;
      cur_dist := floor((abs(x) + abs(y) + abs(z)) / 2);
      if cur_dist > Result then
        Result := cur_dist;
    end;
  end;

  procedure part1(infile: string);
  var
    tests: specialize TDictionary<string, integer>;
    datain: TStringList;
    moves: string;
    dist: integer;
  begin
    writeln('Part 1 ----------------------');
    tests := specialize TDictionary<string, integer>.Create;
    tests.add('ne,ne,ne', 3);
    tests.add('ne,ne,sw,sw', 0);
    tests.add('ne,ne,s,s', 2);
    tests.add('se,sw,se,sw,sw', 3);

    for moves in tests.keys do
    begin
      dist := get_hex_distance(moves);
      if dist = tests[moves] then
        writeln('PASSED for ', moves)
      else
        writeln('FAILED for ', moves);
    end;

    datain := read_data_file(infile);
    dist := get_hex_distance(datain[0]);
    writeln(datain[0]);
    writeln('Distance is: ', dist);

    dist := get_max_distance(datain[0]);
    writeln(datain[0]);
    writeln('Max Distance is: ', dist);


  end;


  procedure part2(infile: string);
  begin
    writeln('Part 2 ----------------------');
  end;

var
  infile: string;
begin
  if IN_TEST then
    infile := 'day11test.txt'
  else
    infile := 'day11input.txt';

  if PART = 1 then
    part1(infile)
  else
    part2(infile);

  readln;

end.
