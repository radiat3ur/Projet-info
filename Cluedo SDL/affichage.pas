unit affichage;

interface

uses SDL2, SDL2_image, SDL2_ttf, TypeEtCte, sysUtils;

procedure InitSDL(var Window: PSDL_Window; var Renderer: PSDL_Renderer);
procedure LoadAssets(var Board: PSDL_Texture ; var Renderer: PSDL_Renderer);
function chargerTexture(Renderer: PSDL_Renderer; filename: String): PSDL_Texture;
function LoadTextureFromText(renderer:PSDL_Renderer; police:PTTF_Font; text:String; color: TSDL_Color):PSDL_Texture;
function Couleur(r, g, b, a: Integer): TSDL_Color;
procedure afficherTexte(Renderer: PSDL_Renderer; text: String; taille, x, y: Integer; couleur: TSDL_Color);
procedure LoadDiceTextures(Renderer: PSDL_Renderer ; var DiceTextures: array of PSDL_Texture);
procedure LoadPionTextures(Renderer : PSDL_Renderer ; var personnages : TCharacters);
procedure RenderDice(Renderer: PSDL_Renderer; DiceTextures: array of PSDL_Texture; DiceResults: TTabInt);
procedure Render(Renderer: PSDL_Renderer; Board: PSDL_Texture; personnages: TCharacters; DiceResults: TTabInt; DiceTextures: array of PSDL_Texture; nbrDeplacement: Integer);
procedure CleanUp(DiceTextures: array of PSDL_Texture; Board: PSDL_Texture; personnages : TCharacters; Renderer: PSDL_Renderer; Window: PSDL_Window);

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

procedure LoadAssets(var Board: PSDL_Texture ; var Renderer: PSDL_Renderer);
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
  Board := SDL_CreateTextureFromSurface(Renderer, Surface);
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

// Charger les textures des dés
procedure LoadDiceTextures(Renderer: PSDL_Renderer ; var DiceTextures: array of PSDL_Texture);
var
  i: Integer;
begin
  for i := 0 to 5 do
    DiceTextures[i] := chargerTexture(Renderer, 'dé '+IntToStr(i+1));
end;

// Charger les textures des pions
procedure LoadPionTextures(Renderer : PSDL_Renderer ; var personnages : TCharacters);
var
  i: Integer;
begin
  for i := 1 to 6 do
    personnages[i].PionTextures := chargerTexture(Renderer, 'pion '+IntToStr(i));
end;

procedure RenderDice(Renderer: PSDL_Renderer; DiceTextures: array of PSDL_Texture; DiceResults: TTabInt);
var
  DestRect: TSDL_Rect;
  Angle1, Angle2 : DOuble;
begin
  Angle1 := -10.0;
  DestRect.x := SCREEN_WIDTH - 280;
  DestRect.y := 100;
  DestRect.w := TILE_SIZE * 3;
  DestRect.h := TILE_SIZE * 3;
  SDL_RenderCopyEx(Renderer, DiceTextures[DiceResults[0]], nil, @DestRect, Angle1, nil, SDL_FLIP_NONE);

  Angle2 := 10.0;
  DestRect.x := SCREEN_WIDTH - 200;
  SDL_RenderCopyEx(Renderer, DiceTextures[DiceResults[1]], nil, @DestRect, Angle2, nil, SDL_FLIP_NONE);
end;

procedure Render(Renderer: PSDL_Renderer; Board: PSDL_Texture; personnages: TCharacters; DiceResults: TTabInt; DiceTextures: array of PSDL_Texture; nbrDeplacement: Integer);
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
  SDL_RenderCopy(Renderer, Board, nil, @DestRect);

  for i := 1 to 6 do
  begin
    DestRect.x := personnages[i].x * TILE_SIZE;
    DestRect.y := personnages[i].y * TILE_SIZE;
    DestRect.w := TILE_SIZE;
    DestRect.h := TILE_SIZE;
    SDL_RenderCopy(Renderer, personnages[i].PionTextures, nil, @DestRect);
  end;

  RenderDice(Renderer, DiceTextures, DiceResults);
  afficherTexte(Renderer, 'Deplacements restants: ' + IntToStr(nbrDeplacement), 14, SCREEN_WIDTH - 280, 60, Couleur(0, 0, 0, 0));

  SDL_RenderPresent(Renderer);
end;

// Nettoyage
procedure CleanUp(DiceTextures: array of PSDL_Texture; Board: PSDL_Texture; personnages : TCharacters; Renderer: PSDL_Renderer; Window: PSDL_Window);
var
  i: Integer;
begin
  for i := 1 to 6 do
    SDL_DestroyTexture(DiceTextures[i]);
  SDL_DestroyTexture(Board);
  for i := 1 to 6 do
    SDL_DestroyTexture(personnages[i].PionTextures);
  SDL_DestroyRenderer(Renderer);
  SDL_DestroyWindow(Window);
  IMG_Quit;
  SDL_Quit;
end;

end.
