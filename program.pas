program cluedo;

Uses Crt, affichage, gestion, TypeEtCte;

var
    choix, nbJoueurs, currentPlayer, i, action: Integer;
    paquetPieces, paquetArmes, paquetPersonnages, solution, paquetSansCartesCrime, cartesChoisies: TPaquet;
    joueurs: TJoueurs;
    fin: Boolean;
    resultatAction: Boolean;

begin
    fin := False;
    menu(choix, nbJoueurs, joueurs, fin);
    currentPlayer:=nbJoueurs-1;
    // Initialize the game
    initialisationPartie(nbJoueurs, joueurs, paquetPieces, paquetArmes, paquetPersonnages, paquetSansCartesCrime, solution);
    for i:=0 to nbJoueurs-1 do
    begin
        // Announce the current player's turn
        preventionTourJoueur(joueurs, currentPlayer);

        // Display the current player's hand
        affichagePaquet(joueurs.listeJoueurs[i].main); 
        finTourJoueur();
    end;

    repeat
        preventionTourJoueur(joueurs, currentPlayer);
        writeln('1. Hypothese');
        writeln('2. Accusation');
        resultatAction:=choixAction(action);

        if resultatAction then
        begin
            writeln('Accusation en cours...');
            hypothese(paquetPieces, paquetArmes, paquetPersonnages, joueurs.listeJoueurs[currentPlayer], cartesChoisies,joueurs);
        end
        else
        finTourJoueur();
    until False;  // Condition de fin à implémenter selon les règles du jeu
end.
