{$mode objfpc}{$H+}{$J-}

unit aocutils;

interface

uses Classes;

  function is_letter(const c: char): boolean;
  function is_number(const s: string): boolean;
  function read_data_file(const filename: string): TStringList;

  implementation

  uses
    SysUtils;

    function is_letter(const c: char): boolean;
    begin
      result := (c in ['a'..'z']) or (c in ['A'..'Z']);
    end;

    function is_number(const s: string): boolean;
    var i: integer;
    begin
      if s = '' then
        Exit(False);

      // Handle optional leading + or -
      i := low(s);
      if s[i] in ['+', '-'] then
        begin
          if Length(s) = 1 then
            Exit(False);
          // string is just "+" or "-", not valid
          inc(i);
        end;

      // Check remaining characters are digits
      for i := i to high(s) do
        if not (s[i] in ['0'..'9']) then
          Exit(False);

      Result := True;
    end;

    function read_data_file(const filename: string): TStringList;
    begin
      Result := TStringList.Create;
      try
        Result.loadfromfile(filename);
      except
        on E: Exception do
              WriteLn('Error reading file: ', E.ClassName, ': ', E.Message);
    end;

  end;

end.
