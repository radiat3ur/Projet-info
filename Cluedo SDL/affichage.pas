unit affichage;

interface

uses SDL2, SDL2_image, SDL2_ttf, TypeEtCte, sysUtils, TypInfo;

procedure InitSDL(var Window: PSDL_Window; var Renderer: PSDL_Renderer);
function chargerTexture(Renderer: PSDL_Renderer; filename: String): PSDL_Texture;
procedure afficherImage(Renderer: PSDL_Renderer; filename: string; DestRect: PSDL_Rect);
function Couleur(r, g, b, a: Integer): TSDL_Color;
function chargerTextureDepuisTexte(renderer:PSDL_Renderer; police:PTTF_Font; text:String; color: TSDL_Color):PSDL_Texture;
procedure afficherTexte(Renderer: PSDL_Renderer; text: String; taille, x, y: Integer; couleur: TSDL_Color);
procedure AfficherDes(Renderer: PSDL_Renderer; DiceTextures: TabTextures; ResultatsDice: TTabInt);
procedure AfficherPions(Renderer : PSDL_Renderer ; joueurs : TJoueurs);
procedure afficherTour(Renderer: PSDL_Renderer; joueurs: TJoueurs; ResultatsDice: TTabInt; DiceTextures: TabTextures; nbDeplacement, joueurActuel: Integer);


procedure CleanUp(Window : PSDL_Window ; Renderer : PSDL_Renderer);

implementation

procedure InitSDL(var Window: PSDL_Window; var Renderer: PSDL_Renderer);
begin
  if SDL_Init(SDL_INIT_VIDEO) < 0 then
  begin
    Writeln('Erreur d''initialisation SDL : ', SDL_GetError);
    Halt;
  end;

  Window := SDL_CreateWindow('Cluedo - Déplacement', SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, SCREEN_WIDTH, SCREEN_HEIGHT, SDL_WINDOW_SHOWN);
  if Window = nil then
  begin
    Writeln('Erreur de création de fenêtre : ', SDL_GetError);
    SDL_Quit;
    Halt;
  end;

  Renderer := SDL_CreateRenderer(Window, -1, SDL_RENDERER_ACCELERATED);
  if Renderer = nil then
  begin
    Writeln('Erreur de création de renderer : ', SDL_GetError);
    SDL_DestroyWindow(Window);
    SDL_Quit;
    Halt;
  end;
end;

function chargerTexture(Renderer: PSDL_Renderer; filename: String): PSDL_Texture;
var image: PSDL_Texture;
    chemin: AnsiString;
begin
  chemin := 'meta/' + filename + '.png';
  image := IMG_LoadTexture(Renderer, PChar(chemin));

  if image = nil then
    Writeln('Erreur de chargement de l''image "', chemin, '": ', IMG_GetError);

  chargerTexture := image;
end;

procedure afficherImage(Renderer: PSDL_Renderer; filename: string; DestRect: PSDL_Rect);
var texture: PSDL_Texture;
begin
  texture := chargerTexture(Renderer, filename);

  if texture = nil then
  begin
    Writeln('Erreur : Impossible de charger la texture pour ', filename, '. SDL_Error: ', IMG_GetError());
    Exit;
  end;

  SDL_RenderCopy(renderer, texture, nil, DestRect);

  // Ne pas détruire la texture si elle est réutilisée
  SDL_DestroyTexture(texture);
end;

function Couleur(r, g, b, a: Integer): TSDL_Color;
begin
  Couleur.r := r;
  Couleur.g := g;
  Couleur.b := b;
  Couleur.a := a;
end;

function chargerTextureDepuisTexte(renderer:PSDL_Renderer; police:PTTF_Font; text:String; color: TSDL_Color):PSDL_Texture;
var surface: PSDL_Surface;
  texture: PSDL_Texture;
  text_compa: AnsiString;
begin
  text_compa := text;
  surface := TTF_RenderText_Solid(police,PChar(text_compa),color);
  if surface = nil then
  begin
    Writeln('Erreur lors de la création de la surface de texte.');
    Exit(nil);
  end;

  texture := SDL_CreateTextureFromSurface(renderer,surface);
  chargerTextureDepuisTexte := texture;
  SDL_FreeSurface(surface);
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

  texteTexture := chargerTextureDepuisTexte(Renderer,police,text,couleur);

  SDL_QueryTexture(texteTexture,nil,nil,@textRect.w,@textRect.h);

  if SDL_RenderCopy(Renderer,texteTexture,nil,@textRect)<>0 then
    Writeln('Erreur SDL: ', SDL_GetError());
  
  TTF_CloseFont(police);
  TTF_Quit();
  SDL_DestroyTexture(texteTexture);
end;

procedure AfficherDes(Renderer: PSDL_Renderer; DiceTextures: TabTextures; ResultatsDice: TTabInt);
var
  DestRect: TSDL_Rect;
  Angle : Double;
begin
  SetLength(ResultatsDice, 2);
  // Définir le rectangle pour le premier dé
  Angle:=-10.0;
  DestRect.x := SCREEN_WIDTH div 2 - 40;
  DestRect.y := 100;
  DestRect.w := TILE_SIZE * 3;
  DestRect.h := TILE_SIZE * 3;
  SDL_RenderCopyEx(Renderer, chargerTexture(Renderer, 'dé ' + IntToStr(ResultatsDice[0] + 1)), nil, @DestRect, Angle, nil, SDL_FLIP_NONE);
    
  // Définir le rectangle pour le deuxième dé
  DestRect.x := SCREEN_WIDTH div 2 + 80;
  Angle:=10.0;
  SDL_RenderCopyEx(Renderer, chargerTexture(Renderer, 'dé ' + IntToStr(ResultatsDice[1] + 1)), nil, @DestRect, Angle, nil, SDL_FLIP_NONE);
end;

procedure AfficherPions(Renderer: PSDL_Renderer; joueurs: TJoueurs);
var
  DestRect: TSDL_Rect;
  i: Integer;
begin
  for i := 0 to Length(joueurs) - 1 do
  begin
    if joueurs[i].nom <> rien then
    begin
      DestRect.x := joueurs[i].x * TILE_SIZE;
      DestRect.y := joueurs[i].y * TILE_SIZE;
      DestRect.w := TILE_SIZE;
      DestRect.h := TILE_SIZE;
      afficherImage(Renderer, 'pion ' + IntToStr(Ord(joueurs[i].nom) + 1), @DestRect);
    end;
  end;
end;

procedure afficherTour(Renderer: PSDL_Renderer; joueurs: TJoueurs; ResultatsDice: TTabInt; DiceTextures: TabTextures; nbDeplacement, joueurActuel: Integer);
var DestRect: TSDL_Rect;
    i: Integer;
    carteRect: array of TSDL_Rect;
begin
  SDL_SetRenderDrawColor(Renderer, 255, 255, 255, 255);
  SDL_RenderClear(Renderer);

  DestRect.x := 0;
  DestRect.y := 0;
  DestRect.w := TILE_SIZE * GRID_WIDTH;
  DestRect.h := TILE_SIZE * GRID_HEIGHT;
  afficherImage(Renderer, 'plateau', @DestRect);

  AfficherPions(Renderer, joueurs);  
  AfficherDes(Renderer, DiceTextures, ResultatsDice);
  afficherTexte(Renderer, 'Deplacements restants : ' + IntToStr(nbDeplacement), 14, SCREEN_WIDTH div 2, 60, Couleur(0, 0, 0, 0));
  
  DestRect.x := 0;
  DestRect.y := SCREEN_HEIGHT-230;
  DestRect.w := 180;
  DestRect.h := 252;
  afficherImage(Renderer, GetEnumName(TypeInfo(TPersonnage), Ord(joueurs[joueurActuel].nom)), @DestRect);

  SetLength(carteRect, length(joueurs[joueurActuel].main));
  for i := 0 to length(joueurs[joueurActuel].main) - 1 do // Parcourt le paquet
  begin
    carteRect[i].x := i * 137 + 210;  // Position en grille
    carteRect[i].y := SCREEN_HEIGHT - 195;
    carteRect[i].w := 135; // Largeur de l'image
    carteRect[i].h := 189; // Hauteur de l'image
    afficherImage(Renderer, 'cartes/' + GetEnumName(TypeInfo(TNomCarte), Ord(joueurs[joueurActuel].main[i].nom)), @carteRect[i]);
  end;

  //SDL_RenderPresent(Renderer);
end;







procedure CleanUp(Window : PSDL_Window ; Renderer : PSDL_Renderer);
begin
  SDL_DestroyRenderer(Renderer);
  SDL_DestroyWindow(Window);
  SDL_Quit;
end;

end.
