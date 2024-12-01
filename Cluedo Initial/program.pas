program cluedo;

Uses Crt, affichage, TypeEtCte, gestion,SDL2_image, SDL2, SDL2_mixer;

var
    choix, nbJoueurs, currentPlayer, i : Integer;
    paquetPieces, paquetArmes, paquetPersonnages, solution, paquetSansCartesCrime, cartesChoisies: TPaquet;
    carteChoisie : TCarte;
    joueurs: TJoueurs;
    plateau : TPlateau;

begin

    write('smlkdjfmsldjfmlsjfsjflsjflsjfsjfmsjdfjsfjsdfjsm');
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
        affichagePaquet(joueurs.listeJoueurs[i].main); 
        finTourJoueur();
    end;

    initialisationPlateau(plateau);
    
    repeat// for pour les tours des joueurs

   begin;
    
        preventionTourJoueur(joueurs, currentPlayer);
        affichagePlateau(plateau, joueurs, currentPlayer);
        jouerTour(joueurs, plateau, paquetPieces, paquetArmes, paquetPersonnages, solution, joueurs.listeJoueurs[currentPlayer], cartesChoisies, carteChoisie, currentPlayer)
    end;
    until False;
end.
