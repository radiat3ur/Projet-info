Unit gestion;

interface

Uses Crt, TypeEtCte;

procedure supprimerLignes(ligneInit, nbLignes : Integer);
procedure initialisationPaquets(var paquetPieces, paquetArmes, paquetPersonnages : TPaquet);
procedure selectionCartesCrime(paquetPieces, paquetArmes, paquetPersonnages : TPaquet; var solution, paquetSansCartesCrime : TPaquet);
procedure melangerPaquet(var paquetSansCartesCrime : TPaquet);
procedure initialisationJoueurs(var joueurs: TJoueurs; nbJoueurs: Integer);
procedure distributionCartesJoueurs(paquetSansCartesCrime : TPaquet ; nbJoueurs : Integer ; var joueurs : TJoueurs);
procedure initialisationPartie(nbJoueurs : Integer ; var joueurs : TJoueurs ; var paquetPieces, paquetArmes, paquetPersonnages, paquetSansCartesCrime, solution : TPaquet);
function choixAction(choix : Integer) : Boolean;
procedure choixCarte(paquet: TPaquet; var carteChoisie: TCarte);
procedure choixCartes(plateau : TPlateau; joueurActuel : TJoueur ; paquetPieces, paquetArmes, paquetPersonnages: TPaquet; var cartesChoisies: TPaquet);
procedure comparaisonCartes(compare, comparant : TPaquet ; var cartesCommunes : TPaquet);
procedure recupererCarteJoueur(compare, comparant : TPaquet ; var carteChoisie : TCarte);
procedure hypothese(plateau : TPlateau ; paquetPieces, paquetArmes, paquetPersonnages: TPaquet; joueurActuel : TJoueur; joueurs : TJoueurs; var cartesChoisies : TPaquet ; var carteChoisie : TCarte);
function accusation(plateau : TPlateau ; paquetPieces, paquetArmes, paquetPersonnages, solution : TPaquet; joueurActuel : TJoueur):Boolean;

procedure lancerDeDes(var deplacement : Integer);
procedure initilisationPositionsJoueurs(var joueurs : TJoueurs ; var plateau : TPlateau);
procedure initialisationPiece(var plateau: TPlateau; debutX, finX, debutY, finY: Integer; piece: TTout; couleur: TCouleur);
procedure initialisationPlateau(var plateau: TPlateau);

implementation

procedure supprimerLignes(ligneInit, nbLignes : Integer);
var i : Integer;

begin
  for i:=ligneInit to ligneInit+nbLignes-1 do
  begin
    GotoXY(1,i);
    ClrEol();
  end;
  GotoXY(1, ligneInit)
end;

procedure initialisationPaquets(var paquetPieces, paquetArmes, paquetPersonnages : TPaquet);
var i : Integer;

begin
    // Crée le paquet des armes
    paquetArmes.taille:=6;
    SetLength(paquetArmes.liste, paquetArmes.taille);
    for i:=0 to paquetArmes.taille-1 do
    begin
        paquetArmes.liste[i].categorie:=Arme;
        paquetArmes.liste[i].nom:=TTout(i);
    end;

    // Crée le paquet des personnages
    paquetPersonnages.taille:=6;
    SetLength(paquetPersonnages.liste, paquetPersonnages.taille);
    for i:=0 to paquetPersonnages.taille-1 do
    begin
        paquetPersonnages.liste[i].categorie:=Personnage;
        paquetPersonnages.liste[i].nom:=TTout(i+paquetArmes.taille);
    end;

    // Crée le paquet des pièces
    paquetPieces.taille:=9;
    SetLength(paquetPieces.liste, paquetPieces.taille);
    for i:=0 to paquetPieces.taille-1 do
    begin
        paquetPieces.liste[i].categorie:=Piece;
        paquetPieces.liste[i].nom:=TTout(i+paquetPersonnages.taille+paquetArmes.taille);
    end;
end;

procedure selectionCartesCrime(paquetPieces, paquetArmes, paquetPersonnages : TPaquet; var solution, paquetSansCartesCrime : TPaquet);
var i, randomIndex, indexPaquet : Integer ;

begin
    // Prend les trois cartes crime au hasard
    Randomize;
    solution.taille:=3;
    SetLength(solution.liste, solution.taille);

    // On sélectionne une carte au hasard dans chaque paquet pour constituer la solution du crime

    // randomIndex est pris au hasard entre 1 et 9, ce qui correspond aux indices du paquet de pièces
    randomIndex:=Random(paquetPieces.taille);
    // ensuite on l'associe à la première carte solution
    solution.liste[0]:=paquetPieces.liste[randomIndex];
    // on fait de même pour les armes et personnages
    randomIndex:=Random(paquetArmes.taille);
    solution.liste[1]:=paquetArmes.liste[randomIndex];
    randomIndex:=Random(paquetPersonnages.taille);
    solution.liste[2]:=paquetPersonnages.liste[randomIndex];

    paquetSansCartesCrime.taille:=18;
    SetLength(paquetSansCartesCrime.liste, paquetSansCartesCrime.taille);
    indexPaquet:=0;

    // Rempli le paquet sans les cartes sélectionnées pour la solution
    for i:=0 to paquetPieces.taille-1 do
    begin
        // Si la carte n'est pas dans la solution, elle est ajoutée à paquetSansCartesCrime
        if (paquetPieces.liste[i].nom<>solution.liste[0].nom) then
        begin
            paquetSansCartesCrime.liste[indexPaquet]:=paquetPieces.liste[i];
            indexPaquet:=indexPaquet+1;
        end;
    end;

    for i:=0 to paquetArmes.taille-1 do
    begin  
        if (paquetArmes.liste[i].nom<>solution.liste[1].nom) then
        begin
            paquetSansCartesCrime.liste[indexPaquet]:=paquetArmes.liste[i];
            indexPaquet:=indexPaquet+1;
        end;
    end;

    for i:=0 to paquetPersonnages.taille-1 do
    begin  
        if (paquetPersonnages.liste[i].nom<>solution.liste[2].nom) then
        begin
            paquetSansCartesCrime.liste[indexPaquet]:=paquetPersonnages.liste[i];
            indexPaquet:=indexPaquet+1;
        end;
    end;
end;

procedure melangerPaquet(var paquetSansCartesCrime : TPaquet);
var i, j : Integer ;
    temp : TCarte ;

begin
    Randomize;
    // Parcourt le paquet à l'envers
    for i:=paquetSansCartesCrime.taille-1 downto 0 do
    begin
        // Prend au hasard un indice entre 0 et i
        j:=Random(i);
        // Echange les cartes d'indice i avec celles d'indice j (temp sert de stock, comme on a vu en I1)
        temp:=paquetSansCartesCrime.liste[i];
        paquetSansCartesCrime.liste[i]:=paquetSansCartesCrime.liste[j];
        paquetSansCartesCrime.liste[j]:=temp;
    end;
end;

procedure initialisationJoueurs(var joueurs: TJoueurs; nbJoueurs: Integer);
var personnagesDisponibles: array[0..MAX_PERSONNAGES - 1] of Boolean;
    i, j, choixPersonnage, cartesParJoueur, joueursAvecNbCartesStandard: Integer;

begin
    // Initialisz les personnages disponibles
    for i := 0 to MAX_PERSONNAGES - 1 do
        personnagesDisponibles[i] := True; // Tous les personnages sont disponibles

    // Initialise le nombre de joueurs, soit la taille du tableau
    joueurs.taille := nbJoueurs;
    SetLength(joueurs.listeJoueurs, nbJoueurs);

    // Les joueurs sélectionnent leur personnage
    for i := 0 to nbJoueurs - 1 do
    begin
        ClrScr;
        writeln('Joueur ', i + 1, ', choisissez un personnage : ');
        
        // Affiche les personnages disponibles
        for j := 0 to MAX_PERSONNAGES - 1 do
        begin
        if personnagesDisponibles[j] then
            writeln(j + 1, '. ', TPersonnages(j));
        end;
        
        // Saisi du choix du joueur
        repeat
        write('Votre choix (1-', MAX_PERSONNAGES, ') : ');
        readln(choixPersonnage);
        until (choixPersonnage >= 1) and (choixPersonnage <= MAX_PERSONNAGES) and personnagesDisponibles[choixPersonnage - 1];

        // Assigne le personnage au joueur
        joueurs.listeJoueurs[i].nom := TPersonnages(choixPersonnage - 1);
        personnagesDisponibles[choixPersonnage - 1] := False; // Marquer le personnage comme utilisé
        write('Vous avez choisi : ', joueurs.listeJoueurs[i].nom);
        readln;
        ClrScr;
    end;

    // Défini la taille de la main pour chaque joueur
    cartesParJoueur := 18 div nbJoueurs; // Nombre de cartes par joueur (de base, change si 4 ou 5 joueurs)
    joueursAvecNbCartesStandard := nbJoueurs; // Initialise le compteur pour les joueurs avec une carte en moins (si 4 ou 5 joueurs)

    // S'il y a 4 ou 5 joueurs, les deux premiers joueurs ont une carte en moins
    if (nbJoueurs = 4) or (nbJoueurs = 5) then
        joueursAvecNbCartesStandard := 2; // Deux premiers joueurs auront une carte en moins
    
    // Attribution des cartes
    for i := 0 to nbJoueurs-1 do
    begin
        if i < joueursAvecNbCartesStandard then
            joueurs.listeJoueurs[i].main.taille := cartesParJoueur // Donne le nombre classique de cartes aux deuxpremiers joueurs
        else
            joueurs.listeJoueurs[i].main.taille := cartesParJoueur+1; // Les joueurs suivants reçoivent une carte supplémentaire
        // Initialise la liste des cartes pour chaque joueur en fonction de la taille assignée
        SetLength(joueurs.listeJoueurs[i].main.liste, joueurs.listeJoueurs[i].main.taille);
    end;
end;

procedure distributionCartesJoueurs(paquetSansCartesCrime: TPaquet; nbJoueurs: Integer; var joueurs: TJoueurs);
var i, j, indexPaquet : Integer;

begin
    indexPaquet := 0;
    // Distribution des cartes en respectant les règles de répartition (et c'est juste ça qui m'a pris des semaines)
    for i := 0 to nbJoueurs - 1 do
    begin
        // Rempli les cartes pour le joueur i
        for j := 0 to joueurs.listeJoueurs[i].main.taille - 1 do
        begin
            joueurs.listeJoueurs[i].main.liste[j] := paquetSansCartesCrime.liste[indexPaquet];
            indexPaquet := indexPaquet + 1;
        end;
    end;
end;

procedure initialisationPartie(nbJoueurs : Integer ; var joueurs : TJoueurs ; var paquetPieces, paquetArmes, paquetPersonnages, paquetSansCartesCrime, solution : TPaquet);

begin
    initialisationPaquets(paquetPieces, paquetArmes, paquetPersonnages);
    selectionCartesCrime(paquetPieces, paquetArmes, paquetPersonnages, solution, paquetSansCartesCrime);
    melangerPaquet(paquetSansCartesCrime);
    distributionCartesJoueurs(paquetSansCartesCrime, nbJoueurs, joueurs);
end;

function choixAction(choix : Integer) : Boolean;

begin
  read(choix);
  if choix=1 then
    choixAction:=True
  else
    choixAction:=False;
end;

procedure choixCarte(paquet: TPaquet; var carteChoisie: TCarte);
var i, choix : Integer;

begin
	repeat
    for i:=0 to paquet.taille-1 do
        writeln(i+1, '. ', paquet.liste[i].nom);
    readln(choix);
    until (choix >= 1) and (choix <= paquet.taille);
    carteChoisie.categorie:=paquet.liste[choix-1].categorie;
    carteChoisie.nom:=paquet.liste[choix-1].nom;
end;

procedure choixCartes(plateau : TPlateau; joueurActuel : TJoueur ; paquetPieces, paquetArmes, paquetPersonnages: TPaquet; var cartesChoisies: TPaquet);

begin
    // Initialise la taille de cartesChoisies pour qu'il contienne trois cartes
    cartesChoisies.taille := 3;
    SetLength(cartesChoisies.liste, cartesChoisies.taille);

    // Choix du suspect
    writeln('Choisissez un suspect :');
    choixCarte(paquetPersonnages, cartesChoisies.liste[0]);
    supprimerLignes(19, paquetPersonnages.taille+2);

    // Choix de la pièce
    writeln('Vous vous trouvez dans : ', plateau[joueurActuel.x,joueurActuel.y].typePiece);
    cartesChoisies.liste[1].categorie:=Piece;
    cartesChoisies.liste[1].nom:=plateau[joueurActuel.x,joueurActuel.y].typePiece;
    Readln();
    supprimerLignes(19,1);

    // Choix de l'arme
    writeln('Choisissez une arme :');
    choixCarte(paquetArmes, cartesChoisies.liste[2]);
    supprimerLignes(19, paquetArmes.taille+2);
end;

procedure comparaisonCartes(compare, comparant : TPaquet ; var cartesCommunes : TPaquet);
var i, j, indexPaquet : Integer;

begin
    indexPaquet:=0;
    for i := 0 to compare.taille-1 do
    begin
        for j := 0 to comparant.taille-1 do
        begin
            if compare.liste[i].nom = comparant.liste[j].nom then
            begin
                cartesCommunes.taille:=indexPaquet+1;
                SetLength(cartesCommunes.liste,cartesCommunes.taille);
                cartesCommunes.liste[indexPaquet]:=compare.liste[i];
                indexPaquet:=indexPaquet+1;
            end;
        end;
    end;
end;

procedure recupererCarteJoueur(compare, comparant : TPaquet ; var carteChoisie : TCarte);
var cartesCommunes : TPaquet;

begin
    comparaisonCartes(compare,comparant,cartesCommunes);
    choixCarte(cartesCommunes, carteChoisie);
    supprimerLignes(19, cartesCommunes.taille+1)
end;

procedure hypothese(plateau : TPlateau ; paquetPieces, paquetArmes, paquetPersonnages: TPaquet; joueurActuel : TJoueur; joueurs : TJoueurs; var cartesChoisies : TPaquet ; var carteChoisie : TCarte);
var i, choix, impossible : Integer;
    
begin
    supprimerLignes(19, 3);
    repeat
        writeln('Choisissez un temoin parmi les autres joueurs :');
        for i:=0 to joueurs.taille-1 do
        begin
            begin
                write(i+1, '. ', joueurs.listeJoueurs[i].nom);
                if joueurs.listeJoueurs[i].nom=joueurActuel.nom then
                begin
                    impossible:=i;
                    write(' (impossible)');
                end;
                writeln();
            end;
        end;
        readln(choix);
        supprimerLignes(19, 4);
    until (choix >= 1) and (choix <= MAX_PERSONNAGES) and (choix-1<>impossible);

    choixCartes(plateau, joueurActuel, paquetPieces, paquetArmes, paquetPersonnages, cartesChoisies);
    writeln('C''est ', cartesChoisies.liste[0].nom, ' dans ', cartesChoisies.liste[1].nom, ' avec ', cartesChoisies.liste[2].nom);
	Delay(5000);
	
    supprimerLignes(19,1);
    writeln('Appuyez sur Entree lorsque le joueur ', joueurs.listeJoueurs[choix-1].nom, ' est pret.'); // Prévention pour le témoin de joueur
    readln;
    supprimerLignes(19,1);

    recupererCarteJoueur(joueurs.listeJoueurs[choix-1].main, cartesChoisies, carteChoisie);
    writeln('Appuyez sur Entree lorsque le joueur ', joueurActuel.nom, ' est pret.'); // Prévention pour joueur actuel de voir la carte
    readln;
    supprimerLignes(19,1)
end;

function accusation(plateau : TPlateau ; paquetPieces, paquetArmes, paquetPersonnages, solution : TPaquet; joueurActuel : TJoueur):Boolean;
var cartesChoisies, cartesCommunes : TPaquet;

begin
    choixCartes(plateau, joueurActuel, paquetPieces, paquetArmes, paquetPersonnages, cartesChoisies);
    comparaisonCartes(cartesChoisies, solution, cartesCommunes);
    if cartesCommunes.taille=3 then
        accusation:=True
    else
        accusation:=False
end;

procedure lancerDeDes(var deplacement : Integer);

begin
    Randomize;
    deplacement := Random(6) + Random(6) + 2 // Fonction random(n) donne [0;n-1] donc ajouter 2
end;

procedure initilisationPositionsJoueurs(var joueurs : TJoueurs ; var plateau : TPlateau);
var i : Integer;

begin
  for i:=0 to joueurs.taille-1 do
    begin
      // Position initiale dans un couloir
      joueurs.listeJoueurs[i].x := 2; 
      joueurs.listeJoueurs[i].y := 2+4*i;

      // Placer le joueur sur le plateau
      plateau[joueurs.listeJoueurs[i].x, joueurs.listeJoueurs[i].y].estOccupee := True;
      plateau[joueurs.listeJoueurs[i].x, joueurs.listeJoueurs[i].y].joueurID := i+1;

      // Vérifiez que la case est un couloir et n'est pas occupée
    end;
end;

// Procédure pour initialiser les pièces et leurs couleurs
procedure initialisationPiece(var plateau: TPlateau; debutX, finX, debutY, finY: Integer; piece: TTout; couleur: TCouleur);
var i, j: Integer;

begin
  for i := debutX to finX do
    for j := debutY to finY do
    begin
      plateau[i, j].typePiece := piece;
      plateau[i, j].couleur := couleur;
      plateau[i, j].estOccupee := False;
    end;

  for i := debutX - 1 to finX + 1 do
  begin
    plateau[i, debutY - 1].typePiece := Mur;
    plateau[i, debutY - 1].couleur := White;
    plateau[i, finY + 1].typePiece := Mur;
    plateau[i, finY + 1].couleur := White;
  end;

  for j := debutY to finY do
  begin
    plateau[debutX - 1, j].typePiece := Mur;
    plateau[debutX - 1, j].couleur := White;
    plateau[finX + 1, j].typePiece := Mur;
    plateau[finX + 1, j].couleur := White;
  end;
end;

// Procédure pour initialiser le plateau avec des couloirs par défaut
procedure initialisationPlateau(var plateau: TPlateau);
var i, j: Integer;

begin
  for i := 1 to 16 do
    for j := 1 to 21 do
    begin
      plateau[i, j].typePiece := Couloir;
      plateau[i, j].couleur := Black;
      plateau[i, j].estOccupee := False;
    end;

  for i := 1 to 16 do
  begin
    plateau[i, 1].typePiece := Mur;
    plateau[i, 21].typePiece := Mur;
  end;
  for j := 1 to 21 do
  begin
    plateau[1, j].typePiece := Mur;
    plateau[16, j].typePiece := Mur;
  end;

  initialisationPiece(plateau, 2, 3, 2, 4, Amphi_Tillion, Blue);
  initialisationPiece(plateau, 2, 3, 10, 12, Labo, Green);
  initialisationPiece(plateau, 2, 3, 18, 20, BU, Red);
  initialisationPiece(plateau, 8, 9, 2, 4, RU, Yellow);
  initialisationPiece(plateau, 8, 9, 10, 12, Parking_visiteurs, Magenta);
  initialisationPiece(plateau, 8, 9, 18, 20, Cafeteria, Yellow);
  initialisationPiece(plateau, 14, 15, 2, 4, Infirmerie, Red);
  initialisationPiece(plateau, 14, 15, 10, 12, Residence, Cyan);
  initialisationPiece(plateau, 14, 15, 18, 20, BDE, Blue);

  plateau[4, 3].typePiece:= Couloir;
  plateau[3, 9].typePiece:= Couloir;
  plateau[4, 11].typePiece:= Couloir;
  plateau[2, 17].typePiece:= Couloir;
  plateau[8, 5].typePiece:= Couloir;
  plateau[9, 9].typePiece:= Couloir;
  plateau[7, 12].typePiece:= Couloir;
  plateau[7, 18].typePiece:= Couloir;
  plateau[10, 20].typePiece:= Couloir;
  plateau[13, 3].typePiece:= Couloir;
  plateau[13, 10].typePiece:= Couloir;
  plateau[15, 17].typePiece:= Couloir;
end;

end.
