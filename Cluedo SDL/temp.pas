procedure hypothese(Renderer: PSDL_Renderer; paquetPieces, paquetArmes, paquetPersonnages: TPaquet; 
    joueurActuel: Integer; joueurs: TJoueurs; var temoinChoisi: Integer);
var
  Event: TSDL_Event;
  SelectionTerminee: Boolean;
begin
  SelectionTerminee := False;
  temoinChoisi := -1;

  SDL_SetRenderDrawColor(Renderer, 255, 255, 255, 255); // Fond blanc
  SDL_RenderClear(Renderer);

  afficherTexte(Renderer, 'Choisissez un témoin :', 30, SCREEN_WIDTH - 500 , 150, Couleur(163, 3, 3, 255));
  // Affichez les joueurs ici...

  SDL_RenderPresent(Renderer);

  // Gérer les événements
  while SDL_PollEvent(@Event) <> 0 do
  begin
    case Event.type_ of
      SDL_MOUSEBUTTONDOWN:
        begin
          // Vérifiez si un joueur est sélectionné
          temoinChoisi := ...; // Logique pour trouver le joueur cliqué
          SelectionTerminee := True;
        end;
      SDL_QUITEV: 
        Halt;
    end;
  end;

  if SelectionTerminee then
    Exit;
end;
