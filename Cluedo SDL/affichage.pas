unit affichage;

interface

uses SDL2, SDL2_image, SDL2_ttf, TypeEtCte, sysUtils, TypInfo;

procedure InitSDL(var Window: PSDL_Window; var Renderer: PSDL_Renderer);
function coordonnees(x, y, w, h : Integer): TSDL_Rect;
function chargerTexture(Renderer: PSDL_Renderer; filename: String): PSDL_Texture;
procedure afficherImage(Renderer: PSDL_Renderer; filename: string; DestRect: PSDL_Rect);
function Couleur(r, g, b, a: Integer): TSDL_Color;
function chargerTextureDepuisTexte(renderer:PSDL_Renderer; police:PTTF_Font; text:String; color: TSDL_Color):PSDL_Texture;
procedure afficherTexte(Renderer: PSDL_Renderer; text: String; taille, x, y: Integer; couleur: TSDL_Color);
procedure affichageRegles(Renderer : PSDL_Renderer);
procedure affichageMenu(Renderer : PSDL_Renderer ; CurrentSelection : Integer);
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

function coordonnees(x, y, w, h : Integer): TSDL_Rect;
begin
  coordonnees.x:=x;
  coordonnees.y:=y;
  coordonnees.w:=w;
  coordonnees.h:=h;
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
  surface := TTF_RenderUTF8_Blended(police,PChar(text_compa),color);
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
  textRect := coordonnees(x, y, 0, 0);

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
  DestRect := coordonnees(SCREEN_WIDTH div 2 - 35, 60, TILE_SIZE * 3, TILE_SIZE * 3);
  SDL_RenderCopyEx(Renderer, chargerTexture(Renderer, 'dé ' + IntToStr(ResultatsDice[0] + 1)), nil, @DestRect, Angle, nil, SDL_FLIP_NONE);
    
  // Définir le rectangle pour le deuxième dé
  DestRect.x := SCREEN_WIDTH div 2 + 85;
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
      DestRect := coordonnees(joueurs[i].x * TILE_SIZE, joueurs[i].y * TILE_SIZE, TILE_SIZE, TILE_SIZE);
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

  DestRect := coordonnees(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT); 

  afficherImage(Renderer, 'fond', @DestRect);

  DestRect := coordonnees(0, 0, TILE_SIZE * GRID_WIDTH, TILE_SIZE * GRID_HEIGHT);
  afficherImage(Renderer, 'plateau', @DestRect);

  AfficherPions(Renderer, joueurs);  
  AfficherDes(Renderer, DiceTextures, ResultatsDice);
  afficherTexte(Renderer, 'Déplacements restants : ' + IntToStr(nbDeplacement), 25, SCREEN_WIDTH div 2 - 60, 200, Couleur(0, 0, 0, 0));
  
  DestRect := coordonnees(0, SCREEN_HEIGHT-230, 180, 252);
  afficherImage(Renderer, GetEnumName(TypeInfo(TPersonnage), Ord(joueurs[joueurActuel].nom)) + 'actuel', @DestRect);

  SetLength(carteRect, length(joueurs[joueurActuel].main));
  for i := 0 to length(joueurs[joueurActuel].main) - 1 do // Parcourt le paquet
  begin
    carteRect[i] := coordonnees(i * 137 + 210, SCREEN_HEIGHT - 195, 135, 189);
    afficherImage(Renderer, 'cartes/' + GetEnumName(TypeInfo(TNomCarte), Ord(joueurs[joueurActuel].main[i].nom)), @carteRect[i]);
  end;

  //SDL_RenderPresent(Renderer);
end;

procedure affichageRegles(Renderer : PSDL_Renderer);
var DestRect : TSDL_Rect;
begin
  SDL_RenderClear(Renderer);
  DestRect := coordonnees(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
  afficherImage(Renderer, 'regles', @DestRect);
  SDL_RenderPresent(Renderer);
end;

procedure affichageMenu(Renderer : PSDL_Renderer ; CurrentSelection : Integer);
var DestRect : TSDL_Rect;
begin
  SDL_RenderClear(Renderer); // Nettoyer l'écran

  // Définir le rectangle pour afficher l'image
  DestRect := coordonnees(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

  // Afficher l'image de fond
  afficherImage(Renderer, 'menu', @DestRect);

  // Affichage du menu texte
  if CurrentSelection = 0 then
    afficherTexte(Renderer, '1. Afficher les règles du jeu', 75, SCREEN_WIDTH div 2 - 465, SCREEN_HEIGHT div 2 - 40, Couleur(163, 3, 3, 0))
  else
    afficherTexte(Renderer, '1. Afficher les règles du jeu', 70, SCREEN_WIDTH div 2 - 440, SCREEN_HEIGHT div 2 - 40, Couleur(0, 0, 0, 0));

  if CurrentSelection = 1 then
    afficherTexte(Renderer, '2. Commencer une nouvelle partie', 75, SCREEN_WIDTH div 2 - 570, SCREEN_HEIGHT div 2 + 80, Couleur(163, 3, 3, 0))
  else
    afficherTexte(Renderer, '2. Commencer une nouvelle partie', 70, SCREEN_WIDTH div 2 - 520, SCREEN_HEIGHT div 2 + 80 , Couleur(0, 0, 0, 0));

  if CurrentSelection = 2 then
    afficherTexte(Renderer, '3. Quitter', 75, SCREEN_WIDTH div 2 - 170, SCREEN_HEIGHT div 2 + 200 , Couleur(163, 3, 3, 0))
  else
    afficherTexte(Renderer, '3. Quitter', 70, SCREEN_WIDTH div 2 - 165, SCREEN_HEIGHT div 2 + 200 , Couleur(0, 0, 0, 0));

  SDL_RenderPresent(Renderer);
end;

procedure CleanUp(Window : PSDL_Window ; Renderer : PSDL_Renderer);
begin
  SDL_DestroyRenderer(Renderer);
  SDL_DestroyWindow(Window);
  SDL_Quit;
end;

end.