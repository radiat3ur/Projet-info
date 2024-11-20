Program ClrEOLSamples;
 
Uses Crt;
 
BEGIN
 ClrScr;
 Write('AAAAAAABBBBBBCCCCCC');
 GotoXY(10,1);
 ClrEol;
 Write('DEF');
 GotoXY(1,2);
 Write('GGGGGGLLLLLLLAAAAAA');
 GotoXY(20,2);
 ClrEol;
 GotoXY(1,3);
END.