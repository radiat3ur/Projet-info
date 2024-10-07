program cluedo;

Uses Crt, affichage, gestion, TypeEtCte;

var
    choix, nbJoueurs, i: Integer;
    paquetPieces, paquetArmes, paquetPersonnages, solution, paquetSansCartesCrime: TPaquet;
    joueurs: TJoueurs;
    fin : Boolean

begin
    fin:=False;
    menu(choix, nbJoueurs, joueurs);
    initialisationPartie(nbJoueurs, joueurs, paquetPieces, paquetArmes, paquetPersonnage, paquetSansCartesCrime, solution);
    // Display the cards after distribution
    writeln('Cartes de crime sélectionnées :');
    afficherPaquet(solution);
    
    writeln('Cartes restantes distribuées :');
    afficherCartesJoueurs(joueurs, nbJoueurs);
end.
