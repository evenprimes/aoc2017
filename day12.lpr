// Just use this line in all modern FPC sources.
{$ifdef FPC} {$mode objfpc}{$H+}{$J-} {$endif}
// Needed for console programs on Windows,
// otherwise (with Delphi) the default is GUI program without console.
{$ifdef MSWINDOWS} {$apptype CONSOLE} {$endif}

program day12;



uses
  //crt,
  Math,
  Classes,
  SysUtils,
  Generics.Collections,
  RegExpr;

const
  IN_TEST = false;
  PART = 2;

type
  TIntList = specialize TList<integer>;
  TOptionalBoolean = (Unknown, Yes, No);

  TProgramNode = class
    can_find_0: TOptionalBoolean;
    pipes: TIntList;
  end;

  TProgramList = specialize TDictionary<integer, TProgramNode>;

  function build_program_list1(d: TStringList): TProgramList;
    // 3 <-> 2, 4
  var
    r: TRegExpr;
    pipes: TStringList;
    line: string;
    node: TProgramNode;
    pipe_str: string;
  begin
    Result := TProgramList.Create;

    r := TregExpr.Create;

    try
      //r.expression := '(\w+)\s+\((\d+)\) -> (.+)';
      //r.expression := '^(\w+)\s+\((\d+)\)(?:\s+->\s+(.+))?$';
      r.expression := '^(\d+)\s+...\s+(\d+.*)$';

      for line in d do
      begin

        if r.exec(line) then
        begin
          pipes := TStringList.Create;
          pipes.delimiter := ',';
          pipes.delimitedText := r.match[2];
          node := TProgramNode.Create;
          node.can_find_0 := Unknown;
          node.pipes := TIntList.Create;

          for pipe_str in pipes do
            node.pipes.add(StrToInt(pipe_str));
          Result.add(StrToInt(r.match[1]), node);

        end; // end if r.exec(l)
      end; // end for

    finally
      r.Free;
    end;  // end try

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

  procedure print_node(n: TProgramNode);
  var
    i: integer;
  begin
    Write('This node links to: ');
    for i in n.pipes do
      Write(i, ' ');
    writeln;
    Write('Can this node get to 0?   ');
    case n.can_find_0 of
      Unknown: writeln('unknown');
      Yes: writeln('yes!');
      No: writeln('No!');
      else
        writeln('This should not happen: ');
    end;
  end;

  procedure link_pipes(pipe: integer; var proglist: TProgramList);
  var
    pipe_link: integer;
  begin
    if proglist[pipe].can_find_0 = Unknown then
    begin
      //writeln('Link_pipes: ', pipe);
      proglist[pipe].can_find_0 := Yes;
      for pipe_link in proglist[pipe].pipes do
      begin
        //writeln('   calling link_pipes on ', pipe_link);
        link_pipes(pipe_link, proglist);
      end;
    end;
  end;

  function count_pipes_not_connected(pl: TprogramList): integer;
  var
    pipe: integer;
  begin
    Result := 0;
    for pipe in pl.keys do
      if pl[pipe].can_find_0 = Unknown then
      begin
        Result := Result + 1;
        //writeln('Pipe ', pipe, ' cannot reach the 0 program');
      end;
  end;

  function count_pipes_connected(pl: TprogramList): integer;
  var
    pipe: integer;
  begin
    Result := 0;
    for pipe in pl.keys do
      if pl[pipe].can_find_0 = Yes then
      begin
        Result := Result + 1;
        //writeln('Pipe ', pipe, ' cannot reach the 0 program');
      end;
  end;

  procedure part1(infile: string);
  var
    datain: TStringList;
    prog_list: TProgramList;
    i: integer;
  begin
    writeln('Part 1 ----------------------');
    if IN_TEST then
      writeln('--- Test Run ---')
    else
      writeln('--- Real Run ---');

    datain := read_data_file(infile);
    prog_list := build_program_list1(datain);
    link_pipes(0, prog_list);
    for i in prog_list.keys do
    begin
      writeln('for program ', i, ':');
      //print_node(prog_list[i]);
    end;
    writeln;
    writeln;
    i := count_pipes_connected(prog_list);
    writeln('Total pipes = ', prog_list.Count);
    writeln('Found ', i, ' programs connected to 0');

  end;


  procedure part2(infile: string);
  var
    datain: TStringList;
    prog_list: TProgramList;
    i: integer;
    groups: integer;
  begin
    writeln('Part 1 ----------------------');
    if IN_TEST then
      writeln('--- Test Run ---')
    else
      writeln('--- Real Run ---');

    datain := read_data_file(infile);
    prog_list := build_program_list1(datain);

    // Starting at 0, link everything it can find.
    // Then, check
    groups := 0;
    for i in prog_list.keys do
    begin
      if prog_list[i].can_find_0 = Unknown then
      begin
        groups := groups + 1;
        link_pipes(i, prog_list);
      end;
    end;
    writeln('Total pipes = ', prog_list.Count);
    writeln('Found ', groups, ' programs groups');
  end;

var
  infile: string;
begin
  if IN_TEST then
    infile := 'day12test.txt'
  else
    infile := 'day12input.txt';

  if PART = 1 then
    part1(infile)
  else
    part2(infile);

  readln;

end.
