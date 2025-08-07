program day6;

uses
  Classes,
  SysUtils,
  Generics.Collections;

const
  PART = 1;

type
  TSet = specialize TDictionary<string, integer>;
  TIntList = specialize TList<integer>;
  TIntArray = array of integer;

  TArrayMax = record
    val: integer;
    i: integer;
  end;

  procedure set_add(var s: TSet; val: string);
  begin
    if not s.ContainsKey(val) then s.add(val, 0);
  end;

  function stringtointarray(s: string): TIntArray;
  var
    i: integer;
    arr: TIntArray;
    cnt: integer;
    strlist: TStringList;
  begin
    strlist := TStringList.Create;

    strlist.delimiter := ' ';
    strlist.delimitedtext := s;

    cnt := strlist.Count;
    setlength(arr, cnt);
    for i := 0 to high(arr) do
      arr[i] := StrToInt(strlist[i]);

    Result := arr;
  end;

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


  function set_sequence(b: TIntArray): string;
  var
    i: integer;
  begin
    Result := '';
    for i := 0 to high(b) do
    begin
      Result := Result + IntToStr(b[i]);
      if i < High(b) then
        Result := Result + ' ';
    end;
  end;

  function find_max(A: TIntArray): integer;
  var
    i: integer;
    max: integer;
  begin

    max := -1;
    for i := 0 to high(A) do
    begin
      if a[i] > max then
      begin
        Result := i;
        max := a[i];
      end;
    end;
  end;

  function sum(b: tintarray): integer;
  var
    i: integer;
  begin
    Result := 0;
    for i := 0 to high(b) do
      Result := Result + b[i];
  end;

  function maxof2(a, b: integer): integer;
  begin
    if a > b then Result := a
    else
      Result := b;
  end;

  function cycle_blocks(var b: TIntArray): integer;
  var
    //cycles: integer;
    i: integer;
    itemcount: integer;
    archive: tset;
    seq: string;
    searching: boolean;
    amax: integer;
    max_val: integer;
    allocation: integer;
    idx: integer;
    offset: integer;
    asum: integer;
    part2str: string;
    part2count: integer;
    inpart2: boolean;
  begin
    writeln(set_sequence(b));
    Result := 1;
    archive := tset.Create;
    searching := True;
    itemcount := length(b);
    asum := sum(b);
    inpart2 := False;

    while searching or inpart2 do
    begin
      //writeln('Current seq (', Result, ') ', set_sequence(b));
      if sum(b) <> asum then
      begin
        writeln('Array does not add up anymore! was: ', asum, ' is ', sum(b));
        break;
      end;
      amax := find_max(b);
      offset := (amax + 1) mod itemcount;
      // In case the highest value is the last element
      //writeln('Current seq (', Result, ') ', set_sequence(b));
      max_val := b[amax];
      allocation := maxof2(max_val div (itemcount - 1), 1);
      //writeln('  max value is: ', max_val, ' at index: ', amax,
      //' allocation is: ', allocation);
      b[amax] := 0;
      //writeln('Current seq (', Result, ') ', set_sequence(b));
      for i := 0 to high(b) do
      begin
        idx := (offset + i) mod itemcount;
        //Write('     ', idx: 2, ' max: ', max_val, ' from: ', b[idx], ' to:');
        //writeln('    idx: ', idx, ' amax.val: ', max_val, '  b[idx]: ', b[idx]);

        // First, if this is the last iteration, then assign all of max_val
        if i = high(b) then
          b[idx] := b[idx] + max_val
        else
        begin
          if max_val >= allocation then
          begin

            b[idx] := b[idx] + allocation;
            max_val := max_val - allocation;
          end
          else
          begin
            b[idx] := b[idx] + max_val;
            max_val := 0;
          end;
        end;
        //writeln(b[idx]);

        // if max_val = 0, break
        if max_val = 0 then break;
      end;

      seq := set_sequence(b);
      writeln('Current seq (', Result, ') ', seq);

      if inpart2 then
      begin
        if seq = part2str then
        begin
          writeln('Found part 2 duplicate in loops: ', part2count);
          inpart2 := False;
        end
        else
        begin
          part2count := part2count + 1;
        end;
      end;


      // Finalize cycle
      if searching then
        if archive.containskey(seq) then
        begin
          part2str := seq;
          part2count := 1;
          inpart2 := True;
          searching := False;
        end
        else
        begin
          Result := Result + 1;
          set_add(archive, seq);
        end;

    end;
    writeln;
  end;

  procedure part1;
  var
    blocks: TIntArray;
    testStr: string;
    //strlist: TStringList;
    itemcount, i: integer;
    cycle_count: integer;
  begin
    teststr := '0 2 7 0';

    writeln('Testing');
    blocks := stringtointarray(teststr);
    itemcount := length(blocks);
    cycle_count := cycle_blocks(blocks);
    writeln('It took ', cycle_count, ' cycles');
    writeln;
    writeln;


    teststr := '10	3	15	10	5	15	5	15	9	2	5	8	5	2	3	6';

    writeln('Prod');
    blocks := stringtointarray(teststr);
    itemcount := length(blocks);
    cycle_count := cycle_blocks(blocks);
    writeln('It took ', cycle_count, ' cycles');
    writeln;
    writeln;

    writeln;
    writeln;
    readln;

  end;

  procedure part2;
  begin
    writeln('part 2 ------------------------------------------------');



    writeln;
    writeln;
    readln;
  end;

begin
  if PART = 1 then part1;
  if PART = 2 then part2;
end.
