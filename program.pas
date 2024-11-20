program cluedo;

Uses Crt, affichage, TypeEtCte, gestion, affichage_plateau, gestion_plateau;

var
    choix, nbJoueurs, currentPlayer, i, action, deplacement : Integer;
    paquetPieces, paquetArmes, paquetPersonnages, solution, paquetSansCartesCrime, cartesChoisies: TPaquet;
    carteChoisie : TCarte;
    joueurs: TJoueurs;
    resultatAction: Boolean;
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

    initialiserPlateau(plateau);
    
    repeat
        preventionTourJoueur(joueurs, currentPlayer);
        afficherPlateau(plateau, joueurs, currentPlayer, deplacement);
        jouerTour(joueurs, plateau, paquetPieces, paquetArmes, paquetPersonnages, solution, joueurs.listeJoueurs[currentPlayer], cartesChoisies, carteChoisie)
    until False;
end.