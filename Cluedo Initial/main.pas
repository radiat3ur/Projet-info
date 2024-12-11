
program cluedo;

Uses Crt, affichage, TypeEtCte, gestion,SDL2_image, SDL2, SDL2_mixer;

var
<<<<<<< HEAD
  choix, nbJoueurs, debutX, finX, debutY, finY, joueurActuel, i : Integer;
  paquetPieces, paquetArmes, paquetPersonnages, solution, paquetSansCartesCrime, cartesChoisies: TPaquet;
  carteChoisie : TCarte;
=======
  choix, nbJoueurs, currentPlayer, i : Integer;
  paquetPieces, paquetArmes, paquetPersonnages, solution, paquetSansCartesCrime: TPaquet;
>>>>>>> 368283784d73933ea28e8499ab9ade0f38dcb9f9
  joueurs: TJoueurs;
  plateau : TPlateau;

begin
<<<<<<< HEAD
  menu(plateau, choix, nbJoueurs, joueurs);
  joueurActuel:=nbJoueurs-1;
=======
  menu(choix, nbJoueurs, joueurs);
  currentPlayer:=nbJoueurs-1;
>>>>>>> 368283784d73933ea28e8499ab9ade0f38dcb9f9
  // Initialise le jeu
  choixDebutJeu(nbJoueurs, plateau, joueurs); // Lorsque 2 est tapé, on initilialise le jeu
  initialisationPartie(nbJoueurs, joueurs, paquetPieces, paquetArmes, paquetPersonnages, paquetSansCartesCrime, solution, plateau);
  narration();

  for i:=0 to nbJoueurs-1 do
  begin
    // Annonce le tour du joueur actuel
    preventionTourJoueur(joueurs, joueurActuel);

    // Affiche la main du joueur actuel
    writeln('Voici les cartes du Joueur ',i+1);
    affichagePaquet(joueurs[i].main); 
    finTourJoueur();
  end;

  initialisationPlateau(plateau);
    
  repeat
<<<<<<< HEAD
    preventionTourJoueur(joueurs, joueurActuel);
    affichagePlateau(plateau, joueurs, joueurActuel);
    jouerTour(joueurs, plateau, paquetPieces, paquetArmes, paquetPersonnages, solution, cartesChoisies, carteChoisie, joueurActuel)
=======
    preventionTourJoueur(joueurs, currentPlayer);
    affichagePlateau(plateau, joueurs, currentPlayer);
    jouerTour(joueurs, plateau, paquetPieces, paquetArmes, paquetPersonnages, solution, joueurs[currentPlayer], currentPlayer)
>>>>>>> 368283784d73933ea28e8499ab9ade0f38dcb9f9
  until False;
end.
