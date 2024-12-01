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
procedure affichageResultatHypothese(paquetPieces, paquetArmes, paquetPersonnages: TPaquet; joueurActuel : TJoueur; joueurs : TJoueurs; cartesChoisies : TPaquet; carteChoisie : TCarte; var presenceCarteCommune:boolean);
procedure affichageResultatAccusation(paquetPieces, paquetArmes, paquetPersonnages, solution : TPaquet; joueurActuel : TJoueur);

procedure attributionCouleur(couleur: TCouleur);
procedure affichagePlateau(var plateau: TPlateau; joueurs: TJoueurs; joueurActuel: Integer);
procedure deplacerJoueur(var joueurs: TJoueurs; currentPlayer: Integer; var plateau: TPlateau; var deplacement: Integer);
procedure LancerDes(var deplacement:integer);
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
  writeln(#27'[1mObjecitf :'#27'[0m');
  writeln('Le but du jeu est d''etre le premier a resoudre l''enquete en decouvrant qui est le coupable, avec quelle arme, et dans quelle piece le crime a ete commis.');
  writeln();
  writeln(#27'[1mMise en place :'#27'[0m');
  writeln('Les cartes sont reparties en trois categories : Suspects, Armes et Pieces.');
  writeln('Une carte de chaque categorie est tiree au hasard. Ce sont les reponses a l''enquete.');
  writeln('On distribue ensuite le reste des cartes aux autres joueurs qui representent des indices.');
  writeln('A chaque tour, chaque joueur lance 2 des: la somme des des equivaut au nombre de deplacements qu''il peut fire sur le plateau');
  writeln('Le plateau de jeu est compose de 9 pieces. Les joueurs peuvent formuler des hypotheses et des accusations uniquement lorsqu''ils sont dans une piece');
  writeln();
  writeln(#27'[1mDeroulement du jeu :'#27'[0m');
  writeln('A tour de role, les joueurs font des hypotheses, en donnant une carte de chaque categorie. Le joueur actif choisit un autre joueur a qui poser une question. ');
  write('Le joueur questionne doit verifier s''il possede l''une des cartes mentionnee (suspect, arme ou piece) dans l''hypothese. ');
  writeln('S''il en possede une, il la montre secretement au joueur qui a fait l''hypothese. Cela permet d''eliminer des possibilites. ');
  writeln();
  writeln(#27'[1mAccusation finale :'#27'[0m');
  writeln('Quand un joueur pense avoir trouve le coupable, l''arme et la piece, il peut faire une accusation finale. ');
  writeln('Si l''accusation correspond à la solution, le joueur gagne la partie. Sinon, ce sont les autres joueurs qui gagnent.');
  writeln();
  writeln('Bon jeu ! :)')
end;

procedure choixDebutJeu(var nbJoueurs : Integer ; var joueurs : TJoueurs);

begin
  repeat
    write('Entrez le nombre de joueurs (2-6) : ');
    readln(nbJoueurs); // Sélectionne le nombre de joueurs
  until (nbJoueurs >= 2) and (nbJoueurs <= MAX_PERSONNAGES); // Vérifie que le nombre est compris entre 2 et 6

  joueurs.taille := nbJoueurs;
  SetLength(joueurs.listeJoueurs,joueurs.taille); // Défini la taille du tableau des joueurs en fonction du nombre de joueurs
  initialisationJoueurs(joueurs, nbJoueurs); // (voir la procedure dans gestion.pas)
end;

procedure menu(var choix, nbJoueurs : Integer ; var joueurs : TJoueurs);

begin
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
end;

procedure preventionTourJoueur(joueurs: TJoueurs; var i: Integer);
begin
  // Passe au joueur suivant
  i := (i + 1) mod joueurs.taille;  // Parcourt les joueurs
  // Annonce du joueur dont c'est le tour
  writeln('Appuyez sur Entree lorsque le joueur ', joueurs.listeJoueurs[i].nom, ' est pret.');
  readln;
  ClrScr;
end;

procedure finTourJoueur();
begin
  writeln();
  write('Appuyez sur Entree pour terminer votre tour');
  readln;
  ClrScr;
end;

procedure affichageCarte(carte: TCarte);

begin
    writeln(carte.nom);
end;

procedure affichagePaquet(paquet: TPaquet);
var  i: Integer;

begin
  for i := 0 to paquet.taille - 1 do // Parcourt le paquet
  begin
    affichageCarte(paquet.liste[i]);
  end;
end;

procedure affichageResultatHypothese(paquetPieces, paquetArmes, paquetPersonnages: TPaquet; joueurActuel : TJoueur; joueurs : TJoueurs; cartesChoisies : TPaquet; carteChoisie : TCarte; var presenceCarteCommune:boolean);

begin
  hypothese(paquetPieces, paquetArmes, paquetPersonnages, joueurActuel, joueurs, cartesChoisies, carteChoisie, presenceCarteCommune);
  writeln('Voici la "carte en commun" : ');
  if presenceCarteCommune= true then
  writeln(carteChoisie.nom)
  else writeln('Aucune carte en commun');
  //ClearLines(18,4); bug
end;

procedure affichageResultatAccusation(paquetPieces, paquetArmes, paquetPersonnages, solution : TPaquet; joueurActuel : TJoueur);
var resultat:Boolean;

begin
  resultat:=accusation(paquetPieces, paquetArmes, paquetPersonnages, solution, joueurActuel);
  if (resultat) then
    writeln(joueurActuel.nom, ' remporte la partie ! Les autres joueurs ont perdu.')
  else
    writeln(joueurActuel.nom, ' a perdu la partie. Les autres joueurs gagnent !');
    writeln('Le veritable coupable est : ',solution.liste[2].nom);
    writeln('Les faits se sont deroules : ',solution.liste[0].nom);
    writeln('Le''arme du crime etait : ',solution.liste[1].nom);
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

  if plateau[i, j].joueurID > 0 then
        write(plateau[i, j].joueurID) // Afficher le numéro du joueur
      else if plateau[i, j].typePiece = Mur then
        write(' ') // Mur marqué par "x"
      else
        write('.'); // Couloirs et pièces marqués par '.'  
            afficherEtiquettes(i,j);
    end;

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
    writeln;
  end;
  TextBackground(0);

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
      writeln('Deplacements restants:', deplacement);
    end;
  end;
end;

//lancer des 2 des
  procedure LancerDes(var deplacement:integer);
  var  des1,des2: integer;
begin
  des1 := Random(6) + 1; 
  des2 := Random(6) + 1;
  deplacement:=des1 + des2;
  write('Tu as obtenu ',deplacement)
end;

//Ajout audio pour annoncer les joueurs
procedure AnnonceTour(currentPlayer: Integer);
var
  music: PMix_Music;
  audioFile: string;
begin
  case currentPlayer of
    1: audioFile := 'joueur1.mp3';
    2: audioFile := 'joueur2.mp3';
    3: audioFile := 'joueur3.mp3';
    4: audioFile := 'joueur4.mp3';
    5: audioFile := 'joueur5.mp3';
    6: audioFile := 'joueur6.mp3';
  else
    exit; // Si joueur non valide, sortir
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
deplacement := 0;
      for currentPlayer := 0 to joueurs.taille - 1 do
  begin
   writeln('Joueur ', currentPlayer +1 , ', c''est votre tour !');
   AnnonceTour(currentPlayer+1);
    LancerDes(deplacement);
    deplacerJoueur(joueurs, currentPlayer, plateau, deplacement);
  ClearLines(18,4);
 if (plateau[joueurs.listeJoueurs[currentPlayer].x, joueurs.listeJoueurs[currentPlayer].y].typePiece <> Mur) and
   (plateau[joueurs.listeJoueurs[currentPlayer].x, joueurs.listeJoueurs[currentPlayer].y].typePiece <> Couloir) then
begin
    writeln('1. Hypothese');
    writeln('2. Accusation');
    resultatAction:=choixAction(action);
 ClearLines(18,2);
    if resultatAction then
        affichageResultatHypothese(paquetPieces, paquetArmes, paquetPersonnages, joueurs.listeJoueurs[currentPlayer], joueurs, cartesChoisies, carteChoisie, presenceCarteCommune)
    else
    begin
        affichageResultatAccusation(paquetPieces, paquetArmes, paquetPersonnages, solution, joueurs.listeJoueurs[currentPlayer]);
        halt;
    end;
   end;
    end;
end;

end.
