unit gestion;

interface

uses SDL2, TypeEtCte;

function creerPiece(x,y,w,h:Integer;salle:TNomPiece):TPiece;
procedure InitPieces(var pieces : TPieces);
procedure InitCharacters(var personnages: TCharacters; var CurrentPlayer: Integer);
function estDansPiece(pieces : TPieces ; xJ, yJ : Integer):Boolean;
procedure RollDice(var DiceResults: TTabInt);
procedure HandleEvents(pieces : TPieces ; var personnages: TCharacters; var CurrentPlayer: Integer; var DiceResults: TTabInt; var nbrDeplacement: Integer);

implementation

function creerPiece(x,y,w,h:Integer;salle:TNomPiece):TPiece;
begin
  creerPiece.x := x;
  creerPiece.y := y;
  creerPiece.w := w;
  creerPiece.h := h;
  creerPiece.salle := salle
end;

procedure InitPieces(var pieces : TPieces);

begin
  SetLength(Pieces,9);
  pieces[0] := creerPiece(0,0,6,3,Tillion);
  pieces[1] := creerPiece(8,0,6,6,Labo);
  pieces[2] := creerPiece(16,0,6,5,Gym);
  pieces[3] := creerPiece(0,5,6,4,Parking);
  pieces[4] := creerPiece(0,11,5,5,Self);
  pieces[5] := creerPiece(0,18,5,4,Shop);
  pieces[6] := creerPiece(7,16,8,6,Biblio);
  pieces[7] := creerPiece(17,17,5,5,Infirmerie);
  pieces[8] := creerPiece(15,8,7,6,Residence);
end;

procedure InitCharacters(var personnages: TCharacters; var CurrentPlayer: Integer);
begin
  personnages[1].x := 0;
  personnages[1].y := 4;
  personnages[2].x := 0;
  personnages[2].y := 17;
  personnages[3].x := 14;
  personnages[3].y := 2;
  personnages[4].x := 21;
  personnages[4].y := 14;
  personnages[5].x := 21;
  personnages[5].y := 7;
  personnages[6].x := 15;
  personnages[6].y := 1;
  CurrentPlayer := 1;
end;

function estDansPiece(pieces : TPieces ; xJ, yJ : Integer):Boolean;
var i : Integer;
    valide : Boolean;

begin
  valide:=False;
  for i:=0 to 8 do
    if (xJ>=pieces[i].x) and (xJ<=pieces[i].x+pieces[i].w-1) and (yJ>=pieces[i].y) and (yJ<=pieces[i].y+pieces[i].h-1) then
    begin
      valide:=True;
      break;
    end;
  estDansPiece:=valide;
end;

// Fonction pour lancer les dés
procedure RollDice(var DiceResults: TTabInt);

begin
  Randomize;
  SetLength(DiceResults,2);
  DiceResults[0] := Random(6); // Résultat du premier dé
  DiceResults[1] := Random(6); // Résultat du second dé
end;

procedure HandleEvents(pieces : TPieces ; var personnages: TCharacters; var CurrentPlayer: Integer; var DiceResults: TTabInt; var nbrDeplacement: Integer);
var
  NewX, NewY: Integer;
  CurrentCell: Integer;
  Event: TSDL_Event;
  IsRunning: Boolean;
begin
  while SDL_PollEvent(@Event) <> 0 do
  begin
    case Event.type_ of
      SDL_QUITEV: IsRunning := False;
      SDL_KEYDOWN:
        begin
          NewX := personnages[CurrentPlayer].x;
          NewY := personnages[CurrentPlayer].y;
          CurrentCell := GRID[personnages[CurrentPlayer].y, personnages[CurrentPlayer].x];
          case Event.key.keysym.sym of
            SDLK_UP: if not (CurrentCell in [1, 3, 5, 9]) and (nbrDeplacement>0) then
            begin
              if not (estDansPiece(pieces,newX,newY) and estDansPiece(pieces,newX,newY-1)) then
                Dec(nbrDeplacement);
              Dec(NewY);
              personnages[CurrentPlayer].y := NewY;
            end;
            SDLK_RIGHT: if not (CurrentCell in [2, 3, 6, 10]) and (nbrDeplacement>0) then
            begin
              if not (estDansPiece(pieces,newX,newY) and estDansPiece(pieces,newX+1,newY)) then
                Dec(nbrDeplacement);
              Inc(NewX);
              personnages[CurrentPlayer].X := NewX;
            end;
            SDLK_DOWN: if not (CurrentCell in [4, 5, 6, 12]) and (nbrDeplacement>0) then
            begin
              if not (estDansPiece(pieces,newX,newY) and estDansPiece(pieces,newX,newY+1)) then
                Dec(nbrDeplacement);
              Inc(NewY);
              personnages[CurrentPlayer].y := NewY;
            end;
            SDLK_LEFT: if not (CurrentCell in [8, 9, 10, 12]) and (nbrDeplacement>0) then
            begin
              if not (estDansPiece(pieces,newX,newY) and estDansPiece(pieces,newX-1,newY)) then
                Dec(nbrDeplacement);
              Dec(NewX);
              personnages[CurrentPlayer].x := NewX;
            end;
            SDLK_RETURN :
            begin
              RollDice(DiceResults); // Relancer les dés pour le joueur suivant
              nbrDeplacement := DiceResults[0] + DiceResults[1] + 2;
              CurrentPlayer := (CurrentPlayer mod 6) + 1; // Passer au joueur suivant
            end;
          end;      
        end;
    end;
  end;
end;

end.