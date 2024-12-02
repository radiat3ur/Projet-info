unit affichage;

interface

uses SDL2, SDL2_image, SDL2_ttf, TypeEtCte, sysUtils;

procedure InitSDL(var Window: PSDL_Window; var Renderer: PSDL_Renderer);
procedure chargerPlateau(var plateau: PSDL_Texture ; var Renderer: PSDL_Renderer);
function chargerTexture(Renderer: PSDL_Renderer; filename: String): PSDL_Texture;
function LoadTextureFromText(renderer:PSDL_Renderer; police:PTTF_Font; text:String; color: TSDL_Color):PSDL_Texture;
function Couleur(r, g, b, a: Integer): TSDL_Color;
procedure afficherTexte(Renderer: PSDL_Renderer; text: String; taille, x, y: Integer; couleur: TSDL_Color);
procedure menu(Renderer: PSDL_Renderer);
procedure chargerTexturesDices(Renderer: PSDL_Renderer ; var DiceTextures: TabTextures);
procedure chargerTexturesPions(Renderer : PSDL_Renderer ; var joueurs : TJoueurs);
procedure RenderDice(Renderer: PSDL_Renderer; DiceTextures: TabTextures; DiceResults: TTabInt);
procedure Render(Renderer: PSDL_Renderer; plateau: PSDL_Texture; joueurs: TJoueurs; DiceResults: TTabInt; DiceTextures: TabTextures; nbrDeplacement, CurrentPlayer: Integer);
procedure ChoixNbJoueurs(Renderer: PSDL_Renderer; var joueurs: TJoueurs);
procedure SelectionJoueurs(Renderer: PSDL_Renderer; var joueurs: TJoueurs);
procedure CleanUp(DiceTextures: TabTextures; plateau: PSDL_Texture; joueurs : TJoueurs; Renderer: PSDL_Renderer; Window: PSDL_Window);

implementation

procedure InitSDL(var Window: PSDL_Window; var Renderer: PSDL_Renderer);
begin
  if SDL_Init(SDL_INIT_VIDEO) < 0 then
  begin
    Writeln('Erreur d''initialisation SDL: ', SDL_GetError);
    Halt(1);
  end;

  Window := SDL_CreateWindow('Cluedo - Déplacement', SDL_WINDOWPOS_CENTERED,
    SDL_WINDOWPOS_CENTERED, SCREEN_WIDTH, SCREEN_HEIGHT, SDL_WINDOW_SHOWN);
  if Window = nil then
  begin
    Writeln('Erreur de création de fenêtre: ', SDL_GetError);
    Halt(1);
  end;

  Renderer := SDL_CreateRenderer(Window, -1, SDL_RENDERER_ACCELERATED);
  if Renderer = nil then
  begin
    Writeln('Erreur de création de renderer: ', SDL_GetError);
    Halt(1);
  end;
end;

procedure chargerPlateau(var plateau : PSDL_Texture ; var Renderer: PSDL_Renderer);
var
  Surface: PSDL_Surface;
begin
  // Charger le plateau
  Surface := IMG_Load(PAnsiChar(AnsiString('meta/plateau.png')));
  if Surface = nil then
  begin
    Writeln('Erreur de chargement de l''image du plateau: ', IMG_GetError);
    Halt(1);
  end;
  plateau := SDL_CreateTextureFromSurface(Renderer, Surface);
  SDL_FreeSurface(Surface);
end;

function chargerTexture(Renderer: PSDL_Renderer; filename: String): PSDL_Texture;
var image: PSDL_Texture;
  chemin: AnsiString;
begin
  chemin := 'meta/' + filename + '.png';
  image := IMG_LoadTexture(Renderer,PChar(chemin));

  if image = nil then
    writeln('Erreur de chargement de l''image : ', IMG_GetError);
  chargerTexture := image;
end;

function Couleur(r, g, b, a: Integer): TSDL_Color;
begin
  Couleur.r := r;
  Couleur.g := g;
  Couleur.b := b;
  Couleur.a := a;
end;

function LoadTextureFromText(renderer:PSDL_Renderer; police:PTTF_Font; text:String; color: TSDL_Color):PSDL_Texture;
var surface: PSDL_Surface;
  texture: PSDL_Texture;
  text_compa: AnsiString;
begin
  text_compa := text;
  surface := TTF_RenderText_Solid(police,PChar(text_compa),color);

  texture := SDL_CreateTextureFromSurface(renderer,surface);
  LoadTextureFromText := texture;
end;

procedure afficherTexte(Renderer: PSDL_Renderer; text: String; taille, x, y: Integer; couleur: TSDL_Color);
var police : PTTF_Font;
  texteTexture: PSDL_Texture;
  textRect: TSDL_Rect;

begin
  textRect.x := x;
  textRect.y := y;
  textRect.w := 0;
  textRect.h := 0;

  if TTF_INIT = -1 then halt;

  police := TTF_OpenFont('Roboto-Black.ttf',taille);

  texteTexture := LoadTextureFromText(Renderer,police,text,couleur);

  SDL_QueryTexture(texteTexture,nil,nil,@textRect.w,@textRect.h);

  if SDL_RenderCopy(Renderer,texteTexture,nil,@textRect)<>0 then
    Writeln('Erreur SDL: ', SDL_GetError());
  
  TTF_CloseFont(police);
  TTF_Quit();
  SDL_DestroyTexture(texteTexture);
end;

procedure menu(Renderer: PSDL_Renderer);
var Event : TSDL_Event;
    CurrentSelection: Integer;
    MenuTexture: PSDL_Texture;
    IsRunning : Boolean;
    DestRect : TSDL_Rect;
begin
  // Charger l'image du menu
  MenuTexture := chargerTexture(Renderer, 'menu');
  if MenuTexture = nil then
  begin
    Writeln('Erreur lors du chargement de menu.png');
    Halt(1);
  end;

  CurrentSelection := 0; // L'option sélectionnée commence à 0
  IsRunning := True;
  
  while IsRunning do
  begin
    SDL_SetRenderDrawColor(Renderer, 255, 255, 255, 255); // Blanc
    SDL_RenderClear(Renderer); // Nettoyer l'écran

    // Définir le rectangle pour afficher l'image
    DestRect.x := 0;
    DestRect.y := 0;
    DestRect.w := SCREEN_WIDTH; // Largeur de l'image (adapter si nécessaire)
    DestRect.h := SCREEN_HEIGHT; // Hauteur de l'image (adapter si nécessaire)

    // Afficher l'image de fond
    SDL_RenderCopy(Renderer, MenuTexture, nil, @DestRect);

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
    while SDL_PollEvent(@Event) = 1 do
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
              0: WriteLn('Afficher les regles du jeu'); // Logique à implémenter
              1: begin
                   WriteLn('Commencer une nouvelle partie');
                   IsRunning := False; // Quitte le menu pour commencer la partie
                 end;
              2: begin
                  IsRunning := False;
                  Halt;
                end; // Quitter
            end;
        end;
        if event.type_ = SDL_QUITEV then
          HALT;
      end;
    end;
    SDL_Delay(16); // Pour limiter la boucle (~60 FPS)
  end;

  // Nettoyage
  SDL_DestroyTexture(MenuTexture); // Libérer la texture après usage
end; 

// Charger les textures des dés
procedure chargerTexturesDices(Renderer: PSDL_Renderer ; var DiceTextures: TabTextures);
var
  i: Integer;
begin
  for i := 0 to 5 do
    DiceTextures[i] := chargerTexture(Renderer, 'dé '+IntToStr(i+1));
end;

// Charger les textures des pions
procedure chargerTexturesPions(Renderer : PSDL_Renderer ; var joueurs : TJoueurs);
var
  i: Integer;
begin
  for i := 0 to length(joueurs) do
    case joueurs[i].nom of
      Duval: joueurs[i].PionTextures := chargerTexture(Renderer, 'pion 1');
      Eleve: joueurs[i].PionTextures := chargerTexture(Renderer, 'pion 2');
      Boutigny: joueurs[i].PionTextures := chargerTexture(Renderer, 'pion 3');
      Lecourt: joueurs[i].PionTextures := chargerTexture(Renderer, 'pion 4');
      Yohann: joueurs[i].PionTextures := chargerTexture(Renderer, 'pion 5');
      Yon: joueurs[i].PionTextures := chargerTexture(Renderer, 'pion 6');
    end;
end;

procedure RenderDice(Renderer: PSDL_Renderer; DiceTextures: TabTextures; DiceResults: TTabInt);
var
  DestRect: TSDL_Rect;
  Angle1, Angle2 : DOuble;
begin
  Angle1 := -10.0;
  DestRect.x := SCREEN_WIDTH div 2 - 40;
  DestRect.y := 100;
  DestRect.w := TILE_SIZE * 3;
  DestRect.h := TILE_SIZE * 3;
  SDL_RenderCopyEx(Renderer, DiceTextures[DiceResults[0]], nil, @DestRect, Angle1, nil, SDL_FLIP_NONE);

  Angle2 := 10.0;
  DestRect.x := SCREEN_WIDTH div 2 + 80;
  SDL_RenderCopyEx(Renderer, DiceTextures[DiceResults[1]], nil, @DestRect, Angle2, nil, SDL_FLIP_NONE);
end;

procedure Render(Renderer: PSDL_Renderer; plateau: PSDL_Texture; joueurs: TJoueurs; DiceResults: TTabInt; DiceTextures: TabTextures; nbrDeplacement, CurrentPlayer: Integer);
var
  DestRect: TSDL_Rect;
  i: Integer;
begin
  SDL_SetRenderDrawColor(Renderer, 255, 255, 255, 255);
  SDL_RenderClear(Renderer);

  DestRect.x := 0;
  DestRect.y := 0;
  DestRect.w := TILE_SIZE * GRID_WIDTH;
  DestRect.h := TILE_SIZE * GRID_HEIGHT;
  SDL_RenderCopy(Renderer, plateau, nil, @DestRect);
  for i := 0 to length(joueurs)-1 do
  begin
    DestRect.x := joueurs[i].x * TILE_SIZE;
    DestRect.y := joueurs[i].y * TILE_SIZE;
    DestRect.w := TILE_SIZE;
    DestRect.h := TILE_SIZE;
    SDL_RenderCopy(Renderer, joueurs[i].PionTextures, nil, @DestRect);
  end;

  RenderDice(Renderer, DiceTextures, DiceResults);
  afficherTexte(Renderer, 'Deplacements restants : ' + IntToStr(nbrDeplacement), 14, SCREEN_WIDTH div 2, 60, Couleur(0, 0, 0, 0));
  
  DestRect.x := 0;
  DestRect.y := SCREEN_HEIGHT-175;
  DestRect.w := 175;
  DestRect.h := 175;
  SDL_RenderCopy(Renderer, chargerTexture(Renderer, 'Eleve'), nil, @DestRect); // Là !!!
  SDL_RenderPresent(Renderer);
end;

procedure ChoixNbJoueurs(Renderer: PSDL_Renderer; var joueurs: TJoueurs);
var
  Event: TSDL_Event;
  IsRunning: Boolean;
  nbJoueurs: Integer;
begin
  IsRunning := True;
  nbJoueurs := 2; // Nombre par défaut
  while IsRunning do
  begin
    SDL_SetRenderDrawColor(Renderer, 255, 255, 255, 255); // Blanc
    SDL_RenderClear(Renderer);

    afficherTexte(Renderer, 'Choisir le nombre de joueurs (2-6) :', 50, SCREEN_WIDTH div 2 - 390, 200, Couleur(0, 0, 0, 255));
    afficherTexte(Renderer, IntToStr(nbJoueurs), 50, SCREEN_WIDTH div 2, 300, Couleur(0, 0, 255, 255));

    SDL_RenderPresent(Renderer);

    while SDL_PollEvent(@Event) = 1 do
    begin
      if Event.type_ = SDL_KEYDOWN then
      begin
        case Event.key.keysym.sym of
          SDLK_UP: if nbJoueurs < 6 then Inc(nbJoueurs);
          SDLK_DOWN: if nbJoueurs > 2 then Dec(nbJoueurs);
          SDLK_RETURN: IsRunning := False; // Valider le choix
        end;
      end;
      if event.type_ = SDL_QUITEV then
          HALT;
    end;
  end;
  SetLength(joueurs,nbJoueurs);
end;

procedure SelectionJoueurs(Renderer: PSDL_Renderer; var joueurs: TJoueurs);
var
  Event: TSDL_Event;
  IsRunning: Boolean;
  SelectedCount: Integer;
  JoueurRect: array[0..5] of TSDL_Rect; // Positions des images des joueurs
  TexturesJoueurs: array[0..5] of PSDL_Texture;
  i: Integer;
  MouseX, MouseY: Integer;
  Selection: array[0..5] of Boolean;

begin
  // Initialisation
  IsRunning := True;
  SelectedCount := 0;
  for i := 0 to 5 do
    Selection[i] := False;

  // Charger les textures des joueurs
  TexturesJoueurs[0] := chargerTexture(Renderer, 'Duval');
  TexturesJoueurs[1] := chargerTexture(Renderer, 'Eleve');
  TexturesJoueurs[2] := chargerTexture(Renderer, 'Boutigny');
  TexturesJoueurs[3] := chargerTexture(Renderer, 'Lecourt');
  TexturesJoueurs[4] := chargerTexture(Renderer, 'Yohann');
  TexturesJoueurs[5] := chargerTexture(Renderer, 'Yon');
  for i := 0 to 5 do
  begin
    JoueurRect[i].x := (i mod 3) * 300 + 535;  // Position en grille
    JoueurRect[i].y := (i div 3) * 400 + 235;
    JoueurRect[i].w := 250; // Largeur de l'image
    JoueurRect[i].h := 350; // Hauteur de l'image
  end;

  // Boucle d'affichage et de sélection
  while IsRunning do
  begin
    SDL_SetRenderDrawColor(Renderer, 255, 255, 255, 255); // Fond blanc
    SDL_RenderClear(Renderer);

    // Afficher les images des joueurs
    for i := 0 to 5 do
      SDL_RenderCopy(Renderer, TexturesJoueurs[i], nil, @JoueurRect[i]); // Dessiner l'image

    // Afficher le texte d'instruction
    afficherTexte(Renderer, 'Cliquez pour selectionner ' + IntToStr(length(joueurs)) + ' joueurs.', 40, SCREEN_WIDTH div 2 - 325, 70, Couleur(163, 3, 3, 255));

    SDL_RenderPresent(Renderer);

    // Gérer les événements
    while IsRunning do
    begin
      SDL_SetRenderDrawColor(Renderer, 255, 255, 255, 255);
      SDL_RenderClear(Renderer);

      for i := 0 to 5 do
        SDL_RenderCopy(Renderer, TexturesJoueurs[i], nil, @JoueurRect[i]);

      afficherTexte(Renderer, 'Cliquez pour selectionner ' + IntToStr(length(joueurs)) + ' joueurs.', 40, SCREEN_WIDTH div 2 - 325, 70, Couleur(0, 0, 0, 255));
      SDL_RenderPresent(Renderer);

      while SDL_PollEvent(@Event) = 1 do
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
                      WriteLn('Joueur sélectionné : ', i); // Debug
                    end
                    else
                      WriteLn('Nombre maximal de joueurs déjà sélectionné.');
                  end;
                end;
              end;
              if SelectedCount = length(joueurs) then
                IsRunning := False;
            end;
          SDL_QUITEV: halt();
        end;
      end;
    end;
    for i := 0 to 5 do
      SDL_DestroyTexture(TexturesJoueurs[i]);
  end;
end;

// Nettoyage
procedure CleanUp(DiceTextures: TabTextures; plateau: PSDL_Texture; joueurs : TJoueurs; Renderer: PSDL_Renderer; Window: PSDL_Window);
var
  i: Integer;
begin
  for i := 0 to 5 do
    SDL_DestroyTexture(DiceTextures[i]);
  SDL_DestroyTexture(plateau);
  for i := 0 to 5 do
    SDL_DestroyTexture(joueurs[i].PionTextures);
  SDL_DestroyRenderer(Renderer);
  SDL_DestroyWindow(Window);
  IMG_Quit;
  SDL_Quit;
end;

end.
