Unit gestion;

interface

Uses Crt, TypeEtCte;

procedure initialisationPaquet(var paquetPieces, paquetArmes, paquetPersonnages : TPaquet);
procedure selectionCartesCrime(paquetPieces, paquetArmes, paquetPersonnages : TPaquet; var solution, paquetSansCartesCrime : TPaquet);
procedure melangerPaquet(var paquetSansCartesCrime : TPaquet);
procedure initialisationJoueurs(nbJoueurs : Integer ; var joueurs : TJoueurs);
procedure distributionCartesJoueurs(paquetSansCartesCrime : TPaquet ; nbJoueurs : Integer ; var joueurs : TJoueurs);
procedure initialisationPartie(nbJoueurs : Integer ; var joueurs : TJoueurs ; var paquetSansCartesCrime, solution : TPaquet);
function choixAction(choix : Integer) : Boolean;

implementation

procedure initialisationPaquet(var paquetPieces, paquetArmes, paquetPersonnages : TPaquet);
var i : Integer;

begin
    paquetPieces.taille:=9;
    SetLength(paquetPieces.liste, paquetPieces.taille);
    for i:=0 to paquetPieces.taille-1 do
    begin
        paquetPieces.liste[i].categorie:=Piece;
        paquetPieces.liste[i].nom:=TTout(i);
    end;

    paquetArmes.taille:=6;
    SetLength(paquetArmes.liste, paquetArmes.taille);
    for i:=0 to paquetArmes.taille-1 do
    begin
        paquetArmes.liste[i].categorie:=Arme;
        paquetArmes.liste[i].nom:=TTout(i+paquetPieces.taille);
    end;

    paquetPersonnages.taille:=6;
    SetLength(paquetPersonnages.liste, paquetPersonnages.taille);
    for i:=0 to paquetPersonnages.taille-1 do
    begin
        paquetPersonnages.liste[i].categorie:=Personnage;
        paquetPersonnages.liste[i].nom:=TTout(i+paquetPieces.taille+paquetArmes.taille);
    end;
end;

procedure selectionCartesCrime(paquetPieces, paquetArmes, paquetPersonnages : TPaquet; var solution, paquetSansCartesCrime : TPaquet);
var i, randomIndex, indexPaquet : Integer ;

begin
    Randomize;
    solution.taille:=3;
    SetLength(solution.liste, solution.taille);
    randomIndex:=Random(paquetPieces.taille);
    solution.liste[0]:=paquetPieces.liste[randomIndex];
    randomIndex:=Random(paquetArmes.taille);
    solution.liste[1]:=paquetArmes.liste[randomIndex];
    randomIndex:=Random(paquetPersonnages.taille);
    solution.liste[2]:=paquetPersonnages.liste[randomIndex];

    paquetSansCartesCrime.taille:=18;
    SetLength(paquetSansCartesCrime.liste, paquetSansCartesCrime.taille);
    indexPaquet:=0;

    for i:=0 to paquetPieces.taille-1 do
    begin  
        if (paquetPieces.liste[i].nom<>solution.liste[0].nom) then
        begin
            paquetSansCartesCrime.liste[indexPaquet]:=paquetPieces.liste[i];
            indexPaquet:=indexPaquet+1;
        end;
    end;

    for i:=0 to paquetArmes.taille-1 do
    begin  
        if (paquetArmes.liste[i].nom<>solution.liste[1].nom) then
        begin
            paquetSansCartesCrime.liste[indexPaquet]:=paquetArmes.liste[i];
            indexPaquet:=indexPaquet+1;
        end;
    end;

    for i:=0 to paquetPersonnages.taille-1 do
    begin  
        if (paquetPersonnages.liste[i].nom<>solution.liste[2].nom) then
        begin
            paquetSansCartesCrime.liste[indexPaquet]:=paquetPersonnages.liste[i];
            indexPaquet:=indexPaquet+1;
        end;
    end;
end;

procedure melangerPaquet(var paquetSansCartesCrime : TPaquet);
var i, j : Integer ; temp : TCarte ;

begin
    Randomize;
    // Parcourir paquet à l'envers
    for i:=paquetSansCartesCrime.taille-1 downto 1 do
    begin
        // Prendre un index entre 0 et i
        j:=Random(i+1);
        // Echanger cartes index i avec index j (temp sert de stock)
        temp:=paquetSansCartesCrime.liste[i];
        paquetSansCartesCrime.liste[i]:=paquetSansCartesCrime.liste[j];
        paquetSansCartesCrime.liste[j]:=temp;
    end;
end;

procedure initialisationJoueurs(nbJoueurs : Integer; var joueurs : TJoueurs);
var
  i: Integer;
begin
  joueurs.taille := nbJoueurs;
  
  // Initialiser les mains de chaque joueur (vide au départ)
  for i := 0 to nbJoueurs - 1 do
  begin
    SetLength(joueurs.listeJoueurs[i].main.liste, 0); // Pas de cartes au début
    joueurs.listeJoueurs[i].main.taille := 0;
  end;
end;

procedure distributionCartesJoueurs(paquetSansCartesCrime : TPaquet; nbJoueurs : Integer ; var joueurs : TJoueurs);
var
    i, j, indexPaquet : Integer;
begin
    indexPaquet := 0;
    
    if (nbJoueurs in [2,3,6]) then
    begin
        for i := 0 to nbJoueurs - 1 do
        begin
            SetLength(joueurs.listeJoueurs[i].main.liste, (18 div nbJoueurs));
            for j := 0 to (18 div nbJoueurs) - 1 do
            begin
                joueurs.listeJoueurs[i].main.liste[j] := paquetSansCartesCrime.liste[indexPaquet];
                writeln(joueurs.listeJoueurs[i].main.liste[j].nom);
                indexPaquet := indexPaquet + 1;
            end;
        end;
    end
    else if (nbJoueurs in [4,5]) then
    begin
        // Distribuer les cartes aux deux premiers joueurs
        for i := 0 to 1 do
        begin
            SetLength(joueurs.listeJoueurs[i].main.liste, (18 div nbJoueurs));
            for j := 0 to (18 div nbJoueurs) - 1 do
            begin
                joueurs.listeJoueurs[i].main.liste[j] := paquetSansCartesCrime.liste[indexPaquet];
                indexPaquet := indexPaquet + 1;
            end;
        end;
        
        // Distribuer les cartes aux autres joueurs (avec une carte supplémentaire)
        for i := 2 to nbJoueurs - 1 do
        begin
            SetLength(joueurs.listeJoueurs[i].main.liste, (18 div nbJoueurs) + 2);
            for j := 0 to (18 div nbJoueurs)+1 do
            begin
                joueurs.listeJoueurs[i].main.liste[j] := paquetSansCartesCrime.liste[indexPaquet];
                indexPaquet := indexPaquet + 1;
            end;
        end;
    end;
end;

procedure initialisationPartie(nbJoueurs : Integer ; var joueurs : TJoueurs ; var paquetPieces, paquetArmes, paquetPersonnage, paquetSansCartesCrime, solution : TPaquet);

begin
  initilisationPaquet(paquetPieces, paquetArmes, paquetPersonnages);
  selectionCartesCrime(paquetPieces, paquetArmes, paquetPersonnage, solution, paquetSansCartesCrime);
  melangerPaquet(paquetSansCartesCrime);
  initialisationJoueurs(nbJoueurs, joueurs);
  distributionCartesJoueurs(paquetSansCartesCrime, nbJoueurs, joueurs);
end;

function choixAction(choix : Integer) : Boolean;

begin
  read(choix);
  if choix=1 then
    choixAction:=True;
  else  
    choixAction:=False;
end;

end.