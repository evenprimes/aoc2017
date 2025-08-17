{ifdef FPC} {mode objfpc}{H+}{J-} {endif}
{ifdef MSWINDOWS} {apptype CONSOLE} {endif}

program day19;

uses 
  Classes, SysUtils, Generics.Collections, RegExpr, aocutils;

  // MARK: part1
  procedure part1(filename: string; in_test: boolean);

  const 
    EXAMPLE_RESULT = 'ABCDEF';

  var 
    map: TStringList;
    direction: char;
    found_letters: string;
    traversing: boolean;
    row, col: integer;
    max_row, max_col: integer;
    i: integer;
    steps: integer;


  begin
    writeln('Part 1 ----');
    direction := 'd';
    found_letters := '';
    traversing := true;
    row := 0;
    col := 0;
    steps := 0;

    map := read_data_file(filename);
    max_row := map.count;
    max_col := length(map[0]);
    writeln('The grid is: ', max_col, ' x ', max_row);

    // First find the starting point
    for i := 0 to length(map[0]) do
      if map[0][i]  = '|' then
        begin
          col := i;
          break;
        end;

    writeln('Map entrance at ', col, ', ', row);


    while traversing do
      begin
        // writeln('at ', col,' x ', row);
        //   traversing := false;

        if direction in ['d','u'] then
          begin
            inc(steps);
            // Move to next row.
            if direction = 'd' then
              row := row + 1
            else
              row := row - 1;

            // If the next row has a '+', then determine if we go left or right.
            if map[row][col] = '+' then
              begin
                // writeln('found a +');
                if (col > 0) and (' ' <> map[row][col-1]) then
                  direction := 'l'
                else if (max_col > col + 1) and (' ' <> map[row][col+1]) then
                       direction := 'r'
                else
                  traversing := false;
              end;
            writeln('   direction: ', direction);
            // continue;
          end
        else
          begin
            inc(steps);
            if direction = 'r' then
              col := col + 1
            else
              col := col -1;

            if map[row][col] = '+' then
              begin
                // writeln('found a +');
                if (row > 0) and (' ' <> map[row-1][col]) then
                  direction := 'u'
                else if (max_row > row + 1) and (' ' <> map[row+1][col]) then
                       direction := 'd'
                else
                  traversing := false;
                writeln('   direction: ', direction);
              end;
          end;

        // If we found a letter, grab it and keep going in the same direction.
        if isletter(map[row][col]) then
          found_letters := found_letters + map[row][col];

        if map[row][col] = ' ' then
          traversing := false;

        if (row < 0) or (col < 0) or (row > max_row) or (col > max_col) then
          traversing := false;

      end;

    writeln('I found: ', found_letters);
    writeln('I took ', steps, ' steps.');

    if in_test then
      begin
        if EXAMPLE_RESULT = found_letters then
          writeln('Found expected results!')
        else
          writeln('Expected to find "', EXAMPLE_RESULT, '" and found "', found_letters,
                  '"');
      end;
  end;

  // MARK: part2
  procedure part2(filename: string; in_test: boolean);
  begin
    writeln('Part 2 ----');
  end;

  // MARK: main program
  var 
    filename: string;
    in_test: boolean;
    in_part: integer;

  begin
    writeln('Running Day 19');

    in_part := 1;
    in_test := false;

    if in_test then
      filename := 'day19test.txt'
    else
      filename := 'day19input.txt';

    if 1 = in_part then
      part1(filename, in_test)
    else
      part2(filename, in_test);
  end.
