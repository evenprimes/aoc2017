program day3;

(*

Uses https://oeis.org/A141481 as a helper!

*)

uses
  SysUtils,
  Generics.Collections,
  Math;

type
  TCoords = record
    x: integer;
    y: integer;
  end;

  TCurState = record
    pos: Tcoords;
    direction: char;
    maxxy: integer;
  end;


  function roundsqrttoprevodd(n: integer): integer;
  var
    roundedup: integer;
  begin
    roundedup := floor(sqrt(n));
    if roundedup mod 2 = 0 then
      Result := roundedup - 1
    else
      Result := roundedup;
  end;

  function manhatten_distance(square: integer): integer;
  var
    dist: integer;
    sqround, maxxy, x, y, curnum, i: integer;
    direction: string;
  begin
    dist := 0;

    if square = 1 then
    begin
      dist := 0;
    end
    else
    begin
      sqround := roundsqrttoprevodd(square);
      //writeln('  Previous odd sq: ', sqround);
      maxxy := sqround div 2 + 1;
      //writeln('  Maxxy: ', maxxy);

      curnum := sqround * sqround + 1;
      //writeln('  starting num: ', curnum);
      x := maxxy;
      y := -(maxxy - 1);
      //writeln('  starting pos: ', x, ', ', y);

      if square <> curnum then
      begin
        direction := 'up';
        for  i := curnum + 1 to square do
        begin
          case direction of
            'up': begin
              y := y + 1;
              if y = maxxy then direction := 'left';
            end;

            'left': begin
              x := x - 1;
              if x = -maxxy then direction := 'down';
            end;
            'down': begin
              y := y - 1;
              if y = -maxxy then direction := 'right';
            end;
            'right': begin
              x := x + 1;
            end;
          end;
          //writeln('  ', i, ' pos: ', x, ', ', y);
        end;
      end;
      //writeln('  ending pos: ', x, ', ', y);
      dist := abs(x) + abs(y);
    end;



    Result := dist;
  end;



  procedure part1;
  var
    md: integer;
  begin
    writeln('Starting part 1 ------------------------------------------');
    writeln('Square 1...');
    md := manhatten_distance(1);
    writeln('expected 0 got ', md);

    writeln;
    writeln('Square 12...');
    md := manhatten_distance(12);
    writeln('expected 3 got ', md);

    writeln;
    writeln('Square 23...');
    md := manhatten_distance(23);
    writeln('expected 2 got ', md);

    writeln;
    writeln('Square 1024...');
    md := manhatten_distance(1024);
    writeln('expected 31 got ', md);

    writeln;
    writeln('PROD: Square 277678...');
    md := manhatten_distance(277678);
    writeln('got ', md);
    writeln;
    writeln;
    readln;
  end;


  function create_coords(x, y: integer): TCoords;
  var
    coord: Tcoords;
  begin
    coord.x := x;
    coord.y := y;
    Result := coord;
  end;

  procedure print_position(p: tcoords);
  begin
    writeln('(', p.x, ', ', p.y, ')');
  end;

  function next_coords(cur, offset: tcoords): tcoords;
  var
    coord: tcoords;
  begin
    coord.x := cur.x + offset.x;
    coord.y := cur.y + offset.y;
    //writeln('  In next_coords:');
    //writeln('cur:');
    //print_position(cur);
    //writeln('offset:');
    //print_position(offset);
    //writeln('coord:');
    //print_position(coord);
    Result := coord;
  end;

  function move_to_next_pos(cs: Tcurstate): tcurstate;
  var
    ns: tcurstate;
  begin
    ns.maxxy := cs.maxxy;
    ns.direction := cs.direction;
    case cs.direction of
      'u': begin
        ns.pos.x := cs.pos.x;
        ns.pos.y := cs.pos.y + 1;
        if ns.pos.y = cs.maxxy then ns.direction := 'l';
      end;
      'l': begin
        ns.pos.x := cs.pos.x - 1;
        ns.pos.y := cs.pos.y;
        if ns.pos.x = -cs.maxxy then ns.direction := 'd';
      end;
      'd': begin
        ns.pos.x := cs.pos.x;
        ns.pos.y := cs.pos.y - 1;
        if ns.pos.y = -cs.maxxy then ns.direction := 'r';
      end;
      'r': begin
        ns.pos.x := cs.pos.x + 1;
        ns.pos.y := cs.pos.y;
        if ns.pos.x = cs.maxxy + 1 then
        begin
          ns.direction := 'u';
          ns.maxxy := cs.maxxy + 1;
        end;
      end;
      else
        writeln('This cannot happen, wtf?');
    end;
    writeln('State: (', ns.pos.x, ', ', ns.pos.y, ') dir: ', ns.direction,
      ' maxxy: ', ns.maxxy);
    Result := ns;
  end;



  function find_next_largest_square(n: integer): integer;
  var
    dict: specialize TDictionary<Tcoords, integer>;
    offsets: array[0..7] of tcoords;
    i, j, k, nc: integer;
    cur_coord, check_coord, ic: Tcoords;
    next_square: integer;
    state: tcurstate;
    square: integer;
  begin

    offsets[0] := create_coords(1, 0);
    offsets[1] := create_coords(1, 1);
    offsets[2] := create_coords(0, 1);
    offsets[3] := create_coords(-1, 1);
    offsets[4] := create_coords(-1, 0);
    offsets[5] := create_coords(-1, -1);
    offsets[6] := create_coords(0, -1);
    offsets[7] := create_coords(1, -1);

    dict := specialize TDictionary<Tcoords, integer>.Create;

    dict.Add(create_coords(0, 0), 1);
    nc := 0;
    state.pos := create_coords(0, 0);
    state.maxxy := 0;
    state.direction := 'r';
    square := 1;
    print_position(state.pos);
    repeat
      begin
        writeln(' Start loop:');
        square := square + 1;
        state := move_to_next_pos(state);
        print_position(state.pos);
        next_square := 0;

        for i := 0 to 7 do
        begin
          //writeln('    i  = ', i);
          check_coord := next_coords(state.pos, offsets[i]);
          if dict.ContainsKey(check_coord) then
            next_square := next_square + dict[check_coord];
        end;
        writeln('  square ', square, ' ', next_square);

        // Prep end of loop
        dict.add(state.pos, next_square);
        nc := (nc + 1) mod 7;

      end;
    until next_square > n;
    dict.Free;
    Result := next_square;
  end;

  procedure part2;
  begin
    writeln('Starting part 2 ------------------------------------------');

    writeln('Next largest square for 20 is ', find_next_largest_square(20));
    writeln;
    writeln('Finding for prod test: 277678');
    writeln(find_next_largest_square(277678));
    writeln;
    readln;
  end;

var
  inpart: integer;
begin
  inpart := 2;
  if inpart = 1 then part1;
  if inpart = 2 then part2;
end.
