unit gestion;

interface

uses SDL2, TypeEtCte, affichage, sysUtils, TypInfo;

procedure menu(Renderer: PSDL_Renderer);
procedure choixNbJoueurs(Renderer: PSDL_Renderer; var joueurs: TJoueurs);
procedure selectionJoueurs(Renderer: PSDL_Renderer; var joueurs: TJoueurs);
function creerPiece(x,y,w,h:Integer;nom:TNomPiece):TPiece;
procedure InitPieces(Renderer : PSDL_Renderer ; var pieces : TPieces);
procedure InitCharacters(var joueurs: TJoueurs; var joueurActuel: Integer);
procedure InitPaquets(var paquetPieces, paquetArmes, paquetPersonnages : TPaquet);
procedure selectionCartesCrime(paquetPieces, paquetArmes, paquetPersonnages : TPaquet; var solution, paquetSansCartesCrime : TPaquet);
procedure melangerPaquet(var paquetSansCartesCrime : TPaquet);
procedure distributionCartesJoueurs(paquetSansCartesCrime: TPaquet ; var joueurs: TJoueurs);
procedure initialisationPartie(Renderer : PSDL_Renderer ; pieces : TPieces ; joueurs : TJoueurs ; joueurActuel: Integer ; var paquetPieces, paquetArmes, paquetPersonnages, solution, paquetSansCartesCrime : TPaquet);
procedure LancerDes(Renderer: PSDL_Renderer; DiceTextures: TabTextures; var ResultatsDice: TTabInt);

function estDansPiece(pieces : TPieces ; xJ, yJ : Integer) : Boolean;
function quellePiece(pieces : TPieces ; xJ, yJ : Integer) : TPiece;
function TPieceToTCarte(piece: TNomPiece): TCarte;
function choixCarte(Renderer: PSDL_Renderer; message: String; paquet : TPaquet) : TCarte;
procedure choixCartes(Renderer: PSDL_Renderer; joueurs: TJoueurs; ResultatsDice: TTabInt; DiceTextures: TabTextures; nbDeplacement, joueurActuel, x, y: Integer; pieces: TPieces; paquetArmes, paquetPersonnages : TPaquet ; var cartesChoisies: TPaquet; var temoinChoisi: Integer);
function comparaisonCartes(compare, comparant : TPaquet) : TPaquet;

function recupererCarteJoueur(Renderer : PSDL_Renderer ; compare, comparant : TPaquet ; ResultatsDice : TTabInt ; DiceTextures : TabTextures ; joueurs : TJoueurs ; nbDeplacement, joueurActuel, temoinChoisi : Integer) : TCarte;
procedure hypothese(Renderer : PSDL_Renderer ; joueurs : TJoueurs ; ResultatsDice : TTabInt ; DiceTextures : TabTextures ; nbDeplacement, joueurActuel, x, y : Integer ; pieces : TPieces ; paquetArmes, paquetPersonnages : TPaquet);
function accusation(Renderer : PSDL_Renderer ; joueurs : TJoueurs ; ResultatsDice : TTabInt ; DiceTextures : TabTextures ; nbDeplacement, joueurActuel, x, y : Integer ; paquetPersonnages, paquetArmes, paquetPieces, solution : TPaquet ; pieces : TPieces): Boolean;
procedure choixActionCouloir(Renderer : PSDL_Renderer ; var joueurActuel : Integer ; nbDeplacement, x, y : Integer ; paquetPersonnages, paquetArmes, paquetPieces, solution : TPaquet ; pieces : TPieces; joueurs : TJoueurs);
procedure choixActionPiece(Renderer : PSDL_Renderer ; var joueurActuel : Integer ; nbDeplacement, x, y : Integer ; pieces : TPieces ; joueurs : TJoueurs ; paquetArmes, paquetPersonnages, paquetPieces, solution : TPaquet ; var cartesCommunes : TPaquet);
procedure gestionTour(Renderer : PSDL_Renderer ; pieces : TPieces ;  paquetArmes, paquetPersonnages, paquetPieces, solution : TPaquet ; var joueurs: TJoueurs; var joueurActuel: Integer; var ResultatsDice : TTabInt; var nbDeplacement: Integer);

implementation

procedure menu(Renderer: PSDL_Renderer);
var Event : TSDL_Event;
    CurrentSelection: Integer;
    IsRunning, lecture : Boolean;
    DestRect : TSDL_Rect;
begin
  CurrentSelection := 0; // L'option sélectionnée commence à 0
  IsRunning := True;
  
  while IsRunning do
  begin
    affichageMenu(Renderer, CurrentSelection);

    // Gestion des événements
    while SDL_PollEvent(@Event) <> 0 do
    begin
      if Event.type_ = SDL_QUITEV then
      begin
        IsRunning := False;
      end
      else if Event.type_ = SDL_KEYDOWN then
      begin
        case Event.key.keysym.sym of
          SDLK_UP:
            if CurrentSelection > 0 then
              Dec(CurrentSelection);
          SDLK_DOWN:
            if CurrentSelection < 2 then
              Inc(CurrentSelection);
          SDLK_RETURN:
            case CurrentSelection of
              0: begin
                  affichageRegles(Renderer);
                  lecture := True;
                  while lecture do
                  begin
                    while SDL_PollEvent(@Event) <> 0 do
                    begin
                      if Event.type_ = SDL_KEYDOWN then
                      begin
                        if Event.key.keysym.sym = SDLK_RETURN then
                          lecture := False;
                      end
                      else if Event.type_ = SDL_QUITEV then
                        Halt;
                    end;
                  end;
                  afficherImage(Renderer, 'menu', @DestRect);
                 end;
              1: begin
                  affichageNarration(Renderer);
                  // SDL_RenderPresent(Renderer);
                  lecture := True;
                  while lecture do
                  begin
                    while SDL_PollEvent(@Event) <> 0 do
                    begin
                      if Event.type_ = SDL_KEYDOWN then
                      begin
                        if Event.key.keysym.sym = SDLK_RETURN then
                          lecture := False;
                      end
                      else if Event.type_ = SDL_QUITEV then
                        Halt;
                    end;
                  end;
                  IsRunning := False;
                 end;
              2: begin
                  IsRunning := False;
                  Halt;
                end; 
            end;
        end;
      end;
    end;
  end;
end; 

procedure choixNbJoueurs(Renderer: PSDL_Renderer; var joueurs: TJoueurs);
var
  Event: TSDL_Event;
  IsRunning: Boolean;
  DestRect : TSDL_Rect;
begin
  IsRunning := True;
  SetLength(joueurs, 2);

  DestRect := coordonnees(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
  
  while IsRunning do
  begin
    SDL_RenderClear(Renderer);

    afficherImage(Renderer, 'choixNbJoueurs', @DestRect);

    afficherTexte(Renderer, IntToStr(Length(joueurs)), 180, SCREEN_WIDTH div 2 - 50, 540, Couleur(163, 3, 3, 255));

    SDL_RenderPresent(Renderer);

    while SDL_PollEvent(@Event) = 1 do
    begin
      if Event.type_ = SDL_KEYDOWN then
      begin
        case Event.key.keysym.sym of
          SDLK_UP: if Length(joueurs) < 6 then SetLength(joueurs, Length(joueurs)+1);
          SDLK_DOWN: if Length(joueurs) > 2 then SetLength(joueurs, Length(joueurs)-1);
          SDLK_RETURN: IsRunning := False; // Valider le choix
        end;
      end;
      if event.type_ = SDL_QUITEV then
          Halt;
    end;
  end;
  SetLength(joueurs,Length(joueurs));
end;

procedure selectionJoueurs(Renderer: PSDL_Renderer; var joueurs: TJoueurs);
var
  Event: TSDL_Event;
  IsRunning: Boolean;
  SelectedCount: Integer;
  JoueurRect: array[0..5] of TSDL_Rect; // Positions des images des joueurs
  DestRect : TSDL_Rect;
  i: Integer;
  MouseX, MouseY: Integer;
  Selection: array[0..5] of Boolean;
  sdlRect1: TSDL_Rect;

begin
  // Initialisation
  IsRunning := True;
  SelectedCount := 0;
  for i := 0 to 5 do
    Selection[i] := False;

  for i := 0 to 5 do
  begin
    JoueurRect[i] := coordonnees((i mod 3) * 300 + 535, (i div 3) * 400 + 235, 250, 350);
  end;

  for i := 0 to Length(joueurs) - 1 do
    joueurs[i].nom := rien;
  
  DestRect := coordonnees(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

  // Boucle d'affichage et de sélection
  while IsRunning do
  begin
    SDL_RenderClear(Renderer);

    afficherImage(Renderer, 'selection joueurs', @DestRect);

    // Gérer les événements
    while SDL_PollEvent(@Event) <> 0 do
    begin
      case Event.type_ of
        SDL_MOUSEBUTTONDOWN:
          begin
            MouseX := Event.button.x;
            MouseY := Event.button.y;
            for i := 0 to 5 do
            begin
              if (MouseX >= JoueurRect[i].x) and (MouseX <= JoueurRect[i].x + JoueurRect[i].w) and
                (MouseY >= JoueurRect[i].y) and (MouseY <= JoueurRect[i].y + JoueurRect[i].h) then
              begin
                if not Selection[i] then
                begin
                  if SelectedCount < Length(joueurs) then
                  begin
                    Selection[i] := True;
                    joueurs[SelectedCount].nom := TPersonnage(i); // Ajouter le joueur sélectionné
                    Inc(SelectedCount);
                  end;
                end;
              end;
            end;
            if SelectedCount = Length(joueurs) then
              IsRunning := False;
          end;
        SDL_QUITEV: Halt;
      end;
    end;
    // Dessiner les rectangles gris sur les joueurs sélectionnés
    for i := 0 to Length(joueurs) - 1 do
    begin
      if joueurs[i].nom = rien then
        continue;
      
      sdlRect1 := coordonnees(JoueurRect[Ord(joueurs[i].nom)].x, JoueurRect[Ord(joueurs[i].nom)].y, JoueurRect[Ord(joueurs[i].nom)].w, JoueurRect[Ord(joueurs[i].nom)].h);

      SDL_SetRenderDrawColor(Renderer, 105, 105, 105, 255);
      SDL_RenderFillRect(Renderer, @sdlRect1);
      SDL_RenderDrawRect(Renderer, @sdlRect1);
    end;

    // Afficher les images des joueurs
    for i := 0 to 5 do
      afficherImage(Renderer, GetEnumName(TypeInfo(TPersonnage), Ord(TPersonnage(i))), @JoueurRect[i]);

    // Afficher le texte d'instruction
    afficherTexte(Renderer, 'Cliquez pour sélectionner ' + IntToStr(Length(joueurs)) + ' joueurs.', 40, SCREEN_WIDTH div 2 - 325, 70, Couleur(163, 3, 3, 255));

    SDL_RenderPresent(Renderer);
  end;
  SDL_RenderClear(Renderer);
end;

function creerPiece(x,y,w,h:Integer;nom:TNomPiece):TPiece;
begin
  creerPiece.x := x;
  creerPiece.y := y;
  creerPiece.w := w;
  creerPiece.h := h;
  creerPiece.nom := nom
end;

procedure InitPieces(Renderer : PSDL_Renderer ; var pieces : TPieces);
begin
  SetLength(Pieces,9);
  pieces[0] := creerPiece(0,0,6,3,Tillion);
  pieces[1] := creerPiece(8,0,6,6,Labo);
  pieces[2] := creerPiece(16,0,6,5,Gym);
  pieces[3] := creerPiece(0,5,6,4,Parking_visiteurs);
  pieces[4] := creerPiece(0,11,5,5,Self);
  pieces[5] := creerPiece(0,18,5,4,INSA_Shop);
  pieces[6] := creerPiece(7,16,8,6,Biblio);
  pieces[7] := creerPiece(17,17,5,5,Inf);
  pieces[8] := creerPiece(15,8,7,6,Chambre);
end;

procedure InitCharacters(var joueurs: TJoueurs; var joueurActuel: Integer);
var
  i, cartesParJoueur, joueursAvecNbCartesStandard: Integer;
begin

  for i := 0 to length(joueurs) - 1 do
  begin
    joueurs[i].x := positionsInitiales[joueurs[i].nom].x;
    joueurs[i].y := positionsInitiales[joueurs[i].nom].y;
  end;
  joueurActuel := 0;

  // Défini la taille de la main pour chaque joueur
  cartesParJoueur := 18 div length(joueurs); // Nombre de cartes par joueur (de base, change si 4 ou 5 joueurs)
  joueursAvecNbCartesStandard := length(joueurs); // Initialise le compteur pour les joueurs avec une carte en moins (si 4 ou 5 joueurs)

  // S'il y a 4 ou 5 joueurs, les deux premiers joueurs ont une carte en moins
  if (length(joueurs) = 4) or (length(joueurs) = 5) then
      joueursAvecNbCartesStandard := 2; // Deux premiers joueurs auront une carte en moins
  
  // Attribution des cartes
  for i := 0 to length(joueurs)-1 do
  begin
      if i < joueursAvecNbCartesStandard then
          SetLength(joueurs[i].main, cartesParJoueur) // Donne le nombre classique de cartes aux deuxpremiers joueurs
      else
          SetLength(joueurs[i].main, cartesParJoueur+1); // Les joueurs suivants reçoivent une carte supplémentaire
      // Initialise la liste des cartes pour chaque joueur en fonction de la taille assignée
  end;
end;

procedure InitPaquets(var paquetPieces, paquetArmes, paquetPersonnages : TPaquet);
var i : Integer;

begin
  SetLength(paquetArmes, 6);
  for i:=0 to Length(paquetArmes)-1 do
  begin
    paquetArmes[i]:=TCarte(i);
  end;

  // Crée le paquet des personnages
  SetLength(paquetPersonnages, 6);
  for i:=0 to length(paquetPersonnages)-1 do
  begin
    paquetPersonnages[i]:=TCarte(i+length(paquetArmes));
  end;

  // Crée le paquet des pièces
  SetLength(paquetPieces, 9);
  for i:=0 to length(paquetPieces)-1 do
  begin
    paquetPieces[i]:=TCarte(i+length(paquetArmes)+length(paquetPersonnages));
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
  randomIndex:=Random(6);
  // ensuite on l'associe à la première carte solution
  solution[0]:=paquetArmes[randomIndex];
  // on fait de même pour les armes et personnages
  randomIndex:=Random(6);
  solution[1]:=paquetPersonnages[randomIndex];
  randomIndex:=Random(9);
  solution[2]:=paquetPieces[randomIndex];

  SetLength(paquetSansCartesCrime, 18);
  indexPaquet:=0;

  // Rempli le paquet sans les cartes sélectionnées pour la solution
  for i:=0 to 5 do
  begin
    // Si la carte n'est pas dans la solution, elle est ajoutée à paquetSansCartesCrime
    if (paquetArmes[i]<>solution[0]) then
    begin
      paquetSansCartesCrime[indexPaquet]:=paquetArmes[i];
      indexPaquet:=indexPaquet+1;
    end;
  end;

  for i:=0 to 5 do
  begin  
    if (paquetPersonnages[i]<>solution[1]) then
    begin
      paquetSansCartesCrime[indexPaquet]:=paquetPersonnages[i];
      indexPaquet:=indexPaquet+1;
    end;
  end;

  for i:=0 to 8 do
  begin  
    if (paquetPieces[i]<>solution[2]) then
    begin
      paquetSansCartesCrime[indexPaquet]:=paquetPieces[i];
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
  for i:=17 downto 0 do
  begin
    // Prend au hasard un indice entre 0 et i
    j:=Random(i);
    // Echange les cartes d'indice i avec celles d'indice j (temp sert de stock, comme on a vu en I1)
    temp:=paquetSansCartesCrime[i];
    paquetSansCartesCrime[i]:=paquetSansCartesCrime[j];
    paquetSansCartesCrime[j]:=temp;
  end;
end;

procedure distributionCartesJoueurs(paquetSansCartesCrime: TPaquet ; var joueurs: TJoueurs);
var i, j, indexPaquet : Integer;

begin
  indexPaquet := 0;
  // Distribution des cartes en respectant les règles de répartition (et c'est juste ça qui m'a pris des semaines)
  for i := 0 to length(joueurs) - 1 do
  begin
    // Rempli les cartes pour le joueur i
    for j := 0 to length(joueurs[i].main) - 1 do
    begin
      joueurs[i].main[j] := paquetSansCartesCrime[indexPaquet];
      indexPaquet := indexPaquet + 1;
    end;
  end;
end;

procedure initialisationPartie(Renderer : PSDL_Renderer ; pieces : TPieces ; joueurs : TJoueurs ; joueurActuel: Integer ; var paquetPieces, paquetArmes, paquetPersonnages, solution, paquetSansCartesCrime : TPaquet);
begin
  InitPieces(Renderer, pieces);
  InitCharacters(joueurs, joueurActuel);
  InitPaquets(paquetPieces, paquetArmes, paquetPersonnages);
  selectionCartesCrime(paquetPieces, paquetArmes, paquetPersonnages, solution, paquetSansCartesCrime );
  melangerPaquet(paquetSansCartesCrime);
  distributionCartesJoueurs(paquetSansCartesCrime, joueurs);
end;

// Fonction pour lancer les dés
procedure LancerDes(Renderer: PSDL_Renderer; DiceTextures: TabTextures; var ResultatsDice: TTabInt);

begin
  Randomize;
  SetLength(ResultatsDice,2);
  ResultatsDice[0] := Random(6); // Résultat du premier dé
  ResultatsDice[1] := Random(6); // Résultat du second dé
  afficherDes(Renderer, DiceTextures, ResultatsDice);
end;

function estDansPiece(pieces : TPieces ; xJ, yJ : Integer) : Boolean;
var i : Integer;
    valide : Boolean;

begin
  valide:=False;
  for i:=0 to 8 do
    if (xJ>=pieces[i].x) and (xJ<=pieces[i].x+pieces[i].w-1) and (yJ>=pieces[i].y) and (yJ<=pieces[i].y+pieces[i].h-1) then
    begin
      valide := True;
      break;
    end;
  estDansPiece := valide;
end;

function quellePiece(pieces : TPieces ; xJ, yJ : Integer) : TPiece;
var i : Integer ;

begin
  for i:=0 to 8 do
    if (xJ>=pieces[i].x) and (xJ<=pieces[i].x+pieces[i].w-1) and (yJ>=pieces[i].y) and (yJ<=pieces[i].y+pieces[i].h-1) then
    begin
      quellePiece:=pieces[i]
    end;
end;

function TPieceToTCarte(piece: TNomPiece): TCarte;
begin
  case piece of
    Tillion : TPieceToTCarte := TCarte(12);
    Labo : TPieceToTCarte := TCarte(13);
    Gym : TPieceToTCarte := TCarte(14);
    Parking_visiteurs : TPieceToTCarte := TCarte(15);
    Self : TPieceToTCarte := TCarte(16);
    INSA_Shop : TPieceToTCarte := TCarte(17);
    Biblio : TPieceToTCarte := TCarte(18);
    Inf : TPieceToTCarte := TCarte(19);
    Chambre : TPieceToTCarte := TCarte(20);
  end;
end;

function choixCarte(Renderer: PSDL_Renderer; message: String; paquet : TPaquet) : TCarte;
var  i: Integer;
    DestRect: array [0..8] of TSDL_Rect;
    Event: TSDL_Event;
    MouseX, MouseY: Integer;
    IsRunning: Boolean;
begin
  IsRunning := True;
  while IsRunning do
  begin
    // Affichage du message
    afficherTexte(Renderer, message, 30, SCREEN_WIDTH - 500, 50, Couleur(163, 3, 3, 255));
    // Affichage des cartes
    for i := 0 to length(paquet) - 1 do
    begin
      DestRect[i] := coordonnees((i mod 3) * 205 + SCREEN_WIDTH - 650, (i div 3) * 285 + 135, 200, 280);
      afficherImage(Renderer, 'cartes/' + GetEnumName(TypeInfo(TCarte), Ord(paquet[i])), @DestRect[i]);
    end;

    SDL_RenderPresent(Renderer); // Affiche le rendu

    // Gestion des événements
    while SDL_PollEvent(@Event) <> 0 do
    begin
      case Event.type_ of
        SDL_MOUSEBUTTONDOWN:
          begin
            MouseX := Event.button.x;
            MouseY := Event.button.y;
            for i := 0 to length(paquet) - 1 do
            begin
              if (MouseX >= DestRect[i].x) and (MouseX <= DestRect[i].x + DestRect[i].w) and
                 (MouseY >= DestRect[i].y) and (MouseY <= DestRect[i].y + DestRect[i].h) then
              begin
                choixCarte := paquet[i];
                writeln(choixCarte);
                IsRunning := False;
                Break;
              end;
            end;
          end;
        SDL_QUITEV: Halt;
      end;
    end;
  end;
end;

procedure choixCartes(Renderer: PSDL_Renderer; joueurs: TJoueurs; ResultatsDice: TTabInt; DiceTextures: TabTextures; nbDeplacement, joueurActuel, x, y: Integer; pieces: TPieces; paquetArmes, paquetPersonnages : TPaquet ; var cartesChoisies: TPaquet; var temoinChoisi: Integer);
var
  i, j: Integer;
  JoueursRect: array[0..8] of TSDL_Rect;
  Event: TSDL_Event;
  MouseX, MouseY: Integer;
  IsRunning: Boolean;
  cartesSuspects, cartesArmes: array[0..5] of TCarte;
begin
  IsRunning := True; // Initialisation de IsRunning
  temoinChoisi := -1; // Aucun témoin sélectionné au début
  SetLength(cartesChoisies, 3);

  SDL_RenderClear(Renderer);
  afficherTour(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, joueurActuel);

  // Sélection du témoin
  if Length(joueurs) = 2 then
    temoinChoisi := (joueurActuel + 1) mod 2
  else if Length(joueurs) > 2 then
  begin
    while IsRunning do
    begin
      afficherTexte(Renderer, 'Choisissez un témoin :', 30, SCREEN_WIDTH - 500, 50, Couleur(163, 3, 3, 255));

      j := 0;
      for i := 0 to Length(joueurs) - 1 do
      begin
        if i <> joueurActuel then
        begin
          JoueursRect[i] := coordonnees((j mod 3) * 205 + SCREEN_WIDTH - 650, (j div 3) * 285 + 135, 200, 280);
          afficherImage(Renderer, GetEnumName(TypeInfo(TPersonnage), Ord(joueurs[i].nom)), @JoueursRect[i]);
          j := j + 1;
        end;
      end;

      SDL_RenderPresent(Renderer); // Affiche le rendu

      // Gestion des événements
      while SDL_PollEvent(@Event) <> 0 do
      begin
        case Event.type_ of
          SDL_MOUSEBUTTONDOWN:
            begin
              MouseX := Event.button.x;
              MouseY := Event.button.y;
              for i := 0 to Length(joueurs) - 1 do
              begin
                if (MouseX >= JoueursRect[i].x) and (MouseX <= JoueursRect[i].x + JoueursRect[i].w) and
                   (MouseY >= JoueursRect[i].y) and (MouseY <= JoueursRect[i].y + JoueursRect[i].h) then
                begin
                  temoinChoisi := i;
                  IsRunning := False;
                  Break;
                end;
              end;
            end;
          SDL_QUITEV: Halt;
        end;
      end;
    end;
  end;

  SDL_RenderClear(Renderer);
  afficherTour(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, joueurActuel);

  cartesChoisies[0] := choixCarte(Renderer, 'Choisissez un suspect :', paquetPersonnages);

  SDL_RenderClear(Renderer);
  afficherTour(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, joueurActuel);

  cartesChoisies[1] := choixCarte(Renderer, 'Choisissez une arme :', paquetArmes);

  // Sélection de la pièce
  cartesChoisies[2] := TPieceToTCarte(quellePiece(pieces, x, y).nom);
end;

function comparaisonCartes(compare, comparant : TPaquet) : TPaquet;
var cartesCommunes : TPaquet;
    i, j, indexPaquet : Integer;
    DestRect : TSDL_Rect;

begin
  SetLength(cartesCommunes, 0);
  indexPaquet := 0;
  for i:=0 to length(compare) - 1 do
    for j:=0 to length(comparant) - 1 do
      if compare[i] = comparant[j] then
        begin
          SetLength(cartesCommunes,indexPaquet+1);
          cartesCommunes[indexPaquet]:=compare[i];
          indexPaquet:=indexPaquet+1;
        end;
  writeln('Cartes communes :');
  if Length(cartesCommunes)>0 then
    for i:=0 to length(cartesCommunes) - 1 do
      writeln(cartesCommunes[i]);
  comparaisonCartes:=cartesCommunes;
end;

function recupererCarteJoueur(Renderer : PSDL_Renderer ; compare, comparant : TPaquet ; ResultatsDice : TTabInt ; DiceTextures : TabTextures ; joueurs : TJoueurs ; nbDeplacement, joueurActuel, temoinChoisi : Integer) : TCarte;
var cartesCommunes : TPaquet;
    DestRect : TSDL_Rect;

begin
  SDL_RenderClear(Renderer);
  cartesCommunes := comparaisonCartes(compare,comparant);
  if length(cartesCommunes) = 0 then
  begin
    DestRect := coordonnees(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    afficherImage(Renderer, 'fond', @DestRect);
    afficherTexte(Renderer, 'Aucune carte commune', 70, SCREEN_WIDTH div 2 - 300, SCREEN_HEIGHT div 2, Couleur(163, 3, 3, 255));
    SDL_RenderPresent(Renderer);
    SDL_Delay(2000); 
  end
  else   
  begin
    preventionJoueur(Renderer, joueurs, temoinChoisi, 'Tu dois montrer une carte à ' + GetEnumName(TypeInfo(TPersonnage), Ord(joueurs[joueurActuel].nom)));
    afficherTour(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, temoinChoisi);
    recupererCarteJoueur := choixCarte(Renderer, 'Choisissez une carte à montrer', cartesCommunes);
  end;
end;

procedure hypothese(Renderer : PSDL_Renderer ; joueurs : TJoueurs ; ResultatsDice : TTabInt ; DiceTextures : TabTextures ; nbDeplacement, joueurActuel, x, y : Integer ; pieces : TPieces ; paquetArmes, paquetPersonnages : TPaquet);
var cartesChoisies, cartesCommunes : TPaquet;
    temoinChoisi : Integer;
    carteChoisie : TCarte;
    DestRect : TSDL_Rect;
begin
  SDL_RenderClear(Renderer);
  choixCartes(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, joueurActuel, x, y, pieces, paquetArmes, paquetPersonnages, cartesChoisies, temoinChoisi);
  cartesCommunes := comparaisonCartes(cartesChoisies, joueurs[temoinChoisi].main);
  carteChoisie := recupererCarteJoueur(Renderer, cartesChoisies, joueurs[temoinChoisi].main, ResultatsDice, DiceTextures, joueurs, nbDeplacement, joueurActuel, temoinChoisi);
  if length(cartesCommunes) <> 0 then
  begin
    SDL_RenderClear(Renderer);
    preventionJoueur(Renderer, joueurs, joueurActuel, 'C''est à toi de regarder l''écran');
    afficherTour(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, joueurActuel);
    afficherTexte(Renderer, 'Voici la carte du témoin', 30, SCREEN_WIDTH - 500, 350, Couleur(163, 3, 3, 255));
    DestRect := coordonnees(SCREEN_WIDTH - 445, 405, 200, 280);
    afficherImage(Renderer, 'cartes/' + GetEnumName(TypeInfo(TCarte), Ord(carteChoisie)), @DestRect);
    SDL_RenderPresent(Renderer);
    SDL_Delay(2000);
  end;
end;

function accusation(Renderer : PSDL_Renderer ; joueurs : TJoueurs ; ResultatsDice : TTabInt ; DiceTextures : TabTextures ; nbDeplacement, joueurActuel, x, y : Integer ; paquetPersonnages, paquetArmes, paquetPieces, solution : TPaquet ; pieces : TPieces): Boolean;
var cartesChoisies, cartesCommunes : TPaquet;
begin
  SDL_RenderClear(Renderer);
  afficherTour(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, joueurActuel);

  SetLength(cartesChoisies, 3);
  cartesChoisies[0] := choixCarte(Renderer, 'Choisissez un suspect :', paquetPersonnages);

  SDL_RenderClear(Renderer);
  afficherTour(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, joueurActuel);

  cartesChoisies[1] := choixCarte(Renderer, 'Choisissez une arme :', paquetArmes);

  SDL_RenderClear(Renderer);
  afficherTour(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, joueurActuel);

  cartesChoisies[2] := choixCarte(Renderer, 'Choisissez une pièce :', paquetPieces);

  cartesCommunes := comparaisonCartes(cartesChoisies, solution);
  if length(cartesCommunes)=3 then
    accusation:=True
  else
    accusation:=False;
end;

procedure choixActionCouloir(Renderer : PSDL_Renderer ; var joueurActuel : Integer ; nbDeplacement, x, y : Integer ; paquetPersonnages, paquetArmes, paquetPieces, solution : TPaquet ; pieces : TPieces; joueurs : TJoueurs);
var IsRunning, victoire : Boolean;
    CurrentSelection : Integer;
    Event : TSDL_Event;
    DestRect : TSDL_Rect;
    ResultatsDice : TTabInt;
    DiceTextures : TabTextures;

begin
  IsRunning:=True;
  CurrentSelection := 0;

  while IsRunning do
  begin
    SDL_RenderClear(Renderer);
    afficherTour(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, joueurActuel);

    afficherTexte(Renderer, 'Voulez-vous formuler une accusation ?', 35, SCREEN_WIDTH - 800, 305, Couleur(163, 3, 3, 255));

    if CurrentSelection = 0 then
      afficherTexte(Renderer, 'Oui', 50, SCREEN_WIDTH - 600, 365, Couleur(163, 3, 3, 0))
    else
      afficherTexte(Renderer, 'Oui', 45, SCREEN_WIDTH - 600, 365, Couleur(0, 0, 0, 0));

    if CurrentSelection = 1 then
      afficherTexte(Renderer, 'Non', 50, SCREEN_WIDTH - 600, 425, Couleur(163, 3, 3, 0))
    else
      afficherTexte(Renderer, 'Non', 45, SCREEN_WIDTH - 600, 425, Couleur(0, 0, 0, 0));

    SDL_RenderPresent(Renderer);

    while SDL_PollEvent(@Event) <> 0 do
    begin
      if Event.type_ = SDL_QUITEV then
      begin
        IsRunning := False;
        Halt;
      end
      else if Event.type_ = SDL_KEYDOWN then
      begin
        case Event.key.keysym.sym of
          SDLK_UP:
            if CurrentSelection = 1 then
              Dec(CurrentSelection);
          SDLK_DOWN:
            if CurrentSelection = 0 then
              Inc(CurrentSelection);
          SDLK_RETURN:
            case CurrentSelection of
              0: begin
                  victoire := accusation(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, joueurActuel, x, y, paquetPersonnages, paquetArmes, paquetPieces, solution, pieces);
                  if (victoire = true) then
                  begin
                    affichageVictoire(Renderer);
                    DestRect := coordonnees(SCREEN_WIDTH div 2 - 250 , SCREEN_HEIGHT div 2 - 300, 500, 700);
                    afficherImage(Renderer, GetEnumName(TypeInfo(TPersonnage), Ord(joueurs[joueurActuel].nom)), @DestRect);
                    SDL_RenderPresent(Renderer);
                    SDL_Delay(5000);
                    Halt;
                  end
                  else
                  begin 
                    affichageVictoire(Renderer);                   
                    SDL_RenderPresent(Renderer);
                    SDL_Delay(5000);
                    Halt;
                  end;
                 end;
              1: begin
                  IsRunning := False;
                 end;
            end;
        end;
      end;
    end;
  end;
  joueurActuel := (joueurActuel + 1) mod length(joueurs);
  preventionJoueur(Renderer, joueurs, joueurActuel, 'C''est à toi de jouer !');
end;  

procedure choixActionPiece(Renderer : PSDL_Renderer ; var joueurActuel : Integer ; nbDeplacement, x, y : Integer ; pieces : TPieces ; joueurs : TJoueurs ; paquetArmes, paquetPersonnages, paquetPieces, solution : TPaquet ; var cartesCommunes : TPaquet);
var IsRunning, victoire : Boolean;
    CurrentSelection, i : Integer;
    Event : TSDL_Event;
    ResultatsDice : TTabInt;
    DiceTextures : TabTextures;
    cartesChoisies : TPaquet;
    temoinChoisi : Integer;
    DestRect : TSDL_Rect;
    carteChoisie : TCarte;

begin
  IsRunning:=True;
  CurrentSelection:=0;

  while IsRunning do
  begin
    SDL_RenderClear(Renderer);
    afficherTour(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, joueurActuel);

    afficherTexte(Renderer, 'Que voulez-vous faire ?', 40, SCREEN_WIDTH - 800, 305, Couleur(163, 3, 3, 0));

    if CurrentSelection = 0 then
      afficherTexte(Renderer, '1. Formuler une hypothèse', 30, SCREEN_WIDTH - 800, 365, Couleur(163, 3, 3, 0))
    else
      afficherTexte(Renderer, '1. Formuler une hyptohèse', 25, SCREEN_WIDTH - 800, 365, Couleur(0, 0, 0, 0));

    if CurrentSelection = 1 then
      afficherTexte(Renderer, '2. Formuler une accusation', 30, SCREEN_WIDTH - 800, 405, Couleur(163, 3, 3, 0))
    else
      afficherTexte(Renderer, '2. Formuler une accusation', 25, SCREEN_WIDTH - 800, 405, Couleur(0, 0, 0, 0));

      if CurrentSelection = 2 then
      afficherTexte(Renderer, '3. Rien', 30, SCREEN_WIDTH - 800, 445, Couleur(163, 3, 3, 0))
    else
      afficherTexte(Renderer, '3. Rien', 25, SCREEN_WIDTH - 800, 445, Couleur(0, 0, 0, 0));

    SDL_RenderPresent(Renderer);

    while SDL_PollEvent(@Event) <> 0 do
    begin
      if Event.type_ = SDL_QUITEV then
      begin
        IsRunning := False;
        Halt;
      end
      else if Event.type_ = SDL_KEYDOWN then
      begin
        case Event.key.keysym.sym of
          SDLK_UP:
            if CurrentSelection > 0 then
              Dec(CurrentSelection);
          SDLK_DOWN:
            if CurrentSelection < 2 then
              Inc(CurrentSelection);
          SDLK_RETURN:
            case CurrentSelection of
              0: begin
                  hypothese(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, joueurActuel, x, y, pieces, paquetArmes, paquetPersonnages);
                  IsRunning:=False;
                 end;
              1: begin
                  victoire := accusation(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, joueurActuel, x, y, paquetPersonnages, paquetArmes, paquetPieces, solution, pieces);
                  write(victoire);
                  if (victoire = true) then
                  begin
                    affichageVictoire(Renderer);
                    DestRect := coordonnees(SCREEN_WIDTH div 2 - 250 , SCREEN_HEIGHT div 2 - 300, 500, 700);
                    afficherImage(Renderer, GetEnumName(TypeInfo(TPersonnage), Ord(joueurs[joueurActuel].nom)), @DestRect);
                    SDL_RenderPresent(Renderer);
                    SDL_Delay(5000);
                    Halt;
                  end
                  else
                  begin 
                    affichageVictoire(Renderer);                   
                    SDL_RenderPresent(Renderer);
                    SDL_Delay(5000);
                    Halt;
                  end;
                 end;
              2: begin
                  IsRunning := False;
                 end;
            end;
        end;
      end;
    end;
  end;
  joueurActuel := (joueurActuel + 1) mod length(joueurs);
  preventionJoueur(Renderer, joueurs, joueurActuel, 'C''est à toi de jouer !');
end;

procedure gestionTour(Renderer : PSDL_Renderer ; pieces : TPieces ;  paquetArmes, paquetPersonnages, paquetPieces, solution : TPaquet ; var joueurs: TJoueurs; var joueurActuel: Integer; var ResultatsDice : TTabInt; var nbDeplacement: Integer);
var
  NewX, NewY, i, j: Integer;
  caseActuelle: Integer;
  Event: TSDL_Event;
  DiceTextures : TabTextures;
  cartesChoisies : TPaquet;
  carte : TCarte;
  IsRunning : Boolean;
  JoueursRect : array of TSDL_Rect;
  cartesCommunes : TPaquet;

begin
  while SDL_PollEvent(@Event) <> 0 do
  begin
    case Event.type_ of
      SDL_QUITEV: Halt;
      SDL_KEYDOWN:
        begin
          NewX := joueurs[joueurActuel].x;
          NewY := joueurs[joueurActuel].y;
          caseActuelle := GRID[joueurs[joueurActuel].y, joueurs[joueurActuel].x];
          case Event.key.keysym.sym of
            SDLK_UP: if not (caseActuelle in [1, 3, 5, 9]) and (nbDeplacement>0) then
            begin
              if not (estDansPiece(pieces,newX,newY) and estDansPiece(pieces,newX,newY-1)) then
                Dec(nbDeplacement);
              Dec(NewY);
              joueurs[joueurActuel].y := NewY;
              if not (estDansPiece(pieces, newX, newY+1)) and (estDansPiece(pieces, newX, newY)) then
              begin
                nbDeplacement:=0;
                choixActionPiece(Renderer, joueurActuel, nbDeplacement, joueurs[joueurActuel].x, joueurs[joueurActuel].y, pieces, joueurs, paquetArmes, paquetPersonnages, paquetPieces, solution,cartesCommunes);
              end
              else if not (estDansPiece(pieces, newX, newY)) and (nbDeplacement=0) then
                choixActionCouloir(Renderer, joueurActuel, nbDeplacement, NewX, NewY, paquetPersonnages, paquetArmes, paquetPieces, solution, pieces, joueurs);
            end;
            SDLK_RIGHT: if not (caseActuelle in [2, 3, 6, 10]) and (nbDeplacement>0) then
            begin
              if not (estDansPiece(pieces,newX,newY) and estDansPiece(pieces,newX+1,newY)) then
                Dec(nbDeplacement);
              Inc(NewX);
              joueurs[joueurActuel].X := NewX;
              if not (estDansPiece(pieces, newX-1, newY)) and (estDansPiece(pieces, newX, newY)) then
              begin
                nbDeplacement:=0;
                choixActionPiece(Renderer, joueurActuel, nbDeplacement, joueurs[joueurActuel].x, joueurs[joueurActuel].y, pieces, joueurs, paquetArmes, paquetPersonnages, paquetPieces, solution, cartesCommunes);
              end
              else if not (estDansPiece(pieces, newX, newY)) and (nbDeplacement=0) then
              begin
                choixActionCouloir(Renderer, joueurActuel, nbDeplacement, NewX, NewY, paquetPersonnages, paquetArmes, paquetPieces, solution, pieces, joueurs);
              end;
            end;
            SDLK_DOWN: if not (caseActuelle in [4, 5, 6, 12]) and (nbDeplacement>0) then
            begin
              if not (estDansPiece(pieces,newX,newY) and estDansPiece(pieces,newX,newY+1)) then
                Dec(nbDeplacement);
              Inc(NewY);
              joueurs[joueurActuel].y := NewY;
              if not (estDansPiece(pieces, newX, newY-1)) and (estDansPiece(pieces, newX, newY)) then
              begin
                nbDeplacement:=0;
                choixActionPiece(Renderer, joueurActuel, nbDeplacement, joueurs[joueurActuel].x, joueurs[joueurActuel].y, pieces, joueurs, paquetArmes, paquetPersonnages, paquetPieces, solution, cartesCommunes);
              end
              else if not (estDansPiece(pieces, newX, newY)) and (nbDeplacement=0) then
              begin
                choixActionCouloir(Renderer, joueurActuel, nbDeplacement, NewX, NewY, paquetPersonnages, paquetArmes, paquetPieces, solution, pieces, joueurs);
              end;
            end;
            SDLK_LEFT: if not (caseActuelle in [8, 9, 10, 12]) and (nbDeplacement>0) then
            begin
              if not (estDansPiece(pieces,newX,newY) and estDansPiece(pieces,newX-1,newY)) then
                Dec(nbDeplacement);
              Dec(NewX);
              joueurs[joueurActuel].x := NewX;
              if not (estDansPiece(pieces, newX+1, newY)) and (estDansPiece(pieces, newX, newY)) then
              begin
                nbDeplacement:=0;
                choixActionPiece(Renderer, joueurActuel, nbDeplacement, joueurs[joueurActuel].x, joueurs[joueurActuel].y, pieces, joueurs, paquetArmes, paquetPersonnages, paquetPieces, solution, cartesCommunes);
              end
              else if not (estDansPiece(pieces, newX, newY)) and (nbDeplacement=0) then
              begin
                choixActionCouloir(Renderer, joueurActuel, nbDeplacement, NewX, NewY, paquetPersonnages, paquetArmes, paquetPieces, solution, pieces, joueurs);
              end;
            end;
            SDLK_RETURN :
            begin
              LancerDes(Renderer, DiceTextures, ResultatsDice); // Relancer les dés pour le joueur suivant
              nbDeplacement := ResultatsDice[0] + ResultatsDice[1] + 2;
            end;
          end;      
        end;
    end;
  end;
end;

end.