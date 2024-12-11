program main;

uses crt, SDL2, SDL2_image, SDL2_Mixer, SDL2_ttf, TypeEtCte, affichage, gestion, TypInfo;

var Window: PSDL_Window;
    Renderer: PSDL_Renderer;
    joueurs : TJoueurs;
    ResultatsDice : TTabInt;
    DiceTextures : TabTextures;
    nbDeplacement, joueurActuel : Integer;
    pieces : TPieces;
    cartesChoisies, paquetPieces, paquetArmes, paquetPersonnages, solution, paquetSansCartesCrime : TPaquet;
    IsRunning, presenceCarteCommune : Boolean;
    Event : TSDL_Event;
    Rect : TSDL_Rect;
    carteChoisie : TCarte;
    audio : PMix_Chunk;

begin
  InitSDL(Window, Renderer);
  menu(Renderer);
  InitPieces(Renderer, pieces);
  choixNbJoueurs(Renderer, joueurs);
  selectionJoueurs(Renderer, joueurs);
  SDL_Delay(750);
  initialisationPartie(Renderer, pieces, joueurs, joueurActuel, paquetPieces, paquetArmes, paquetPersonnages, solution, paquetSansCartesCrime);
  preventionJoueur(Renderer, joueurs, joueurActuel, 'C''est à toi de jouer !');
  IsRunning:=True;
  while IsRunning do
  begin
    gestionTour(Renderer, pieces, paquetArmes, paquetPersonnages, paquetPieces, solution, joueurs, joueurActuel, ResultatsDice, nbDeplacement);
    afficherTour(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, joueurActuel);
    SDL_RenderPresent(Renderer);
    SDL_Delay(16);
    if Event.type_ = SDL_QUITEV then
    begin
      IsRunning := False; // Arrêtez la boucle principale
      Halt;
    end;
  end;

  CleanUp(Window, Renderer);
end.