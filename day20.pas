{$ifdef FPC} {$mode objfpc}{$H+}{$J-}  {$endif}
{$ifdef MSWINDOWS} {$apptype CONSOLE} {$endif}


(*
Part 1: the trick is that the overall acceleration was not calculated JUST by adding up the accelerations
        per direction.


Part 2: Correct answer with my input is 571. I'm getting 607. Hmmm

I changed my loops to not use indexes or keys, but to iterate on .values and suddenly I got the
right answer! There might be a lesson there!

*)

program day20;

uses 
  SysUtils, Generics.Collections, RegExpr, aocutils, Math, classes;

  type 
    TVector = record
      x,y,z: integer;
    end;
    TIntegerList = specialize TList<integer>;
    TPositions = specialize TDictionary<TVector, TIntegerList>;

    TParticle = class

      p,v,a: TVector;
      id: integer;



      public 
        constructor Create(ap, av, aa: TVector; aid: integer);
        procedure tick;
        // function distance(aTime: integer): integer;
        // function abs_accel(): integer;
      end;
      TParticleList = specialize TDictionary<integer, TParticle>;

      // MARK: TParticle.Create
      constructor TParticle.Create(ap, av, aa: TVector; aid: integer);
      begin
        inherited Create;
        self.p := ap;
        self.v := av;
        self.a := aa;
        self.id := aid;
      end;

      // MARK: TParticle.tick;
      procedure TParticle.tick;
      begin
        // Update the velocity
        self.v.x := self.v.x + self.a.x;
        self.v.y := self.v.y + self.a.y;
        self.v.z := self.v.z + self.a.z;

        // Update the position
        self.p.x := self.p.x + self.v.x;
        self.p.y := self.p.y + self.v.y;
        self.p.z := self.p.z + self.v.z;
      end;

      // function TParticle.distance(aTime: integer): integer;
      // begin
      //   result := 0;
      // end;

      function accel(x,y,z: integer): double;
      begin
        result := sqrt(abs(x)*abs(x) + abs(y)*abs(y) + abs(z)*abs(z));
      end;

      // MARK: part1
      procedure part1(filename: string; in_test: boolean);
      var 
        plist: TStringList;
        lowest_i, i: integer;
        r: TRegExpr;
        lowest_accel, current: double;

      begin
        writeln('Part 1 ----');
        r := TregExpr.Create;
        r.expression := 'a=<\s*(-?\d+),(-?\d+),(-?\d+)>';
        lowest_accel := maxdouble;


        plist := read_data_file(filename);
        for i := 0 to high( plist.count)  do
          begin
            writeln('Particle: ', i, ': ',plist[i]);
            if r.exec(plist[i]) then
              begin
                current := accel(strToInt(r.match[1]),strToInt(r.match[2]),strToInt(r.match[3]));
                writeln('   Acceleration is: ', current);
                if current < lowest_accel then
                  begin
                    lowest_accel := current;
                    lowest_i := i;
                    writeln('                    new lowest');
                  end
                else if current = lowest_accel then
                       writeln('  Duplicate lowest!!!!!');
              end
            else writeln('   No match!');
          end;
        writeln('Lowest accel was ', lowest_accel, ' at index ', lowest_i);

      end;

      // MARK: parse_data_line2
      function parse_data_line2(s: string; id: integer): TParticle;
      var 
        p, v, a: TVector;
        r: TRegExpr;

      begin
        r := TRegExpr.Create;
        r.expression := 





'p=<\s*(-?\d+),(-?\d+),(-?\d+)>,\s+v=<\s*(-?\d+),(-?\d+),(-?\d+)>,\s+a=<\s*(-?\d+),(-?\d+),(-?\d+)>'
        ;

        if r.exec(s) then
          begin
            p.x := StrToInt(r.match[1]);
            p.y := StrToInt(r.match[2]);
            p.z := StrToInt(r.match[3]);

            v.x := StrToInt(r.match[4]);
            v.y := StrToInt(r.match[5]);
            v.z := StrToInt(r.match[6]);

            a.x := StrToInt(r.match[7]);
            a.y := StrToInt(r.match[8]);
            a.z := StrToInt(r.match[9]);
          end
        else
          begin
            writeln('--- no match for "',s,'"');
          end;
        result := TParticle.create(p, v, a, id);
      end;

      // MARK: part2
      procedure part2(filename: string; in_test: boolean);
      var 
        t, i, dupe: integer;
        positions: TPositions;
        particles: TParticleList;
        p: TParticle;
        pos: TVector;
        input: TStringList;
        s: string;
        collisions: TIntegerList;

      const 
        ITERATIONS = 1000;

      begin
        writeln('Part 2 ----');

        particles := TParticleList.Create;
        input := read_data_file(filename);

        // Build the original input
        t := 0;
        for s in input do
          begin
            p := parse_data_line2(s, t);
            particles.add(t, p);
            inc(t);
          end;

        writeln('Found ', particles.count, ' particles.');

        // Run 200 iterations
        for t := 0 to ITERATIONS do
          begin
            // Iterate the ticks and find the new positions.
            positions := TPositions.Create;
            for p in particles.values do
              begin
                if t > 0 then
                  p.tick;
                if not positions.containskey(p.p) then
                  begin
                    positions.add(p.p, TIntegerList.create);
                  end;
                positions[p.p].add(p.id);
              end;

            // For any positions with more than 1 id, delete those ids.
            for collisions in positions.values do
              begin
                if collisions.count > 1 then
                  begin
                    writeln('  Found ', collisions.count, ' collisions.');
                    for dupe in collisions do
                      begin
                        particles[dupe].free;
                        particles.remove(dupe);
                      end;
                  end;
              end;

            writeln('After iteration ', t, ' there are ', particles.count,
                    ' particles.');
            positions.free;
          end;

        // Clean up
        for t in particles.keys do
          begin
            particles[t].free;
            particles.remove(t);
          end;
        particles.free;
      end;

      // MARK: main program
      var 
        filename: string;
        in_test: boolean;
        in_part: integer;

      begin
        writeln('Running Day 20');

        in_part := 2;
        in_test := false;

        if in_test then
          filename := 'day20test.txt'
        else
          filename := 'day20input.txt';

        if 1 = in_part then
          part1(filename, in_test)
        else
          part2(filename, in_test);
      end.
