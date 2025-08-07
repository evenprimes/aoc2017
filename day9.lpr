// Just use this line in all modern FPC sources.
{$ifdef FPC} {$mode objfpc}{$H+}{$J-} {$endif}
// Needed for console programs on Windows,
// otherwise (with Delphi) the default is GUI program without console.
{$ifdef MSWINDOWS} {$apptype CONSOLE} {$endif}



program day9;
// From:  https://adventofcode.com/2017/day/9

uses
  //crt,
  Classes,
  SysUtils,
  Generics.Collections,
  RegExpr, Unit1;

const
  IN_TEST = False;
  PART = 2;



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



  function score_string(s: string): integer;
  var
    ingarbage: boolean;
    ignorenext: boolean;
    i: integer;
    score: integer;
  begin
    Result := 0;
    score := 1;
    ingarbage := False;
    ignorenext := False;

    for i := 1 to length(s) do
    begin
      if ignorenext then
      begin
        ignorenext := False;
        continue;
      end;
      if ingarbage then
      begin
        case s[i] of
          '!': ignorenext := True;
          '>': ingarbage := False;
          else
            continue;
        end; // end case
      end
      else
        case s[i] of
          '{': begin
            Result := Result + score;
            score := score + 1;
          end;
          '}': begin
            score := score - 1;
          end;
          '<': ingarbage := True;
          '!': ignorenext := True;
          else
            continue;
        end;  // end case
    end;

  end;

  procedure part1(infile: string);
  var
    test_string: string;
    score: integer;
    test_dict: specialize TDictionary<string, integer>;
    strlist: TStringList;
  begin
    test_dict := specialize TDictionary<string, integer>.Create;

    // Tests
    test_dict.add('{}', 1);
    test_dict.add('{{{}}}', 6);
    test_dict.add('{{},{}}', 5);
    test_dict.add('{{{},{},{{}}}}', 16);
    test_dict.add('{<a>,<a>,<a>,<a>}', 1);
    test_dict.add('{{<ab>},{<ab>},{<ab>},{<ab>}}', 9);
    test_dict.add('{{<!!>},{<!!>},{<!!>},{<!!>}}', 9);
    test_dict.add('{{<a!>},{<a!>},{<a!>},{<ab>}}', 3);

    for test_string in test_dict.Keys do
    begin
      score := score_string(test_string);
      if score = test_dict[test_string] then
        writeln('PASS Got expected score of ', score, ' for string ', test_string)
      else
        writeln('FAIL Got ', score, ' instead of ', test_dict[test_string],
          ' for string ', test_string);
    end;

    strlist := TStringList.Create;
    strlist := read_datA_file(infile);
    score := score_string(strlist[0]);
    writeln('Score for full string is: ', score);

  end;

  function cancelled_chars(s: string): integer;
  var
    ingarbage: boolean;
    ignorenext: boolean;
    i: integer;
    score: integer;
  begin
    Result := 0;
    score := 1;
    ingarbage := False;
    ignorenext := False;

    for i := 1 to length(s) do
    begin
      if ignorenext then
      begin
        ignorenext := False;
        continue;
      end;
      if ingarbage then
      begin
        case s[i] of
          '!': ignorenext := True;
          '>': ingarbage := False;
          else
            result := result + 1;
        end; // end case
      end
      else
        case s[i] of
          '<': ingarbage := True;
          '!': ignorenext := True;
          else
            continue;
        end;  // end case
    end;

  end;


  procedure part2(infile: string);
  var
    test_string: string;
    score: integer;
    test_dict: specialize TDictionary<string, integer>;
    strlist: TStringList;
  begin
    test_dict := specialize TDictionary<string, integer>.Create;

    // Tests
    test_dict.add('<>', 0);
    test_dict.add('<random characters>', 17);
    test_dict.add('<<<<>', 3);
    test_dict.add('<{!>}>', 2);
    test_dict.add('<!!>', 0);
    test_dict.add('<!!!>>', 0);
    test_dict.add('<{o"i!a,<{i<a>', 10);

    for test_string in test_dict.Keys do
    begin
      score := cancelled_chars(test_string);
      if score = test_dict[test_string] then
        writeln('PASS Got expected score of ', score, ' for string ', test_string)
      else
        writeln('FAIL Got ', score, ' instead of ', test_dict[test_string],
          ' for string ', test_string);
    end;

    strlist := TStringList.Create;
    strlist := read_datA_file(infile);
    score := cancelled_chars(strlist[0]);
    writeln('Cancelled chares for full string is: ', score);
  end;


var
  infile: string;
begin
  if IN_TEST then
    infile := 'day8test.txt'
  else
    infile := 'day9input.txt';

  if PART = 1 then
    part1(infile)
  else
    part2(infile);

  readln;
end.
