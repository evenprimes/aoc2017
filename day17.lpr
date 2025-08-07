// Just use this line in all modern FPC sources.
{$ifdef FPC} {$mode objfpc}{$H+}{$J-} {$endif}
// Needed for console programs on Windows,
// otherwise (with Delphi) the default is GUI program without console.
{$ifdef MSWINDOWS} {$apptype CONSOLE} {$endif}

// https://adventofcode.com/2017/day/17

program day17;

uses
  //crt,
  Classes,
  SysUtils,
  Generics.Collections,
  RegExpr;

type
  TIntList = specialize TList<integer>;

const
  REPS = 50;

  procedure print_list(lst: TIntList);
  var
    i: integer;
  begin
    for i := 0 to lst.Count - 1 do
      Write(lst[i], ' ');
    writeln;
  end;

var
  lst: TIntList;
  lock, pos, i, resval: integer;


begin
  lst := TIntList.Create;
  lst.capacity := 9;
  lst.add(0);
  print_list(lst);
  pos := 0;
  lock := 348;

  //for i := 1 to 2017 do
  //begin
  //  pos := ((pos + lock) mod lst.Count) + 1;
  //  //writeln('Inserting ', i, ' at pos: ', pos);
  //  lst.insert(pos, i);
  //  //Write(i, ' -- ');
  //  //print_list(lst);
  //end;
  //lst.Free;
  //
  //// part 1
  //for i := 0 to 3 do
  //  Write(lst[i + pos], ' ');

  for i := 1 to 50000000 do
  begin
    pos := ((pos + lock) mod i) + 1;
    if pos = 1 then resval := i;
    //writeln('Inserting ', i, ' at pos: ', pos);
    //lst.insert(pos, i);
    //write(i, ' -- ');
    //print_list(lst);
  end;
  writeln('Part 2: ', resval);

  readln;
end.
