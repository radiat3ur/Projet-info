Unit TypeEtCte;

interface

Uses Crt;

const

  MAX_PERSONNAGES = 6;
  MAX_CARTES = 21;

Type Personnages = ('Prof 1', 'Prof 2', 'Prof 3', 'Prof 4', 'Prof 5', 'Prof 6');
Type Pieces = ('Piece 1', 'Piece 2', 'Piece 3', 'Pièce 4', 'Pièce 5', 'Pièce 6', 'Pièce 7', 'Pièce 8', 'Pièce 9');
Type Armes = ('Arme 1', 'Arme 2', 'Arme 3', 'Arme 4', 'Arme 5', 'Arme 6');
Type TCategorie = ('Personnage','Arme','Piece');

Type TCarte = Record
	categorie : TCategorie;
	nom : String;
end;

Type TPaquet = Array[1..MAX_CARTES] of TCarte;