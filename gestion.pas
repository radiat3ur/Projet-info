Unit gestion;

interface

Uses Crt, TypeEtCte;

procedure initialisationPaquets(var paquetPieces, paquetArmes, paquetPersonnages : TPaquet);
procedure selectionCartesCrime(paquetPieces, paquetArmes, paquetPersonnages : TPaquet; var solution, paquetSansCartesCrime : TPaquet);
procedure melangerPaquet(var paquetSansCartesCrime : TPaquet);
procedure initialisationJoueurs(var joueurs: TJoueurs; nbJoueurs: Integer);
procedure distributionCartesJoueurs(paquetSansCartesCrime : TPaquet ; nbJoueurs : Integer ; var joueurs : TJoueurs);
procedure initialisationPartie(nbJoueurs : Integer ; var joueurs : TJoueurs ; var paquetPieces, paquetArmes, paquetPersonnages, paquetSansCartesCrime, solution : TPaquet);
function choixAction(choix : Integer) : Boolean;
procedure choixCarte(paquet: TPaquet; var carteChoisie: TCarte);
procedure choixCartes(paquetPieces, paquetArmes, paquetPersonnages : TPaquet ; var cartesChoisies : TPaquet);
procedure hypothese(paquetPieces, paquetArmes, paquetPersonnages: TPaquet; joueurActuel : TJoueur; var cartesChoisies : TPaquet ; var joueurs: TJoueurs);

implementation

procedure initialisationPaquets(var paquetPieces, paquetArmes, paquetPersonnages : TPaquet);
var i : Integer;

begin
    // Créer le paquet des pièces
    paquetPieces.taille:=9;
    SetLength(paquetPieces.liste, paquetPieces.taille);
    for i:=0 to paquetPieces.taille-1 do
    begin
        paquetPieces.liste[i].categorie:=Piece;
        paquetPieces.liste[i].nom:=TTout(i);
    end;

    // Créer le paquet des armes
    paquetArmes.taille:=6;
    SetLength(paquetArmes.liste, paquetArmes.taille);
    for i:=0 to paquetArmes.taille-1 do
    begin
        paquetArmes.liste[i].categorie:=Arme;
        paquetArmes.liste[i].nom:=TTout(i+paquetPieces.taille);
    end;

    // Créer le paquet des personnages
    paquetPersonnages.taille:=6;
    SetLength(paquetPersonnages.liste, paquetPersonnages.taille);
    for i:=0 to paquetPersonnages.taille-1 do
    begin
        paquetPersonnages.liste[i].categorie:=Personnage;
        paquetPersonnages.liste[i].nom:=TTout(i+paquetPieces.taille+paquetArmes.taille);
    end;
end;

procedure selectionCartesCrime(paquetPieces, paquetArmes, paquetPersonnages : TPaquet; var solution, paquetSansCartesCrime : TPaquet);
var i, randomIndex, indexPaquet : Integer ;

begin
    // Prends les trois cartes crimes au hasard
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

    // Remplissage du paquet sans les cartes sélectionnées pour la solution
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
var i, j : Integer ; temp : TCarte ;

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
var
  personnagesDisponibles: array[0..MAX_PERSONNAGES - 1] of Boolean;
  i, j, choixPersonnage, cartesParJoueur, joueursAvecNbCartesStandard: Integer;
begin
  // Initialisation des personnages disponibles
  for i := 0 to MAX_PERSONNAGES - 1 do
    personnagesDisponibles[i] := True; // Tous les personnages sont disponibles

  // Initialisation du nombre de joueurs, soit la taille du tableau
  joueurs.taille := nbJoueurs;
  SetLength(joueurs.listeJoueurs, nbJoueurs);

  // Les joueurs sélectionnent leur personnage
  for i := 0 to nbJoueurs - 1 do
  begin
    ClrScr;
    writeln('Joueur ', i + 1, ', choisissez un personnage : ');
    
    // Afficher les personnages disponibles
    for j := 0 to MAX_PERSONNAGES - 1 do
    begin
      if personnagesDisponibles[j] then
        writeln(j + 1, '. ', TPersonnages(j));
    end;
    
    // Saisir le choix du joueur
    repeat
      write('Votre choix (1-', MAX_PERSONNAGES, ') : ');
      readln(choixPersonnage);
    until (choixPersonnage >= 1) and (choixPersonnage <= MAX_PERSONNAGES) and personnagesDisponibles[choixPersonnage - 1];

    // Assigner le personnage au joueur
    joueurs.listeJoueurs[i].nom := TPersonnages(choixPersonnage - 1);
    personnagesDisponibles[choixPersonnage - 1] := False; // Marquer le personnage comme utilisé
    write('Vous avez choisi : ', joueurs.listeJoueurs[i].nom);
    readln;
    ClrScr;
  end;

    // Définir la taille de la main pour chaque joueur
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
        // Initialiser la liste des cartes pour chaque joueur en fonction de la taille assignée
        SetLength(joueurs.listeJoueurs[i].main.liste, joueurs.listeJoueurs[i].main.taille);
    end;
end;

procedure distributionCartesJoueurs(paquetSansCartesCrime: TPaquet; nbJoueurs: Integer; var joueurs: TJoueurs);
var
    i, j, indexPaquet, cartesParJoueur, joueursAvecCartesSupp: Integer;
begin
    indexPaquet := 0;
    //cartesParJoueur := 18 div nbJoueurs;
    //joueursAvecCartesSupp := 0;

    //if (nbJoueurs = 4) or (nbJoueurs = 5) then
      //  joueursAvecCartesSupp := 2; // Les deux premiers joueurs auront une carte en moins

    // Distribution des cartes en respectant les règles de répartition (et c'est juste ça qui m'a pris des semaines)
    for i := 0 to nbJoueurs - 1 do
    begin
        // Remplir les cartes pour le joueur i
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
    cartesCategorie: array of TCarte;
begin
    for i:=0 to paquet.taille-1 do
        writeln(i+1, '. ', paquet.liste[i].nom);
    readln(choix);
    carteChoisie.categorie:=paquet.liste[choix-1].categorie;
    carteChoisie.nom:=paquet.liste[choix-1].nom;
end;

procedure choixCartes(paquetPieces, paquetArmes, paquetPersonnages: TPaquet; var cartesChoisies: TPaquet);
begin
    // Initialiser la taille de cartesChoisies pour qu'il contienne trois cartes
    cartesChoisies.taille := 3;
    SetLength(cartesChoisies.liste, cartesChoisies.taille);

    writeln('--- Formulation d''une hypothèse ---');

    // Choix du suspect
    writeln('Choisissez un suspect :');
    choixCarte(paquetPersonnages, cartesChoisies.liste[0]);

    // Choix de l'arme
    writeln('Choisissez une arme :');
    choixCarte(paquetArmes, cartesChoisies.liste[1]);

    // Choix de la pièce
    writeln('Choisissez un lieu :');
    choixCarte(paquetPieces, cartesChoisies.liste[2]);
end;

procedure hypothese(paquetPieces, paquetArmes, paquetPersonnages: TPaquet; joueurActuel : TJoueur; var cartesChoisies : TPaquet ; var joueurs: TJoueurs);
var
    i, choix, impossible : Integer;
    personnageChoisi, armeChoisie, pieceChoisie: TCarte;
begin
    repeat
        writeln('Choisissez un témoin parmi les autres joueurs :');
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
    until (choix >= 1) and (choix <= MAX_PERSONNAGES) and (choix-1<>impossible);
    
    choixCartes(paquetPieces, paquetArmes, paquetPersonnages, cartesChoisies);
    writeln('Vous avez formulé l''hypothèse suivante :');
    writeln('Suspect : ', cartesChoisies.liste[0].nom);
    writeln('Arme : ', cartesChoisies.liste[1].nom);
    writeln('Piece : ', cartesChoisies.liste[2].nom);
end;

end.
