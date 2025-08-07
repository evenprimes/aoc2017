// Just use this line in all modern FPC sources.
{$ifdef FPC} {$mode objfpc}{$H+}{$J-} {$endif}
// Needed for console programs on Windows,
// otherwise (with Delphi) the default is GUI program without console.
{$ifdef MSWINDOWS} {$apptype CONSOLE} {$endif}

// https://adventofcode.com/2017/day/15

program day15;

uses
  //crt,
  Classes,
  SysUtils,
  Generics.Collections,
  RegExpr;

const
  IN_TEST = false;
  PART = 2;
  GENAFACTOR = 16807;
  GENBFACTOR = 48271;
  GENAMULT = 4;
  GENBMULT = 8;

  function calc(seed, factor: integer): integer;
  begin
    Result := (seed * factor) mod 2147483647;
  end;

  procedure part1(gena, genb: integer);
  var
    ga, gb, ma, mb: integer;
    i: integer;
    matches: integer;
  begin
    ga := gena;
    gb := genb;

    matches := 0;
    for i := 0 to 40000000 do
    begin
      ga := calc(ga, GENAFACTOR);
      gb := calc(gb, GENBFACTOR);
      //write(ga:15, '  ', gb:15);
      ma := ga and $ffff;
      mb := gb and $ffff;
      //writeln('  ', ma:10, '  ', mb:10);
      if ma = mb then Inc(matches);

    end;
    writeln('Found ', matches, ' matches');

  end;

  function calc2(seed, factor, mult: integer): integer;
  var
    last: integer;
  begin
    last := seed;
    repeat
      Result := (last * factor) mod 2147483647;
      last := Result;
    until Result mod mult = 0;
  end;

  procedure part2(gena, genb: integer);
  var
    ga, gb, ma, mb: integer;
    i: integer;
    matches: integer;
  begin
    writeln('PART 2 ------------------------');
    writeln;
    ga := gena;
    gb := genb;

    matches := 0;
    for i := 0 to 5000000 do
    begin
      //writeln(i);
      ga := calc2(ga, GENAFACTOR, GENAMULT);
      gb := calc2(gb, GENBFACTOR, GENBMULT);
      //Write(ga: 15, '  ', gb: 15);
      ma := ga and $ffff;
      mb := gb and $ffff;
      //writeln('  ', ma: 10, '  ', mb: 10);
      if ma = mb then Inc(matches);

    end;
    writeln('Found ', matches, ' matches');

  end;

var
  a, b: integer;
begin

  if IN_TEST then
  begin
    a := 65;
    b := 8921;
  end
  else
  begin
    a := 512;
    b := 191;
  end;
  writeln('DAY 15');
  if PART = 1 then part1(a, b);
  if PART = 2 then part2(a, b);

  readln;

end.
