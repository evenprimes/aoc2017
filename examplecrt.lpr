program examplecrt;
uses crt;
begin

  WriteLn('This is written in the default color');
  TextColor(Red);
  WriteLn('This is written in Red');
  TextColor(White);
  WriteLn('This is written in White');
  TextColor(LightBlue);
  WriteLn('This is written in Light Blue');
  NormVideo;
  writeln('THis is back to normal');
  readln;
end.

