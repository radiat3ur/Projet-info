program main;

uses
  crt, SDL2, SDL2_image, SDL2_ttf, TypeEtCte, affichage, gestion;

var
  Window: PSDL_Window;
  Renderer: PSDL_Renderer;
  IsRunning: Boolean;
  plateau: PSDL_Texture;
  joueurs: TJoueurs;
  DiceTextures: TabTextures;
  CurrentPlayer: Integer;
  DiceResults: TTabInt;
  nbrDeplacement : Integer;
  pieces : TPieces;
  font : PTTF_Font;
  Event : TSDL_Event;

begin
  InitSDL(Window, Renderer);
  menu(Renderer);
  ChoixNbJoueurs(Renderer, joueurs);
  SelectionJoueurs(Renderer, joueurs);
  InitCharacters(joueurs, CurrentPlayer);
  chargerPlateau(plateau, Renderer);
  SetLength(DiceTextures,6);
  chargerTexturesDices(Renderer, DiceTextures);
  chargerTexturesPions(Renderer,joueurs); // Charger les sprites des joueurs
  RollDice(DiceResults); // Initialiser avec un premier lancer de dés

  IsRunning := True;
  InitPieces(pieces);
  while IsRunning do
  begin
    HandleEvents(pieces, joueurs, CurrentPlayer, DiceResults,nbrDeplacement);
    Render(Renderer, plateau, joueurs, DiceResults, DiceTextures, nbrDeplacement, CurrentPlayer);
    SDL_Delay(16); // ~60 FPS
    if Event.type_ = SDL_QUITEV then
    begin
      IsRunning := False; // Arrêtez la boucle principale
      Halt;
    end;
  end;

  TTF_CloseFont(font);
  TTF_Quit;
  CleanUp(DiceTextures, plateau, joueurs, Renderer, Window);
end.
