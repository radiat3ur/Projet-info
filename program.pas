program cluedo;

Uses Crt, affichage, gestion, TypeEtCte;

var
    choix, nbJoueurs, currentPlayer, i, action: Integer;
    paquetPieces, paquetArmes, paquetPersonnages, solution, paquetSansCartesCrime, cartesChoisies: TPaquet;
    carteChoisie : TCarte;
    joueurs: TJoueurs;
    resultatAction: Boolean;

begin
    menu(choix, nbJoueurs, joueurs);
    currentPlayer:=nbJoueurs-1;
    // Initialise le jeu
    initialisationPartie(nbJoueurs, joueurs, paquetPieces, paquetArmes, paquetPersonnages, paquetSansCartesCrime, solution);
    narration();
    ClrScr;
    for i:=0 to nbJoueurs-1 do
    begin
        // Annonce le tour du joueur actuel
        preventionTourJoueur(joueurs, currentPlayer);

        // Affiche la main du joueur actuel
        affichagePaquet(joueurs.listeJoueurs[i].main); 
        finTourJoueur();
    end;

    repeat
        preventionTourJoueur(joueurs, currentPlayer);
        writeln('1. Hypothese');
        writeln('2. Accusation');
        resultatAction:=choixAction(action);

        if resultatAction then
            affichageResultatHypothese(paquetPieces, paquetArmes, paquetPersonnages, joueurs.listeJoueurs[currentPlayer], joueurs, cartesChoisies, carteChoisie)
        else
        begin
            affichageResultatAccusation(paquetPieces, paquetArmes, paquetPersonnages, solution, joueurs.listeJoueurs[currentPlayer]);
            halt;
        end;
    until False;
end.