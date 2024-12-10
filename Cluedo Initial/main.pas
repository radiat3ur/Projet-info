
program cluedo;

Uses Crt, affichage, TypeEtCte, gestion,SDL2_image, SDL2, SDL2_mixer;

var
  choix, nbJoueurs, debutX, finX, debutY, finY, currentPlayer, i : Integer;
  paquetPieces, paquetArmes, paquetPersonnages, solution, paquetSansCartesCrime, cartesChoisies: TPaquet;
  carteChoisie : TCarte;
  joueurs: TJoueurs;
  plateau : TPlateau;
  couleur : TCouleur;
  piece : TPiece;

begin
  menu(plateau, choix, nbJoueurs, joueurs);
  currentPlayer:=nbJoueurs-1;
  // Initialise le jeu
  choixDebutJeu(nbJoueurs, plateau, joueurs); // Lorsque 2 est tapé, on initilialise le jeu
  initialisationPartie(nbJoueurs, debutX, finX, debutY, finY, piece, couleur, joueurs, paquetPieces, paquetArmes, paquetPersonnages, paquetSansCartesCrime, solution, plateau);
  narration();

  for i:=0 to nbJoueurs-1 do
  begin
    // Annonce le tour du joueur actuel
    preventionTourJoueur(joueurs, currentPlayer);

    // Affiche la main du joueur actuel
    writeln('Voici les cartes du Joueur ',i+1);
    affichagePaquet(joueurs[i].main); 
    finTourJoueur();
  end;

  initialisationPlateau(plateau);
    
  repeat
    preventionTourJoueur(joueurs, currentPlayer);
    affichagePlateau(plateau, joueurs, currentPlayer);
    jouerTour(joueurs, plateau, paquetPieces, paquetArmes, paquetPersonnages, solution, joueurs[currentPlayer], cartesChoisies, carteChoisie, currentPlayer)
  until False;
end.
