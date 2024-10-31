Unit affichage;

interface 

Uses Crt, TypeEtCte, gestion;

procedure narration();
procedure affichageMenu();
procedure affichageRegles();
procedure choixDebutJeu(var nbJoueurs : Integer ; var joueurs : TJoueurs);
procedure menu(var choix, nbJoueurs : Integer ; var joueurs : TJoueurs);
procedure preventionTourJoueur(joueurs: TJoueurs; var i: Integer);
procedure finTourJoueur();
procedure affichageCarte(carte : TCarte);
procedure affichagePaquet(paquet: TPaquet);
procedure affichageResultatHypothese(paquetPieces, paquetArmes, paquetPersonnages: TPaquet; joueurActuel : TJoueur; joueurs : TJoueurs; cartesChoisies : TPaquet; carteChoisie : TCarte);
procedure affichageResultatAccusation(paquetPieces, paquetArmes, paquetPersonnages, solution : TPaquet; joueurActuel : TJoueur);

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

procedure affichageResultatHypothese(paquetPieces, paquetArmes, paquetPersonnages: TPaquet; joueurActuel : TJoueur; joueurs : TJoueurs; cartesChoisies : TPaquet; carteChoisie : TCarte);

begin
  hypothese(paquetPieces, paquetArmes, paquetPersonnages, joueurActuel, joueurs, cartesChoisies, carteChoisie);
  affichageCarte(carteChoisie)
end;

procedure affichageResultatAccusation(paquetPieces, paquetArmes, paquetPersonnages, solution : TPaquet; joueurActuel : TJoueur);
var resultat:Boolean;

begin
  resultat:=accusation(paquetPieces, paquetArmes, paquetPersonnages, solution, joueurActuel);
  if (resultat) then
    writeln(joueurActuel.nom, ' remporte la partie ! Les autres joueurs ont perdu.')
  else
    writeln(joueurActuel.nom, ' a perdu la partie. Les autres joueurs gagnent !')
end;

end.