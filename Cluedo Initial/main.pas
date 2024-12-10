
program cluedo;

Uses Crt, affichage, TypeEtCte, gestion,SDL2_image, SDL2, SDL2_mixer;

var
  choix, nbJoueurs, currentPlayer, i : Integer;
  paquetPieces, paquetArmes, paquetPersonnages, solution, paquetSansCartesCrime, cartesChoisies: TPaquet;
  carteChoisie : TCarte;
  joueurs: TJoueurs;
  plateau : TPlateau;

begin
  menu(choix, nbJoueurs, joueurs);
  currentPlayer:=nbJoueurs-1;
  // Initialise le jeu
  initialisationPartie(nbJoueurs, joueurs, paquetPieces, paquetArmes, paquetPersonnages, paquetSansCartesCrime, solution);
  narration();
  initilisationPositionsJoueurs(joueurs, plateau);

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
