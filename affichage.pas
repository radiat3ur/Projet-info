Unit affichage;

interface 

Uses Crt, TypeEtCte, gestion;

procedure affichageMenu();
procedure affichageRegles();
procedure choixDebutJeu(var nbJoueurs : Integer ; var joueurs : TJoueurs);
procedure menu(var choix, nbJoueurs : Integer ; var joueurs : TJoueurs ; var fin : Boolean);
procedure preventionTourJoueur(joueurs: TJoueurs; var i: Integer);
procedure finTourJoueur();
procedure affichageCarte(carte : TCarte);
procedure affichagePaquet(paquet: TPaquet);

implementation

procedure affichageMenu(); // Affiche le menu au tout début du jeu
begin
  writeln('--- Menu du Cluedo ---');
  writeln('1. Afficher les règles du jeu');
  writeln('2. Commencer une nouvelle partie');
  writeln('3. Quitter le jeu');
  write('Votre choix : ');
end;

procedure affichageRegles(); // Afficher les règles, à écrire
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
    readln(nbJoueurs); // Sélection du nombre de joueurs
  until (nbJoueurs >= 2) and (nbJoueurs <= MAX_PERSONNAGES); // Vérifie que le nombre est compris entre 2 et 6

  joueurs.taille := nbJoueurs;
  SetLength(joueurs.listeJoueurs,joueurs.taille); // Définir la taille du tableau des joueurs en fonction du nombre de joueurs
  initialisationJoueurs(joueurs, nbJoueurs); // (voir la procedure dans gestion.pas)
end;

procedure menu(var choix, nbJoueurs : Integer ; var joueurs : TJoueurs ; var fin : Boolean);
var quitter : Boolean;
begin
  quitter := false;
  //repeat
    ClrScr;
    affichageMenu();
    readln(choix);
	
    case choix of
      1: begin
             ClrScr;
             affichageRegles(); // Lorsque 1 est tapé, on affiche les règles
          end;
      2: begin
             ClrScr;
             choixDebutJeu(nbJoueurs, joueurs); // Lorsque é est tapé, on initilialise le jeu
          end;
      3: fin := true; // Lorsque 3 est tapé, on quitte le jeu
    else
      writeln('Choix invalide, veuillez réessayer.');
    end;
  //until fin;
end;

procedure preventionTourJoueur(joueurs: TJoueurs; var i: Integer);
begin
  // Passer au joueur suivant
  i := (i + 1) mod joueurs.taille;  // Parcourir les joueurs
  // Annonce du joueur dont c'est le tour
  writeln('Appuyez sur Entrée lorsque le joueur ', joueurs.listeJoueurs[i].nom, ' est prêt.');
  readln;
  ClrScr;
end;

procedure finTourJoueur();
begin
  writeln('Appuyez sur Entrée pour terminer votre tour');
  readln;
  ClrScr;
end;

procedure affichageCarte(carte: TCarte);
begin
    writeln(carte.nom);
end;

procedure affichagePaquet(paquet: TPaquet);
var
  i: Integer;
begin
  writeln('--- Affichage de la main ---');
  for i := 0 to paquet.taille - 1 do // Parcourt le paquet
  begin
    affichageCarte(paquet.liste[i]);
  end;
end;

end.
