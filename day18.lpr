
// Just use this line in all modern FPC sources.
{$ifdef FPC} {$mode objfpc}{$H+}{$J-} {$endif}
// Needed for console programs on Windows,
// otherwise (with Delphi) the default is GUI program without console.
{$ifdef MSWINDOWS} {$apptype CONSOLE} {$endif}

// https://adventofcode.com/2017/day/17

program day18;

uses 
  //crt,
  Classes,
  SysUtils,
  Generics.Collections,
  RegExpr;

  // MARK: const

  const 
    IN_TEST = false;
    PART = 2;

  type 
    TSecOp = class
      isReg: boolean;
      reg: integer;
      val: integer;
    end;

    TOp = class
      op: string;
      regi: integer;
      val: TSecOp;
    end;

    TOp2 = class
      op: string;
      // index of the register for first operand
      regi: integer;
      // value of the second operand, may need to lookup current register value
      val: int64;
    end;

    TRegisters = array [0..25] of int64;
    TMessages = specialize TQueue<int64>;
    TMachine = class
      public 
        r: TRegisters;
        waiting: boolean;
        ip: integer;
        oplist: Tstringlist;
        in_msg, out_msg: TMessages;
        sent: int64;
        pid: int64;
        constructor Create(apid: int64; aoplist: Tstringlist; ain_msg, aout_msg: TMessages
        );
        procedure run;
      end;

      function IsSignedIntegerString(const s: string): boolean;
      var 
        i: integer;
      begin
        if s = '' then
          Exit(False);

        // Handle optional leading + or -
        i := 1;
        if s[1] in ['+', '-'] then
          begin
            if Length(s) = 1 then
              Exit(False);
            // string is just "+" or "-", not valid
            i := 2;
          end;

        // Check remaining characters are digits
        for i := i to Length(s) do
          if not (s[i] in ['0'..'9']) then
            Exit(False);

        Result := True;
      end;

      // MARK: print_registers
      procedure print_registers(regs: array of int64);
      var 
        i: integer;
        chara: integer;
      begin
        chara := Ord('a');
        for i := low(regs) to high(regs) do
          begin
            writeln(chr(chara + i), ' : ', regs[i]);
          end;
      end;


      // MARK: parse_op
      function parse_op(s: string; r: array of int64): TOp2;
      var 
        parts: TStringList;
        idx: integer;

      begin
        Result := TOp2.create;
        parts := tstringlist.create;
        parts.Delimiter := ' ';
        parts.DelimitedText := s;
        // writeln('in parse_op: ', s);

        Result.op := parts[0];
        result.val := 0;
        if (result.op = 'jgz') or (result.op = 'snd') then
          begin
            if IsSignedIntegerString(parts[1]) then
              begin
                result.regi :=  StrToInt(parts[1])
              end
            else
              begin
                idx := Ord(parts[1][1]) - Ord('a');
                Result.regi := r[idx];
              end;
          end
          // jgz or snd
        else
          Result.regi := Ord(parts[1][1]) - Ord('a');

        if parts.count > 2 then
          begin
            if IsSignedIntegerString(parts[2]) then
              Result.val := StrToInt(parts[2])
            else
              Result.val := r[ord(parts[2][1]) - ord('a')];
          end;

      end;



      // MARK: TMachine.Create
      constructor TMachine.Create(apid: int64; aoplist: Tstringlist; ain_msg, aout_msg:
                                  TMessages);
      var 
        i : int64;
      begin
        inherited create;
        for i := 0 to 25 do
          self.r[i] := 0;
        self.r[ord('p')-ord('a')] := apid;
        self.ip := 0;
        self.oplist := aoplist;
        self.waiting := false;
        self.in_msg := ain_msg;
        self.out_msg := aout_msg;
        self.sent := 0;
        self.pid := apid;
        writeln('In TMachine.Create(), apid = ', apid);
      end;

      // MARK: TMachine.run
      procedure TMachine.run;
      var 
        i : int64;
        op: TOp2;

      begin
        writeln('Run cycle for program ', self.pid);
        self.waiting := false;
        while false = self.waiting do
          begin
            op := parse_op(self.oplist[self.ip], self.r);
            writeln('Got instruction for: , ',self.oplist[self.ip]);
            writeln('    resulting instruction: ', op.op, ' register: ', op.regi,
                    ' value: ' , op.val);

            case op.op of 
              'jgz':
                     begin
                       if op.regi > 0 then
                         begin
                           ip := ip + op.val;
                           op.free;
                           continue;
                         end;
                     end;
              'snd':
                     begin
                       self.sent := self.sent + 1;
                       writeln('Prepping to enqueue: ', op.regi);
                       self.out_msg.enqueue(op.regi);
                       writeln('Finished enqueue: ', op.regi);
                     end;
              'set': r[op.regi] := op.val;
              'add': r[op.regi] := r[op.regi] + op.val;
              'mul': r[op.regi] := r[op.regi] * op.val;
              'mod': r[op.regi] := r[op.regi] mod op.val;
              'rcv':
                     begin
                       if 0 = self.in_msg.count then
                         begin
                           self.waiting := True;
                           continue;
                         end
                       else
                         begin
                           r[op.regi] := self.in_msg.dequeue();
                         end;
                     end;
              else writeln('unknown operation! ', op.op);
            end;
            op.free;
            inc(self.ip);

          end;

      end;


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



  function parse_op(s: string): Top;
  var 
    parts: TStringList;
  begin
    Result := TOp.Create;
    parts := TStringList.Create;
    parts.Delimiter := ' ';
    parts.DelimitedText := s;
    writeln(s);
    //Write(s, ' [0]: ', parts[0], ' [1]: "', parts[1], '"');


    Result.op := parts[0];

    Result.regi := Ord(parts[1][1]) - Ord('a');
    if not ((parts[0] = 'snd') or (parts[0] = 'rcv')) then
      begin
        Result.val := TSecOp.Create;
        if IsSignedIntegerString(parts[2]) then
          begin
            Result.val.isReg := False;
            Result.val.val := StrToInt(parts[2]);
          end
        else
          begin
            Result.val.isReg := True;
            //Write('  [2-reg]: ', parts[2]);
            Result.val.reg := Ord(parts[2][1]) - Ord('a');
          end;

      end;
    //writeln;
    parts.Free;
  end;

  // function get(s: string; r: array of integer): integer;
  // var 

  // begin
  // end;


  // MARK: part2
  procedure part2(fname: string);

  var 
    p: array [0..1] of TMachine;
    q0, q1: TMessages;
    ipointer1, ipointer2, i, p1_snds: integer;
    ilist: Tstringlist;
    op: top2;
    in_deadlock: boolean;

  begin
    writeln('PART 2 ********');

    // Initialize everything
    ilist := read_data_file(fname);
    q0 := TMessages.create;
    q1 := TMessages.create;
    p[0] := TMachine.create(0, ilist, q0,q1);
    p[1] := TMachine.create(1, ilist, q1,q0);
    in_deadlock := False;
    writeln('pid 0 registers:');
    print_registers(p[0].r);
    readln;
    writeln('pid 1 registers:');
    print_registers(p[1].r);
    readln;

    // Run until in deadlock
    while not in_deadlock do
      begin
        writeln('Queue 0 count: ', q0.count);
        writeln('Queue 1 count: ', q1.count);

        for i := 0 to 1 do
          p[i].run;

        // Deadlock is nothing in queue and everyone is waiting to read
        if (0 = q0.count) and (0 = q1.count) and (p[0].waiting) and p[1].waiting then
          in_deadlock := true;

        writeln('In deadlock? ', in_deadlock);
        writeln;
      end;

    writeln('program 0 sent ', p[0].sent, ' values');
    writeln('program 1 sent ', p[1].sent, ' values');
  end;

  // MARK: main
  var 
    registers: array[0..25] of int64;
    ipointer: integer;
    last_played, recovered: int64;
    ilist: TStringList;
    fname: string;
    i: integer;
    op: TOp2;
    current_op: string;

  begin
    write('DAY 18');
    if IN_TEST then
      begin
        if 1 = part then
          fname := 'day18test.txt'
        else
          fname := 'day18test2.txt';
        writeln('  testing -----');
      end
    else
      begin
        fname := 'day18input.txt';
        writeln('  PROD ***************************************');
      end;

    if 2 = PART then
      begin
        part2(fname);
        exit();
      end;

    ipointer := 0;
    recovered := -999;
    for i := 0 to high(registers) do
      registers[i] := 0;
    ilist := read_data_file(fname);

    while (ipointer >= 0) and (ipointer < ilist.Count) do
      begin
        op := parse_op(ilist[ipointer], registers);

        case op.op of 
          'jgz':
                 begin
                   if op.regi > 0 then
                     begin
                       writeln('-- -- JGZ triggered by ', op.val);
                       write('-- -- -- ipointer from ', ipointer);
                       ipointer := ipointer + op.val;
                       writeln(' to ', ipointer);
                       print_registers(registers);
                       readln;
                       continue;
                     end;
                 end;
          'snd':
                 begin
                   writeln('-- -- SND at tone ', registers[op.regi]);
                   last_played := registers[op.regi];
                 end;
          'set': registers[op.regi] := op.val;
          'add': registers[op.regi] := registers[op.regi] + op.val;
          'mul': registers[op.regi] := registers[op.regi] * op.val;
          'mod': registers[op.regi] := registers[op.regi] mod op.val;
          'rcv':
                 begin
                   writeln('rcv ', op.regi);
                   if registers[op.regi] <> 0 then
                     begin
                       writeln('-- -- valid rcv');
                       recovered := last_played;
                       break;
                     end;
                 end;
          else writeln('unknown operation! ', op.op);
        end;
        if registers[15] < 0 then writeln('register p went negative: ', registers[15]);
        inc(ipointer);
        op.Free;
      end;
    writeln;
    writeln('Recovered ', recovered);

  end.
