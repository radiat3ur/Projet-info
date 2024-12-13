Unit TypeEtCte;

interface

uses SDL2;

Type TPersonnage = (Duval, Eleve, Boutigny, Delaroche, Yohann, Yon, rien); // Type pour les joueurs
Type TCarte = (Blouse, Livre, Panier, Plateau, Reveil, Stethoscope, Dudu, Etudiant, DuoBoutigny, IsabelleDelaroche, YohannLepailleur, JeromeYon, Amphi, Laboratoire, Gymnase, Parking, RU, Shop, Bibliotheque, Infirmerie, Residence); //Type pour les cartes
Type TNomPiece = (Tillion, Labo, Gym, Parking_visiteurs, Self, INSA_Shop, Biblio, Inf, Chambre);  

Type TPaquet = Array of TCarte;
  
Type TJoueur = Record
	nom : TPersonnage;
	main : TPaquet;
	x, y : Integer;
  PionTextures: PSDL_Texture;
end;

Type TJoueurs = Array of TJoueur;

Type TCase = record
    estOccupee: Boolean;
    typePiece: TNomPiece;
    joueurID : Integer; 
end;

Type TPiece = record
    x,y,w,h : Integer;
    nom : TNomPiece;
end;

Type TPieces = array of TPiece;

Type TTabInt = array of Integer;

Type test = array of TSDL_Rect;

Type TabTextures = array of PSDL_Texture;


const
  // Constantes pour les dimensions de l'écran et du plateau de jeu
  SCREEN_WIDTH = 1920;
  SCREEN_HEIGHT = 1080;
  TILE_SIZE = 40; // Taille d'une case en pixels
  GRID_WIDTH = 22; // Nombre de colonnes sur la grille
  GRID_HEIGHT = 22; // Nombre de lignes sur la grille

  // Représente les murs et cases pouvant être traversées
  GRID: array[0..GRID_HEIGHT-1, 0..GRID_WIDTH-1] of Integer = (
      (9, 1, 1, 1, 1, 3, 9, 3, 9, 1, 1, 1, 1, 3, 9, 3, 9, 1, 1, 1, 1, 3),
      (8, 0, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 0, 2),
      (12, 4, 4, 4, 4, 2, 8, 2, 8, 0, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 0, 2),
      (9, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 0, 2),
      (12, 4, 4, 4, 4, 4, 0, 2, 8, 0, 0, 0, 0, 2, 8, 2, 12, 0, 4, 4, 4, 6),
      (9, 1, 1, 1, 1, 3, 8, 2, 12, 4, 0, 0, 4, 6, 8, 0, 1, 0, 1, 1, 1, 3),
      (8, 0, 0, 0, 0, 2, 8, 0, 5, 5, 4, 4, 5, 1, 0, 0, 0, 0, 0, 0, 0, 2),
      (8, 0, 0, 0, 0, 0, 0, 2, 9, 1, 1, 1, 3, 8, 0, 4, 4, 4, 4, 4, 4, 6),
      (12, 4, 0, 4, 4, 6, 8, 2, 8, 0, 0, 0, 2, 8, 2, 9, 1, 1, 1, 1, 1, 3),
      (9, 1, 0, 1, 1, 1, 0, 2, 8, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 0, 0, 2),
      (8, 4, 4, 4, 4, 0, 0, 2, 8, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 0, 0, 2),
      (8, 1, 1, 1, 3, 8, 0, 2, 8, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 2),
      (8, 0, 0, 0, 2, 8, 0, 2, 8, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 0, 0, 2),
      (8, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 2, 8, 2, 12, 4, 4, 4, 4, 4, 6),
      (8, 0, 0, 0, 2, 8, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 3),
      (12, 4, 4, 4, 6, 8, 0, 4, 0, 4, 4, 4, 4, 0, 4, 0, 0, 0, 0, 0, 0, 6),
      (9, 1, 1, 1, 1, 0, 2, 9, 0, 1, 1, 1, 1, 0, 3, 8, 0, 0, 4, 4, 4, 2),
      (12, 4, 4, 4, 4, 0, 2, 8, 0, 0, 0, 0, 0, 0, 2, 8, 2, 8, 1, 1, 1, 2),
      (8, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 2),
      (8, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 2),
      (8, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 2),
      (12, 4, 4, 4, 6, 12, 6, 12, 4, 4, 4, 4, 4, 4, 6, 12, 6, 12, 4, 4, 4, 12)
  );

  // Positions initiales des joueurs
  positionsInitX: TTabInt = (15, 0, 0, 14, 21, 21);
  positionsInitY: TTabInt = (1, 4, 17, 2, 14, 7);

implementation

end.