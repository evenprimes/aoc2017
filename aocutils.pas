
unit aocutils;

{$mode objfpc}{$H+}

interface

uses Classes;

  function read_data_file(const filename: string): TStringList;
  function isletter(const c: char): boolean;

  implementation

  uses 
    SysUtils;

    function isletter(const c: char): boolean;
    begin
      result := (c in ['a'..'z']) or (c in ['A'..'Z']);
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
