program day5;

uses
  Classes,
  SysUtils,
  Generics.Collections;

const
  PART = 2;

type
  //TSet = specialize TDictionary<string, integer>;
  TIntList = specialize TList<integer>;

  function read_data_file(fname: string): TStringList;
  var
    infile: TStringList;
  begin
    infile := TStringList.Create;
    try
      infile.loadfromfile(fname);
    except
      on E: Exception do
        WriteLn('Error reading file: ', E.ClassName, ': ', E.Message);
    end;
    Result := infile;
  end;

  procedure print_instructions(inlist: tintlist; ip: integer);
  var
    i: integer;
  begin
    for i := 0 to inlist.Count - 1 do
    begin
      if i = ip then
        Write('(', inlist[i], ') ')
      else
        Write(inlist[i], ' ');
    end;
    writeln;
  end;

  function count_steps_part1(var inlist: tintlist): integer;
  var
    steps: integer;
    ip: integer;
    icount: integer;
    jumpto: integer;
  begin
    icount := inlist.Count;
    ip := 0;
    steps := 0;
    print_instructions(inlist, ip);

    while ip < icount do
    begin
      jumpto := ip + inlist[ip];
      inlist[ip] := inlist[ip] + 1;
      ip := jumpto;
      steps := steps + 1;
      if steps mod 100 = 0 then  writeln(steps);
      //  print_instructions(inlist, ip);
      //writeln('  ip: ', ip, ' icount: ', icount);
    end;

    Result := steps;
  end;

  procedure part1;
  var
    test: tintlist;
    input: TStringList;
    stepcount: integer;
    i: integer;
  begin
    writeln('PART 1 ----------------------------------------------------');
    test := tintlist.Create;
    test.add(0);
    test.add(3);
    test.add(0);
    test.add(1);
    test.add(-3);
    stepcount := count_steps_part1(test);
    writeln(' First test data took ', stepcount, ' steps');
    test.Free;

    writeln;
    writeln('*** prod run:');
    input := read_datA_file('day5input');
    test := tintlist.Create;
    for i := 0 to input.Count - 1 do
    begin
      test.add(StrToInt(input[i]));
    end;
    stepcount := count_steps_part1(test);
    writeln(' Prod data took ', stepcount, ' steps');
    test.Free;

    writeln;
    writeln;
    readln;

  end;

  function count_steps_part2(var inlist: tintlist): integer;
  var
    steps: integer;
    ip: integer;
    icount: integer;
    jumpto: integer;
  begin
    icount := inlist.Count;
    ip := 0;
    steps := 0;
    print_instructions(inlist, ip);

    while ip < icount do
    begin
      jumpto := ip + inlist[ip];
      if inlist[ip] >= 3 then
        inlist[ip] := inlist[ip] - 1
      else
        inlist[ip] := inlist[ip] + 1;
      ip := jumpto;
      steps := steps + 1;
      if steps mod 100 = 0 then  writeln(steps);
      //  print_instructions(inlist, ip);
      //writeln('  ip: ', ip, ' icount: ', icount);
    end;
    print_instructions(inlist, ip);

    Result := steps;
  end;

  procedure part2;
  var
    test: tintlist;
    input: TStringList;
    stepcount: integer;
    i: integer;
  begin
    writeln('PART 2 ----------------------------------------------------');
    test := tintlist.Create;
    test.add(0);
    test.add(3);
    test.add(0);
    test.add(1);
    test.add(-3);
    stepcount := count_steps_part2(test);
    writeln(' First test data took ', stepcount, ' steps');
    test.Free;

    writeln;
    writeln('*** prod run:');
    input := read_datA_file('day5input');
    test := tintlist.Create;
    for i := 0 to input.Count - 1 do
    begin
      test.add(StrToInt(input[i]));
    end;
    stepcount := count_steps_part2(test);
    writeln(' Prod data took ', stepcount, ' steps');
    test.Free;

    writeln;
    writeln;
    readln;
  end;

begin
  if PART = 1 then part1;
  if PART = 2 then part2;
end.
