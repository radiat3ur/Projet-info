unit gestion;

interface

uses SDL2, SDL2_Mixer, TypeEtCte, affichage, audio, sysUtils, TypInfo;

procedure cliqueSuivant();
procedure menu(Renderer: PSDL_Renderer ; musico : PMix_Music);
procedure choixNbJoueurs(Renderer: PSDL_Renderer; var joueurs: TJoueurs);
procedure selectionJoueurs(Renderer: PSDL_Renderer; var joueurs: TJoueurs);
function creerPiece(x,y,w,h:Integer;nom:TNomPiece):TPiece;
procedure initPieces(Renderer : PSDL_Renderer ; var pieces : TPieces);
procedure initJoueurs(var joueurs: TJoueurs; var joueurActuel: Integer);
procedure initPaquets(var paquetPieces, paquetArmes, paquetPersonnages : TPaquet);
procedure selectionCartesCrime(paquetPieces, paquetArmes, paquetPersonnages : TPaquet; var solution, paquetSansCartesCrime : TPaquet);
procedure melangerPaquet(var paquetSansCartesCrime : TPaquet);
procedure distributionCartesJoueurs(paquetSansCartesCrime: TPaquet ; var joueurs: TJoueurs);
procedure initPartie(Renderer : PSDL_Renderer ; pieces : TPieces ; joueurs : TJoueurs ; joueurActuel: Integer ; var paquetPieces, paquetArmes, paquetPersonnages, solution, paquetSansCartesCrime : TPaquet);
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

procedure cliqueSuivant();
var Event: TSDL_Event;
    lecture : Boolean;
begin
  lecture := True;
  while lecture do
  begin
    while SDL_PollEvent(@Event) <> 0 do
    begin
      if Event.type_ = SDL_KEYDOWN then
        if Event.key.keysym.sym = SDLK_RETURN then
          lecture := False
      else if Event.type_ = SDL_QUITEV then
        Halt;
    end;
  end;
end;

procedure menu(Renderer: PSDL_Renderer ; musico : PMix_Music);
var Event : TSDL_Event;
    selectionActuelle: Integer;
    IsRunning : Boolean;
    DestRect : TSDL_Rect;
begin
  selectionActuelle := 0;
  IsRunning := True;
  
  while IsRunning do
  begin
    affichageMenu(Renderer, selectionActuelle);

    while SDL_PollEvent(@Event) <> 0 do
    begin
      if Event.type_ = SDL_QUITEV then
        IsRunning := False
      else if Event.type_ = SDL_KEYDOWN then
        case Event.key.keysym.sym of
          SDLK_UP:
            if selectionActuelle > 0 then
              Dec(selectionActuelle);
          SDLK_DOWN:
            if selectionActuelle < 2 then
              Inc(selectionActuelle);
          SDLK_RETURN:
            case selectionActuelle of
              0: begin
                  affichageRegles(Renderer);
                  cliqueSuivant();
                  afficherImage(Renderer, 'menu', @DestRect);
                 end;
              1: begin
                  affichageNarration(Renderer);
                  //lancerMusique(musico);
                  cliqueSuivant();
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

procedure choixNbJoueurs(Renderer: PSDL_Renderer; var joueurs: TJoueurs);
var Event: TSDL_Event;
    IsRunning: Boolean;
    DestRect : TSDL_Rect;
begin
  IsRunning := True;
  Setlength(joueurs, 2);

  DestRect := coordonnees(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
  
  while IsRunning do
  begin
    SDL_RenderClear(Renderer);

    afficherImage(Renderer, 'choixNbJoueurs', @DestRect);

    afficherTexte(Renderer, IntToStr(length(joueurs)), 180, SCREEN_WIDTH div 2 - 50, 513, Couleur(163, 3, 3, 255));

    SDL_RenderPresent(Renderer);

    while SDL_PollEvent(@Event) = 1 do
    begin
      if Event.type_ = SDL_KEYDOWN then
      case Event.key.keysym.sym of
        SDLK_UP: if length(joueurs) < 6 then Setlength(joueurs, length(joueurs)+1);
        SDLK_DOWN: if length(joueurs) > 2 then Setlength(joueurs, length(joueurs)-1);
        SDLK_RETURN: IsRunning := False;
      end;
      if event.type_ = SDL_QUITEV then
        Halt;
    end;
  end;
  Setlength(joueurs, length(joueurs));
end;

procedure selectionJoueurs(Renderer: PSDL_Renderer; var joueurs: TJoueurs);
var Event: TSDL_Event;
  IsRunning: Boolean;
  SelectedCount: Integer;
  JoueurRect: array[0..5] of TSDL_Rect;
  DestRect : TSDL_Rect;
  i, j: Integer;
  MouseX, MouseY: Integer;
  Selection: array[0..5] of Boolean;
  sdlRect1: TSDL_Rect;
begin
  IsRunning := True;
  SelectedCount := 0;
  for i := 0 to 5 do
    Selection[i] := False;

  for i := 0 to 5 do
    JoueurRect[i] := coordonnees((i mod 3) * 300 + 535, (i div 3) * 400 + 235, 250, 350);

  for i := 0 to length(joueurs) - 1 do
    joueurs[i].nom := rien;
  
  DestRect := coordonnees(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

  while IsRunning do
  begin
    SDL_RenderClear(Renderer);

    afficherImage(Renderer, 'selection joueurs', @DestRect);

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
                  if SelectedCount < length(joueurs) then
                  begin
                    Selection[i] := True;
                    joueurs[SelectedCount].nom := TPersonnage(i); // Ajouter le joueur sélectionné
                    Inc(SelectedCount);
                    for j := 0 to 5 do
                    begin
                      if Selection[j] then
                      begin
                        sdlRect1 := coordonnees(JoueurRect[j].x, JoueurRect[j].y, JoueurRect[j].w, JoueurRect[j].h);
                        SDL_SetRenderDrawColor(Renderer, 105, 105, 105, 255);
                        SDL_RenderFillRect(Renderer, @sdlRect1);
                        SDL_RenderDrawRect(Renderer, @sdlRect1);
                      end;
                    end;

                    // Afficher les images des joueurs
                    for j := 0 to 5 do
                      afficherImage(Renderer, GetEnumName(TypeInfo(TPersonnage), Ord(TPersonnage(j))), @JoueurRect[j]);
                    lancerAudio('Presentation ' + GetEnumName(TypeInfo(TPersonnage), ord(joueurs[SelectedCount-1].nom)), 4000);
                  end;
                end;
              end;
            end;
            if SelectedCount = length(joueurs) then
              IsRunning := False;
          end;
        SDL_QUITEV: Halt;
      end;
    end;

    for i := 0 to 5 do
    begin
      if Selection[i] then
      begin
        sdlRect1 := coordonnees(JoueurRect[i].x, JoueurRect[i].y, JoueurRect[i].w, JoueurRect[i].h);
        SDL_SetRenderDrawColor(Renderer, 105, 105, 105, 255);
        SDL_RenderFillRect(Renderer, @sdlRect1);
        SDL_RenderDrawRect(Renderer, @sdlRect1);
      end;
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

procedure initPieces(Renderer : PSDL_Renderer ; var pieces : TPieces);
begin
  Setlength(Pieces,9);
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

procedure initJoueurs(var joueurs: TJoueurs; var joueurActuel: Integer);
var
  i, cartesParJoueur, joueursAvecNbCartesStandard: Integer;
begin
  for i := 0 to length(joueurs) - 1 do
  begin
    joueurs[i].x := positionsInitX[Ord(joueurs[i].nom)];
    joueurs[i].y := positionsInitY[Ord(joueurs[i].nom)];
  end;

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
          Setlength(joueurs[i].main, cartesParJoueur) // Donne le nombre classique de cartes aux deuxpremiers joueurs
      else
          Setlength(joueurs[i].main, cartesParJoueur+1); // Les joueurs suivants reçoivent une carte supplémentaire
      // Initialise la liste des cartes pour chaque joueur en fonction de la taille assignée
  end;

  joueurActuel := 0;
end;

procedure initPaquets(var paquetPieces, paquetArmes, paquetPersonnages : TPaquet);
var i : Integer;

begin
  // Crée le paquet d'arme
  Setlength(paquetArmes, 6);
  for i:=0 to length(paquetArmes)-1 do
  begin
    paquetArmes[i]:=TCarte(i);
  end;

  // Crée le paquet de personnages
  Setlength(paquetPersonnages, 6);
  for i:=0 to length(paquetPersonnages)-1 do
  begin
    paquetPersonnages[i]:=TCarte(i+length(paquetArmes));
  end;

  // Crée le paquet de pièces
  Setlength(paquetPieces, 9);
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
  Setlength(solution, 3);

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

  Setlength(paquetSansCartesCrime, 18);
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

procedure initPartie(Renderer : PSDL_Renderer ; pieces : TPieces ; joueurs : TJoueurs ; joueurActuel: Integer ; var paquetPieces, paquetArmes, paquetPersonnages, solution, paquetSansCartesCrime : TPaquet);
begin
  initPieces(Renderer, pieces);
  initJoueurs(joueurs, joueurActuel);
  initPaquets(paquetPieces, paquetArmes, paquetPersonnages);
  selectionCartesCrime(paquetPieces, paquetArmes, paquetPersonnages, solution, paquetSansCartesCrime );
  melangerPaquet(paquetSansCartesCrime);
  distributionCartesJoueurs(paquetSansCartesCrime, joueurs);
end;

// Fonction pour lancer les dés
procedure LancerDes(Renderer: PSDL_Renderer; DiceTextures: TabTextures; var ResultatsDice: TTabInt);
begin
  Randomize;
  Setlength(ResultatsDice,2);
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
var i: Integer;
    DestRect: array [0..8] of TSDL_Rect;
    Event: TSDL_Event;
    MouseX, MouseY: Integer;
    IsRunning: Boolean;
begin
  IsRunning := True;
  while IsRunning do
  begin
    afficherTexte(Renderer, message, 30, SCREEN_WIDTH - 500, 50, Couleur(163, 3, 3, 255));

    for i := 0 to length(paquet) - 1 do
    begin
      DestRect[i] := coordonnees((i mod 3) * 205 + SCREEN_WIDTH - 650, (i div 3) * 285 + 135, 200, 280);
      afficherImage(Renderer, 'cartes/' + GetEnumName(TypeInfo(TCarte), Ord(paquet[i])), @DestRect[i]);
    end;

    SDL_RenderPresent(Renderer);

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
var i, j: Integer;
    JoueursRect: array[0..8] of TSDL_Rect;
    Event: TSDL_Event;
    MouseX, MouseY: Integer;
    IsRunning: Boolean;
begin
  IsRunning := True;
  temoinChoisi := -1; // Aucun témoin sélectionné au début
  Setlength(cartesChoisies, 3);

  SDL_RenderClear(Renderer);
  afficherTour(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, joueurActuel);

  if length(joueurs) = 2 then
    temoinChoisi := (joueurActuel + 1) mod 2
  else if length(joueurs) > 2 then
  begin
    while IsRunning do
    begin
      afficherTexte(Renderer, 'Choisissez un témoin :', 30, SCREEN_WIDTH - 500, 50, Couleur(163, 3, 3, 255));
      j := 0;
      for i := 0 to length(joueurs) - 1 do
      begin
        if i <> joueurActuel then
        begin
          JoueursRect[i] := coordonnees((j mod 3) * 205 + SCREEN_WIDTH - 650, (j div 3) * 285 + 135, 200, 280);
          afficherImage(Renderer, GetEnumName(TypeInfo(TPersonnage), Ord(joueurs[i].nom)), @JoueursRect[i]);
          j := j + 1;
        end;
      end;

      SDL_RenderPresent(Renderer);

      while SDL_PollEvent(@Event) <> 0 do
      begin
        case Event.type_ of
          SDL_MOUSEBUTTONDOWN:
            begin
              MouseX := Event.button.x;
              MouseY := Event.button.y;
              for i := 0 to length(joueurs) - 1 do
              begin
                if (MouseX >= JoueursRect[i].x) and (MouseX <= JoueursRect[i].x + JoueursRect[i].w) and
                   (MouseY >= JoueursRect[i].y) and (MouseY <= JoueursRect[i].y + JoueursRect[i].h) then
                begin
                  temoinChoisi := i;
                  IsRunning := False;
                  lancerAudio('Temoin ' + GetEnumName(TypeInfo(TPersonnage), ord(joueurs[temoinChoisi].nom)), 2000);
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
  lancerAudio(GetEnumName(TypeInfo(TCarte), Ord(cartesChoisies[0])), 2000);
  SDL_RenderClear(Renderer);
  afficherTour(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, joueurActuel);

  cartesChoisies[1] := choixCarte(Renderer, 'Choisissez une arme :', paquetArmes);
  lancerAudio(GetEnumName(TypeInfo(TCarte), Ord(cartesChoisies[1])), 2000);

  // Sélection de la pièce
  cartesChoisies[2] := TPieceToTCarte(quellePiece(pieces, x, y).nom);
  lancerAudio(GetEnumName(TypeInfo(TCarte), Ord(cartesChoisies[2])), 2000);
end;

function comparaisonCartes(compare, comparant : TPaquet) : TPaquet;
var cartesCommunes : TPaquet;
    i, j : Integer;

begin
  Setlength(cartesCommunes, 0);
  for i:=0 to length(compare) - 1 do
    for j:=0 to length(comparant) - 1 do
      if compare[i] = comparant[j] then
        begin
          Setlength(cartesCommunes,length(cartesCommunes)+1);
          cartesCommunes[length(cartesCommunes)-1]:=compare[i];
        end;
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
    lancerAudio('Temoin 0 carte', 3000);
    cliqueSuivant();
  end
  else   
  begin
    preventionJoueur(Renderer, joueurs, temoinChoisi, 'Tu dois montrer une carte à ' + GetEnumName(TypeInfo(TPersonnage), Ord(joueurs[joueurActuel].nom)));
    SDL_RenderPresent(Renderer);
    lancerAudio('Temoin regarde cartes', 3000);
    cliqueSuivant();
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
    SDL_RenderPresent(Renderer);
    lancerAudio('Enqueteur peut regarder', 3000);
    cliqueSuivant();
    afficherTour(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, joueurActuel);
    afficherTexte(Renderer, 'Voici la carte du témoin', 30, SCREEN_WIDTH - 500, 350, Couleur(163, 3, 3, 255));
    DestRect := coordonnees(SCREEN_WIDTH - 445, 405, 200, 280);
    afficherImage(Renderer, 'cartes/' + GetEnumName(TypeInfo(TCarte), Ord(carteChoisie)), @DestRect);
    SDL_RenderPresent(Renderer);
    cliqueSuivant();
  end;
end;

function accusation(Renderer : PSDL_Renderer ; joueurs : TJoueurs ; ResultatsDice : TTabInt ; DiceTextures : TabTextures ; nbDeplacement, joueurActuel, x, y : Integer ; paquetPersonnages, paquetArmes, paquetPieces, solution : TPaquet ; pieces : TPieces): Boolean;
var cartesChoisies, cartesCommunes : TPaquet;
begin
  SDL_RenderClear(Renderer);
  afficherTour(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, joueurActuel);

  Setlength(cartesChoisies, 3);
  cartesChoisies[0] := choixCarte(Renderer, 'Choisissez un suspect :', paquetPersonnages);
  lancerAudio(GetEnumName(TypeInfo(TCarte), Ord(cartesChoisies[0])), 2000);

  SDL_RenderClear(Renderer);
  afficherTour(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, joueurActuel);

  cartesChoisies[1] := choixCarte(Renderer, 'Choisissez une arme :', paquetArmes);
  lancerAudio(GetEnumName(TypeInfo(TCarte), Ord(cartesChoisies[1])), 2000);

  SDL_RenderClear(Renderer);
  afficherTour(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, joueurActuel);

  cartesChoisies[2] := choixCarte(Renderer, 'Choisissez une pièce :', paquetPieces);
  lancerAudio(GetEnumName(TypeInfo(TCarte), Ord(cartesChoisies[2])), 2000);

  cartesCommunes := comparaisonCartes(cartesChoisies, solution);
  if length(cartesCommunes)=3 then
    accusation:=True
  else
    accusation:=False;
end;

procedure choixActionCouloir(Renderer : PSDL_Renderer ; var joueurActuel : Integer ; nbDeplacement, x, y : Integer ; paquetPersonnages, paquetArmes, paquetPieces, solution : TPaquet ; pieces : TPieces; joueurs : TJoueurs);
var IsRunning, victoire : Boolean;
    selectionActuelle : Integer;
    Event : TSDL_Event;
    DestRect : TSDL_Rect;
    ResultatsDice : TTabInt;
    DiceTextures : TabTextures;
    joueurRect: TSDL_Rect;

begin
  IsRunning:=True;
  selectionActuelle := 0;

  while IsRunning do
  begin
  SDL_RenderClear(Renderer);
  afficherTour(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, joueurActuel);
  affichageAccusation(Renderer, selectionActuelle);

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
      if selectionActuelle = 1 then
        Dec(selectionActuelle);
      SDLK_DOWN:
      if selectionActuelle = 0 then
        Inc(selectionActuelle);
      SDLK_RETURN:
      case selectionActuelle of
        0: begin
          victoire := accusation(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, joueurActuel, x, y, paquetPersonnages, paquetArmes, paquetPieces, solution, pieces);
          if (victoire = true) then
          begin
            affichageVictoire(Renderer);
            DestRect := coordonnees(SCREEN_WIDTH div 2 - 250 , SCREEN_HEIGHT div 2 - 300, 500, 700);
            afficherImage(Renderer, GetEnumName(TypeInfo(TPersonnage), Ord(joueurs[joueurActuel].nom)), @DestRect);
            SDL_RenderPresent(Renderer);
            lancerAudio('Victoire', 2000);
            lancerAudio('musique fin', 2000);
            cliqueSuivant();
            Halt;
          end
          else
          begin 
            affichageVictoire(Renderer);
            afficherImagesCentrees(Renderer, joueurs, joueurActuel);
            SDL_RenderPresent(Renderer);
            lancerAudio('Victoire', 2000);
            lancerAudio('musique fin', 2000);
            cliqueSuivant();
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
  lancerAudio('Prevention ' + GetEnumName(TypeInfo(TPersonnage), Ord(joueurs[joueurActuel].nom)), 5000);
  cliqueSuivant();
end;

// Amanda
procedure choixActionPiece(Renderer : PSDL_Renderer ; var joueurActuel : Integer ; nbDeplacement, x, y : Integer ; pieces : TPieces ; joueurs : TJoueurs ; paquetArmes, paquetPersonnages, paquetPieces, solution : TPaquet ; var cartesCommunes : TPaquet);
var IsRunning, victoire : Boolean;
    selectionActuelle : Integer;
    Event : TSDL_Event;
    ResultatsDice : TTabInt;
    DiceTextures : TabTextures;
    DestRect : TSDL_Rect;

begin
  IsRunning:=True;
  selectionActuelle:=0;

  while IsRunning do
  begin
    SDL_RenderClear(Renderer);
    afficherTour(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, joueurActuel);
    affichageTour(Renderer, selectionActuelle);

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
            if selectionActuelle > 0 then
              Dec(selectionActuelle);
          SDLK_DOWN:
            if selectionActuelle < 2 then
              Inc(selectionActuelle);
          SDLK_RETURN:
            case selectionActuelle of
              0: begin
                  hypothese(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, joueurActuel, x, y, pieces, paquetArmes, paquetPersonnages);
                  IsRunning:=False;
                 end;
              1: begin
                  victoire := accusation(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, joueurActuel, x, y, paquetPersonnages, paquetArmes, paquetPieces, solution, pieces);
                  if (victoire = true) then
                  begin
                    affichageVictoire(Renderer);
                    DestRect := coordonnees(SCREEN_WIDTH div 2 - 250 , SCREEN_HEIGHT div 2 - 300, 500, 700);
                    afficherImage(Renderer, GetEnumName(TypeInfo(TPersonnage), Ord(joueurs[joueurActuel].nom)), @DestRect);
                    SDL_RenderPresent(Renderer);
                    lancerAudio('Victoire', 2000);
                    lancerAudio('musique fin', 2000);
                    cliqueSuivant();
                    Halt;
                  end
                  else
                  begin 
                    affichageVictoire(Renderer);
                    afficherImagesCentrees(Renderer, joueurs, joueurActuel);
                    SDL_RenderPresent(Renderer);
                    lancerAudio('Victoire', 2000);
                    lancerAudio('musique fin', 2000);
                    cliqueSuivant();
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
  lancerAudio('Prevention ' + GetEnumName(TypeInfo(TPersonnage), Ord(joueurs[joueurActuel].nom)), 5000);
  cliqueSuivant();
end;


// Mènel
procedure gestionTour(Renderer : PSDL_Renderer ; pieces : TPieces ;  paquetArmes, paquetPersonnages, paquetPieces, solution : TPaquet ; var joueurs: TJoueurs; var joueurActuel: Integer; var ResultatsDice : TTabInt; var nbDeplacement: Integer);
var
  NewX, NewY: Integer;
  caseActuelle: Integer;
  Event: TSDL_Event;
  DiceTextures : TabTextures;
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
              if not (estDansPiece(pieces,newX,newY-1)) then
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
              if not (estDansPiece(pieces,newX+1,newY)) then
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
             if not (estDansPiece(pieces,newX,newY+1)) then
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
              if not (estDansPiece(pieces,newX-1,newY)) then
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
            if (nbDeplacement=0) then
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