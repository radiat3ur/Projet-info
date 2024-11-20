Unit gestion_plateau;

interface

Uses Crt, affichage, TypeEtCte, gestion, affichage_plateau;

procedure initilisationPositionsJoueurs(var joueurs : TJoueurs ; var plateau : TPlateau);
procedure initialiserPiece(var plateau: TPlateau; debutX, finX, debutY, finY: Integer; piece: TPiece; couleur: TCouleur);
procedure initialiserPlateau(var plateau: TPlateau);
procedure deplacerJoueur(var joueurs: TJoueurs; currentPlayer: Integer; var plateau: TPlateau; var deplacement: Integer);
procedure jouerTour(var joueurs: TJoueurs; var plateau: TPlateau; paquetPieces, paquetArmes, paquetPersonnages, solution: TPaquet; joueurActuel : TJoueur; cartesChoisies : TPaquet; carteChoisie : TCarte);

implementation

procedure initilisationPositionsJoueurs(var joueurs : TJoueurs ; var plateau : TPlateau);
var i : Integer;

begin
  for i:=0 to joueurs.taille-1 do
    begin
      // Position initiale dans un couloir
      joueurs.listeJoueurs[i].x := 2; 
      joueurs.listeJoueurs[i].y := 2+4*i;

      // Placer le joueur sur le plateau
      plateau[joueurs.listeJoueurs[i].x, joueurs.listeJoueurs[i].y].estOccupee := True;
      plateau[joueurs.listeJoueurs[i].x, joueurs.listeJoueurs[i].y].joueurID := i+1;

      // Vérifiez que la case est un couloir et n'est pas occupée
    end;
end;

// Procédure pour initialiser les pièces et leurs couleurs
procedure initialiserPiece(var plateau: TPlateau; debutX, finX, debutY, finY: Integer; piece: TPiece; couleur: TCouleur);
var i, j: Integer;

begin
  for i := debutX to finX do
    for j := debutY to finY do
    begin
      plateau[i, j].typePiece := piece;
      plateau[i, j].couleur := couleur;
      plateau[i, j].estOccupee := False;
    end;

  for i := debutX - 1 to finX + 1 do
  begin
    plateau[i, debutY - 1].typePiece := Mur;
    plateau[i, debutY - 1].couleur := White;
    plateau[i, finY + 1].typePiece := Mur;
    plateau[i, finY + 1].couleur := White;
  end;

  for j := debutY to finY do
  begin
    plateau[debutX - 1, j].typePiece := Mur;
    plateau[debutX - 1, j].couleur := White;
    plateau[finX + 1, j].typePiece := Mur;
    plateau[finX + 1, j].couleur := White;
  end;
end;

// Procédure pour initialiser le plateau avec des couloirs par défaut
procedure initialiserPlateau(var plateau: TPlateau);
var i, j: Integer;

begin
  for i := 1 to 16 do
    for j := 1 to 21 do
    begin
      plateau[i, j].typePiece := Couloir;
      plateau[i, j].couleur := Black;
      plateau[i, j].estOccupee := False;
    end;

  for i := 1 to 16 do
  begin
    plateau[i, 1].typePiece := Mur;
    plateau[i, 21].typePiece := Mur;
  end;
  for j := 1 to 21 do
  begin
    plateau[1, j].typePiece := Mur;
    plateau[16, j].typePiece := Mur;
  end;

  initialiserPiece(plateau, 2, 3, 2, 4, Amphi_Tillionn, Blue);
  initialiserPiece(plateau, 2, 3, 10, 12, Laboo, Green);
  initialiserPiece(plateau, 2, 3, 18, 20, BUU, Red);
  initialiserPiece(plateau, 8, 9, 2, 4, RUU, Yellow);
  initialiserPiece(plateau, 8, 9, 10, 12, Parking_visiteurs, Magenta);
  initialiserPiece(plateau, 8, 9, 18, 20, Cafeteriaa, Yellow);
  initialiserPiece(plateau, 14, 15, 2, 4, Infirmeriee, Red);
  initialiserPiece(plateau, 14, 15, 10, 12, Residencee, Cyan);
  initialiserPiece(plateau, 14, 15, 18, 20, BDEE, Blue);

  plateau[4, 3].typePiece:= Couloir;
  plateau[3, 9].typePiece:= Couloir;
  plateau[4, 11].typePiece:= Couloir;
  plateau[2, 17].typePiece:= Couloir;
  plateau[8, 5].typePiece:= Couloir;
  plateau[9, 9].typePiece:= Couloir;
  plateau[7, 12].typePiece:= Couloir;
  plateau[7, 18].typePiece:= Couloir;
  plateau[10, 20].typePiece:= Couloir;
  plateau[13, 3].typePiece:= Couloir;
  plateau[13, 10].typePiece:= Couloir;
  plateau[15, 17].typePiece:= Couloir;
end;

// Procédure pour déplacer un joueur
procedure deplacerJoueur(var joueurs: TJoueurs; currentPlayer: Integer; var plateau: TPlateau; var deplacement: Integer);
var
  oldX,oldY,newX, newY: Integer;
  key: Char;
begin
  while deplacement > 0 do
  begin
    key := ReadKey;

    // Calculer la nouvelle position en fonction de la touche
    newX := joueurs.listeJoueurs[currentPlayer].x;
    newY := joueurs.listeJoueurs[currentPlayer].y;
    oldX := newX;
    oldY := newY;

    case key of
      #72: Dec(newX); // Haut
      #80: Inc(newX); // Bas
      #75: Dec(newY); // Gauche
      #77: Inc(newY); // Droite
    end;

    // Vérifier si la nouvelle position est valide
    if (plateau[newX, newY].typePiece <> Mur) and (not plateau[newX, newY].estOccupee) then
    begin
      // Libérer l'ancienne position
      plateau[joueurs.listeJoueurs[currentPlayer].x, joueurs.listeJoueurs[currentPlayer].y].estOccupee := False;
      plateau[joueurs.listeJoueurs[currentPlayer].x, joueurs.listeJoueurs[currentPlayer].y].joueurID := 0;

      // Déplacer le joueur
      joueurs.listeJoueurs[currentPlayer].x := newX;
      joueurs.listeJoueurs[currentPlayer].y := newY;

      // Occuper la nouvelle position
      plateau[newX, newY].estOccupee := True;
      plateau[newX, newY].joueurID := currentPlayer + 1; // ID de joueur commence à 1

      Dec(deplacement); // Réduire le nombre de déplacements restants

      GotoXY(oldY,oldX+1);
      attributionCouleur(plateau[oldX,oldY].couleur);
      write('.');

      GotoXY(newY,newX+1);
      attributionCouleur(plateau[newX,newY].couleur);
      write(currentPlayer+1);

      GotoXY(1,20);
      attributionCouleur(Black);
      ClrEol();
      GotoXY(1,21);
      ClrEol();
      GotoXY(1,20);
    end;
  end;
end;

// Procédure principale pour gérer les tours
procedure jouerTour(var joueurs: TJoueurs; var plateau: TPlateau; paquetPieces, paquetArmes, paquetPersonnages, solution: TPaquet; joueurActuel : TJoueur; cartesChoisies : TPaquet; carteChoisie : TCarte);

var
  currentPlayer, deplacement: Integer;
  action : Integer;
  resultatAction : Boolean;
begin
  for currentPlayer := 0 to joueurs.taille - 1 do
  begin
    // Nombre de déplacements pour le joueur actuel
    deplacement := 7; // Exemple : 5 déplacements par tour
    writeln('Joueur ', currentPlayer + 1, ', c''est votre tour !');
    deplacerJoueur(joueurs, currentPlayer, plateau, deplacement);
  end;

    writeln('1. Hypothese');
    writeln('2. Accusation');
    resultatAction:=choixAction(action);

    if resultatAction then
        affichageResultatHypothese(paquetPieces, paquetArmes, paquetPersonnages, joueurs.listeJoueurs[currentPlayer], joueurs, cartesChoisies, carteChoisie)
    else
    begin
        affichageResultatAccusation(paquetPieces, paquetArmes, paquetPersonnages, solution, joueurs.listeJoueurs[currentPlayer]);
        halt;
    end;
end;

end.