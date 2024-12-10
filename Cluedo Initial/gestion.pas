Unit gestion;

interface

Uses Crt, TypeEtCte, affichage;

function choixAction(choix : Integer) : Boolean;
function TPieceToTCarte(piece: TPiece): TCarte;
procedure menu( var choix, nbJoueurs : Integer ; var joueurs : TJoueurs);
procedure initialisationPaquets(var paquetPieces, paquetArmes, paquetPersonnages : TPaquet);
procedure selectionCartesCrime(paquetPieces, paquetArmes, paquetPersonnages : TPaquet; var solution, paquetSansCartesCrime : TPaquet);
procedure melangerPaquet(var paquetSansCartesCrime : TPaquet);
procedure initialisationJoueurs(var joueurs: TJoueurs; var plateau : TPlateau; nbJoueurs: Integer);
procedure distributionCartesJoueurs(paquetSansCartesCrime : TPaquet ; nbJoueurs : Integer ; var joueurs : TJoueurs);
procedure initialisationPiece(var plateau: TPlateau; debutX, finX, debutY, finY: Integer; piece: TPiece; couleur: TCouleur);
procedure initialisationPlateau(var plateau: TPlateau);
procedure choixDebutJeu(var nbJoueurs : Integer ; var plateau : TPlateau ; var joueurs : TJoueurs);
procedure initialisationPartie(nbJoueurs : Integer ; var joueurs : TJoueurs ; var paquetPieces, paquetArmes, paquetPersonnages, paquetSansCartesCrime, solution : TPaquet ; var plateau : TPlateau);
procedure choixCarte(paquet: TPaquet; var carteChoisie: TCarte);
procedure choixCartesAccusation(paquetPieces, paquetArmes, paquetPersonnages : TPaquet; var cartesChoisies : TPaquet);
procedure choixCartesHypothese(paquetPieces, paquetArmes, paquetPersonnages: TPaquet; var cartesChoisies: TPaquet; plateau:TPlateau; joueurs:TJoueurs; currentPlayer:integer);
procedure comparaisonCartes(compare, comparant : TPaquet ; var cartesCommunes : TPaquet);
procedure recupererCarteJoueur(compare, comparant : TPaquet ; var carteChoisie : TCarte; var presenceCarteCommune:boolean);
procedure hypothese(paquetPieces, paquetArmes, paquetPersonnages: TPaquet; joueurActuel : TJoueur; joueurs : TJoueurs; var cartesChoisies : TPaquet ; var carteChoisie : TCarte; var presenceCarteCommune:Boolean;plateau:TPlateau;currentPlayer:Integer);
function accusation(paquetPieces, paquetArmes, paquetPersonnages, solution : TPaquet; joueurActuel : TJoueur):Boolean;
procedure affichageResultatHypothese(paquetPieces, paquetArmes, paquetPersonnages: TPaquet; joueurActuel : TJoueur; joueurs : TJoueurs; cartesChoisies : TPaquet; carteChoisie : TCarte; var presenceCarteCommune:boolean;currentPlayer:integer;plateau:TPlateau);
procedure affichageResultatAccusation(paquetPieces, paquetArmes, paquetPersonnages, solution : TPaquet; joueurActuel : TJoueur);
procedure placerPionDansPiece(var plateau : TPlateau ; currentPlayer : Integer ; piece : TPiece);
procedure PlacerDevantPorte(var plateau: TPlateau; var joueurs: TJoueurs; currentPlayer: Integer; var deplacement:integer);
procedure deplacerJoueur(var joueurs: TJoueurs; currentPlayer: Integer; var plateau: TPlateau; var deplacement: Integer);
function LancerDes( deplacement:integer) : integer;
procedure jouerTour(var joueurs: TJoueurs; var plateau: TPlateau; paquetPieces, paquetArmes, paquetPersonnages, solution: TPaquet; joueurActuel : TJoueur; currentPlayer:integer);


implementation

function choixAction(choix : Integer) : Boolean;
begin
  read(choix);
  if choix = 1 then
    choixAction:=True
  else
    choixAction:=False;
end;

function TPieceToTCarte(piece: TPiece): TCarte;
begin
  case piece of
    Amphi_Tillionn : TPieceToTCarte := Amphi_Tillion;
    Laboo : TPieceToTCarte := Labo;
    Cafeteriaa : TPieceToTCarte := Cafeteria;
    Parking_visiteurs : TPieceToTCarte := Parking_visiteur;
    RUU : TPieceToTCarte := RU;
    BDEE : TPieceToTCarte := BDE;
    BUU : TPieceToTCarte := BU;
    Infirmeriee : TPieceToTCarte := Infirmerie;
    Residencee : TPieceToTCarte := Residence; 
  end;
end;

procedure menu( var choix, nbJoueurs : Integer ; var joueurs : TJoueurs);
begin
repeat
  ClrScr;
  affichageMenu();
  readln(choix);

  case choix of
    1: begin
        ClrScr;
        affichageRegles(); // Lorsque 1 est tapé, on affiche les règles
        readln();
        menu( choix, nbJoueurs, joueurs);
        end;
    2: begin
          ClrScr;
        end;
    3: halt; // Lorsque 3 est tapé, on quitte le jeu
  else
    writeln('Choix invalide, veuillez reessayer.');
  end;
  until (choix=1) or (choix=2) or (choix=3) ;
end;

procedure initialisationPaquets(var paquetPieces, paquetArmes, paquetPersonnages : TPaquet);
var i : Integer;

begin
  // Crée le paquet des pièces
  SetLength(paquetPieces, 9);
  for i := 0 to Length(paquetPieces) - 1 do
  begin
    paquetPieces[i] := TCarte(i);
  end;

  // Crée le paquet des armes
  SetLength(paquetArmes, 6);
  for i := 0 to Length(paquetArmes) - 1 do
  begin
    paquetArmes[i] := TCarte(i + Length(paquetPieces));
  end;

  // Crée le paquet des personnages
  SetLength(paquetPersonnages, 6);
  for i := 0 to Length(paquetPersonnages) - 1 do
  begin
    paquetPersonnages[i] := TCarte(i + Length(paquetPieces) + Length(paquetArmes));
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
  randomIndex:=Random(Length(paquetPieces));
  // ensuite on l'associe à la première carte solution
  solution[0] := paquetPieces[randomIndex];
  // on fait de même pour les armes et personnages
  randomIndex := Random(Length(paquetArmes));
  solution[1] := paquetArmes[randomIndex];
  randomIndex := Random(Length(paquetPersonnages));
  solution[2] := paquetPersonnages[randomIndex];

  SetLength(paquetSansCartesCrime, 18);
  indexPaquet:=0;

  // Rempli le paquet sans les cartes sélectionnées pour la solution
  for i := 0 to Length(paquetPieces)-1 do
  begin
    // Si la carte n'est pas dans la solution, elle est ajoutée à paquetSansCartesCrime
    if (paquetPieces[i]<>solution[0]) then
    begin
      paquetSansCartesCrime[indexPaquet] := paquetPieces[i];
      indexPaquet := indexPaquet + 1;
    end;
  end;

  for i:=0 to Length(paquetArmes)-1 do
  begin  
    if (paquetArmes[i]<>solution[1]) then
    begin
      paquetSansCartesCrime[indexPaquet] := paquetArmes[i];
      indexPaquet := indexPaquet + 1;
    end;
  end;

  for i:=0 to Length(paquetPersonnages)-1 do
  begin  
    if (paquetPersonnages[i]<>solution[2]) then
    begin
      paquetSansCartesCrime[indexPaquet] := paquetPersonnages[i];
      indexPaquet := indexPaquet + 1;
    end;
  end;
end;

procedure melangerPaquet(var paquetSansCartesCrime : TPaquet);
var i, j : Integer ;
    temp : TCarte ;
begin
  Randomize;
  // Parcourt le paquet à l'envers
  for i := 0 to Length(paquetSansCartesCrime) - 1 do
  begin
    // Prend au hasard un indice entre 0 et i
    j := Random(i);
    // Echange les cartes d'indice i avec celles d'indice j (temp sert de stock, comme on a vu en I1)
    temp := paquetSansCartesCrime[i];
    paquetSansCartesCrime[i] := paquetSansCartesCrime[j];
    paquetSansCartesCrime[j] := temp;
  end;
end;

procedure initialisationJoueurs(var joueurs: TJoueurs; var plateau : TPlateau; nbJoueurs: Integer);
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
      SetLength(joueurs[i].main, cartesParJoueur + 1);
    end;

    for i:=0 to Length(joueurs)-1 do
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
        joueurs[i].x := 6; 
        joueurs[i].y := 20;
        end;
      5:begin;
        joueurs[i].x := 12; 
        joueurs[i].y := 20;
        end;
      end;
      joueurs[i].dansPiece:=false;
      // Placer le joueur sur le plateau
      plateau[joueurs[i].x, joueurs[i].y].estOccupee := True;
      plateau[joueurs[i].x, joueurs[i].y].joueurID := i+1;
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
      for j := 0 to Length(joueurs[i].main)-1 do
      begin
        joueurs[i].main[j] := paquetSansCartesCrime[indexPaquet];
        indexPaquet := indexPaquet + 1;
      end;
    end;
end;

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
  plateau[2, 13].typePiece:= Couloir;
  plateau[4, 20].typePiece:= Couloir;
  plateau[8, 5].typePiece:= Couloir;
  plateau[10, 11].typePiece:= Couloir;
  plateau[7, 12].typePiece:= Couloir;
  plateau[10, 20].typePiece:= Couloir;
  plateau[13, 3].typePiece:= Couloir;
  plateau[15, 9].typePiece:= Couloir;
  plateau[15, 17].typePiece:= Couloir;
end;

procedure choixDebutJeu(var nbJoueurs : Integer ; var plateau : TPlateau ; var joueurs : TJoueurs);
begin
  repeat
    write('Entrez le nombre de joueurs (2-6) : ');
    readln(nbJoueurs); // Sélectionne le nombre de joueurs
  until (nbJoueurs >= 2) and (nbJoueurs <= MAX_PERSONNAGES); // Vérifie que le nombre est compris entre 2 et 6

  SetLength(joueurs,nbJoueurs); // Défini la taille du tableau des joueurs en fonction du nombre de joueurs
  initialisationJoueurs(joueurs, plateau, nbJoueurs); // (voir la procedure dans gestion.pas)
end;


procedure initialisationPartie(nbJoueurs:integer;  var joueurs : TJoueurs ; var paquetPieces, paquetArmes, paquetPersonnages, paquetSansCartesCrime, solution : TPaquet ; var plateau : TPlateau);

begin
  initialisationPaquets(paquetPieces, paquetArmes, paquetPersonnages);
  selectionCartesCrime(paquetPieces, paquetArmes, paquetPersonnages, solution, paquetSansCartesCrime);
  melangerPaquet(paquetSansCartesCrime);
  distributionCartesJoueurs(paquetSansCartesCrime, nbJoueurs, joueurs);
  initialisationPlateau(plateau);
end;

procedure choixCarte(paquet: TPaquet; var carteChoisie: TCarte);
var i, choix : Integer;

begin
	repeat
    for i := 0 to Length(paquet) - 1 do
      writeln(i + 1, '. ', paquet[i]);
    readln(choix);
    until (choix >= 1) and (choix <= Length(paquet));
    carteChoisie:=paquet[choix - 1];
end;

procedure choixCartesAccusation(paquetPieces, paquetArmes, paquetPersonnages : TPaquet; var cartesChoisies : TPaquet);

begin
  // Initialise la taille de cartesChoisies pour qu'il contienne trois cartes
  SetLength(cartesChoisies, 3);

  // Choix du suspect
  writeln('Choisissez un suspect :');
  choixCarte(paquetPersonnages, cartesChoisies[0]);
  effacerLignes(18,10);

  // Choix de l'arme
  writeln('Choisissez une arme :');
  choixCarte(paquetArmes, cartesChoisies[1]);
  effacerLignes(18,10);
  
  // Choix de la pièce
  writeln('Choisissez un lieu :');
  choixCarte(paquetPieces, cartesChoisies[2]);
  effacerLignes(18,12);
end;

procedure choixCartesHypothese(paquetPieces, paquetArmes, paquetPersonnages: TPaquet; var cartesChoisies: TPaquet; plateau:TPlateau; joueurs:TJoueurs; currentPlayer:integer);
var posX, posY:integer;
    caseActuelle:TCase;
   
begin
  // Initialise la taille de cartesChoisies pour qu'il contienne trois cartes
  SetLength(cartesChoisies,3);

  // Choix du suspect
  writeln('Choisissez un suspect :');
  choixCarte(paquetPersonnages, cartesChoisies[0]);
  effacerLignes(18,12);

  // Choix de l'arme
  writeln('Choisissez une arme :');
  choixCarte(paquetArmes, cartesChoisies[1]);
  effacerLignes(18,12);
  
  // Choix de la pièce
  posX:=joueurs[currentPlayer].x;
  posY:=joueurs[currentPlayer].y;
  caseActuelle:=plateau[posX,posY];
  cartesChoisies[2] := TPieceToTCarte(caseActuelle.typePiece);
  // effacerLignes(18,12);
end;

procedure comparaisonCartes(compare, comparant : TPaquet ; var cartesCommunes : TPaquet);
var i, j, indexPaquet : Integer;
begin
  SetLength(cartesCommunes, 0);
  indexPaquet:=0;
  for i := 0 to Length(compare)-1 do
  begin
    for j := 0 to Length(comparant)-1 do
    begin
      if compare[i] = comparant[j] then
      begin
        SetLength(cartesCommunes,indexPaquet+1);
        cartesCommunes[indexPaquet]:=compare[i];
        indexPaquet:=indexPaquet+1;
      end;
    end;
  end;
end;

procedure recupererCarteJoueur(compare, comparant : TPaquet ; var carteChoisie : TCarte; var presenceCarteCommune:boolean);
var cartesCommunes : TPaquet;

begin
  presenceCarteCommune:=false;
  comparaisonCartes(compare,comparant,cartesCommunes);
  if Length(cartesCommunes) = 0 then
  begin
    write('Aucune carte commune. Rien a montrer.');
    clreol();
  end
  else   
  begin 
    presenceCarteCommune:=true;
    writeln('Veuillez selectionner la carte a montrer');
    choixCarte(cartesCommunes, carteChoisie);
    effacerLignes(18,7);
  end; 
end;

procedure hypothese(paquetPieces, paquetArmes, paquetPersonnages: TPaquet; joueurActuel : TJoueur; joueurs : TJoueurs; var cartesChoisies : TPaquet ; var carteChoisie : TCarte; var presenceCarteCommune:Boolean;plateau:TPlateau;currentPlayer:Integer);
var i, choix, impossible : Integer;
    
begin
  repeat
    writeln('Choisissez un temoin parmi les autres joueurs :');
    for i:=0 to Length(joueurs)-1 do
    begin
      write(i+1, '. ', joueurs[i].nom);
      if joueurs[i].nom=joueurActuel.nom then
      begin
        impossible:=i;
        write(' (impossible)');
      end;
      writeln();
    end;
    readln(choix);
    effacerLignes(18,9);
  until (choix >= 1) and (choix <= MAX_PERSONNAGES) and (choix-1<>impossible);

  choixCartesHypothese(paquetPieces, paquetArmes, paquetPersonnages, cartesChoisies,plateau,joueurs,currentPlayer);
  writeln('Votre hypothese est : C''est ', cartesChoisies[0], ' dans ', cartesChoisies[2], ' avec ', cartesChoisies[1]);
	Delay(3000);//(pas besoin?)
	effacerLignes(18,2);
    
  writeln('Appuyez sur Entree lorsque le joueur ', joueurs[choix-1].nom, ' est pret.'); // Prévention pour le témoin de joueur
  readln;
  recupererCarteJoueur(joueurs[choix-1].main, cartesChoisies, carteChoisie,presenceCarteCommune);
  effacerLignes(18,6);
  
  writeln('Appuyez sur Entree lorsque le joueur ', joueurActuel.nom, ' est pret.'); // Prévention pour joueur actuel de voir la carte
  readln;
end;

function accusation(paquetPieces, paquetArmes, paquetPersonnages, solution : TPaquet; joueurActuel : TJoueur):Boolean;
var cartesChoisies, cartesCommunes : TPaquet;

begin
  choixCartesAccusation(paquetPieces, paquetArmes, paquetPersonnages, cartesChoisies);
  comparaisonCartes(cartesChoisies, solution, cartesCommunes);
  if Length(cartesCommunes)=3 then
    accusation:=True
  else
    accusation:=False
end;

procedure affichageResultatHypothese(paquetPieces, paquetArmes, paquetPersonnages: TPaquet; joueurActuel : TJoueur; joueurs : TJoueurs; cartesChoisies : TPaquet; carteChoisie : TCarte; var presenceCarteCommune:boolean;currentPlayer:integer;plateau:TPlateau);

begin
  hypothese(paquetPieces, paquetArmes, paquetPersonnages, joueurActuel, joueurs, cartesChoisies, carteChoisie, presenceCarteCommune,plateau,currentPlayer);
  writeln('Voici la "carte en commun" : ');
  if presenceCarteCommune= true then
    writeln(carteChoisie)
  else
    writeln('Aucune carte en commun');
end;

procedure affichageResultatAccusation(paquetPieces, paquetArmes, paquetPersonnages, solution : TPaquet; joueurActuel : TJoueur);
var resultat:Boolean;

begin
  resultat:=accusation(paquetPieces, paquetArmes, paquetPersonnages, solution, joueurActuel);
  if (resultat) then
    writeln(joueurActuel.nom, ' remporte la partie ! Les autres joueurs ont perdu.')
  else
    writeln(joueurActuel.nom, ' a perdu la partie. Les autres joueurs gagnent !');
    writeln('Le veritable coupable est : ',solution[2]);
    writeln('Les faits se sont deroules : ',solution[0]);
    writeln('L''arme du crime etait : ',solution[1]);
end;

procedure placerPionDansPiece(var plateau : TPlateau ; currentPlayer : Integer ; piece : TPiece);
var i,j : Integer;
    positionTrouvee : Boolean;
    oldX, oldY : Integer;
begin
  positionTrouvee := False;
  //Parcours du plateau pour trouver la position du joueur
  for i := 1 to 16 do
  begin
    for j := 1 to 21 do
    begin
      if (plateau[i, j].joueurID = currentPlayer) then
      begin
        oldX := i;
        oldY := j;

        // Libérer l'ancienne position
        plateau[i, j].estOccupee := False;
        plateau[i, j].joueurID := 0;

        // Effacer l'affichage de l'ancienne position
        GotoXY(oldY, oldX + 1);
        attributionCouleur(plateau[i, j].couleur);
        write('.');
        Break; // arrêt quand la position trouvée
      end;
    end;
  end;

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

        // Afficher la nouvelle position
        GotoXY(j, i + 1);
        attributionCouleur(plateau[i, j].couleur);
        write(currentPlayer);
        attributionCouleur(Black);
        Break; // Arrête la boucle
      end;
    end;

    if positionTrouvee then
      Break;
  end;
end;

procedure PlacerDevantPorte(var plateau: TPlateau; var joueurs: TJoueurs; currentPlayer: Integer; var deplacement:integer);
var oldx,oldy,i, j, nbPortes, choix: Integer;
    portesX, portesY: array[1..2] of integer;

begin
  nbPortes := 0;
  for i := 1 to 16 do
  begin
    for j := 1 to 21 do
    begin
    //attribuer la position du pion
    if  plateau[i,j].joueurID=currentPlayer+1 then
    begin
    joueurs[currentPlayer].x:=i;
    joueurs[currentPlayer].y:=j;
    end;
      // Identifier les portes autour de la pièce
      if (plateau[i, j].typePiece = Couloir) and
         ((plateau[i + 1, j].typePiece = joueurs[currentPlayer].piecePrecedente) or
          (plateau[i - 1, j].typePiece = joueurs[currentPlayer].piecePrecedente) or
          (plateau[i, j + 1].typePiece = joueurs[currentPlayer].piecePrecedente) or
          (plateau[i, j - 1].typePiece = joueurs[currentPlayer].piecePrecedente)) then
      begin
        Inc(nbPortes);
        portesX[nbPortes]:= i;
        portesY[nbPortes] := j;
        if nbPortes = 2 then //Arret lorsqu'il atteint un nb de 2 portes
          Break;
      end;
    end;
    if nbPortes = 2 then
      Break;
  end;

  // Affichage
  writeln('Choisissez une porte :');
  for i := 1 to nbPortes do
    writeln(i, '. Porte en position (', portesY[i], ',', portesX[i], ')');
  repeat
    write('Votre choix : ');
    readln(choix);
  until (choix >= 1) and (choix <= nbPortes);
  
  oldx:=joueurs[currentPlayer].x;
  oldy:=joueurs[currentPlayer].y;

   // Effacer l'ancienne position
  plateau[joueurs[currentPlayer].x, joueurs[currentPlayer].y].estOccupee := False;
  plateau[joueurs[currentPlayer].x, joueurs[currentPlayer].y].joueurID := 0;

  // Déplacer le joueur devant la porte choisie
  joueurs[currentPlayer].x := portesX[choix];
  joueurs[currentPlayer].y := portesY[choix];

  plateau[joueurs[currentPlayer].x, joueurs[currentPlayer].y].estOccupee := True;
  plateau[joueurs[currentPlayer].x, joueurs[currentPlayer].y].joueurID := currentPlayer+1;

  // Mettre à jour l'affichage
  GotoXY(oldY,oldx+1);
  attributionCouleur(plateau[oldX,oldY].couleur);
  write('.');
      
  GotoXY(portesY[choix], portesX[choix] + 1); //+1 car écriture "plateau de jeu"
  attributionCouleur(plateau[joueurs[currentPlayer].x, joueurs[currentPlayer].y].couleur);
  write(currentPlayer+1);

  // Réinitialiser "dansPiece"
  joueurs[currentPlayer].dansPiece := False;
  effacerLignes(18,7);
end;

procedure deplacerJoueur(var joueurs: TJoueurs; currentPlayer: Integer; var plateau: TPlateau; var deplacement: Integer);
var
  oldX,oldY,newX, newY: Integer;
  key: Char;
  piece:TPiece;
begin
  while deplacement >=0 do
  begin
    key := ReadKey;
 
    // Calculer la nouvelle position en fonction de la touche
    newX := joueurs[currentPlayer].x;
    newY := joueurs[currentPlayer].y;
    oldX := newX;
    oldY := newY;

    case key of
      #72: Dec(newX); // Haut
      #80: Inc(newX); // Bas
      #75: Dec(newY); // Gauche
      #77: Inc(newY); // Droite
    end;  

    // Vérifier si la nouvelle position est valide
    if (plateau[newX, newY].typePiece <> Mur) and (not plateau[newX, newY].estOccupee) then
    begin
      // Libérer l'ancienne position
      plateau[joueurs[currentPlayer].x, joueurs[currentPlayer].y].estOccupee := False;
      plateau[joueurs[currentPlayer].x, joueurs[currentPlayer].y].joueurID := 0;

      // Déplacer le joueur
      joueurs[currentPlayer].x := newX;
      joueurs[currentPlayer].y := newY;

      // Occuper la nouvelle position
      plateau[newX, newY].estOccupee := True;
      plateau[newX, newY].joueurID := currentPlayer + 1; // ID de joueur commence à 1

      GotoXY(oldY,oldX+1);
      attributionCouleur(plateau[oldX,oldY].couleur);
      write('.');

      GotoXY(newY,newX+1);
      attributionCouleur(plateau[newX,newY].couleur);
      write(currentPlayer+1);

      GotoXY(1,20);
      attributionCouleur(Black);
      ClrEol();
      GotoXY(1,21);
      ClrEol();
      GotoXY(1,20);
      writeln('Deplacements restants:', deplacement); 
      Dec(deplacement); // Réduire le nombre de déplacements restants
      
      if (plateau[newX, newY].typePiece <> Couloir) then
      begin
      deplacement:=-1;
      currentPlayer:=plateau[newX, newY].joueurID;
      piece:=plateau[newX, newY].typePiece;
      PlacerPionDansPiece(plateau,currentPlayer, piece);
      
      //joueurs[currentPlayer].dansPiece := True;
      //joueurs[currentPlayer].piecePrecedente := piece; 
      end;
    end;
  end;
end;

function LancerDes( deplacement:integer) : integer;
  var  des1,des2: integer;
begin
  des1 := Random(6) + 1; 
  des2 := Random(6) + 1;
  LancerDes:=deplacement+des1 + des2;
end;

procedure jouerTour(var joueurs: TJoueurs; var plateau: TPlateau; paquetPieces, paquetArmes, paquetPersonnages, solution: TPaquet; joueurActuel : TJoueur; currentPlayer:integer);
var
  deplacement: Integer;
  action : Integer;
  resultatAction, presenceCarteCommune : Boolean;
  cartesChoisies:TPaquet;
  carteChoisie:TCarte;
begin
//initialisation des variables
action:=1;
carteChoisie:=RU;
setlength(cartesChoisies,3);

//Parcours de tous les joueurs
for currentPlayer := 0 to length(joueurs)-1 do
 begin
   deplacement := 0;
   writeln('Joueur ', currentPlayer +1 , ', c''est votre tour !');
   AnnonceTour(currentPlayer);
   if joueurs[currentPlayer].dansPiece then
    begin
     PlacerDevantPorte(plateau, joueurs, currentPlayer, deplacement);
     deplacement:=-1; //retire 1 deplacement lors du lancer de dés
    end;
   deplacement := LancerDes(deplacement);
   write('Tu as obtenu ',deplacement);
   deplacerJoueur(joueurs, currentPlayer, plateau, deplacement);
   effacerLignes(18,4);
    //si le joueur actuel est dans une piece
   if (plateau[joueurs[currentPlayer].x, joueurs[currentPlayer].y].typePiece <> Mur) and
   (plateau[joueurs[currentPlayer].x, joueurs[currentPlayer].y].typePiece <> Couloir) then
    begin
     joueurs[currentPlayer].dansPiece:=True;
     joueurs[currentPlayer].piecePrecedente := plateau[joueurs[currentPlayer].x, joueurs[currentPlayer].y].typePiece;
     writeln('1. Hypothese');
     writeln('2. Accusation');
     resultatAction:=choixAction(action);
     effacerLignes(18,2);
     if resultatAction then
      begin
       affichageResultatHypothese(paquetPieces, paquetArmes, paquetPersonnages, joueurs[currentPlayer], joueurs, cartesChoisies, carteChoisie, presenceCarteCommune,currentPlayer,plateau);
       Delay(3000);
       effacerLignes(18,4);
      end
     else
      begin
       affichageResultatAccusation(paquetPieces, paquetArmes, paquetPersonnages, solution, joueurs[currentPlayer]);
       halt;
      end;
     end
     //sinon dans un couloir, le joueur ne peut que formuler une accusation
    else if (plateau[joueurs[currentPlayer].x, joueurs[currentPlayer].y].typePiece = Couloir) then
     begin
      writeln('Souhaitez vous faire une accusation?');
      writeln('1. oui');
      writeln('2. non');
      resultatAction:=choixAction(action);
      effacerLignes(18,4);
      if resultatAction then
        begin
          affichageResultatAccusation(paquetPieces, paquetArmes, paquetPersonnages, solution, joueurs[currentPlayer]);
          halt;
        end;
      end;
    end;
  end;
end.
