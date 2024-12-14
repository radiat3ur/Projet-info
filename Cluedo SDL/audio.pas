unit audio;

interface

uses SDL2, SDL2_Mixer, TypeEtCte, sysUtils, TypInfo;

procedure initisationMusiqueEtSon();
function chargerTextureDepuisAudio(nomDuFichier: String): PMix_Chunk;
function obtenirDureeAudio(audio: PMix_Chunk): Integer;
procedure lancerAudio(nomDuFichier: string; delais : Integer);
function chargerTextureDepuisMusique(nomDuFichier: String): PMix_Music;
procedure lancerMusique(musique : PMix_Music);
procedure arreterMusique();

implementation

procedure initisationMusiqueEtSon();
begin
  if Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 2048) < 0 then
    begin
      WriteLn('Erreur d''initialisation de SDL_mixer: ', Mix_GetError);
      Exit;
    end;
end;

function chargerTextureDepuisAudio(nomDuFichier: String): PMix_Chunk;
var audio: PMix_Chunk;
    chemin: AnsiString;
begin
  chemin := 'Cluedo SDL/meta/audio/' + nomDuFichier + '.mp3';
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
  obtenirDureeAudio := (audio^.alen div 8) * 1000 div MIX_DEFAULT_FREQUENCY;
end;

procedure lancerAudio(nomDuFichier: string ; delais : Integer);
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
  write(duree);
  SDL_Delay(duree + 500);

  Mix_FreeChunk(audio);
end;

function chargerTextureDepuisMusique(nomDuFichier: String): PMix_Music;
var musique: PMix_Music;
    chemin: AnsiString;
begin
  chemin := 'Cluedo SDL/meta/audio/' + nomDuFichier + '.mp3';
  musique := Mix_LoadMUS(PChar(chemin));

  if musique = nil then
  begin
    writeln('Erreur de chargement de l''audio : ', chemin, ' : ', Mix_GetError);
    Halt;
  end;

  chargerTextureDepuisMusique := musique;
end;

procedure lancerMusique(musique : PMix_Music);
begin
  if Mix_PlayMusic(musique, 0) < 0 then
  begin
    writeln('Erreur de lecture de l''audio : ', Mix_GetError);
    Halt;
  end;
end;

procedure arreterMusique();
begin
  Mix_HaltMusic();
end;

end.