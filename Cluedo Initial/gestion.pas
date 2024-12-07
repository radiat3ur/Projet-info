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
procedure ClearLines(debutligne, lignes: Integer);
procedure choixCarte(paquet: TPaquet; var carteChoisie: TCarte);
procedure choixCartes(paquetPieces, paquetArmes, paquetPersonnages : TPaquet ; var cartesChoisies : TPaquet);
procedure choixCartesHyp(paquetPieces, paquetArmes, paquetPersonnages: TPaquet; var cartesChoisies: TPaquet; plateau:TPlateau; joueurs:TJoueurs; currentPlayer:integer);
procedure comparaisonCartes(compare, comparant : TPaquet ; var cartesCommunes : TPaquet);
procedure recupererCarteJoueur(compare, comparant : TPaquet ; var carteChoisie : TCarte; var presenceCarteCommune:boolean);
procedure hypothese(paquetPieces, paquetArmes, paquetPersonnages: TPaquet; joueurActuel : TJoueur; joueurs : TJoueurs; var cartesChoisies : TPaquet ; var carteChoisie : TCarte; var presenceCarteCommune:Boolean;plateau:TPlateau;currentPlayer:Integer);
function accusation(paquetPieces, paquetArmes, paquetPersonnages, solution : TPaquet; joueurActuel : TJoueur):Boolean;

procedure initilisationPositionsJoueurs(var joueurs : TJoueurs ; var plateau : TPlateau);
procedure initialisationPiece(var plateau: TPlateau; debutX, finX, debutY, finY: Integer; piece: TPiece; couleur: TCouleur);
procedure initialisationPlateau(var plateau: TPlateau);
Procedure PlacerPionDansPiece(var plateau: TPlateau; currentPlayer: Integer; piece: TPiece);

implementation

procedure initialisationPaquets(var paquetPieces, paquetArmes, paquetPersonnages : TPaquet);
var i : Integer;

begin
    // Crée le paquet des pièces
    SetLength(paquetPieces, 9);
    for i:=0 to length(paquetPieces)-1 do
    begin
        paquetPieces[i].categorie:=Piece;
        paquetPieces[i].nom:=TTout(i);
    end;

    // Crée le paquet des armes
    SetLength(paquetArmes, 6);
    for i:=0 to length(paquetArmes)-1 do
    begin
        paquetArmes[i].categorie:=Arme;
        paquetArmes[i].nom:=TTout(i+length(paquetPieces));
    end;

    // Crée le paquet des personnages
    SetLength(paquetPersonnages, 6);
    for i:=0 to length(paquetPersonnages)-1 do
    begin
        paquetPersonnages[i].categorie:=Personnage;
        paquetPersonnages[i].nom:=TTout(i+length(paquetPieces)+length(paquetArmes));
    end;
end;

procedure selectionCartesCrime(paquetPieces, paquetArmes, paquetPersonnages : TPaquet; var solution, paquetSansCartesCrime : TPaquet);
var i, randomIndex, indexPaquet : Integer ;

begin
    // Prend les trois cartes crime au hasard
    Randomize;
    SetLength(solution, 3);

    // On sélectionne une carte au hasard dans chaque paquet pour constituer la solution du crime

    // randomIndex est pris au hasard entre 1 et 9, ce qui correspond aux indices du paquet de pièces
    randomIndex:=Random(length(paquetPieces));
    // ensuite on l'associe à la première carte solution
    solution[0]:=paquetPieces[randomIndex];
    // on fait de même pour les armes et personnages
    randomIndex:=Random(length(paquetArmes));
    solution[1]:=paquetArmes[randomIndex];
    randomIndex:=Random(length(paquetPersonnages));
    solution[2]:=paquetPersonnages[randomIndex];

    SetLength(paquetSansCartesCrime, 18);
    indexPaquet:=0;

    // Rempli le paquet sans les cartes sélectionnées pour la solution
    for i:=0 to length(paquetPieces)-1 do
    begin
        // Si la carte n'est pas dans la solution, elle est ajoutée à paquetSansCartesCrime
        if (paquetPieces[i].nom<>solution[0].nom) then
        begin
            paquetSansCartesCrime[indexPaquet]:=paquetPieces[i];
            indexPaquet:=indexPaquet+1;
        end;
    end;

    for i:=0 to length(paquetArmes)-1 do
    begin  
        if (paquetArmes[i].nom<>solution[1].nom) then
        begin
            paquetSansCartesCrime[indexPaquet]:=paquetArmes[i];
            indexPaquet:=indexPaquet+1;
        end;
    end;

    for i:=0 to length(paquetPersonnages)-1 do
    begin  
        if (paquetPersonnages[i].nom<>solution[2].nom) then
        begin
            paquetSansCartesCrime[indexPaquet]:=paquetPersonnages[i];
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
    for i:=length(paquetSansCartesCrime)-1 downto 0 do
    begin
        // Prend au hasard un indice entre 0 et i
        j:=Random(i);
        // Echange les cartes d'indice i avec celles d'indice j (temp sert de stock, comme on a vu en I1)
        temp:=paquetSansCartesCrime[i];
        paquetSansCartesCrime[i]:=paquetSansCartesCrime[j];
        paquetSansCartesCrime[j]:=temp;
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
    SetLength(joueurs, nbJoueurs);

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
        joueurs[i].nom := TPersonnages(choixPersonnage - 1);
        personnagesDisponibles[choixPersonnage - 1] := False; // Marquer le personnage comme utilisé
        write('Vous avez choisi : ', joueurs[i].nom);
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
            SetLength(joueurs[i].main, cartesParJoueur) // Donne le nombre classique de cartes aux deuxpremiers joueurs
        else
        // Les joueurs suivants reçoivent une carte supplémentaire
        // Initialise la liste des cartes pour chaque joueur en fonction de la taille assignée
        SetLength(joueurs[i].main, cartesParJoueur+1);
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
        for j := 0 to length(joueurs[i].main)-1 do
        begin
            joueurs[i].main[j] := paquetSansCartesCrime[indexPaquet];
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

//supprimer plusieurs lignes
procedure ClearLines(debutligne, lignes: Integer);
var
  i: Integer;
begin
  for i := 0 to lignes - 1 do
  begin
    GotoXY(1, debutligne + i); // Positionne le curseur au début de la ligne
    ClrEol;                  // Efface la ligne courante
  end;
  GotoXY(1,18);
end;

procedure choixCarte(paquet: TPaquet; var carteChoisie: TCarte);
var i, choix : Integer;

begin
	repeat
    for i:=0 to length(paquet)-1 do
        writeln(i+1, '. ', paquet[i].nom);
    readln(choix);
    until (choix >= 1) and (choix <= length(paquet));
    carteChoisie.categorie:=paquet[choix-1].categorie;
    carteChoisie.nom:=paquet[choix-1].nom;
end;

procedure choixCartes(paquetPieces, paquetArmes, paquetPersonnages: TPaquet; var cartesChoisies: TPaquet);

begin
    // Initialise la taille de cartesChoisies pour qu'il contienne trois cartes
    SetLength(cartesChoisies, 3);

    // Choix du suspect
    writeln('Choisissez un suspect :');
    choixCarte(paquetPersonnages, cartesChoisies[0]);
     ClearLines(18,10);

    // Choix de l'arme
    writeln('Choisissez une arme :');
    choixCarte(paquetArmes, cartesChoisies[1]);
    ClearLines(18,10);
    

    // Choix de la pièce
    writeln('Choisissez un lieu :');
    choixCarte(paquetPieces, cartesChoisies[2]);
     ClearLines(18,12);
end;

function TPieceToTTout(piece: TPiece): TTout;
begin
  case piece of
    Amphi_Tillionn: TPieceToTTout := Amphi_Tillion;
    Laboo:          TPieceToTTout := Labo;
    Cafeteriaa:     TPieceToTTout := Cafeteria;
    Parking_visiteurs: TPieceToTTout := Parking_visiteur;
    RUU:            TPieceToTTout := RU;
    BDEE:           TPieceToTTout := BDE;
    BUU:            TPieceToTTout := BU;
    Infirmeriee:    TPieceToTTout := Infirmerie;
    Residencee:    TPieceToTTout := Residence;
    
  end;
end;


procedure choixCartesHyp(paquetPieces, paquetArmes, paquetPersonnages: TPaquet; var cartesChoisies: TPaquet; plateau:TPlateau; joueurs:TJoueurs; currentPlayer:integer);
var posX, posY:integer;
    caseActuelle:TCase;
   
begin
    // Initialise la taille de cartesChoisies pour qu'il contienne trois cartes
    SetLength(cartesChoisies,3);

    // Choix du suspect
    writeln('Choisissez un suspect :');
    choixCarte(paquetPersonnages, cartesChoisies[0]);
     ClearLines(18,12);

    // Choix de l'arme
    writeln('Choisissez une arme :');
    choixCarte(paquetArmes, cartesChoisies[1]);
    ClearLines(18,12);
    
    // Choix de la pièce
    posX:=joueurs[currentPlayer].x;
    posY:=joueurs[currentPlayer].y;
    caseActuelle:=plateau[posX,posY];
    cartesChoisies[2].nom := TPieceToTTout(caseActuelle.typePiece);
    // ClearLines(18,12);
end;

procedure comparaisonCartes(compare, comparant : TPaquet ; var cartesCommunes : TPaquet);
var compare, comparant : TPaquet ; var cartesCommunes : TPaquet

begin
    indexPaquet:=0;
    for i := 0 to length(compare)-1 do
    begin
        for j := 0 to length(comparant)-1 do
        begin
            if compare[i].nom = comparant[j].nom then
            begin
                SetLength(cartesCommunes,indexPaquet+1);
                cartesCommunes[indexPaquet]:=compare[i];
                indexPaquet:=indexPaquet+1;
            end;
            // Si aucune carte commune
  if indexPaquet = 0 then
  begin
    SetLength(cartesCommunes, 0);
  end;
        end;
    end;
end;

procedure recupererCarteJoueur(compare, comparant : TPaquet ; var carteChoisie : TCarte; var presenceCarteCommune:boolean);
var cartesCommunes : TPaquet;

begin
presenceCarteCommune:=false;
    comparaisonCartes(compare,comparant,cartesCommunes);
    if length(cartesCommunes) = 0 then
  begin
    write('Aucune carte commune. Rien a montrer.');
    clreol();
    end
    else   
    begin 
    presenceCarteCommune:=true;
    writeln('Veuillez selectionner la carte a montrer');
    choixCarte(cartesCommunes, carteChoisie);
    ClearLines(18,7);
    end;
    
end;

procedure hypothese(paquetPieces, paquetArmes, paquetPersonnages: TPaquet; joueurActuel : TJoueur; joueurs : TJoueurs; var cartesChoisies : TPaquet ; var carteChoisie : TCarte; var presenceCarteCommune:Boolean;plateau:TPlateau;currentPlayer:Integer);
var i, choix, impossible : Integer;
    
begin
    repeat
        writeln('Choisissez un temoin parmi les autres joueurs :');
        for i:=0 to length(joueurs)-1 do
        begin
            begin
                write(i+1, '. ', joueurs[i].nom);
                if joueurs[i].nom=joueurActuel.nom then
                begin
                    impossible:=i;
                    write(' (impossible)');
                end;
                 writeln();
            end;
        end;
        readln(choix);
                         ClearLines(18,9);
    until (choix >= 1) and (choix <= MAX_PERSONNAGES) and (choix-1<>impossible);

    choixCartesHyp(paquetPieces, paquetArmes, paquetPersonnages, cartesChoisies,plateau,joueurs,currentPlayer);
    writeln('Votre hypothese est : C''est ', cartesChoisies[0].nom, ' dans ', cartesChoisies[2].nom, ' avec ', cartesChoisies[1].nom);
	Delay(3000);//(pas besoin?)
	ClearLines(18,2);
    
    writeln('Appuyez sur Entree lorsque le joueur ', joueurs[choix-1].nom, ' est pret.'); // Prévention pour le témoin de joueur
    readln;
    recupererCarteJoueur(joueurs[choix-1].main, cartesChoisies, carteChoisie,presenceCarteCommune);
    ClearLines(18,6);
    
    writeln('Appuyez sur Entree lorsque le joueur ', joueurActuel.nom, ' est pret.'); // Prévention pour joueur actuel de voir la carte
    readln;
    
    
end;

function accusation(paquetPieces, paquetArmes, paquetPersonnages, solution : TPaquet; joueurActuel : TJoueur):Boolean;
var cartesChoisies, cartesCommunes : TPaquet;

begin
    choixCartes(paquetPieces, paquetArmes, paquetPersonnages, cartesChoisies);
    comparaisonCartes(cartesChoisies, solution, cartesCommunes);
    if length(cartesCommunes)=3 then
        accusation:=True
    else
        accusation:=False
end;


procedure initilisationPositionsJoueurs(var joueurs : TJoueurs ; var plateau : TPlateau);
var i:integer;
begin
for i:=0 to length(joueurs)-1 do
    begin;
     // Position initiale joueur 1
    case i of
    0:begin;
      joueurs[i].x := 6; 
      joueurs[i].y := 2;
      end;
    1:begin;
      joueurs[i].x := 15; 
      joueurs[i].y := 15;
      end;
    2:begin;
      joueurs[i].x := 11; 
      joueurs[i].y := 2;
      end;
    3:begin;
      joueurs[i].x := 2; 
      joueurs[i].y := 7;
      end;
    4:begin;
      joueurs[i].x := 5; 
      joueurs[i].y := 20;
      end;
    5:begin;
      joueurs[i].x := 12; 
      joueurs[i].y := 20;
      end;
    end;
          // Placer le joueur sur le plateau
      plateau[joueurs[i].x, joueurs[i].y].estOccupee := True;
      plateau[joueurs[i].x, joueurs[i].y].joueurID := i+1;
end;
end;

// Procédure pour initialiser les pièces et leurs couleurs
procedure initialisationPiece(var plateau: TPlateau; debutX, finX, debutY, finY: Integer; piece: TPiece; couleur: TCouleur);
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

  initialisationPiece(plateau, 2, 3, 2, 4, Amphi_Tillionn, Blue);
  initialisationPiece(plateau, 2, 3, 10, 12, Laboo, Green);
  initialisationPiece(plateau, 2, 3, 18, 20, BUU, Red);
  initialisationPiece(plateau, 8, 9, 2, 4, RUU, Yellow);
  initialisationPiece(plateau, 8, 9, 10, 12, Parking_visiteurs, Magenta);
  initialisationPiece(plateau, 8, 9, 18, 20, Cafeteriaa, Yellow);
  initialisationPiece(plateau, 14, 15, 2, 4, Infirmeriee, Red);
  initialisationPiece(plateau, 14, 15, 10, 12, Residencee, Cyan);
  initialisationPiece(plateau, 14, 15, 18, 20, BDEE, Blue);

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

Procedure PlacerPionDansPiece(var plateau: TPlateau; currentPlayer: Integer; piece: TPiece);
var
  i, j: Integer;
  positionTrouvee: Boolean;
begin
  positionTrouvee := False;

  // Parcours du plateau pour trouver une case libre dans la pièce donnée
  for i := 1 to 16 do
  begin
    for j := 1 to 21 do
    begin
      if (plateau[i, j].typePiece = piece) and not plateau[i, j].estOccupee then
      begin
        // Place le joueur sur la case libre trouvée
        plateau[i, j].estOccupee := True;
        plateau[i, j].joueurID := currentPlayer;
        positionTrouvee := True;
        write(currentPlayer+1);
        Break; //Arrête la boucle
      end;
    end;

    if positionTrouvee then
      Break;
  end;
end;

end.
