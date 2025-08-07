program day2;


// Turn off 'marked as inline is not inlined' warning.
{$WARN 6058 OFF}

uses
  Classes,
  Generics.Collections,
  SysUtils;

type
  TRow = specialize TList<integer>;
  //TSheet = specialize TList<Trow>;
  //TRow = class(TList<integer>)
  //public
  //  function checksum: integer;
  //end;

  function row_checksum(r: TRow): integer;
  var
    max, min: integer;
    i: integer;
  begin
    max := 0;
    min := high(integer);

    for i := 0 to r.Count - 1 do
    begin
      if r[i] > max then max := r[i];
      if r[i] < min then min := r[i];
    end;

    Result := max - min;

  end;

  function get_row_cells(s: string): TRow;
  var
    cells: TStringList;
    i: integer;
    ints: TRow;
  begin
    cells := TStringList.Create;
    ints := TRow.Create;

    try
      cells.delimiter := ' ';
      cells.delimitedtext := s;

      for i := 0 to cells.Count - 1 do
      begin
        //writeln(cells[i]);
        ints.add(StrToInt(cells[i]));
      end;

    finally
      cells.Free;
    end;
    Result := ints;
  end;

  function calculate_spreadsheet(s_list: TStringList): integer;
  var
    i: integer;
    row: TRow;
    checksum: integer;
  begin
    checksum := 0;
    for i := 0 to s_list.Count - 1 do
    begin
      //writeln('Current checksum is ', checksum);
      row := get_row_cells(s_list[i]);
      checksum := checksum + row_checksum(row);
      row.Free;
    end;
    //writeln('Final checksum is ', checksum);

    Result := checksum;
  end;

  procedure test_run_part1;
  var
    test_strings: TStringList;
    //row: TRow;
    //i: integer;
    //checksum: integer;
  begin

    writeln('Test data run:');
    test_strings := TStringList.Create;

    test_strings.add('5 1 9 5');
    test_strings.add('7 5 3');
    test_strings.add('2 4 6 8');

    writeln('Final checksum is ', calculate_spreadsheet(test_strings));

    test_strings.Free;

  end;

  procedure prod_run_part1;
  var
    test_strings: TStringList;
    //row: TRow;
    //i: integer;
    //checksum: integer;
  begin
    writeln;
    writeln('Prod data run:');
    test_strings := TStringList.Create;

    try
      test_strings.loadfromfile('day2input.txt');
      //test_string := in_str.Text;
      writeln('Final checksum is ', calculate_spreadsheet(test_strings));
    except
      on E: Exception do
        WriteLn('Error reading file: ', E.ClassName, ': ', E.Message);
    end;

    //writeln('Final checksum is ', calculate_spreadsheet(test_strings));

    test_strings.Free;

  end;

  function part2_checksum(r: trow): integer;
  var
    i1, i2: integer;
    checksum: integer;
  begin
    checksum := -1;
    for i1 := 0 to r.Count - 2 do
    begin
      for i2 := i1 + 1 to r.Count - 1 do
      begin
        if r[i1] mod r[i2] = 0 then checksum := r[i1] div r[i2];
        if r[i2] mod r[i1] = 0 then checksum := r[i2] div r[i1];
        if checksum <> -1 then break;
      end;
      if checksum <> -1 then break;
    end;
    Result := checksum;
  end;

  function part2_process_spreadsheet(ss: TStringList): integer;
  var
    i: integer;
    row: TRow;
    checksum: integer;
    running_total: integer;
  begin
    writeln('starting part2_process_spreadsheet...');
    checksum := 0;
    running_total := 0;
    for i := 0 to ss.Count - 1 do
    begin
      row := get_row_cells(ss[i]);
      checksum := part2_checksum(row);
      writeln(checksum);
      running_total := running_total + checksum;
    end;
    writeln('finishing part2_process_spreadsheet...');
    Result := running_total;
  end;

  procedure test_run_part2;
  var
    tdata: TStringList;
    //i: integer;
    checksum: integer;
    row: TRow;
  begin
    writeln('First, test the new checksum...');
    try
      row := get_row_cells('5 9 2 8');
      checksum := part2_checksum(row);
      writeln('Expected 4, got: ', checksum);
      //except
      //on E: Exception do
      //  WriteLn('Error reading file: ', E.ClassName, ': ', E.Message);
    finally
      row.Free;
    end;

    writeln('Create multiple rows');

    try
      tdata := TStringList.Create;
      tdata.add('5 9 2 8');
      tdata.add('9 4 7 3');
      tdata.add('3 8 6 5');
      writeln('Prep to call process_spreadsheet');
      checksum := part2_process_spreadsheet(tdata);
      writeln('Expected 9, got: ', checksum);
    finally
      tdata.Free;
    end;


    //    //checksum := 0;

    //    checksum := part2_process_spreadsheet(tdata);
    //    writeln('Final checksum is: ', checksum);
    //    tdata.Free;

  end;

  procedure prod_part2;
  var
    instr: TStringList;
    //checksum, i: integer;
  begin
    writeln;
    writeln('Prod data run:');
    instr := TStringList.Create;

    try
      instr.loadfromfile('day2input.txt');
      //test_string := in_str.Text;
      writeln('Prod part 2 checksum is ', part2_process_spreadsheet(instr));
    except
      on E: Exception do
        WriteLn('Error reading file: ', E.ClassName, ': ', E.Message);
    end;

    //writeln('Final checksum is ', calculate_spreadsheet(test_strings));

    instr.Free;
  end;

begin
  //test_string := '5 1 9 5';
  writeln('Starting part 1 --------------------------------------');
  test_run_part1;
  prod_run_part1;
  writeln;
  writeln('Press enter to continue...');
  readln;

  writeln;
  writeln;
  writeln('Starting part 2 --------------------------------------');
  test_run_part2;
  prod_part2;

  readln;


end.
