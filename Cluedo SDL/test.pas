program CluedoMovementWithDice;

uses
  crt, SDL2, SDL2_image;

const
  SCREEN_WIDTH = 1100;  // Largeur de la fenêtre (espace supplémentaire pour les dés)
  SCREEN_HEIGHT = 880;  // Hauteur de la fenêtre
  TILE_SIZE = 30;       // Taille d'une case (réduit pour adapter le plateau)
  GRID_WIDTH = 22;      // Nombre de colonnes sur la grille
  GRID_HEIGHT = 22;     // Nombre de lignes sur la grille

  // Grille étendue avec murs et cases traversables
  GRID: array[0..GRID_HEIGHT-1, 0..GRID_WIDTH-1] of Integer = (
    (9, 1, 1, 1, 1, 3, 9, 3, 9, 1, 1, 1, 1, 3, 9, 3, 9, 1, 1, 1, 1, 3),
    (8, 0, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 0, 2),
    (12, 4, 4, 4, 4, 2, 8, 2, 8, 0, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 0, 2),
    (9, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 0, 2),
    (12, 4, 4, 4, 4, 4, 0, 2, 8, 0, 0, 0, 0, 2, 8, 2, 12, 0, 4, 4, 4, 6),
    (9, 1, 1, 1, 1, 3, 8, 2, 12, 4, 0, 0, 4, 6, 8, 0, 1, 0, 1, 1, 1, 3),
    (8, 0, 0, 0, 0, 2, 8, 0, 5, 5, 4, 4, 5, 1, 0, 0, 0, 0, 0, 0, 0, 2),
    (8, 0, 0, 0, 0, 0, 0, 2, 9, 1, 1, 1, 3, 8, 0, 4, 4, 4, 4, 4, 4, 6),
    (12, 4, 0, 4, 4, 6, 8, 2, 8, 0, 0, 0, 2, 8, 2, 9, 1, 1, 1, 1, 1, 3),
    (9, 1, 0, 1, 1, 1, 0, 2, 8, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 0, 0, 2),
    (8, 4, 4, 4, 4, 0, 0, 2, 8, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2),
    (8, 1, 1, 1, 3, 8, 0, 2, 8, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 2),
    (8, 0, 0, 0, 2, 8, 0, 2, 8, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 0, 0, 2),
    (8, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 2, 8, 2, 12, 4, 4, 4, 4, 4, 6),
    (8, 0, 0, 0, 2, 8, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 3),
    (12, 4, 4, 4, 6, 8, 0, 4, 0, 4, 4, 4, 4, 0, 4, 0, 0, 0, 0, 0, 0, 2),
    (8, 1, 1, 1, 1, 0, 2, 9, 0, 1, 1, 1, 1, 0, 3, 8, 0, 0, 4, 4, 4, 2),
    (8, 4, 4, 4, 4, 0, 2, 8, 0, 0, 0, 0, 0, 0, 2, 8, 2, 8, 1, 1, 1, 2),
    (8, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 2),
    (8, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 2),
    (8, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 2),
    (12, 4, 4, 4, 6, 12, 6, 12, 4, 4, 4, 4, 4, 4, 6, 12, 6, 12, 4, 4, 4, 12)
  );

type
  TCharacter = record
    x, y: Integer; // Position du personnage (en cases)
    sprite: PSDL_Texture; // Sprite du personnage
  end;

var
  Window: PSDL_Window;
  Renderer: PSDL_Renderer;
  Event: TSDL_Event;
  IsRunning: Boolean;
  Board: PSDL_Texture;
  Character: TCharacter;
  DiceTextures: array[1..6] of PSDL_Texture;
  DiceResults: array[1..2] of Integer;

// Initialisation de SDL
procedure InitSDL;
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

  if IMG_Init(IMG_INIT_PNG) = 0 then
  begin
    Writeln('Erreur d''initialisation SDL_image: ', IMG_GetError);
    Halt(1);
  end;
end;

// Charger les textures des dés
procedure LoadDiceTextures;
var
  Surface: PSDL_Surface;
  i: Integer;
  DiceFiles: array[1..6] of string = (
    'dé 1.png',
    'dé 2.png',
    'dé 3.png',
    'dé 4.png',
    'dé 5.png',
    'dé 6.png'
  );
begin
  for i := 1 to 6 do
  begin
    Surface := IMG_Load(PAnsiChar(AnsiString(DiceFiles[i])));
    if Surface = nil then
    begin
      Writeln('Erreur de chargement de l''image du dé ', i, ': ', IMG_GetError);
      Halt(1);
    end;
    DiceTextures[i] := SDL_CreateTextureFromSurface(Renderer, Surface);
    SDL_FreeSurface(Surface);
  end;
end;

// Charger les assets (plateau et personnage)
procedure LoadAssets;
var
  Surface: PSDL_Surface;
begin
  // Charger le plateau
  Surface := IMG_Load(PAnsiChar(AnsiString('plateau.png')));
  if Surface = nil then
  begin
    Writeln('Erreur de chargement de l''image du plateau: ', IMG_GetError);
    Halt(1);
  end;
  Board := SDL_CreateTextureFromSurface(Renderer, Surface);
  SDL_FreeSurface(Surface);

  // Charger le personnage
  Surface := IMG_Load(PAnsiChar(AnsiString('character.png')));
  if Surface = nil then
  begin
    Writeln('Erreur de chargement de l''image du personnage: ', IMG_GetError);
    Halt(1);
  end;
  Character.sprite := SDL_CreateTextureFromSurface(Renderer, Surface);
  SDL_FreeSurface(Surface);

  // Position initiale
  Character.x := 0;
  Character.y := 0;
end;

// Fonction pour lancer les dés
procedure RollDice;
begin
  Randomize;
  DiceResults[1] := Random(6) + 1; // Résultat du premier dé
  DiceResults[2] := Random(6) + 1; // Résultat du second dé
end;

// Gérer les événements pour le personnage et les dés
procedure HandleEvents;
var
  NewX, NewY: Integer;
  CurrentCell: Integer;
begin
  while SDL_PollEvent(@Event) <> 0 do
  begin
    case Event.type_ of
      SDL_QUITEV: IsRunning := False;
      SDL_KEYDOWN:
        begin
          NewX := Character.x;
          NewY := Character.y;
          CurrentCell := GRID[Character.y, Character.x];

          case Event.key.keysym.sym of
            SDLK_UP: if not (CurrentCell in [1, 3, 5, 9]) then Dec(NewY);
            SDLK_RIGHT: if not (CurrentCell in [2, 3, 6, 10]) then Inc(NewX);
            SDLK_DOWN: if not (CurrentCell in [4, 5, 6, 12]) then Inc(NewY);
            SDLK_LEFT: if not (CurrentCell in [8, 9, 10, 12]) then Dec(NewX);
            SDLK_RETURN: RollDice; // Relancer les dés avec Entrée
          end;

          // Vérifiez si les nouvelles coordonnées sont valides
          if (NewX >= 0) and (NewX < GRID_WIDTH) and
             (NewY >= 0) and (NewY < GRID_HEIGHT) then
          begin
            Character.x := NewX;
            Character.y := NewY;
          end;
        end;
    end;
  end;
end;

// Afficher les dés
procedure RenderDice;
var
  DestRect: TSDL_Rect;
  Angle1, Angle2: Double;
begin
  // Définir les angles de rotation pour les dés
  Angle1 := -10.0; // Inclinaison vers la gauche pour le premier dé
  Angle2 := 10.0;  // Inclinaison vers la droite pour le second dé

  // Afficher le premier dé (incliné vers la gauche)
  DestRect.x := SCREEN_WIDTH - 280; // Position x du premier dé
  DestRect.y := 100;                // Position y du premier dé
  DestRect.w := TILE_SIZE * 3;      // Largeur du dé
  DestRect.h := TILE_SIZE * 3;      // Hauteur du dé
  SDL_RenderCopyEx(Renderer, DiceTextures[DiceResults[1]], nil, @DestRect, Angle1, nil, SDL_FLIP_NONE);

  // Afficher le second dé (incliné vers la droite)
  DestRect.x := SCREEN_WIDTH - 200; // Position x du second dé
  DestRect.y := 100;                // Position y du second dé (légèrement décalé)
  DestRect.w := TILE_SIZE * 3;
  DestRect.h := TILE_SIZE * 3;
  SDL_RenderCopyEx(Renderer, DiceTextures[DiceResults[2]], nil, @DestRect, Angle2, nil, SDL_FLIP_NONE);
end;

// Rendu principal
procedure Render;
var
  DestRect: TSDL_Rect;
begin
  SDL_RenderClear(Renderer);

  // Définir un fond blanc
  SDL_SetRenderDrawColor(Renderer, 255, 255, 255, 255); // Blanc en RGBA
  SDL_RenderClear(Renderer); // Remplir l'écran avec la couleur définie

  // Dessiner le plateau
  DestRect.x := 0;
  DestRect.y := 0;
  DestRect.w := TILE_SIZE * GRID_WIDTH;
  DestRect.h := TILE_SIZE * GRID_HEIGHT;
  SDL_RenderCopy(Renderer, Board, nil, @DestRect);

  // Dessiner le personnage
  DestRect.x := Character.x * TILE_SIZE;
  DestRect.y := Character.y * TILE_SIZE;
  DestRect.w := TILE_SIZE;
  DestRect.h := TILE_SIZE;
  SDL_RenderCopy(Renderer, Character.sprite, nil, @DestRect);

  // Dessiner les dés
  RenderDice;

  SDL_RenderPresent(Renderer);
end;

// Nettoyage
procedure CleanUp;
var
  i: Integer;
begin
  for i := 1 to 6 do
    SDL_DestroyTexture(DiceTextures[i]);
  SDL_DestroyTexture(Board);
  SDL_DestroyTexture(Character.sprite);
  SDL_DestroyRenderer(Renderer);
  SDL_DestroyWindow(Window);
  IMG_Quit;
  SDL_Quit;
end;

// Programme principal
begin
  InitSDL;
  LoadAssets;
  LoadDiceTextures;
  RollDice; // Initialiser avec un premier lancer de dés

  IsRunning := True;
  while IsRunning do
  begin
    HandleEvents;
    Render;
    SDL_Delay(16); // ~60 FPS
  end;

  CleanUp;
end.