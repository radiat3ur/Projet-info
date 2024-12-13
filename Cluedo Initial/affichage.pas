Unit affichage; // Amanda

interface 

Uses Crt, TypeEtCte, SDL2, SDL2_mixer;

procedure effacerLignes(ligne, nbLignes: Integer);
procedure affichageMenu();
procedure affichageRegles();
procedure narration();

procedure preventionTourJoueur(joueurs: TJoueurs; var i: Integer);
procedure finTourJoueur();

procedure affichageCarte(carte: TCarte);
procedure affichagePaquet(paquet: TPaquet);

procedure attributionCouleur(couleur: TCouleur);
procedure afficherEtiquettes(i, j: Integer);
procedure affichageLegende(i : Integer);

procedure affichagePlateau(var plateau: TPlateau; joueurs: TJoueurs; joueurActuel: Integer);

procedure annonceTour(joueurActuel: Integer);


implementation

procedure effacerLignes(ligne, nbLignes: Integer);
var i: Integer;
begin
  for i := 0 to nbLignes - 1 do
  begin
    GotoXY(1, ligne + i);
    ClrEol;
  end;
  GotoXY(1,18);
end;

procedure affichageMenu(); // Affiche le menu au tout début du jeu
begin
  writeln('==========================');
  writeln(#27'[1m       MENU PRINCIPAL      '#27'[0m'); // Met en gras
  writeln('==========================');
  writeln('+--------------------------------+');
  writeln('|1. Afficher les regles du jeu   |');
  writeln('|2. Commencer une nouvelle partie|');
  writeln('|3. Quitter le jeu               |');
  writeln('+--------------------------------+');
  write('Votre choix : ');
end;

procedure affichageRegles(); // Affiche les règles
begin
  writeln('--- Regles du Jeu ---');
  writeln('Bienvenue a l''INSA, ou un crime odieux vient d''etre commis!');
  writeln('Le professeur d''informatique, Monsieur Lecomte, a ete retrouve mort dans des circonstances mysterieuses.');

  writeln('Votre mission : remonter la piste et decouvrir qui est le coupable, avec quelle arme, et dans quelle piece.');
  writeln('Saurez-vous resoudre ce mystere avant vos camarades ?');
  writeln;

  writeln('--- Comment commencer une partie ? ---');
  writeln(' • Chaque joueur choisit un pion pour incarner son personnage prefere. Ce sera votre avatar d''enqueteur tout au long de la partie.');
  writeln(' • Le programme selectionne automatiquement une arme, un suspect et un lieu.');
  writeln('   Ces elements sont places dans une enveloppe virtuelle qui contient la solution de l''enigme.');
  writeln('   Les cartes restantes sont reparties automatiquement entre les joueurs.');
  writeln(' • Munissez-vous d''une feuille d''enquete qui repertorie tous les suspects, armes, et lieux possibles.');
  writeln;
  writeln('Appuyez sur ENTREE pour afficher la suite');
  readln;
  
  writeln('--- Comment jouer ? ---');
  writeln('La partie commence dans les couloirs de l''INSA, chaque pion a un emplacement predefini.');
  writeln;
  writeln('A chaque tour :');
  writeln(' • Vous lancez virtuellement les des (avec la touche ENTREE) pour avancer dans les couloirs de l''ecole.');
  writeln(' • Sur le plateau, les pions se deplacent a l''aide des fleches du clavier.');
  writeln(' • Si vous arrivez dans un couloir, votre tour est termine.');
  writeln(' • Si vous entrez dans une piece, vous pouvez formuler une hypothese sur le crime.');
  writeln;

  writeln('Formuler une hypothese :');
  writeln('   ◦ Vous choisissez un suspect, une arme du crime, et la piece ou vous etes.');
  writeln('     (par exemple : Je pense que c''est DuDu, avec le reveil, dans la bibliotheque.)');
  writeln('   ◦ Vous designer un joueur.');
  writeln('   ◦ Si le joueur designe possede une ou plusieurs des cartes de l''hypothese, il en choisit une');
  writeln('     et elle vous sera revelee en prive.');
  writeln('   ◦ Si personne ne possede les cartes que vous avez mentionnees, vous etes peut-etre proche de la solution!');
  writeln('   ◦ Votre tour est termine.');
  writeln;
  writeln('Continuez d''explorer d''autres pieces, de formuler des hypotheses, et d''eliminer des options');
  writeln('sur votre feuille d’enquete numerique.');
  writeln;

  writeln('--- Comment gagner ? ---');
  writeln('Formuler une accusation finale :');
  writeln(' • Lorsque vous pensez avoir identifie les trois elements du crime, vous pouvez formuler une accusation.');
  writeln('   Contrairement a l''hypothese, elle peut se faire depuis n''importe quelle case du plateau.');
  writeln(' • Si votre accusation est correcte, le programme revelera la solution, et vous deviendrez');
  writeln('   le maitre enqueteur. Felicitations !');
  writeln(' • Si vous vous trompez, vous perdez la partie et les autres joueurs l''emportent.');
  writeln('   Ne vous loupez pas !');
  writeln;

  writeln('Pret a resoudre le mystere ? L''INSA n''attend que vous... Que l''enquete commence !');
end;

procedure narration(); // Affiche la narration
begin
  write('La nuit est tombee sur le campus de l''INSA, et une ombre s''etend sur les batiments normalement empreints de l''effervescence etudiante. Mais ce soir, l''atmosphere est differente... une tension palpable flotte dans l''air. ');
  write('Au petit matin, la terrible nouvelle est tombee comme un couperet : Alexis LECOMTE, figure respectee (et redoutee) de l''ecole, a ete retrouve sans vie, mysterieusement assassine. ');
  writeln('Son corps inerte a ete decouvert dans l''une des salles de l''etablissement, entoure de quelques accessoires de laboratoire... et des indices qui echappent a toute logique. ');
  writeln();
  writeln('Les lieux du crime restent inconnus : a-t-il ete surpris au laboratoire de chimie, attaque dans le calme apparent de la bibliotheque, ou pris au piege dans la salle des machines ? Autour de lui, des traces d''etranges outils et accessoires de travail, signes d''une lutte inattendue. ');
  write('Mais le plus surprenant dans cette sombre affaire, c''est que chacun des professeurs proches de lui semble avoir un alibi... ou une excuse. Entre jalousies academiques, vieilles rancunes et competitions feroces, il se pourrait bien que l''un d''eux ait franchi la ligne de l''acceptable.');
  readln();
end;

procedure preventionTourJoueur(joueurs: TJoueurs; var i : Integer);
begin
  i := (i + 1) mod length(joueurs);
  writeln('Appuyez sur Entree lorsque le joueur ', joueurs[i].nom, ' est pret.');
  Readln;
  ClrScr;
end;

procedure finTourJoueur();
begin
  writeln();
  writeln('Appuyez sur Entree pour terminer votre tour');
  readln;
  ClrScr;
end;

procedure affichageCarte(carte: TCarte);
begin
  writeln(carte);
end;

procedure affichagePaquet(paquet: TPaquet);
var  i: Integer;

begin
  for i := 0 to length(paquet)-1 do
    affichageCarte(paquet[i]);
end;

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

procedure afficherEtiquettes(i, j: Integer);
begin
  if (j = 21) then
  begin
    TextColor(0);
    if (i = 2) or (i = 14 ) then
      write('B')
    else if (i = 15) then
      write('D')
    else if (i = 16) then
      write('E')
    else if (i = 8) then
      write('R')
    else if (i = 3) or (i = 9) then
      write('U')
  end;
  TextColor(15);
end;

procedure affichageLegende(i : Integer);
begin
case i of
  1: begin
      TextBackground(0);
      write('  Legende :');
    end;
  2: write();
  3: begin
      TextBackground(0);
      write('   ');
      TextBackground(1);
      write('   ');
      TextBackground(0);
      write(' - Amphi Tillion');
    end;
  4: begin
      TextBackground(0);
      write('    ');
      TextBackground(4);
      write('   ');
      TextBackground(0);
      write(' - BU');
      end;
  5: begin
      TextBackground(0);
      write('    ');
      TextBackground(2);
      write('   ');
      TextBackground(0);
      write(' - Labo');
    end;
  6: begin
      TextBackground(0);
      write('    ');
      TextBackground(5);
      write('   ');
      TextBackground(0);
      write(' - Parking visiteurs');
    end;
  7: begin
      TextBackground(0);
      write('    ');
      TextBackground(14);
      write('   ');
      TextBackground(0);
      write(' - RU');
    end;
  8: begin
      TextBackground(0);
      write('   ');
      TextBackground(1);
      write('   ');
      TextBackground(0);
      write(' - BDE');
    end;
  9: begin  
      TextBackground(0);
      write('   ');
      TextBackground(3);
      write('   ');
      TextBackground(0);
      write(' - Residence');
    end;
  10: begin
      TextBackground(0);
      write('    ');
      TextBackground(4);
      write('   ');
      TextBackground(0);
      write(' - Infirmerie');
    end;
  11: begin
      TextBackground(0);
      write('    ');
      TextBackground(14);
      write('   ');
      TextBackground(0);
      write(' - Cafeteria');
    end;
  end;
end;

procedure affichagePlateau(var plateau: TPlateau; joueurs: TJoueurs; joueurActuel: Integer);
var
  i, j: Integer;
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
      afficherEtiquettes(i,j);

      if plateau[i, j].joueurID > 0 then
        write(plateau[i, j].joueurID) // Afficher le numéro du joueur
      else if plateau[i, j].typePiece = Mur then
        write(' ') 
      else
        write('.'); // Couloirs et pièces marqués par '.'  
          
    end;
    affichageLegende(i);
    writeln;
  end;
  TextBackground(0);
end;

procedure AnnonceTour(joueurActuel: Integer);
var music: PMix_Music;
begin
  if Mix_OpenAudio(22050, AUDIO_S16, 2, 4096) < 0 then halt;
  case joueurActuel of
    0: music := Mix_LoadMUS('son/joueur1.wav');
    1: music := Mix_LoadMUS('son/joueur2.wav');
    2: music := Mix_LoadMUS('son/joueur3.wav');
    3: music := Mix_LoadMUS('son/joueur4.wav');
    4: music := Mix_LoadMUS('son/joueur5.wav');
    5: music := Mix_LoadMUS('son/joueur6.wav');
  end;

  if music <> nil then
  begin
    Mix_PlayMusic(music, 0); // 1 lecture
    SDL_Delay(3000);         
    Mix_FreeMusic(music);
  end;

  Mix_CloseAudio;
end;
end.
