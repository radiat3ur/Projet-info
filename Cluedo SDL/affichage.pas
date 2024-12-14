unit affichage;

interface

uses SDL2, SDL2_image, SDL2_ttf, TypeEtCte, sysUtils, TypInfo;

procedure initSDL(var Window: PSDL_Window; var Renderer: PSDL_Renderer);
function coordonnees(x, y, w, h : Integer): TSDL_Rect;
function chargerTextureImage(Renderer: PSDL_Renderer; nomDuFichier: String): PSDL_Texture;
procedure afficherImage(Renderer: PSDL_Renderer; nomDuFichier: string; DestRect: PSDL_Rect);
procedure afficherImagesCentrees(Renderer: PSDL_Renderer; joueurs : TJoueurs ; joueurActuel : Integer);
function couleur(r, g, b, a: Integer): TSDL_Color;
function chargerTextureDepuisTexte(renderer:PSDL_Renderer; police:PTTF_Font; text:String; color: TSDL_Color):PSDL_Texture;
procedure afficherTexte(Renderer: PSDL_Renderer; text: String; taille, x, y: Integer; couleur: TSDL_Color);

procedure affichageMenu(Renderer : PSDL_Renderer ; selectionActuelle : Integer);
procedure affichageRegles(Renderer : PSDL_Renderer);
procedure affichageNarration(Renderer : PSDL_Renderer);

procedure afficherDes(Renderer: PSDL_Renderer; DiceTextures: TabTextures; ResultatsDice: TTabInt);
procedure afficherPions(Renderer : PSDL_Renderer ; joueurs : TJoueurs);
procedure preventionJoueur(Renderer : PSDL_Renderer ; joueurs : TJoueurs ; joueurActuel : Integer ; texte : String);
procedure afficherTour(Renderer: PSDL_Renderer; joueurs: TJoueurs; ResultatsDice: TTabInt; DiceTextures: TabTextures; nbDeplacement, joueurActuel: Integer);
procedure affichageTour(Renderer : PSDL_Renderer ; selectionActuelle : Integer);
procedure affichageAccusation(Renderer : PSDL_Renderer ; selectionActuelle : Integer);
procedure affichageVictoire(Renderer : PSDL_Renderer);
procedure CleanUp(Window : PSDL_Window ; Renderer : PSDL_Renderer);

implementation

// Initialisation de la SDL
procedure initSDL(var Window: PSDL_Window; var Renderer: PSDL_Renderer);
begin
  if SDL_Init(SDL_INIT_VIDEO) < 0 then
  begin
    writeln('Erreur d''initialisation SDL : ', SDL_GetError);
    Halt;
  end;

  Window := SDL_CreateWindow('Cluedo - Déplacement', SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, SCREEN_WIDTH, SCREEN_HEIGHT, SDL_WINDOW_FULLSCREEN); // mettre SDL_WINDOW_BORDERLESS pour la présentation
  if Window = nil then
  begin
    writeln('Erreur de création de fenêtre : ', SDL_GetError);
    SDL_Quit;
    Halt;
  end;

  Renderer := SDL_CreateRenderer(Window, -1, SDL_RENDERER_ACCELERATED);
  if Renderer = nil then
  begin
    writeln('Erreur de création de renderer : ', SDL_GetError);
    SDL_DestroyWindow(Window);
    SDL_Quit;
    Halt;
  end;
end;

function coordonnees(x, y, w, h : Integer): TSDL_Rect;
begin
  coordonnees.x := x;
  coordonnees.y := y;
  coordonnees.w := w;
  coordonnees.h := h;
end;

// Charger une texture à partir d'un fichier png
function chargerTextureImage(Renderer: PSDL_Renderer; nomDuFichier: String): PSDL_Texture;
var image: PSDL_Texture;
    chemin: AnsiString;
begin
  chemin := 'meta/' + nomDuFichier + '.png';
  image := IMG_LoadTexture(Renderer, PChar(chemin));

  if image = nil then
    Writeln('Erreur de chargement de l''image "', chemin, '": ', IMG_GetError);

  chargerTextureImage := image;
end;

procedure afficherImage(Renderer: PSDL_Renderer; nomDuFichier: string; DestRect: PSDL_Rect);
var texture: PSDL_Texture;
begin
  texture := chargerTextureImage(Renderer, nomDuFichier);

  if texture = nil then
  begin
    Writeln('Erreur : Impossible de charger la texture pour ', nomDuFichier, '. SDL_Error: ', IMG_GetError());
    Exit;
  end;

  SDL_RenderCopy(renderer, texture, nil, DestRect);

  SDL_DestroyTexture(texture);
end;

procedure afficherImagesCentrees(Renderer: PSDL_Renderer; joueurs : TJoueurs ; joueurActuel : Integer);
var i, j, n: Integer;
    totalWidth : Integer;
    destRect: TSDL_Rect;

begin
  n:=length(joueurs) - 1;
  totalWidth := n * 300;

  j:=0;
  for i := 0 to length(joueurs) - 1 do
    if i<>joueurActuel then
    begin
      destRect.x := (SCREEN_WIDTH - totalWidth) div 2 + j * 300;
      destRect.y := SCREEN_HEIGHT div 2 - 100;
      destRect.w := 300;
      destRect.h := 420;
      afficherImage(Renderer, GetEnumName(TypeInfo(TPersonnage), Ord(joueurs[i].nom)) + 'actuel', @destRect);
      j := j + 1;
    end;
end;

function couleur(r, g, b, a: Integer): TSDL_Color;
begin
  couleur.r := r;
  couleur.g := g;
  couleur.b := b;
  couleur.a := a; // l'opacité ne fonctionne pas
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
    Exit;
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

procedure afficherDes(Renderer: PSDL_Renderer; DiceTextures: TabTextures; ResultatsDice: TTabInt);
var
  DestRect: TSDL_Rect;
  Angle : Double;
  texture1, texture2 : PSDL_Texture;
begin
  Setlength(ResultatsDice, 2);
  // Emplacement, angle et taille du premier dé
  Angle:=-10.0;
  DestRect := coordonnees(SCREEN_WIDTH div 2 - 35, 60, TILE_SIZE * 3, TILE_SIZE * 3);
  texture1 := chargerTextureImage(Renderer, 'dé ' + IntToStr(ResultatsDice[0] + 1));
  SDL_RenderCopyEx(Renderer, texture1, nil, @DestRect, Angle, nil, SDL_FLIP_NONE);
    
  //  Emplacement, angle et taille du deuxième dé
  DestRect.x := SCREEN_WIDTH div 2 + 85;
  Angle:=10.0;
  texture2 := chargerTextureImage(Renderer, 'dé ' + IntToStr(ResultatsDice[1] + 1));
  SDL_RenderCopyEx(Renderer, texture2, nil, @DestRect, Angle, nil, SDL_FLIP_NONE);

  SDL_DestroyTexture(texture1);
  SDL_DestroyTexture(texture2);
end;

procedure afficherPions(Renderer: PSDL_Renderer; joueurs: TJoueurs);
var
  DestRect: TSDL_Rect;
  i: Integer;
begin
  for i := 0 to length(joueurs) - 1 do
  begin
    if joueurs[i].nom <> rien then
    begin
      DestRect := coordonnees(joueurs[i].x * TILE_SIZE, joueurs[i].y * TILE_SIZE, TILE_SIZE, TILE_SIZE);
      afficherImage(Renderer, 'pion ' + IntToStr(Ord(joueurs[i].nom) + 1), @DestRect);
    end;
  end;
end;

procedure preventionJoueur(Renderer : PSDL_Renderer ; joueurs : TJoueurs ; joueurActuel : Integer ; texte : String);
var DestRect : TSDL_Rect;
begin
  DestRect := coordonnees(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
  afficherImage(Renderer, 'prevention', @DestRect);
  afficherTexte(Renderer, texte, 70, 600, 500, couleur(163, 3, 3, 255));
  DestRect := coordonnees(100, 200, 500, 700);
  afficherImage(Renderer, GetEnumName(TypeInfo(TPersonnage), Ord(joueurs[joueurActuel].nom)), @DestRect);
  SDL_RenderPresent(Renderer);
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

  afficherPions(Renderer, joueurs);  
  afficherDes(Renderer, DiceTextures, ResultatsDice);
  afficherTexte(Renderer, 'Déplacements restants : ' + IntToStr(nbDeplacement), 25, SCREEN_WIDTH div 2 - 60, 200, couleur(0, 0, 0, 0));
  
  DestRect := coordonnees(0, SCREEN_HEIGHT-230, 180, 252);
  afficherImage(Renderer, GetEnumName(TypeInfo(TPersonnage), Ord(joueurs[joueurActuel].nom)) + 'actuel', @DestRect);

  Setlength(carteRect, length(joueurs[joueurActuel].main));
  for i := 0 to length(joueurs[joueurActuel].main) - 1 do // Parcourt le paquet
  begin
    carteRect[i] := coordonnees(i * 137 + 210, SCREEN_HEIGHT - 195, 135, 189);
    afficherImage(Renderer, 'cartes/' + GetEnumName(TypeInfo(TCarte), Ord(joueurs[joueurActuel].main[i])), @carteRect[i]);
  end;
end;

procedure affichageMenu(Renderer : PSDL_Renderer ; selectionActuelle : Integer);
var DestRect : TSDL_Rect;
begin
  SDL_RenderClear(Renderer);

  DestRect := coordonnees(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
  afficherImage(Renderer, 'menu', @DestRect);

  if selectionActuelle = 0 then
    afficherTexte(Renderer, '1. Afficher les règles du jeu', 75, SCREEN_WIDTH div 2 - 465, SCREEN_HEIGHT div 2 - 40, couleur(163, 3, 3, 0))
  else
    afficherTexte(Renderer, '1. Afficher les règles du jeu', 70, SCREEN_WIDTH div 2 - 440, SCREEN_HEIGHT div 2 - 40, couleur(0, 0, 0, 0));

  if selectionActuelle = 1 then
    afficherTexte(Renderer, '2. Commencer une nouvelle partie', 75, SCREEN_WIDTH div 2 - 570, SCREEN_HEIGHT div 2 + 80, couleur(163, 3, 3, 0))
  else
    afficherTexte(Renderer, '2. Commencer une nouvelle partie', 70, SCREEN_WIDTH div 2 - 520, SCREEN_HEIGHT div 2 + 80 , couleur(0, 0, 0, 0));

  if selectionActuelle = 2 then
    afficherTexte(Renderer, '3. Quitter', 75, SCREEN_WIDTH div 2 - 170, SCREEN_HEIGHT div 2 + 200 , couleur(163, 3, 3, 0))
  else
    afficherTexte(Renderer, '3. Quitter', 70, SCREEN_WIDTH div 2 - 165, SCREEN_HEIGHT div 2 + 200 , couleur(0, 0, 0, 0));

  SDL_RenderPresent(Renderer);
end;

procedure affichageTour(Renderer : PSDL_Renderer ; selectionActuelle : Integer);
begin
  afficherTexte(Renderer, 'Que voulez-vous faire ?', 40, SCREEN_WIDTH - 800, 305, couleur(163, 3, 3, 0));

  if selectionActuelle = 0 then
    afficherTexte(Renderer, '1. Formuler une hypothèse', 30, SCREEN_WIDTH - 800, 365, couleur(163, 3, 3, 0))
  else
    afficherTexte(Renderer, '1. Formuler une hyptohèse', 25, SCREEN_WIDTH - 800, 365, couleur(0, 0, 0, 0));

  if selectionActuelle = 1 then
    afficherTexte(Renderer, '2. Formuler une accusation', 30, SCREEN_WIDTH - 800, 405, couleur(163, 3, 3, 0))
  else
    afficherTexte(Renderer, '2. Formuler une accusation', 25, SCREEN_WIDTH - 800, 405, couleur(0, 0, 0, 0));

    if selectionActuelle = 2 then
    afficherTexte(Renderer, '3. Rien', 30, SCREEN_WIDTH - 800, 445, couleur(163, 3, 3, 0))
  else
    afficherTexte(Renderer, '3. Rien', 25, SCREEN_WIDTH - 800, 445, couleur(0, 0, 0, 0));

  SDL_RenderPresent(Renderer);
end;

procedure affichageAccusation(Renderer : PSDL_Renderer ; selectionActuelle : Integer);
begin
  afficherTexte(Renderer, 'Voulez-vous formuler une accusation ?', 35, SCREEN_WIDTH - 800, 305, couleur(163, 3, 3, 255));

  if selectionActuelle = 0 then
    afficherTexte(Renderer, 'Oui', 50, SCREEN_WIDTH - 600, 365, couleur(163, 3, 3, 0))
  else
    afficherTexte(Renderer, 'Oui', 45, SCREEN_WIDTH - 600, 365, couleur(0, 0, 0, 0));

  if selectionActuelle = 1 then
    afficherTexte(Renderer, 'Non', 50, SCREEN_WIDTH - 600, 425, couleur(163, 3, 3, 0))
  else
    afficherTexte(Renderer, 'Non', 45, SCREEN_WIDTH - 600, 425, couleur(0, 0, 0, 0));

  SDL_RenderPresent(Renderer);
end;

procedure affichageRegles(Renderer : PSDL_Renderer);
var DestRect : TSDL_Rect;
begin
  SDL_RenderClear(Renderer);
  DestRect := coordonnees(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
  afficherImage(Renderer, 'regles', @DestRect);
  SDL_RenderPresent(Renderer);
end;

procedure affichageNarration(Renderer : PSDL_Renderer);
var DestRect : TSDL_Rect;
begin
  SDL_RenderClear(Renderer);

  DestRect := coordonnees(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
  afficherImage(Renderer, 'narration', @DestRect);

  SDL_RenderPresent(Renderer);
end;

procedure affichageVictoire(Renderer : PSDL_Renderer);
var DestRect : TSDL_Rect;
begin
  SDL_RenderClear(Renderer);

  DestRect := coordonnees(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
  afficherImage(Renderer, 'victoire', @DestRect);
end;

procedure CleanUp(Window : PSDL_Window ; Renderer : PSDL_Renderer);
begin
  SDL_DestroyRenderer(Renderer);
  SDL_DestroyWindow(Window);
  SDL_Quit;
end;

end.