// Just use this line in all modern FPC sources.
{$ifdef FPC} {$mode objfpc}{$H+}{$J-} {$endif}
// Needed for console programs on Windows,
// otherwise (with Delphi) the default is GUI program without console.
{$ifdef MSWINDOWS} {$apptype CONSOLE} {$endif}


program day1;

uses 
  Classes,
  SysUtils;

  var 
    //i: integer;
    //working_char: char;
    test_string: string;
    //first_num : integer;
    //working_num: integer;
    //next_num : integer;
    in_str: TStringList;




  function calculate_string(s_in: string): integer;

  var 
    first_num, running_total: integer;
    working_num, prev_num, s_len, i: integer;
    w_str: string;
  begin
    w_str := trim(s_in);
    first_num := -1;
    running_total := 0;
    s_len := length(w_str);

    for i := 1 to s_len do
      begin
        working_num := Ord(w_str[i]) - Ord('0');
        if first_num = -1 then
          begin
            first_num := working_num;
            prev_num := working_num;
          end
        else
          begin
            if working_num = prev_num then
              begin
                running_total := running_total + working_num;
              end;
            prev_num := working_num;
          end;

        if i = s_len then
          begin
            if working_num = first_num then
              begin
                running_total := running_total + working_num;
              end;
          end;
      end;

    Result := running_total;
  end;

  function calculate_string_p2(in_str: string): integer;

  var 
    w_str: string;
    i, w_len, io, i2, d1, d2, running_total: integer;

  function comp_index(i: integer; offset: integer; max_i: integer): integer;

  var 
    comp_idx: integer;
  begin
    comp_idx := i + offset;
    if comp_idx > max_i then
      begin
        comp_idx := comp_idx - max_i;
      end;
    Result := comp_idx;
  end;

  begin
    w_str := trim(in_str);
    w_len := length(w_str);
    io := w_len div 2;
    running_total := 0;

    //writeln(w_str);
    //writeln(w_len);
    //writeln(io);
    for i := 1 to w_len do
      begin
        d1 := Ord(w_str[i]) - Ord('0');
        i2 := comp_index(i, io, w_len);
        d2 := Ord(w_str[i2]) - Ord('0');
        //writeln('i = ',i,' i2 = ',i2);
        if d1 = d2 then
          begin
            running_total := running_total + d1;
          end;
      end;

    Result := running_total;
  end;

  begin
    test_string := '1122';
    writeln('Test string "', test_string, '" should be 3');
    writeln('result is: ', calculate_string(test_string));

    test_string := '1111';
    writeln('Test string "', test_string, '" should be 4');
    writeln('result is: ', calculate_string(test_string));

    test_string := '1234';
    writeln('Test string "', test_string, '" should be 0');
    writeln('result is: ', calculate_string(test_string));

    test_string := '91212129';
    writeln('Test string "', test_string, '" should be 9');
    writeln('result is: ', calculate_string(test_string));

    // Now handle the actual test string
    in_str := TStringList.Create;
    try
      in_str.loadfromfile('day1input.txt');
      test_string := in_str.Text;
    except
      on E: Exception do
            WriteLn('Error reading file: ', E.ClassName, ': ', E.Message);
  end;
  writeln(in_str.Text);
  writeln(test_string);
  writeln('production result is: ', calculate_string(test_string));


  writeln;
  writeln;
  writeln('Part 2 -------------------------------------------------------');

  test_string := '1212';
  writeln('Test string "', test_string, '" should be 6');
  writeln('result is: ', calculate_string_p2(test_string));

  test_string := '1221';
  writeln('Test string "', test_string, '" should be 0');
  writeln('result is: ', calculate_string_p2(test_string));

  test_string := '123425';
  writeln('Test string "', test_string, '" should be 4');
  writeln('result is: ', calculate_string_p2(test_string));

  test_string := '123123';
  writeln('Test string "', test_string, '" should be 12');
  writeln('result is: ', calculate_string_p2(test_string));

  test_string := '12131415';
  writeln('Test string "', test_string, '" should be 4');
  writeln('result is: ', calculate_string_p2(test_string));

  test_string := in_str.Text;
  writeln(in_str.Text);
  writeln(test_string);
  writeln('production result is: ', calculate_string_p2(test_string));

  in_str.Free;
  readln;
end.
