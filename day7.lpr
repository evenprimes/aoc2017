// Just use this line in all modern FPC sources.
{$ifdef FPC} {$mode objfpc}{$H+}{$J-} {$endif}
// Needed for console programs on Windows,
// otherwise (with Delphi) the default is GUI program without console.
{$ifdef MSWINDOWS} {$apptype CONSOLE} {$endif}

program day7;

uses
  //crt,
  Classes,
  SysUtils,
  Generics.Collections,
  RegExpr;

const
  IN_TEST = False;
  PART = 2;

type
  TSet = specialize TDictionary<string, integer>;
  TStringDict = specialize TDictionary<string, string>;
  TIntList = specialize TList<integer>;
  TIntArray = array of integer;

  TProgramNode = record
    Name: string;
    weight: integer;
    children: TStringList;

  end;

  TPNode = class
    Name: string;
    weight: integer;
    cweight: integer;
    tweight: integer;
    childrenStringList: TStringList;
    //children: specialize TList<TPNode>;
  end;
  TPNodeTree = specialize Tdictionary<string, TPNode>;


  //TGraphList = specialize TDictionary<string, TGraph>;

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

  function parse_line(l: string): TPNode;
  var
    i: integer;
    r: TRegExpr;
    children: TStringList;
    child: string;
  begin
    //Result.children := TStringList.Create;
    Result := TPNode.Create;
    Result.childrenStringList := TStringList.Create;
    //Result.children := specialize TList<TPNode>.Create;

    r := TregExpr.Create;
    try
      //r.expression := '(\w+)\s+\((\d+)\) -> (.+)';
      r.expression := '^(\w+)\s+\((\d+)\)(?:\s+->\s+(.+))?$';

      if r.exec(l) then
      begin
        //writeln(' id: ', r.match[1], ' weight: ', r.match[2]);
        Result.Name := r.match[1];
        Result.weight := StrToInt(r.match[2]);
        if r.match[3] <> '' then
        begin
          children := TStringList.Create;
          children.delimiter := ',';
          children.delimitedtext := r.match[3];
          for  child in children do
            Result.childrenstringlist.add(child);
        end;

      end;
    finally
      r.Free;
    end;
  end;

  procedure print_node(node: string; indent: integer; tree: TPNodeTree);
  var
    prefix: string;
    cstring: string;
    cnode: TPNode;
  begin
    prefix := stringofchar(' ', indent * 4);

    //for  node in tree.Values do
    //begin
    //textcolor(white);
    writeln(prefix, '  Name: ', tree[node].Name);
    writeln(prefix, 'Weight: ', tree[node].weight);
    writeln(prefix, 'Children Weight: ', tree[node].cweight);
    if tree[node].childrenstringlist.Count > 0 then
    begin

      //textcolor(Yellow);
      //Write(prefix, 'Children names: ');
      //normvideo;
      for cstring in tree[node].childrenStringList do
      begin
        print_node(cstring, indent + 1, tree);
      end;
      writeln;
    end;

  end;

  //procedure print_tree(tree: TPNodeTree);
  //var
  //  t: TPNode;
  //begin
  //  for t in tree.values do
  //    print_node(t, 0);
  //end;

  //procedure add_children(var root: TPNode; var tree: TPNodeTree; parents: TStringDict);
  //var
  //  child: string;
  //begin
  //  for child in root.childrenStringList do
  //  begin
  //    if tree[child].childrenStringList.Count > 0 then
  //      add_children(tree[child], tree, parents);
  //    root.children.add(tree[child]);
  //  end;

  //end;

  //function build_tree(var tree: TPnodeTree): TPNode;
  //var
  //  node, child: TPNode;
  //  Name: string;
  //  names: TStringList;
  //  building: boolean;
  //  parents: TStringDict;
  //begin
  //  names := TStringList.Create;
  //  parents := TStringDict.Create;
  //  //names.delimiter := ' ';
  //  // Find the parent of every node (except the root!)
  //  for node in tree.values do
  //  begin
  //    if node.childrenStringList.Count > 0 then
  //      for Name in node.childrenStringList do
  //        parents.add(Name, node.Name);
  //  end;

  //  // The root will be the node with no parents
  //  for Name in tree.Keys do
  //    if not parents.containskey(Name) then
  //      Result := tree[Name];
  //  //add_children(Result, tree, parents);

  //end;


  //procedure part1;
  //var
  //  datain: TStringList;
  //  i: integer;
  //  s, child: string;
  //  t: TPNode;
  //  tree: TPNodeTree;
  //  root: TPNode;
  //  parents: TStringDict;
  //begin
  //  writeln('Part 1 --------------------------');
  //  datain := read_datA_file('day7test');
  //  tree := TPNodeTree.Create;

  //  for s in datain do
  //  begin

  //    writeln(s);
  //    t := parse_line(s);
  //    tree.add(t.Name, t);
  //    writeln('   name: ', t.Name);
  //    writeln(' weight: ', t.weight);
  //    for child in t.childrenstringlist do
  //      writeln('    child: ', child);
  //  end;

  //  writeln('-': 10);
  //  writeln('Raw tree as dictionary:');
  //  print_tree(tree);
  //  root := build_tree(tree);

  //  writeln;
  //  writeln;
  //  writeln('----------------------------');
  //  writeln('Root and nodes:');
  //  print_node(root, 0);
  //  writeln;

  //  // Cleanup
  //  datain.Free();
  //  tree.Free();
  //  root.Free();


  //  writeln('Part 1 prod --------------------------');
  //  datain := read_datA_file('day7input.txt');

  //  tree := TPNodeTree.Create;

  //  for s in datain do
  //  begin

  //    writeln(s);
  //    t := parse_line(s);
  //    tree.add(t.Name, t);
  //    writeln('   name: ', t.Name);
  //    writeln(' weight: ', t.weight);
  //    for child in t.childrenstringlist do
  //      writeln('    child: ', child);
  //  end;

  //  writeln('-': 10);
  //  writeln('Raw tree as dictionary:');
  //  print_tree(tree);
  //  root := build_tree(tree);

  //  writeln;
  //  writeln;
  //  writeln('----------------------------');
  //  writeln('Root and nodes:');
  //  print_node(root, 0);
  //  writeln;

  //  // Cleanup
  //  datain.Free();
  //  tree.Free();
  //  root.Free();

  //end;

  procedure calculate_weights(var tree: TPNodeTree; node: string);
  var
    child: string;
    //cweight: integer;
  begin
    writeln('Called for ', node);
    tree[node].cweight := 0;
    for child in tree[node].childrenstringlist do
    begin
      if tree[child].cweight = -1 then
        calculate_weights(tree, child);
      tree[node].cweight := tree[node].cweight + tree[child].weight +
        tree[child].cweight;

    end;
  end;

  procedure check_weights(node: string; tree: TPNodeTree; balanceto: integer);
  var
    child: string;
    balance: specialize TDictionary<integer, integer>;
    weight: integer;
    child_weight, total_weight, new_balance: integer;
    i: integer;
  begin
    balance := specialize TDictionary<integer, integer>.Create;
    child_weight := 0;
    total_weight := 0;
    // Check the children first, to see if one of them is unbalanced
    for child in tree[node].childrenStringList do
    begin
      weight := tree[child].cweight + tree[child].weight;
      child_weight := child_weight + weight;
      if balance.containskey(weight) then
        balance[weight] := balance[weight] + 1
      else
        balance.add(weight, 1);
    end;
    if balance.Count = 1 then
    begin
      writeln('Children are balanced, we are at an unbalanced node: ', node);
      Write('  old weight: ', tree[node].weight);
      writeln('  new weight: ', balanceto - child_weight);
    end
    else
    begin
      writeln('Need to find unbalanced child node of: ', node);
      for i in balance.keys do
        if balance[i] = 1 then
          child_weight := i
        else
          new_balance := i;
      for child in tree[node].childrenStringList do
        if tree[child].weight + tree[child].cweight = child_weight then
          check_weights(child, tree, new_balance);
    end;

  end;

  procedure part2(infilename: string);
  var
    datain: TStringList;
    i: integer;
    s, child: string;
    t: TPNode;
    tree: TPNodeTree;
    root: string;
    parents: TStringDict;
    weight: integer;
  begin
    writeln('Part 2 --------------------------');
    datain := read_datA_file(infilename);
    weight := 0;
    tree := TPNodeTree.Create;
    parents := TStringDict.Create;

    for s in datain do
    begin

      writeln(s);
      t := parse_line(s);
      tree.add(t.Name, t);
      writeln('   name: ', t.Name);
      writeln(' weight: ', t.weight);
      weight := weight + t.weight;
      if t.childrenStringList.Count = 0 then
        t.cweight := 0
      else
        t.cweight := -1;
      for child in t.childrenstringlist do
      begin
        writeln('    child: ', child);
        parents.add(child, t.Name);
      end;
    end;

    // Find the root
    for s in tree.Keys do
      if not parents.containskey(s) then
        root := s;
    writeln('The root node is: ', root);
    print_node(root, 0, tree);

    // Add the weights
    calculate_weights(tree, root);
    print_node(root, 0, tree);

    check_weights(root, tree, weight);

  end;

var
  fname: string;
begin
  if IN_TEST then
    fname := 'day7test'
  else
    fname := 'day7input.txt';

  //if PART = 1 then part1;
  if PART = 2 then part2(fname);

  readln;
end.
