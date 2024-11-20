Unit affichage_plateau;

interface

Uses Crt, affichage, TypeEtCte, gestion;

procedure afficherPlateau(var plateau: TPlateau; joueurs: TJoueurs; joueurActuel: Integer; deplacementRestant: Integer);
procedure attributionCouleur(couleur: TCouleur);

implementation

// Procédure pour attribuer une couleur au texte de fond
procedure attributionCouleur(couleur: TCouleur);

begin
  case couleur of
    Black: TextBackground(0);
    Blue: TextBackground(1);
    Green: TextBackground(2);
    Cyan: TextBackground(3);
    Red: TextBackground(4);
    Magenta: TextBackground(5);
    Yellow: TextBackground(14);
    White: TextBackground(15);
  end;
end;

// Procédure pour afficher le plateau avec les joueurs
procedure afficherPlateau(var plateau: TPlateau; joueurs: TJoueurs; joueurActuel: Integer; deplacementRestant: Integer);
var
  i, j, k: Integer;
  caseJoueur: Boolean;
begin
  ClrScr;
  writeln('Plateau de jeu :');
  for i := 1 to 16 do
  begin
    for j := 1 to 21 do
    begin
      // Ajuster la couleur uniquement si Mur ou Couloir
      if plateau[i, j].typePiece = Mur then
        plateau[i, j].couleur := White
      else if plateau[i, j].typePiece = Couloir then
        plateau[i, j].couleur := Black;

      attributionCouleur(plateau[i, j].couleur);

      if plateau[i, j].joueurID > 0 then
        write(plateau[i, j].joueurID) // Afficher le numéro du joueur
      else if plateau[i, j].typePiece = Mur then
        write(' ') // Mur marqué par "x"
      else
        write('.'); // Couloirs et pièces marqués par '.'
    end;

    case i of
          1: begin
                TextBackground(0);
                write('  Legende :');
              end;
          2: write();
          3: begin
                TextBackground(0);
                write('  ');
                TextBackground(1);
                write('   ');
                TextBackground(0);
                write(' - Amphi Tillion');
              end;
          4: begin
                TextBackground(0);
                write('  ');
                TextBackground(4);
                write('   ');
                TextBackground(0);
                write(' - BU');
              end;
          5: begin
                TextBackground(0);
                write('  ');
                TextBackground(2);
                write('   ');
                TextBackground(0);
                write(' - Labo');
              end;
          6: begin
                TextBackground(0);
                write('  ');
                TextBackground(5);
                write('   ');
                TextBackground(0);
                write(' - Parking visiteurs');
              end;
          7: begin
                TextBackground(0);
                write('  ');
                TextBackground(14);
                write('   ');
                TextBackground(0);
                write(' - RU');
              end;
          8: begin
              TextBackground(0);
              write('  ');
              TextBackground(1);
              write('   ');
              TextBackground(0);
              write(' - BDE');
              end;
          9: begin  
              TextBackground(0);
              write('  ');
              TextBackground(3);
              write('   ');
              TextBackground(0);
              write(' - Residence');
              end;
          10: begin
              TextBackground(0);
              write('  ');
              TextBackground(4);
              write('   ');
              TextBackground(0);
              write(' - Infirmerie');
              end;
          11: begin
              TextBackground(0);
              write('  ');
              TextBackground(14);
              write('   ');
              TextBackground(0);
              write(' - Cafeteria');
              end;
      end;
    writeln;
  end;

  TextBackground(0);
  writeln('Tour du Joueur ', joueurActuel, '.');
  writeln('Déplacements restants : ', deplacementRestant);
end;

end.
