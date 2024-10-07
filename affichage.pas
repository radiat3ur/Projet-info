Unit affichage;

interface 

Uses Crt, TypeEtCte, gestion;

procedure affichageMenu();
procedure affichageRegles();
procedure choixDebutJeu(var nbJoueurs : Integer ; var joueurs : TJoueurs);
procedure menu(var choix, nbJoueurs : Integer; var joueurs : TJoueurs);

procedure preventionTourJoueur(joueurs : TJoueurs);
procedure affichageCarte(carte : TCarte);
procedure affichagePaquet(paquet: TPaquet);

implementation

procedure affichageMenu();
begin
  writeln('--- Menu du Cluedo ---');
  writeln('1. Afficher les règles du jeu');
  writeln('2. Commencer une nouvelle partie');
  writeln('3. Quitter le jeu');
  write('Votre choix : ');
end;

procedure affichageRegles();
begin
  writeln('--- Règles du Cluedo ---');
  writeln('Blabla des règles');
end;

procedure choixDebutJeu(var nbJoueurs : Integer ; var joueurs : TJoueurs);
var 
  i, j, choixPersonnage : Integer;
  personnagesDisponibles: array[0..MAX_PERSONNAGES-1] of Boolean;
begin
  repeat
    write('Entrez le nombre de joueurs (2 à 6) : ');
    readln(nbJoueurs);
  until (nbJoueurs >= 2) and (nbJoueurs <= MAX_PERSONNAGES);

  joueurs.taille := nbJoueurs;
  SetLength(joueurs.listeJoueurs,joueurs.taille);

  // Initialisation des personnages disponibles
  for i := 0 to MAX_PERSONNAGES - 1 do
    personnagesDisponibles[i] := True; // Tous les personnages sont disponibles

  for i := 0 to nbJoueurs - 1 do
  begin
    writeln('Joueur ', i + 1, ', choisissez un personnage : ');
    
    // Afficher les personnages disponibles
    for j:= 0 to MAX_PERSONNAGES - 1 do
    begin
      if personnagesDisponibles[j] then
        writeln(j + 1, '. ', TPersonnages(j));
    end;
    
    // Lire le choix du joueur
    repeat
      write('Votre choix (1-6) : ');
      readln(choixPersonnage);
    until (choixPersonnage >= 1) and (choixPersonnage <= MAX_PERSONNAGES) and personnagesDisponibles[choixPersonnage - 1];

    // Assigner le personnage au joueur
    joueurs.listeJoueurs[i].nom := TPersonnages(choixPersonnage - 1);
    personnagesDisponibles[choixPersonnage - 1] := False; // Marquer le personnage comme utilisé
  end;
end;


procedure menu(var choix, nbJoueurs : Integer ; var joueurs : TJoueurs ; var fin : Boolean);

begin
  quitter := false;
  //repeat
    ClrScr;
    affichageMenu();
    readln(choix);
	
    case choix of
      1: begin
             ClrScr;
             affichageRegles();
           end;
      2: begin
             ClrScr;
             choixDebutJeu(nbJoueurs, joueurs);
           end;
      3: fin := true;
    else
      writeln('Choix invalide, veuillez réessayer.');
    end;
  //until fin;
end;

procedure preventionTourJoueur(fin : Boolean ; joueurs : TJoueurs ; var i : Integer);
begin
  while (fin=False) do
  begin
    i:=i+1;
    if i>joueurs.taille then
      i:=1
  end;
end;

begin
  while quitter=False do
end;

procedure affichageCarte(carte : TCarte);
begin
    writeln(carte.nom)
end;

procedure affichagePaquet(paquet : TPaquet);
var i : Integer;

begin
  for i:=0 paquet.taille-1 do
    afficherCarte(paquet.liste[i])
end;

end.
