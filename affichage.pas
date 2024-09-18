Unit affichage;

interface 

Uses Crt, T&Cte;

procedure afficherMenu();
procedure afficherRegles();
procedure choixDebutJeu(var nbJoueur : Word);
procedure menu(var choix : Word);

implementation

procedure afficherMenu();
begin
  writeln('--- Menu du Cluedo ---');
  writeln('1. Afficher les règles du jeu');
  writeln('2. Commencer une nouvelle partie');
  writeln('3. Quitter le jeu');
  write('Votre choix : ');
end;

procedure afficherRegles();
begin
  writeln('--- Règles du Cluedo ---');
  writeln('Blabla des règles');
end;

procedure choixDebutJeu(var nbJoueur : Word);
var i, choix: integer;
	joueurs: array[1..6] of string;
	personnagesDisponibles: array[1..MAX_PERSONNAGES] of Boolean;
	
begin
  // Initialisation des personnages disponibles
  for i := 1 to MAX_PERSONNAGES do
    personnagesDisponibles[i] := True;

  // Saisie du nombre de joueurs
  repeat
    write('Entrez le nombre de joueurs (2 à 6) : ');
    readln(nbJoueur);
  until (nbJoueur >= 2) and (nbJoueur <= MAX_PERSONNAGES);

  // Choix des personnages pour chaque joueur
  for i := 1 to nbJoueur do
  begin
    writeln('Joueur ', i, ', choisissez votre personnage :');
    
    // Affichage des personnages disponibles
    for choix := 1 to MAX_PERSONNAGES do
    begin
      if personnagesDisponibles[choix] then
        writeln(choix, '. ', Personnages[choix]);
    end;

    // Saisie du choix du personnage
    repeat
      write('Votre choix (1-', MAX_PERSONNAGES, ') : ');
      readln(choix);
    until (choix >= 1) and (choix <= MAX_PERSONNAGES) and personnagesDisponibles[choix];

    joueurs[i] := Personnages[choix];
    personnagesDisponibles[choix] := False;  // Marque le personnage comme choisi
    writeln('Vous avez choisi : ', Personnages[choix]);
    ClrScr;
  end;

  // Affichage des joueurs et de leurs personnages
  writeln('--- Liste des joueurs et de leurs personnages ---');
  for i := 1 to nbJoueur do
    writeln('Joueur ', i, ': ', joueurs[i]);

  writeln('Appuyez sur une touche pour revenir au menu.');
  readln;
end;

procedure menu(var choix : Word);
var quitter:Boolean;nbJoueur:Word;
begin
  quitter := false;
  repeat
    ClrScr;
    afficherMenu();
    readln(choix);
	
    case choix of
      1: begin
             ClrScr;
             afficherRegles();
           end;
      2: begin
             ClrScr;
             choixDebutJeu(nbJoueur);
           end;
      3: quitter := true;
    else
      writeln('Choix invalide, veuillez réessayer.');
    end;
  until quitter;
  writeln('Merci d''avoir joué !');
end;

end.
