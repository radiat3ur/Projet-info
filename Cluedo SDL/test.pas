program CluedoMovementWithDice;

uses
  crt, SDL2, SDL2_image, SDL2_ttf, sysUtils, TypeEtCte;

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
    (8, 4, 4, 4, 4, 0, 0, 2, 8, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 2),
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

Type
  TCharacter = record
    x, y: Integer; // Position du personnage (en cases)
    PionTextures : PSDL_Texture; // Sprite du personnage
  end;

  TCharacters = array[1..6] of TCharacter;

  TTabInt = Array of Integer;

var
  Window: PSDL_Window;
  Renderer: PSDL_Renderer;
  Event: TSDL_Event;
  IsRunning: Boolean;
  Board: PSDL_Texture;
  personnages : TCharacters;
  DiceTextures: array[1..6] of PSDL_Texture;
  currentPlayer: Integer;

// Initialisation de SDL
// procedure InitSDL;
// begin
//   if SDL_Init(SDL_INIT_VIDEO) < 0 then
//   begin
//     Writeln('Erreur d''initialisation SDL: ', SDL_GetError);
//     Halt(1);
//   end;

//   Window := SDL_CreateWindow('Cluedo - Déplacement', SDL_WINDOWPOS_CENTERED,
//     SDL_WINDOWPOS_CENTERED, SCREEN_WIDTH, SCREEN_HEIGHT, SDL_WINDOW_SHOWN);
//   if Window = nil then
//   begin
//     Writeln('Erreur de création de fenêtre: ', SDL_GetError);
//     Halt(1);
//   end;

//   Renderer := SDL_CreateRenderer(Window, -1, SDL_RENDERER_ACCELERATED);
//   if Renderer = nil then
//   begin
//     Writeln('Erreur de création de renderer: ', SDL_GetError);
//     Halt(1);
//   end;
// end;

// function creerPiece(x,y,w,h:Integer;salle:TNomPiece):TPiece;
// begin
//   creerPiece.x := x;
//   creerPiece.y := y;
//   creerPiece.w := w;
//   creerPiece.h := h;
//   creerPiece.salle := salle
// end;

// procedure InitPieces(var pieces : TPieces);

// begin
//   SetLength(Pieces,9);
//   pieces[0] := creerPiece(0,0,6,3,Tillion);
//   pieces[1] := creerPiece(8,0,6,6,Labo);
//   pieces[2] := creerPiece(16,0,6,5,Gym);
//   pieces[3] := creerPiece(0,5,6,4,Parking);
//   pieces[4] := creerPiece(0,11,5,5,Self);
//   pieces[5] := creerPiece(0,18,5,4,Shop);
//   pieces[6] := creerPiece(7,16,8,6,Biblio);
//   pieces[7] := creerPiece(17,17,5,5,Infirmerie);
//   pieces[8] := creerPiece(15,8,7,6,Residence);
// end;

// function estDansPiece(pieces : TPieces ; xJ, yJ : Integer):Boolean;
// var i : Integer;
//     valide : Boolean;

// begin
//   valide:=False;
//   for i:=0 to 8 do
//     if (xJ>=pieces[i].x) and (xJ<=pieces[i].x+pieces[i].w-1) and (yJ>=pieces[i].y) and (yJ<=pieces[i].y+pieces[i].h-1) then
//     begin
//       valide:=True;
//       break;
//     end;
//   estDansPiece:=valide;
// end;

// function chargerTexture(Renderer: PSDL_Renderer; filename: String): PSDL_Texture;
// var image: PSDL_Texture;
//   chemin: AnsiString;
// begin
//   chemin := 'meta/' + filename + '.png';
//   image := IMG_LoadTexture(Renderer,PChar(chemin));

//   if image = nil then
//     writeln('Erreur de chargement de l''image : ', IMG_GetError);
//   chargerTexture := image;
// end;

// function LoadTextureFromText(renderer:PSDL_Renderer; police:PTTF_Font; text:String; color: TSDL_Color):PSDL_Texture;
// var surface: PSDL_Surface;
//   texture: PSDL_Texture;
//   text_compa: AnsiString;
// begin
//   text_compa := text;
//   surface := TTF_RenderText_Solid(police,PChar(text_compa),color);

//   texture := SDL_CreateTextureFromSurface(renderer,surface);
//   LoadTextureFromText := texture;
// end;

// procedure afficherTexte(text: String; taille: Integer; x,y: Integer; couleur: TSDL_COlor);
// var police : PTTF_Font;
//   texteTexture: PSDL_Texture;
//   textRect: TSDL_Rect;
// begin
//   textRect.x := x;
//   textRect.y := y;
//   textRect.w := 0;
//   textRect.h := 0;

//   if TTF_INIT = -1 then halt;

//   police := TTF_OpenFont('Roboto-Black.ttf',taille);

//   texteTexture := LoadTextureFromText(Renderer,police,text,couleur);

//   SDL_QueryTexture(texteTexture,nil,nil,@textRect.w,@textRect.h);

//   if SDL_RenderCopy(Renderer,texteTexture,nil,@textRect)<>0 then
//     Writeln('Erreur SDL: ', SDL_GetError());
  
//   TTF_CloseFont(police);
//   TTF_Quit();
//   SDL_DestroyTexture(texteTexture);
// end;

// Charger les textures des dés
// procedure LoadDiceTextures;
// var
//   i: Integer;
// begin
//   for i := 1 to 6 do
//     DiceTextures[i] := chargerTexture(Renderer, 'dé '+IntToStr(i));
// end;

// Charger les textures des pions
// procedure LoadPionTextures;
// var
//   i: Integer;
// begin
//   for i := 1 to 6 do
//     personnages[i].PionTextures := chargerTexture(Renderer, 'pion '+IntToStr(i));
// end;

// procedure InitCharacters;

// begin
//   personnages[1].x := 0;
//   personnages[1].y := 4;
//   personnages[2].x := 0;
//   personnages[2].y := 17;
//   personnages[3].x := 14;
//   personnages[3].y := 2;
//   personnages[4].x := 21;
//   personnages[4].y := 14;
//   personnages[5].x := 21;
//   personnages[5].y := 7;
//   personnages[6].x := 15;
//   personnages[6].y := 1;
//   CurrentPlayer := 1; // Le joueur 1 commence
// end;

// function Couleur(r,g,b,a:Integer):TSDL_Color;
// begin
//   Couleur.r := r;
//   Couleur.g := g;
//   Couleur.b := b;
//   Couleur.a := a;
// end;

// Charger les assets (plateau et personnage)
// procedure LoadAssets;
// var
//   Surface: PSDL_Surface;
// begin
//   // Charger le plateau
//   Surface := IMG_Load(PAnsiChar(AnsiString('meta/plateau.png')));
//   if Surface = nil then
//   begin
//     Writeln('Erreur de chargement de l''image du plateau: ', IMG_GetError);
//     Halt(1);
//   end;
//   Board := SDL_CreateTextureFromSurface(Renderer, Surface);
//   SDL_FreeSurface(Surface);

//   // // Charger le personnage
//   // Surface := IMG_Load(PAnsiChar(AnsiString('meta/character.png')));
//   // if Surface = nil then
//   // begin
//   //   Writeln('Erreur de chargement de l''image du personnage: ', IMG_GetError);
//   //   Halt(1);
//   // end;
//   // Character.sprite := SDL_CreateTextureFromSurface(Renderer, Surface);
//   // SDL_FreeSurface(Surface);

//   // Position initiale
//   // Character.x := 0;
//   // Character.y := 0;
// end;

// Fonction pour lancer les dés
// procedure RollDice(var DiceResults: TTabInt);

// begin
//   Randomize;
//   SetLength(DiceResults,2);
//   DiceResults[0] := Random(6) + 1; // Résultat du premier dé
//   DiceResults[1] := Random(6) + 1; // Résultat du second dé
// end;

// Gérer les événements pour le personnage et les dés
// procedure HandleEvents(pieces : TPieces; var DiceResults : TTabInt; var nbrDeplacement: Integer);
// var
//   NewX, NewY: Integer;
//   CurrentCell: Integer;
  
// begin
//   while SDL_PollEvent(@Event) <> 0 do
//   begin
//     case Event.type_ of
//       SDL_QUITEV: IsRunning := False;
//       SDL_KEYDOWN:
//         begin
//           NewX := personnages[CurrentPlayer].x;
//           NewY := personnages[CurrentPlayer].y;
//           CurrentCell := GRID[personnages[CurrentPlayer].y, personnages[CurrentPlayer].x];
//           case Event.key.keysym.sym of
//             SDLK_UP: if not (CurrentCell in [1, 3, 5, 9]) and (nbrDeplacement>0) then
//             begin
//               if not (estDansPiece(pieces,newX,newY) and estDansPiece(pieces,newX,newY-1)) then
//                 Dec(nbrDeplacement);
//               Dec(NewY);
//               personnages[CurrentPlayer].y := NewY;
//             end;
//             SDLK_RIGHT: if not (CurrentCell in [2, 3, 6, 10]) and (nbrDeplacement>0) then
//             begin
//               if not (estDansPiece(pieces,newX,newY) and estDansPiece(pieces,newX+1,newY)) then
//                 Dec(nbrDeplacement);
//               Inc(NewX);
//               personnages[CurrentPlayer].X := NewX;
//             end;
//             SDLK_DOWN: if not (CurrentCell in [4, 5, 6, 12]) and (nbrDeplacement>0) then
//             begin
//               if not (estDansPiece(pieces,newX,newY) and estDansPiece(pieces,newX,newY+1)) then
//                 Dec(nbrDeplacement);
//               Inc(NewY);
//               personnages[CurrentPlayer].y := NewY;
//             end;
//             SDLK_LEFT: if not (CurrentCell in [8, 9, 10, 12]) and (nbrDeplacement>0) then
//             begin
//               if not (estDansPiece(pieces,newX,newY) and estDansPiece(pieces,newX-1,newY)) then
//                 Dec(nbrDeplacement);
//               Dec(NewX);
//               personnages[CurrentPlayer].x := NewX;
//             end;
//             SDLK_RETURN :
//             begin
//               RollDice(DiceResults); // Relancer les dés pour le joueur suivant
//               nbrDeplacement := DiceResults[0] + DiceResults[1];
//               CurrentPlayer := (CurrentPlayer mod 6) + 1; // Passer au joueur suivant
//             end;
//           end;      
//         end;
//     end;
//   end;
// end;

// Afficher les dés
// procedure RenderDice(DiceResults : TTabInt);
// var
//   DestRect: TSDL_Rect;
//   Angle1, Angle2: Double;
// begin
//   // Définir les angles de rotation pour les dés
//   Angle1 := -10.0; // Inclinaison vers la gauche pour le premier dé
//   Angle2 := 10.0;  // Inclinaison vers la droite pour le second dé

//   // Afficher le premier dé (incliné vers la gauche)
//   DestRect.x := SCREEN_WIDTH - 280; // Position x du premier dé
//   DestRect.y := 100;                // Position y du premier dé
//   DestRect.w := TILE_SIZE * 3;      // Largeur du dé
//   DestRect.h := TILE_SIZE * 3;      // Hauteur du dé
//   SDL_RenderCopyEx(Renderer, DiceTextures[DiceResults[0]], nil, @DestRect, Angle1, nil, SDL_FLIP_NONE);

//   // Afficher le second dé (incliné vers la droite)
//   DestRect.x := SCREEN_WIDTH - 200; // Position x du second dé
//   DestRect.y := 100;                // Position y du second dé (légèrement décalé)
//   DestRect.w := TILE_SIZE * 3;
//   DestRect.h := TILE_SIZE * 3;
//   SDL_RenderCopyEx(Renderer, DiceTextures[DiceResults[1]], nil, @DestRect, Angle2, nil, SDL_FLIP_NONE);
// end;

// Rendu principal
// procedure Render(DiceResults : TTabInt ; nbrDeplacement : Integer);
// var
//   DestRect: TSDL_Rect;
//   i: Integer;
// begin
//   SDL_RenderClear(Renderer);

//   // Définir un fond blanc
//   SDL_SetRenderDrawColor(Renderer, 255, 255, 255, 255); // Blanc en RGBA
//   SDL_RenderClear(Renderer); // Remplir l'écran avec la couleur définie

//   // Dessiner le plateau
//   DestRect.x := 0;
//   DestRect.y := 0;
//   DestRect.w := TILE_SIZE * GRID_WIDTH;
//   DestRect.h := TILE_SIZE * GRID_HEIGHT;
//   SDL_RenderCopy(Renderer, Board, nil, @DestRect);

//   // Dessiner tous les personnages
//   for i := 1 to 6 do
//   begin
//     DestRect.x := personnages[i].x * TILE_SIZE;
//     DestRect.y := personnages[i].y * TILE_SIZE;
//     DestRect.w := TILE_SIZE;
//     DestRect.h := TILE_SIZE;
//     SDL_RenderCopy(Renderer, personnages[i].PionTextures, nil, @DestRect);
//   end;

//   // Dessiner les dés
//   RenderDice(DiceResults);
//   afficherTexte('Deplacements restants : '+IntToStr(nbrDeplacement),14,SCREEN_WIDTH-280,60,Couleur(0,0,0,0));

//   SDL_RenderPresent(Renderer);
// end;

// Nettoyage
// procedure CleanUp;
// var
//   i: Integer;
// begin
//   for i := 1 to 6 do
//     SDL_DestroyTexture(DiceTextures[i]);
//   SDL_DestroyTexture(Board);
//   for i := 1 to 6 do
//     SDL_DestroyTexture(personnages[i].PionTextures);
//   SDL_DestroyRenderer(Renderer);
//   SDL_DestroyWindow(Window);
//   IMG_Quit;
//   SDL_Quit;
// end;

var DiceResults : TTabInt;
  nbrDeplacement:Integer;
  pieces : TPieces;
// Programme principal
begin
  InitSDL;
  LoadAssets;
  LoadDiceTextures;
  LoadPionTextures; // Charger les sprites des joueurs
  InitCharacters;       // Initialiser les positions des joueurs
  RollDice(DiceResults); // Initialiser avec un premier lancer de dés

  IsRunning := True;
  InitPieces(pieces);
  while IsRunning do
  begin
    HandleEvents(pieces, DiceResults,nbrDeplacement);
    Render(DiceResults,nbrDeplacement);
    SDL_Delay(16); // ~60 FPS
  end;

  CleanUp;
end.