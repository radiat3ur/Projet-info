program main;

uses
  crt, SDL2, SDL2_image, SDL2_ttf, TypeEtCte, affichage, gestion;

var
  Window: PSDL_Window;
  Renderer: PSDL_Renderer;
  IsRunning: Boolean;
  Board: PSDL_Texture;
  personnages: TJoueurs;
  DiceTextures: array[0..5] of PSDL_Texture;
  CurrentPlayer: Integer;
  DiceResults: TTabInt;
  nbrDeplacement, nbJoueurs : Integer;
  pieces : TPieces;
  font : PTTF_Font;
  Event : TSDL_Event;
  joueursSelectionnes : Array of Integer;

begin
  InitSDL(Window, Renderer);
  menu(Renderer);
  ChoixNbJoueurs(Renderer, nbJoueurs);
  SelectionJoueurs(Renderer, joueursSelectionnes, nbJoueurs);
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
    if Event.type_ = SDL_QUITEV then
    begin
      IsRunning := False; // Arrêtez la boucle principale
      Halt;
    end;
  end;

  TTF_CloseFont(font);
  TTF_Quit;
  CleanUp(DiceTextures, Board, personnages, Renderer, Window);
end.
