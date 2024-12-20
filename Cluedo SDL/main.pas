program main;

uses crt, SDL2, SDL2_image, SDL2_Mixer, SDL2_ttf, TypeEtCte, affichage, audio, gestion, TypInfo;

var Window: PSDL_Window;
    Renderer: PSDL_Renderer;
    joueurs : TJoueurs;
    ResultatsDice : TTabInt;
    DiceTextures : TabTextures;
    nbDeplacement, joueurActuel : Integer;
    pieces : TPieces;
    paquetPieces, paquetArmes, paquetPersonnages, solution, paquetSansCartesCrime : TPaquet;
    IsRunning: Boolean;
    musico : PMix_Music;

begin
  initSDL(Window, Renderer);
  initisationMusiqueEtSon();
  musico := chargerTextureDepuisMusique('musique narration');
  menu(Renderer, musico);
  initPieces(Renderer, pieces);
  choixNbJoueurs(Renderer, joueurs);
  selectionJoueurs(Renderer, joueurs);
  SDL_Delay(750);
  joueurActuel := 0;
  DiceTextures := Default(TabTextures);
  initPartie(Renderer, pieces, joueurs, joueurActuel, paquetPieces, paquetArmes, paquetPersonnages, solution, paquetSansCartesCrime);
  preventionJoueur(Renderer, joueurs, joueurActuel, 'C''est à toi de jouer !');
  lancerAudio('Prevention ' + GetEnumName(TypeInfo(TPersonnage), Ord(joueurs[joueurActuel].nom)), 5000);
  cliqueSuivant();
  IsRunning:=True;
  while IsRunning do
  begin
    gestionTour(Renderer, pieces, paquetArmes, paquetPersonnages, paquetPieces, solution, joueurs, joueurActuel, ResultatsDice, nbDeplacement);
    afficherTour(Renderer, joueurs, ResultatsDice, DiceTextures, nbDeplacement, joueurActuel);
    SDL_RenderPresent(Renderer);
    SDL_Delay(16);
  end;

  nettoyer(Window, Renderer);
end.