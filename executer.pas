program executer;

uses Dos, Crt, sysUtils, Process;

var Aprocess : TProcess;
    choix : Integer;

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

    // Aprocess := TProcess.Create(nil);
    // Aprocess.Executable := 'Cluedo SDL/main';
    // Aprocess.Options := AProcess.Options + [poWaitOnExit];
    // AProcess.Execute;
end.
