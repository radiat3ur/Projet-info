unit audio;

interface

uses SDL2, SDL2_Mixer, TypeEtCte, sysUtils, TypInfo;

function chargerTextureDepuisAudio(nomDuFichier: String): PMix_Chunk;
function obtenirDureeAudio(audio: PMix_Chunk): Integer;
procedure lancerAudio(nomDuFichier: string; delais : Integer);
function chargerTextureDepuisMusique(nomDuFichier: String): PMix_Chunk;
procedure lancerMusique(nomDuFichier: string);

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

function obtenirDureeAudio(audio: PMix_Chunk): Integer;
begin
  // Assuming audio is in 16-bit stereo format
  obtenirDureeAudio := (audio^.alen div 4) * 1000 div MIX_DEFAULT_FREQUENCY;
end;

procedure lancerAudio(nomDuFichier: string; delais : Integer);
var audio: PMix_Chunk;
    duree : Integer;
begin
  audio := chargerTextureDepuisAudio(nomDuFichier);

  if Mix_PlayChannel(-1, audio, 0) < 0 then
  begin
    writeln('Erreur de lecture de l''audio : ', Mix_GetError);
    Halt;
  end;

  Mix_PlayChannel(-1, audio, 0);

  duree := obtenirDureeAudio(audio);
  SDL_Delay(duree + 500);

  Mix_FreeChunk(audio);
end;

end.