unit audio;

interface

uses SDL2, SDL2_Mixer, TypeEtCte, sysUtils, TypInfo;

function chargerTextureDepuisAudio(nomDuFichier: String): PMix_Chunk;
procedure lancerAudio(nomDuFichier: string);

implementation

function chargerTextureDepuisAudio(nomDuFichier: String): PMix_Chunk;
var audio: PMix_Chunk;
    chemin: AnsiString;
begin
  if Mix_OpenAudio(MIX_DEFAULT_FREQUENCY, MIX_DEFAULT_FORMAT,
    MIX_DEFAULT_CHANNELS, 4096) < 0 then Exit;

  chemin := 'meta/audio/' + nomDuFichier + '.mp3';
  audio := Mix_LoadWAV(PChar(chemin));

  if audio = nil then
  begin
    writeln('Erreur de chargement de l''audio : ', chemin, ' : ', Mix_GetError);
    Halt;
  end;

  chargerTextureDepuisAudio := audio;
end;

procedure lancerAudio(nomDuFichier: string);
var audio: PMix_Chunk;
begin
  audio := chargerTextureDepuisAudio(nomDuFichier);

  if Mix_PlayChannel(-1, audio, 0) < 0 then
  begin
    writeln('Erreur de lecture de l''audio : ', Mix_GetError);
    Halt;
  end;

  Mix_PlayChannel(-1, audio, 0);

  SDL_Delay(3000);

  Mix_FreeChunk(audio);
end;

end.