program main;

uses
  crt, SDL2, SDL2_image, SDL2_ttf, TypeEtCte, affichage, gestion;

var
  Window: PSDL_Window;
  Renderer: PSDL_Renderer;
  IsRunning: Boolean;
  Board: PSDL_Texture;
  personnages: TCharacters;
  DiceTextures: array[1..6] of PSDL_Texture;
  CurrentPlayer: Integer;
  DiceResults: TTabInt;
  nbrDeplacement: Integer;
  pieces : TPieces;

begin
  InitSDL(Window, Renderer);
  LoadAssets(Board, Renderer);
  LoadDiceTextures(Renderer, DiceTextures);
  LoadPionTextures(Renderer, personnages); // Charger les sprites des joueurs
  InitCharacters(personnages, CurrentPlayer);       // Initialiser les positions des joueurs
  RollDice(DiceResults); // Initialiser avec un premier lancer de dés

  IsRunning := True;
  InitPieces(pieces);
  while IsRunning do
  begin
    HandleEvents(pieces, personnages, CurrentPlayer, DiceResults,nbrDeplacement);
    Render(Renderer, Board, personnages, DiceResults, DiceTextures, nbrDeplacement);
    SDL_Delay(16); // ~60 FPS
  end;

  CleanUp(DiceTextures, Board, personnages, Renderer, Window);
end.