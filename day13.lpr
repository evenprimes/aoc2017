// Just use this line in all modern FPC sources.
{$ifdef FPC} {$mode objfpc}{$H+}{$J-} {$endif}
// Needed for console programs on Windows,
// otherwise (with Delphi) the default is GUI program without console.
{$ifdef MSWINDOWS} {$apptype CONSOLE} {$endif}


// https://adventofcode.com/2017/day/13

program day13;

uses
  //crt,
  Classes,
  SysUtils,
  Generics.Collections,
  RegExpr;

const
  IN_TEST = False;
  PART = 2;

type
  TLayer = class
    id: integer;
    range: integer;
    pos: integer;
    direction: integer;
  end;

  TFireWall = specialize TDictionary<integer, TLayer>;

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

  function parse_line(l: string): TLayer;
  var
    s: TStringList;
  begin
    Result := TLayer.Create;
    s := TStringList.Create;
    s.Delimiter := ':';
    s.DelimitedText := l;
    Result.id := StrToInt(s[0]);
    Result.range := StrToInt(s[1]);
    Result.pos := 0;
    Result.direction := 1;
  end;

  procedure part1(infilename: string);
  var
    din: TStringList;
    id: integer;
    i: integer;
    layer: TLayer;
    fw: TFirewall;
    s: string;
    max_layer: integer;
    picosecond, severity: integer;
  begin
    writeln('PART 1 ----------------');
    fw := TFireWall.Create;
    din := read_datA_file(infilename);
    for s in din do
    begin
      layer := parse_line(s);
      fw.add(layer.id, layer);
    end;
    writeln('Found ', fw.Count, ' layers');
    max_layer := 0;
    for i in fw.Keys do
      if i > max_layer then max_layer := i;
    writeln('Max Layer was ', max_layer);

    severity := 0;
    for picosecond := 0 to max_layer do
    begin
      // Check for being caught
      if fw.ContainsKey(picosecond) then
        if fw[picosecond].pos = 0 then
        begin  // Caught!
          writeln('Caught at ', picosecond);
          severity := severity + (picosecond * fw[picosecond].range);
        end;

      // advance all positions
      for i in fw.keys do
      begin
        fw[i].pos := fw[i].pos + fw[i].direction;
        if fw[i].pos = 0 then fw[i].direction := 1;
        if fw[i].pos = fw[i].range - 1 then fw[i].direction := -1;
      end;
    end;

    writeln('Trip severity is: ', severity);

  end;

  function scanner_location(time: integer; range: integer): integer;
  var
    period, pos: integer;
  begin
    period := range * 2;
    pos := time mod period;
    if pos < range then
      Result := pos
    else
      Result := period - pos;
  end;

  procedure part2(infilename: string);
  var
    din: TStringList;
    id: integer;
    i: integer;
    layer: TLayer;
    fw: TFirewall;
    s: string;
    max_layer: integer;
    picosecond, severity: integer;
    delay: integer;
    caught: boolean;
    atpos: integer;
    atlayer: integer;
    fwrange: array of integer;
  begin
    writeln('PART 2 ----------------');
    fw := TFireWall.Create;
    din := read_datA_file(infilename);
    for s in din do
    begin
      layer := parse_line(s);
      fw.add(layer.id, layer);
    end;
    writeln('Found ', fw.Count, ' layers');
    max_layer := 0;
    for i in fw.Keys do
      if i > max_layer then max_layer := i;
    writeln('Max Layer was ', max_layer);
    Setlength(fwrange, max_layer + 1);
    writeln('fwrange');
    for i := 0 to high(fwrange) do begin
      if fw.containskey(i) then
        fwrange[i] := fw[i].range - 1
      else
        fwrange[i] := 0;
      writeln(i, ':',fwrange[i]);
    end;
    writeln;

    severity := -1;
    delay := 0;
    caught := True;

    //for picosecond := 0 to 10 do
    //writeln('scanner 1: ', scanner_location(picosecond, fw[1].range-1));

    while caught do
    begin
      caught := False;
      atpos := 0;

      for picosecond := 0 to max_layer do
      begin
        if (fwrange[picosecond] > 0) and (scanner_location(picosecond + delay, fwrange[picosecond])  = 0) then
        begin
          caught := True;
          break;
        end; // if
      end;  // for
      if caught then delay := delay + 1;
      //if delay mod 1000 = 0 then
      //  writeln('new delay ', delay);

    end;


    writeln('Delay needed to be ', delay, ' picoseconds');
  end;

var
  fname: string;

begin
  if IN_TEST then
    fname := 'day13test.txt'
  else
    fname := 'day13input.txt';

  if PART = 1 then part1(fname);
  if PART = 2 then part2(fname);

  readln;

end.
