unit affichage;

interface

uses SDL2, SDL2_image, SDL2_ttf, TypeEtCte, sysUtils;

procedure InitSDL(var Window: PSDL_Window; var Renderer: PSDL_Renderer);
procedure LoadAssets(var Board: PSDL_Texture ; var Renderer: PSDL_Renderer);
function chargerTexture(Renderer: PSDL_Renderer; filename: String): PSDL_Texture;
function LoadTextureFromText(renderer:PSDL_Renderer; police:PTTF_Font; text:String; color: TSDL_Color):PSDL_Texture;
function Couleur(r, g, b, a: Integer): TSDL_Color;
procedure afficherTexte(Renderer: PSDL_Renderer; text: String; taille, x, y: Integer; couleur: TSDL_Color);
procedure menu(Renderer: PSDL_Renderer);
procedure LoadDiceTextures(Renderer: PSDL_Renderer ; var DiceTextures: array of PSDL_Texture);
procedure LoadPionTextures(Renderer : PSDL_Renderer ; var joueurs : TJoueurs);
procedure RenderDice(Renderer: PSDL_Renderer; DiceTextures: array of PSDL_Texture; DiceResults: TTabInt);
procedure Render(Renderer: PSDL_Renderer; Board: PSDL_Texture; joueurs: TJoueurs; DiceResults: TTabInt; DiceTextures: array of PSDL_Texture; nbrDeplacement: Integer);
procedure ChoixNbJoueurs(Renderer: PSDL_Renderer; var nbJoueurs: Integer);
procedure SelectionJoueurs(Renderer: PSDL_Renderer; var joueursSelectionnes: array of Integer; nbJoueurs: Integer);
procedure CleanUp(DiceTextures: array of PSDL_Texture; Board: PSDL_Texture; joueurs : TJoueurs; Renderer: PSDL_Renderer; Window: PSDL_Window);

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
      end;
    end;
    SDL_Delay(16); // Pour limiter la boucle (~60 FPS)
  end;

  // Nettoyage
  SDL_DestroyTexture(MenuTexture); // Libérer la texture après usage
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
procedure LoadPionTextures(Renderer : PSDL_Renderer ; var joueurs : TJoueurs);
var
  i: Integer;
begin
  for i := 0 to 5 do
    joueurs[i].PionTextures := chargerTexture(Renderer, 'pion '+IntToStr(i+1));
end;

procedure RenderDice(Renderer: PSDL_Renderer; DiceTextures: array of PSDL_Texture; DiceResults: TTabInt);
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
  DestRect.x := SCREEN_WIDTH div 2 + 40;
  SDL_RenderCopyEx(Renderer, DiceTextures[DiceResults[1]], nil, @DestRect, Angle2, nil, SDL_FLIP_NONE);
end;

procedure Render(Renderer: PSDL_Renderer; Board: PSDL_Texture; joueurs: TJoueurs; DiceResults: TTabInt; DiceTextures: array of PSDL_Texture; nbrDeplacement: Integer);
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

  for i := 0 to 5 do
  begin
    DestRect.x := joueurs[i].x * TILE_SIZE;
    DestRect.y := joueurs[i].y * TILE_SIZE;
    DestRect.w := TILE_SIZE;
    DestRect.h := TILE_SIZE;
    SDL_RenderCopy(Renderer, joueurs[i].PionTextures, nil, @DestRect);
  end;

  RenderDice(Renderer, DiceTextures, DiceResults);
  afficherTexte(Renderer, 'Deplacements restants: ' + IntToStr(nbrDeplacement), 14, SCREEN_WIDTH div 2 - 40, 60, Couleur(0, 0, 0, 0));

  SDL_RenderPresent(Renderer);
end;

procedure ChoixNbJoueurs(Renderer: PSDL_Renderer; var nbJoueurs: Integer);
var
  Event: TSDL_Event;
  IsRunning: Boolean;
begin
  IsRunning := True;
  nbJoueurs := 2; // Nombre par défaut
  while IsRunning do
  begin
    SDL_SetRenderDrawColor(Renderer, 255, 255, 255, 255); // Blanc
    SDL_RenderClear(Renderer);

    afficherTexte(Renderer, 'Choisir le nombre de joueurs (2-6):', 50, SCREEN_WIDTH div 2 - 300, 200, Couleur(0, 0, 0, 255));
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
    end;
  end;
end;

procedure SelectionJoueurs(Renderer: PSDL_Renderer; var JoueursSelectionnes: array of Integer; nbJoueurs: Integer);
var
  Event: TSDL_Event;
  IsRunning: Boolean;
  SelectedCount: Integer;
  PlayerRect: array[0..5] of TSDL_Rect; // Positions des images des joueurs
  PlayerTextures: array[0..5] of PSDL_Texture;
  i: Integer;
  MouseX, MouseY: Integer;
  SelectedFlags: array[0..5] of Boolean;

begin
  // Initialisation
  IsRunning := True;
  SelectedCount := 0;
  for i := 0 to 5 do
    SelectedFlags[i] := False;

  // Charger les textures des joueurs
  PlayerTextures[0] := chargerTexture(Renderer, 'Duval');
  PlayerTextures[1] := chargerTexture(Renderer, 'Eleve');
  PlayerTextures[2] := chargerTexture(Renderer, 'Boutigny');
  PlayerTextures[3] := chargerTexture(Renderer, 'Lecourt');
  PlayerTextures[4] := chargerTexture(Renderer, 'Yohann');
  PlayerTextures[5] := chargerTexture(Renderer, 'Yon');
  for i := 0 to 5 do
  begin
    PlayerRect[i].x := (i mod 2) * 200 + 100;  // Position en grille
    PlayerRect[i].y := (i div 2) * 200 + 100;
    PlayerRect[i].w := 150; // Largeur de l'image
    PlayerRect[i].h := 150; // Hauteur de l'image
  end;

  // Boucle d'affichage et de sélection
  while IsRunning do
  begin
    SDL_SetRenderDrawColor(Renderer, 255, 255, 255, 255); // Fond blanc
    SDL_RenderClear(Renderer);

    // Afficher les images des joueurs
    for i := 0 to 5 do
    begin
      if SelectedFlags[i] then
        SDL_SetRenderDrawColor(Renderer, 0, 255, 0, 255) // Bordure verte si sélectionné
      else
        SDL_SetRenderDrawColor(Renderer, 0, 0, 0, 255); // Bordure noire sinon
      SDL_RenderDrawRect(Renderer, @PlayerRect[i]); // Dessiner la bordure
      SDL_RenderCopy(Renderer, PlayerTextures[i], nil, @PlayerRect[i]); // Dessiner l'image
    end;

    // Afficher le texte d'instruction
    afficherTexte(Renderer, 'Cliquez pour selectionner ' + IntToStr(nbJoueurs) + ' joueurs.', 40, 100, 50, Couleur(0, 0, 0, 255));

    SDL_RenderPresent(Renderer);

    // Gérer les événements
    while SDL_PollEvent(@Event) = 1 do
    begin
      case Event.type_ of
        SDL_QUITEV:
          IsRunning := False;

        SDL_MOUSEBUTTONDOWN:
          begin
            MouseX := Event.button.x;
            MouseY := Event.button.y;

            // Vérifier si un joueur a été cliqué
            for i := 0 to 5 do
            begin
              if (MouseX >= PlayerRect[i].x) and (MouseX <= PlayerRect[i].x + PlayerRect[i].w) and
                 (MouseY >= PlayerRect[i].y) and (MouseY <= PlayerRect[i].y + PlayerRect[i].h) then
              begin
                if not SelectedFlags[i] then
                begin
                  if SelectedCount < nbJoueurs then
                  begin
                    SelectedFlags[i] := True;
                    joueursSelectionnes[SelectedCount] := i;
                    Inc(SelectedCount);
                  end;
                end
                else
                begin
                  SelectedFlags[i] := False;
                  Dec(SelectedCount);
                end;
              end;
            end;

            // Quitter la sélection si tous les joueurs sont sélectionnés
            if SelectedCount = nbJoueurs then
              IsRunning := False;
          end;
      end;
    end;
  end;

  // Libérer les textures
  for i := 0 to 5 do
    SDL_DestroyTexture(PlayerTextures[i]);
end;

// Nettoyage
procedure CleanUp(DiceTextures: array of PSDL_Texture; Board: PSDL_Texture; joueurs : TJoueurs; Renderer: PSDL_Renderer; Window: PSDL_Window);
var
  i: Integer;
begin
  for i := 0 to 5 do
    SDL_DestroyTexture(DiceTextures[i]);
  SDL_DestroyTexture(Board);
  for i := 0 to 5 do
    SDL_DestroyTexture(joueurs[i].PionTextures);
  SDL_DestroyRenderer(Renderer);
  SDL_DestroyWindow(Window);
  IMG_Quit;
  SDL_Quit;
end;

end.
