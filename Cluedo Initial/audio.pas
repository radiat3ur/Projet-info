Unit audio;

interface

Uses SDL2, SDL2_Mixer;

procedure annonceTour(joueurActuel: Integer);

implementation

procedure annonceTour(joueurActuel: Integer);
var music: PMix_Music;
begin
  if Mix_OpenAudio(22050, AUDIO_S16, 2, 4096) < 0 then halt;
  case joueurActuel of
    0: music := Mix_LoadMUS('son/joueur1.wav');
    1: music := Mix_LoadMUS('son/joueur2.wav');
    2: music := Mix_LoadMUS('son/joueur3.wav');
    3: music := Mix_LoadMUS('son/joueur4.wav');
    4: music := Mix_LoadMUS('son/joueur5.wav');
    5: music := Mix_LoadMUS('son/joueur6.wav');
  end;

  if music <> nil then
  begin
    Mix_PlayMusic(music, 0); // 1 lecture
    SDL_Delay(3000);         
    Mix_FreeMusic(music);
  end;

  Mix_CloseAudio;
end;

end.