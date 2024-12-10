Unit affichage;

interface 

Uses Crt, TypeEtCte, gestion, SDL2, SDL2_mixer;

procedure narration();
procedure affichageMenu();
procedure affichageRegles();
procedure choixDebutJeu(var nbJoueurs : Integer ; var joueurs : TJoueurs);
procedure menu(var choix, nbJoueurs : Integer ; var joueurs : TJoueurs);
procedure preventionTourJoueur(joueurs: TJoueurs; var i: Integer);
procedure finTourJoueur();
procedure affichageCarte(carte : TCarte);
procedure affichagePaquet(paquet: TPaquet);
procedure affichageResultatHypothese(paquetPieces, paquetArmes, paquetPersonnages: TPaquet; joueurActuel : TJoueur; joueurs : TJoueurs; cartesChoisies : TPaquet; carteChoisie : TCarte; var presenceCarteCommune:boolean;currentPlayer:integer;plateau:TPlateau);
procedure affichageResultatAccusation(paquetPieces, paquetArmes, paquetPersonnages, solution : TPaquet; joueurActuel : TJoueur);

procedure attributionCouleur(couleur: TCouleur);
procedure affichageLegende(i : Integer);
procedure affichagePlateau(var plateau: TPlateau; joueurs: TJoueurs; joueurActuel: Integer);
Procedure PlacerPionDansPiece(var plateau: TPlateau; currentPlayer: Integer; piece: TPiece);
procedure PlacerDevantPorte(var plateau: TPlateau; var joueurs: TJoueurs; currentPlayer: Integer; var deplacement:integer);
procedure deplacerJoueur(var joueurs: TJoueurs; currentPlayer: Integer; var plateau: TPlateau; var deplacement: Integer);
function LancerDes( deplacement:integer) : integer;
procedure jouerTour(var joueurs: TJoueurs; var plateau: TPlateau; paquetPieces, paquetArmes, paquetPersonnages, solution: TPaquet; joueurActuel : TJoueur; cartesChoisies : TPaquet; carteChoisie : TCarte; currentPlayer:integer);



implementation

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
  writeln('Le professeur d''informatique, **Monsieur Lecomte**, a ete retrouve mort dans des circonstances mysterieuses.');

  writeln('Votre mission : **remonter la piste** et decouvrir qui est le coupable, avec quelle arme, et dans quelle piece.');
  writeln('**Saurez-vous resoudre ce mystere avant vos camarades ?**');
  writeln;

  writeln('--- Comment commencer une partie ? ---');
  writeln(' • Chaque joueur choisit un pion pour incarner son personnage prefere. Ce sera votre **avatar d''enqueteur** tout au long de la partie.');
  writeln(' • Le programme selectionne automatiquement une arme, un suspect et un lieu.');
  writeln('   Ces elements sont places dans une **enveloppe virtuelle** qui contient la solution de l''enigme.');
  writeln('   Les cartes restantes sont **reparties automatiquement** entre les joueurs.');
  writeln(' • Munissez-vous d''une feuille d''enquete qui repertorie tous les suspects, armes, et lieux possibles.');
  writeln;
  writeln(#27'[3mAppuyez sur ENTREE pour afficher la suite'#27'[0m'); // Texte en italique (verifier à l'insa!)
  readln;
  
  writeln('--- Comment jouer ? ---');
  writeln('La partie commence dans les couloirs de l''INSA, chaque pion a un **emplacement predefini**.');
  writeln;
  writeln('A chaque tour :');
  writeln(' • Vous lancez virtuellement les des (avec la touche **ENTREE**) pour avancer dans les couloirs de l''ecole.');
  writeln(' • Sur le plateau, les pions se deplacent a l''aide des **fleches du clavier**.');
  writeln(' • Si vous arrivez dans un couloir, votre tour est termine.');
  writeln(' • Si vous entrez dans une piece, vous pouvez formuler une **hypothese** sur le crime.');
  writeln;

  writeln('Formuler une hypothese :');
  writeln('   ◦ Vous choisissez un **suspect**, une **arme du crime**, et la **piece ou vous etes**.');
  writeln('     (par exemple : Je pense que c''est **DuDu**, avec le **reveil**, dans la **bibliotheque**.)');
  writeln('   ◦ Vous designer un joueur.');
  writeln('   ◦ Si le joueur designe possede une ou plusieurs des cartes de l''hypothese, il en choisit une');
  writeln('     et elle vous sera revelee en prive.');
  writeln('   ◦ Si personne ne possede les cartes que vous avez mentionnees, vous etes peut-etre **proche de la solution**!');
  writeln('   ◦ Votre tour est termine.');
  writeln;
  writeln('Continuez d''explorer d''autres pieces, de formuler des hypotheses, et d''eliminer des options');
  writeln('sur votre **feuille d’enquete numerique**.');
  writeln;

  writeln('--- Comment gagner ? ---');
  writeln('Formuler une **accusation finale** :');
  writeln(' • Lorsque vous pensez avoir identifie les trois elements du crime, vous pouvez formuler une **accusation**.');
  writeln('   Contrairement a l''hypothese, elle peut se faire depuis **n''importe quelle case** du plateau.');
  writeln(' • Si votre accusation est correcte, le programme revelera la solution, et vous deviendrez');
  writeln('   le **maitre enqueteur**. **Felicitations !**');
  writeln(' • Si vous vous trompez, vous perdez la partie et les autres joueurs l''emportent.');
  writeln('   **Ne vous loupez pas !**');
  writeln;

  writeln('Pret a resoudre le mystere ? L''INSA n''attend que vous... Que l''enquete commence !');
end;

procedure choixDebutJeu(var nbJoueurs : Integer ; var joueurs : TJoueurs);

begin
  repeat
    write('Entrez le nombre de joueurs (2-6) : ');
    readln(nbJoueurs); // Sélectionne le nombre de joueurs
  until (nbJoueurs >= 2) and (nbJoueurs <= MAX_PERSONNAGES); // Vérifie que le nombre est compris entre 2 et 6

  SetLength(joueurs,nbJoueurs); // Défini la taille du tableau des joueurs en fonction du nombre de joueurs
  initialisationJoueurs(joueurs, nbJoueurs); // (voir la procedure dans gestion.pas)
end;

procedure menu(var choix, nbJoueurs : Integer ; var joueurs : TJoueurs);

begin
repeat
  ClrScr;
  affichageMenu();
  readln(choix);

  case choix of
    1: begin
        ClrScr;
        affichageRegles(); // Lorsque 1 est tapé, on affiche les règles
        readln();
        menu(choix, nbJoueurs, joueurs);
        end;
    2: begin
          ClrScr;
          choixDebutJeu(nbJoueurs, joueurs); // Lorsque 2 est tapé, on initilialise le jeu
        end;
    3: halt; // Lorsque 3 est tapé, on quitte le jeu
  else
    writeln('Choix invalide, veuillez reessayer.');
  end;
  until (choix=1) or (choix=2) or (choix=3) ;
end;

procedure preventionTourJoueur(joueurs: TJoueurs; var i: Integer);
begin
  // Passe au joueur suivant
  i := (i + 1) mod length(joueurs);  // Parcourt les joueurs
  // Annonce du joueur dont c'est le tour
  writeln('Appuyez sur Entree lorsque le joueur ', joueurs[i].nom, ' est pret.');
  readln;
  ClrScr;
end;

procedure finTourJoueur();
begin
  writeln();
  writeLN('Appuyez sur Entree pour terminer votre tour');
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
  for i := 0 to length(paquet)-1 do // Parcourt le paquet
    affichageCarte(paquet[i]);
end;

procedure affichageResultatHypothese(paquetPieces, paquetArmes, paquetPersonnages: TPaquet; joueurActuel : TJoueur; joueurs : TJoueurs; cartesChoisies : TPaquet; carteChoisie : TCarte; var presenceCarteCommune:boolean;currentPlayer:integer;plateau:TPlateau);

begin
  hypothese(paquetPieces, paquetArmes, paquetPersonnages, joueurActuel, joueurs, cartesChoisies, carteChoisie, presenceCarteCommune,plateau,currentPlayer);
  writeln('Voici la "carte en commun" : ');
  if presenceCarteCommune= true then
    writeln(carteChoisie)
  else
    writeln('Aucune carte en commun');
end;

procedure affichageResultatAccusation(paquetPieces, paquetArmes, paquetPersonnages, solution : TPaquet; joueurActuel : TJoueur);
var resultat:Boolean;

begin
  resultat:=accusation(paquetPieces, paquetArmes, paquetPersonnages, solution, joueurActuel);
  if (resultat) then
    writeln(joueurActuel.nom, ' remporte la partie ! Les autres joueurs ont perdu.')
  else
    writeln(joueurActuel.nom, ' a perdu la partie. Les autres joueurs gagnent !');
    writeln('Le veritable coupable est : ',solution[2]);
    writeln('Les faits se sont deroules : ',solution[0]);
    writeln('L''arme du crime etait : ',solution[1]);
end;


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

procedure afficherEtiquettes(i, j: Integer);
begin
 //Ecriture BDE sur les bords
  if (i = 14) and (j = 21) then
  begin
    TextColor(0); // Texte noir
    write('B');
  end
  else if (i = 15) and (j = 21) then
  begin
    TextColor(0); // Texte noir
    write('D');
  end
  else if (i = 16) and (j = 21) then
  begin
    TextColor(0); // Texte noir
    write('E');
  end
  //Ecriture RU sur les bords
  else if (i = 8) and (j = 21) then
  begin
    TextColor(0); // Texte noir
    write('R');
  end
  else if (i = 9) and (j = 21) then
  begin
    TextColor(0); // Texte noir
    write('U');
  end
  //Ecriture BU sur les bords
  else if (i = 2) and (j = 21) then
  begin
    TextColor(0); // Texte noir
    write('B');
  end
  else if (i = 3) and (j = 21) then
  begin
    TextColor(0); // Texte noir
    write('U');
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

// Procédure pour afficher le plateau avec les joueurs
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

procedure PlacerPionDansPiece(var plateau: TPlateau; currentPlayer: Integer; piece: TPiece);
var
  i, j: Integer;
  positionTrouvee: Boolean;
  oldX, oldY: Integer;
begin
  positionTrouvee := False;

  // Trouver l'ancienne position du joueur et la libérer
  for i := 1 to 16 do
  begin
    for j := 1 to 21 do
    begin
      if (plateau[i, j].joueurID = currentPlayer) then
      begin
        oldX := i;
        oldY := j;

        // Libérer l'ancienne position
        plateau[i, j].estOccupee := False;
        plateau[i, j].joueurID := 0;

        // Effacer l'affichage de l'ancienne position
        GotoXY(oldY, oldX + 1);
        attributionCouleur(plateau[i, j].couleur);
        write('.');
        Break; // On arrête une fois la position trouvée
      end;
    end;
  end;

  // Parcours du plateau pour trouver une case libre dans la pièce donnée
  for i := 1 to 16 do
  begin
    for j := 1 to 21 do
    begin
      if (plateau[i, j].typePiece = piece) and not plateau[i, j].estOccupee then
      begin
        // Place le joueur sur la case libre trouvée
        plateau[i, j].estOccupee := True;
        plateau[i, j].joueurID := currentPlayer;
        positionTrouvee := True;

        // Afficher la nouvelle position
        GotoXY(j, i + 1);
        attributionCouleur(plateau[i, j].couleur);
        write(currentPlayer);
        attributionCouleur(Black);
        Break; // Arrête la boucle
      end;
    end;

    if positionTrouvee then
      Break;
  end;
end;

procedure PlacerDevantPorte(var plateau: TPlateau; var joueurs: TJoueurs; currentPlayer: Integer; var deplacement:integer);
var oldx,oldy,i, j, nbPortes, choix: Integer;
    portesDisponibles: array[1..2] of record
    x, y: Integer;
  end;
begin
  nbPortes := 0;
  for i := 1 to 16 do
  begin
    for j := 1 to 21 do
    begin
    //attribuer la position du pion
    if  plateau[i,j].joueurID=currentPlayer+1 then
    begin
    joueurs[currentPlayer].x:=i;
    joueurs[currentPlayer].y:=j;
    end;
      // Identifier les portes autour de la pièce
      if (plateau[i, j].typePiece = Couloir) and
         ((plateau[i + 1, j].typePiece = joueurs[currentPlayer].piecePrecedente) or
          (plateau[i - 1, j].typePiece = joueurs[currentPlayer].piecePrecedente) or
          (plateau[i, j + 1].typePiece = joueurs[currentPlayer].piecePrecedente) or
          (plateau[i, j - 1].typePiece = joueurs[currentPlayer].piecePrecedente)) then
      begin
        Inc(nbPortes);
        portesDisponibles[nbPortes].x := i;
        portesDisponibles[nbPortes].y := j;
        if nbPortes = 2 then //Arret lorsqu'il atteint un nb de 2 portes
          Break;
      end;
    end;
    if nbPortes = 2 then
      Break;
  end;

  // Affichage
  writeln('Choisissez une porte :');
  for i := 1 to nbPortes do
    writeln(i, '. Porte en position (', portesDisponibles[i].y, ',', portesDisponibles[i].x, ')');
  repeat
    write('Votre choix : ');
    readln(choix);
  until (choix >= 1) and (choix <= nbPortes);
  
  oldx:=joueurs[currentPlayer].x;
  oldy:=joueurs[currentPlayer].y;

   // Effacer l'ancienne position
  plateau[joueurs[currentPlayer].x, joueurs[currentPlayer].y].estOccupee := False;
  plateau[joueurs[currentPlayer].x, joueurs[currentPlayer].y].joueurID := 0;

  // Déplacer le joueur devant la porte choisie
  joueurs[currentPlayer].x := portesDisponibles[choix].x;
  joueurs[currentPlayer].y := portesDisponibles[choix].y;

  plateau[joueurs[currentPlayer].x, joueurs[currentPlayer].y].estOccupee := True;
  plateau[joueurs[currentPlayer].x, joueurs[currentPlayer].y].joueurID := currentPlayer+1;

  // Mettre à jour l'affichage
  GotoXY(oldY,oldx+1);
  attributionCouleur(plateau[oldX,oldY].couleur);
  write('.');
      
  GotoXY(portesDisponibles[choix].y, portesDisponibles[choix].x + 1); //+1 car écriture "plateau de jeu"
  attributionCouleur(plateau[joueurs[currentPlayer].x, joueurs[currentPlayer].y].couleur);
  write(currentPlayer+1);

  // Réinitialiser "dansPiece"
  joueurs[currentPlayer].dansPiece := False;
  ClearLines(18,7);
end;


// Procédure pour déplacer un joueur
procedure deplacerJoueur(var joueurs: TJoueurs; currentPlayer: Integer; var plateau: TPlateau; var deplacement: Integer);
var
  oldX,oldY,newX, newY: Integer;
  key: Char;
  piece:TPiece;
begin
  while deplacement >=0 do
  begin
    key := ReadKey;
 
    // Calculer la nouvelle position en fonction de la touche
    newX := joueurs[currentPlayer].x;
    newY := joueurs[currentPlayer].y;
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
      plateau[joueurs[currentPlayer].x, joueurs[currentPlayer].y].estOccupee := False;
      plateau[joueurs[currentPlayer].x, joueurs[currentPlayer].y].joueurID := 0;

      // Déplacer le joueur
      joueurs[currentPlayer].x := newX;
      joueurs[currentPlayer].y := newY;

      // Occuper la nouvelle position
      plateau[newX, newY].estOccupee := True;
      plateau[newX, newY].joueurID := currentPlayer + 1; // ID de joueur commence à 1

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
      writeln('Deplacements restants:', deplacement); 
      Dec(deplacement); // Réduire le nombre de déplacements restants
      
      if (plateau[newX, newY].typePiece <> Couloir) then
      begin
      deplacement:=-1;
      currentPlayer:=plateau[newX, newY].joueurID;
      piece:=plateau[newX, newY].typePiece;
      PlacerPionDansPiece(plateau,currentPlayer, piece);
      
      //joueurs[currentPlayer].dansPiece := True;
      //joueurs[currentPlayer].piecePrecedente := piece; 
      end;
    end;
  end;
end;

//lancer des 2 des
function LancerDes( deplacement:integer) : integer;
  var  des1,des2: integer;
begin
  des1 := Random(6) + 1; 
  des2 := Random(6) + 1;
  LancerDes:=deplacement+des1 + des2;
  end;

//Ajout audio pour annoncer les joueurs
procedure AnnonceTour(currentPlayer: Integer);
var
  music: PMix_Music;
  audioFile: string;
begin
  case currentPlayer of
    0: audioFile := 'joueur1.mp3';
    1: audioFile := 'joueur2.mp3';
    2: audioFile := 'joueur3.mp3';
    3: audioFile := 'joueur4.mp3';
    4: audioFile := 'joueur5.mp3';
    5: audioFile := 'joueur6.mp3';
  //else
  //  exit; // Si joueur non valide, sortir
  end;

  if Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 2048) < 0 then exit;

  music := Mix_LoadMUS(PAnsiChar(AnsiString(audioFile)));

  if music <> nil then
  begin
    Mix_PlayMusic(music, 0); // Lecture une seule fois
    SDL_Delay(3000);         // Pause pour écouter (3 secondes ici)
    Mix_FreeMusic(music);
  end;

  Mix_CloseAudio;
end;

// Procédure principale pour gérer les tours
procedure jouerTour(var joueurs: TJoueurs; var plateau: TPlateau; paquetPieces, paquetArmes, paquetPersonnages, solution: TPaquet; joueurActuel : TJoueur; cartesChoisies : TPaquet; carteChoisie : TCarte; currentPlayer:integer);
var
  deplacement: Integer;
  action : Integer;
  resultatAction, presenceCarteCommune : Boolean;
begin
action:=1;
      for currentPlayer := 0 to length(joueurs)-1 do
  begin
  deplacement := 0;
   writeln('Joueur ', currentPlayer +1 , ', c''est votre tour !');
   AnnonceTour(currentPlayer);
   if joueurs[currentPlayer].dansPiece then
   begin
  PlacerDevantPorte(plateau, joueurs, currentPlayer, deplacement);
  deplacement:=-1;
  end;
  deplacement := LancerDes(deplacement);
  write('Tu as obtenu ',deplacement);
  deplacerJoueur(joueurs, currentPlayer, plateau, deplacement);
  ClearLines(18,4);
    
  
 if (plateau[joueurs[currentPlayer].x, joueurs[currentPlayer].y].typePiece <> Mur) and
   (plateau[joueurs[currentPlayer].x, joueurs[currentPlayer].y].typePiece <> Couloir) then
    begin
  joueurs[currentPlayer].dansPiece:=True;
  joueurs[currentPlayer].piecePrecedente := plateau[joueurs[currentPlayer].x, joueurs[currentPlayer].y].typePiece;
    writeln('1. Hypothese');
    writeln('2. Accusation');
    resultatAction:=choixAction(action);
    ClearLines(18,2);
    if resultatAction then
    begin
      affichageResultatHypothese(paquetPieces, paquetArmes, paquetPersonnages, joueurs[currentPlayer], joueurs, cartesChoisies, carteChoisie, presenceCarteCommune,currentPlayer,plateau);
      Delay(3000);
      ClearLines(18,4);
    end
    else
    begin
      affichageResultatAccusation(paquetPieces, paquetArmes, paquetPersonnages, solution, joueurs[currentPlayer]);
      halt;
    end;
    end
    else if (plateau[joueurs[currentPlayer].x, joueurs[currentPlayer].y].typePiece = Couloir) then
    begin
      writeln('Souhaitez vous faire une accusation?');
      writeln('1. oui');
      writeln('2. non');
      resultatAction:=choixAction(action);
      ClearLines(18,4);
      if resultatAction then
        begin
          affichageResultatAccusation(paquetPieces, paquetArmes, paquetPersonnages, solution, joueurs[currentPlayer]);
          halt;
        end;
    end;
  end;
end;

end.
