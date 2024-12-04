unit gestion;

interface

uses SDL2, TypeEtCte, affichage, sysUtils, TypInfo;

procedure menu(Renderer: PSDL_Renderer);
procedure choixNbJoueurs(Renderer: PSDL_Renderer; var joueurs: TJoueurs);
procedure selectionJoueurs(Renderer: PSDL_Renderer; var joueurs: TJoueurs);
function creerPiece(x,y,w,h:Integer;salle:TNomPiece):TPiece;
procedure InitPieces(Renderer : PSDL_Renderer ; var pieces : TPieces);
procedure InitCharacters(var joueurs: TJoueurs; var joueurActuel: Integer);
procedure InitPaquets(var paquetPieces, paquetArmes, paquetPersonnages : TPaquet);
procedure selectionCartesCrime(paquetPieces, paquetArmes, paquetPersonnages : TPaquet; var solution, paquetSansCartesCrime : TPaquet);
procedure melangerPaquet(var paquetSansCartesCrime : TPaquet);
procedure distributionCartesJoueurs(paquetSansCartesCrime: TPaquet ; var joueurs: TJoueurs);
procedure initialisationPartie(Renderer : PSDL_Renderer ; pieces : TPieces ; joueurs : TJoueurs ; joueurActuel: Integer ; paquetPieces, paquetArmes, paquetPersonnages, solution, paquetSansCartesCrime : TPaquet);
procedure LancerDes(Renderer: PSDL_Renderer; DiceTextures: TabTextures; var ResultatsDice: TTabInt);
function estDansPiece(pieces : TPieces ; xJ, yJ : Integer):Boolean;
procedure gestionTour(Renderer : PSDL_Renderer ; pieces : TPieces ; var joueurs: TJoueurs; var joueurActuel: Integer; var ResultatsDice : TTabInt; var nbDeplacement: Integer);

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
    SDL_RenderClear(Renderer); // Nettoyer l'écran

    // Définir le rectangle pour afficher l'image
    DestRect.x := 0;
    DestRect.y := 0;
    DestRect.w := SCREEN_WIDTH; 
    DestRect.h := SCREEN_HEIGHT; 

    // Afficher l'image de fond
    afficherImage(Renderer, 'menu', @DestRect);

    // Affichage du menu texte
    if CurrentSelection = 0 then
      afficherTexte(Renderer, '1. Afficher les regles du jeu', 75, SCREEN_WIDTH div 2 - 465, SCREEN_HEIGHT div 2 - 40, Couleur(163, 3, 3, 0))
    else
      afficherTexte(Renderer, '1. Afficher les regles du jeu', 70, SCREEN_WIDTH div 2 - 440, SCREEN_HEIGHT div 2 - 40, Couleur(0, 0, 0, 0));

    if CurrentSelection = 1 then
      afficherTexte(Renderer, '2. Commencer une nouvelle partie', 75, SCREEN_WIDTH div 2 - 570, SCREEN_HEIGHT div 2 + 80, Couleur(163, 3, 3, 0))
    else
      afficherTexte(Renderer, '2. Commencer une nouvelle partie', 70, SCREEN_WIDTH div 2 - 520, SCREEN_HEIGHT div 2 + 80 , Couleur(0, 0, 0, 0));

    if CurrentSelection = 2 then
      afficherTexte(Renderer, '3. Quitter', 75, SCREEN_WIDTH div 2 - 170, SCREEN_HEIGHT div 2 + 200 , Couleur(163, 3, 3, 0))
    else
      afficherTexte(Renderer, '3. Quitter', 70, SCREEN_WIDTH div 2 - 165, SCREEN_HEIGHT div 2 + 200 , Couleur(0, 0, 0, 0));

    SDL_RenderPresent(Renderer);

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
                  SDL_RenderClear(Renderer);
                  afficherImage(Renderer, 'regles', @DestRect);
                  SDL_RenderPresent(Renderer);
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
begin
  IsRunning := True;
  SetLength(joueurs, 2);
  while IsRunning do
  begin
    SDL_SetRenderDrawColor(Renderer, 255, 255, 255, 255); // Blanc
    SDL_RenderClear(Renderer);

    afficherTexte(Renderer, 'Choisir le nombre de joueurs (2-6) :', 50, SCREEN_WIDTH div 2 - 390, 200, Couleur(0, 0, 0, 255));
    afficherTexte(Renderer, IntToStr(Length(joueurs)), 50, SCREEN_WIDTH div 2, 300, Couleur(0, 0, 255, 255));

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
    JoueurRect[i].x := (i mod 3) * 300 + 535;  // Position en grille
    JoueurRect[i].y := (i div 3) * 400 + 235;
    JoueurRect[i].w := 250; // Largeur de l'image
    JoueurRect[i].h := 350; // Hauteur de l'image
  end;

  for i := 0 to Length(joueurs) - 1 do
    joueurs[i].nom := rien;

  // Boucle d'affichage et de sélection
  while IsRunning do
  begin
    SDL_SetRenderDrawColor(Renderer, 255, 255, 255, 255); // Fond blanc
    SDL_RenderClear(Renderer);

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
      
      sdlRect1.x := JoueurRect[Ord(joueurs[i].nom)].x;
      sdlRect1.y := JoueurRect[Ord(joueurs[i].nom)].y;
      sdlRect1.w := JoueurRect[Ord(joueurs[i].nom)].w;
      sdlRect1.h := JoueurRect[Ord(joueurs[i].nom)].h;

      SDL_SetRenderDrawColor(Renderer, 105, 105, 105, 255);
      SDL_RenderFillRect(Renderer, @sdlRect1);
      SDL_RenderDrawRect(Renderer, @sdlRect1);
    end;

    // Afficher les images des joueurs
    for i := 0 to 5 do
      afficherImage(Renderer, GetEnumName(TypeInfo(TPersonnage), Ord(TPersonnage(i))), @JoueurRect[i]);

    // Afficher le texte d'instruction
    afficherTexte(Renderer, 'Cliquez pour selectionner ' + IntToStr(Length(joueurs)) + ' joueurs.', 40, SCREEN_WIDTH div 2 - 325, 70, Couleur(163, 3, 3, 255));

    SDL_RenderPresent(Renderer);
  end;
  SDL_RenderClear(Renderer);
end;

function creerPiece(x,y,w,h:Integer;salle:TNomPiece):TPiece;
begin
  creerPiece.x := x;
  creerPiece.y := y;
  creerPiece.w := w;
  creerPiece.h := h;
  creerPiece.salle := salle
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
    // Crée le paquet des armes
    SetLength(paquetArmes, 6);
    for i:=0 to Length(paquetArmes)-1 do
    begin
        paquetArmes[i].categorie:=Arme;
        paquetArmes[i].nom:=TNomCarte(i);
    end;

    // Crée le paquet des personnages
    SetLength(paquetPersonnages, 6);
    for i:=0 to length(paquetPersonnages)-1 do
    begin
        paquetPersonnages[i].categorie:=Personnage;
        paquetPersonnages[i].nom:=TNomCarte(i+length(paquetArmes));
    end;

    // Crée le paquet des pièces
    SetLength(paquetPieces, 9);
    for i:=0 to length(paquetPieces)-1 do
    begin
        paquetPieces[i].categorie:=Piece;
        paquetPieces[i].nom:=TNomCarte(i+length(paquetArmes)+length(paquetPersonnages));
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
        if (paquetArmes[i].nom<>solution[0].nom) then
        begin
            paquetSansCartesCrime[indexPaquet]:=paquetArmes[i];
            indexPaquet:=indexPaquet+1;
        end;
    end;

    for i:=0 to 5 do
    begin  
        if (paquetPersonnages[i].nom<>solution[1].nom) then
        begin
            paquetSansCartesCrime[indexPaquet]:=paquetPersonnages[i];
            indexPaquet:=indexPaquet+1;
        end;
    end;

    for i:=0 to 8 do
    begin  
        if (paquetPieces[i].nom<>solution[2].nom) then
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

procedure initialisationPartie(Renderer : PSDL_Renderer ; pieces : TPieces ; joueurs : TJoueurs ; joueurActuel: Integer ; paquetPieces, paquetArmes, paquetPersonnages, solution, paquetSansCartesCrime : TPaquet);
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

function estDansPiece(pieces : TPieces ; xJ, yJ : Integer):Boolean;
var i : Integer;
    valide : Boolean;

begin
  valide:=False;
  for i:=0 to 8 do
    if (xJ>=pieces[i].x) and (xJ<=pieces[i].x+pieces[i].w-1) and (yJ>=pieces[i].y) and (yJ<=pieces[i].y+pieces[i].h-1) then
    begin
      valide:=True;
      break;
    end;
  estDansPiece:=valide;
end;

procedure gestionTour(Renderer : PSDL_Renderer ; pieces : TPieces ; var joueurs: TJoueurs; var joueurActuel: Integer; var ResultatsDice : TTabInt; var nbDeplacement: Integer);
var
  NewX, NewY: Integer;
  caseActuelle: Integer;
  Event: TSDL_Event;
  DiceTextures : TabTextures;
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
              if not (estDansPiece(pieces, newX, newY)) and (estDansPiece(pieces, newX, newY-1)) then
                nbDeplacement:=0;
              Dec(NewY);
              joueurs[joueurActuel].y := NewY;
            end;
            SDLK_RIGHT: if not (caseActuelle in [2, 3, 6, 10]) and (nbDeplacement>0) then
            begin
              if not (estDansPiece(pieces,newX,newY) and estDansPiece(pieces,newX+1,newY)) then
                Dec(nbDeplacement);
              if not (estDansPiece(pieces, newX, newY)) and (estDansPiece(pieces, newX+1, newY)) then
                nbDeplacement:=0;
              Inc(NewX);
              joueurs[joueurActuel].X := NewX;
            end;
            SDLK_DOWN: if not (caseActuelle in [4, 5, 6, 12]) and (nbDeplacement>0) then
            begin
              if not (estDansPiece(pieces,newX,newY) and estDansPiece(pieces,newX,newY+1)) then
                Dec(nbDeplacement);
              if not (estDansPiece(pieces, newX, newY)) and (estDansPiece(pieces, newX, newY+1)) then
                nbDeplacement:=0;
              Inc(NewY);
              joueurs[joueurActuel].y := NewY;
            end;
            SDLK_LEFT: if not (caseActuelle in [8, 9, 10, 12]) and (nbDeplacement>0) then
            begin
              if not (estDansPiece(pieces,newX,newY) and estDansPiece(pieces,newX-1,newY)) then
                Dec(nbDeplacement);
              if not (estDansPiece(pieces, newX, newY)) and (estDansPiece(pieces, newX-1, newY)) then
                nbDeplacement:=0;
              Dec(NewX);
              joueurs[joueurActuel].x := NewX;
            end;
            SDLK_RETURN :
            begin
              LancerDes(Renderer, DiceTextures, ResultatsDice); // Relancer les dés pour le joueur suivant
              nbDeplacement := ResultatsDice[0] + ResultatsDice[1] + 2;
              joueurActuel := (joueurActuel + 1) mod length(joueurs); // Passer au joueur suivant
            end;
          end;      
        end;
    end;
  end;
end;

end.