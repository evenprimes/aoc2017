program day4;


uses
  Classes,
  SysUtils,
  Generics.Collections;

const
  PART = 2;

type
  TSet = specialize TDictionary<string, integer>;

  procedure set_add(var s: TSet; val: string);
  begin
    if not s.ContainsKey(val) then s.add(val, 0);
  end;

  function password_is_valid(pw: string): integer;
  var
    d: tset;
    lst: TStringList;
    isvalid, i: integer;
  begin

    d := tset.Create;
    lst := TStringList.Create;
    isvalid := 1;

    try
      lst.delimiter := ' ';
      lst.delimitedtext := pw;

      for i := 0 to lst.Count - 1 do
      begin
        if d.containskey(lst[i]) then
          isvalid := 0
        else
          //d.add(lst[i], 0);
          set_add(d, lst[i]);
      end;

    finally
      lst.Free;
      d.Free;
    end;

    Result := isvalid;
  end;

  procedure part1;
  var
    str: string;
    infile: TStringList;
    i, validcount: integer;
  begin
    writeln('PART 1 ----------------------------------------------------');
    str := 'aa bb cc dd ee';
    writeln('"', str, '" is valid? ', password_is_valid(str));

    str := 'aa bb cc dd aa';
    writeln('"', str, '" is valid? ', password_is_valid(str));

    str := 'aa bb cc dd aaa';
    writeln('"', str, '" is valid? ', password_is_valid(str));
    writeln;
    writeln;
    writeln(' **** Production run:');
    infile := TStringList.Create;
    validcount := 0;
    try
      infile.loadfromfile('day4input.txt');

    except
      on E: Exception do
        WriteLn('Error reading file: ', E.ClassName, ': ', E.Message);
    end;

    for i := 0 to infile.Count - 1 do
    begin
      validcount := validcount + password_is_valid(infile[i]);
    end;
    writeln('found ', validcount, ' valid passwords');


    readln;
  end;




  procedure Swap(var A, B: char);
  var
    Temp: char;
  begin
    Temp := A;
    A := B;
    B := Temp;
  end;

  procedure GeneratePermutations(var S: string; L, R: integer; ResultList: tset);
  var
    i: integer;
  begin
    if L = R then
      //ResultList.Add(S)
      set_add(resultlist, s)
    else
      for i := L to R do
      begin
        Swap(S[L], S[i]);
        GeneratePermutations(S, L + 1, R, ResultList);
        Swap(S[L], S[i]); // backtrack
      end;
  end;

  procedure print_perms(p: tset);
  var
    k: string;
    i: integer;
  begin
    i := 0;
    for k in p.keys do
    begin
      writeln('  ', i, ' - ', k);
      i := i + 1;
    end;
  end;

  function password_is_valid_p2(pw: string): integer;
  var
    d, perms: tset;
    lst: TStringList;
    isvalid, i: integer;
    word, j: string;
  begin
    isvalid := 1;
    d := tset.Create;
    lst := TStringList.Create;

    try
      lst.delimiter := ' ';
      lst.delimitedtext := pw;

      for i := 0 to lst.Count - 1 do
      begin
        perms := tset.Create;
        word := lst[i];
        GeneratePermutations(word, 1, length(word), perms);

        for j in perms.keys do
        begin
          if d.containskey(j) then
          begin
            isvalid := 0;
            break;
          end
          else
          begin
            set_add(d, j);
          end;
        end;
        if isvalid = 0 then break;

        //if d.containskey(lst[i]) then
        //  isvalid := 0
        //else
        //  //d.add(lst[i], 0);
        //  set_add(d, lst[i]);
      end;

    finally
      lst.Free;
      d.Free;
    end;

    Result := isvalid;
  end;

  procedure part2;
  var
    str: string;
    perms: tset;
    validcount, i: integer;
    infile: TStringList;
  begin
    writeln('PART 2 ----------------------------------------------------');
    perms := tset.Create;
    str := 'absd';
    writeln('For string "', str, '"');
    GeneratePermutations(str, 1, length(str), perms);
    print_perms(perms);
    perms.Free;
    writeln;
    writeln;

    perms := tset.Create;
    str := 'abbc';
    writeln('For string "', str, '"');
    GeneratePermutations(str, 1, length(str), perms);
    print_perms(perms);
    perms.Free;
    WriteLn;
    WriteLn;

    str := 'abcde fghij';
    writeln('password ', str, ' 1 = ', password_is_valid_p2(str));
    writeln;

    str := 'abcde xyz ecdab';
    writeln('password ', str, ' 0 = ', password_is_valid_p2(str));
    writeln;

    str := 'a ab abc abd abf abj';
    writeln('password ', str, ' 1 = ', password_is_valid_p2(str));
    writeln;

    str := 'iiii oiii ooii oooi oooo';
    writeln('password ', str, ' 1 = ', password_is_valid_p2(str));
    writeln;

    str := 'oiii ioii iioi iiio';
    writeln('password ', str, ' 0 = ', password_is_valid_p2(str));
    writeln;

    writeln(' **** Production run:');
    infile := TStringList.Create;
    validcount := 0;
    try
      infile.loadfromfile('day4input.txt');

    except
      on E: Exception do
        WriteLn('Error reading file: ', E.ClassName, ': ', E.Message);
    end;

    for i := 0 to infile.Count - 1 do
    begin
      writeln('  processing "', infile[i], '"');
      validcount := validcount + password_is_valid_p2(infile[i]);
    end;
    writeln('found ', validcount, ' valid passwords');

    readln;
  end;

begin

  if PART = 1 then part1;
  if PART = 2 then part2;
end.
