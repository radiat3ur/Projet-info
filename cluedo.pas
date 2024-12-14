program cluedo;

uses Dos, Crt, sysUtils, Process;

var choix : Integer;

begin
    repeat
        writeln('Que voulez faire ?');
        writeln('1. Lancer le jeu dans le terminal');
        writeln('2. Utiliser une interface graphique');
        readln(choix);
        ClrScr;
    until (choix>=1) and (choix<=2);
    if choix=1 then
        Exec('Cluedo Initial/main', '');
    writeln(DosError);
    if choix=2 then
       Exec('Cluedo SDL/main', '');
end.
