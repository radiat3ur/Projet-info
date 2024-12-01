Unit TypeEtCte;

interface

uses SDL2;

const
    MAX_PERSONNAGES = 6;
    MAX_CARTES = 21;
    SCREEN_WIDTH = 1100;  // Largeur de la fenêtre (espace supplémentaire pour les dés)
    SCREEN_HEIGHT = 880;  // Hauteur de la fenêtre
    TILE_SIZE = 30;       // Taille d'une case (réduit pour adapter le plateau)
    GRID_WIDTH = 22;      // Nombre de colonnes sur la grille
    GRID_HEIGHT = 22;     // Nombre de lignes sur la grille

    // Grille étendue avec murs et cases traversables
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
        (8, 4, 4, 4, 4, 0, 0, 2, 8, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 2),
        (8, 1, 1, 1, 3, 8, 0, 2, 8, 0, 0, 0, 2, 8, 0, 0, 0, 0, 0, 0, 0, 2),
        (8, 0, 0, 0, 2, 8, 0, 2, 8, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 0, 0, 2),
        (8, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 2, 8, 2, 12, 4, 4, 4, 4, 4, 6),
        (8, 0, 0, 0, 2, 8, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 3),
        (12, 4, 4, 4, 6, 8, 0, 4, 0, 4, 4, 4, 4, 0, 4, 0, 0, 0, 0, 0, 0, 2),
        (8, 1, 1, 1, 1, 0, 2, 9, 0, 1, 1, 1, 1, 0, 3, 8, 0, 0, 4, 4, 4, 2),
        (8, 4, 4, 4, 4, 0, 2, 8, 0, 0, 0, 0, 0, 0, 2, 8, 2, 8, 1, 1, 1, 2),
        (8, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 2),
        (8, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 2),
        (8, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 2),
        (12, 4, 4, 4, 6, 12, 6, 12, 4, 4, 4, 4, 4, 4, 6, 12, 6, 12, 4, 4, 4, 12)
    );

Type TPersonnages = (Duval, Jerome_YON, Yohann, Diane_Duval, Thomas_LECOURT, Jerome_Thibaut); // Type pour les joueurs
Type TTout = (Blouse, Stylo, Ordinateur_portable, Leocarte, Rapport_de_stage, Calculatrice, Dudu, Yon, Lepailleur, Diane, Lecourt, THIBAUT, Amphi_Tillion, Laboratoire, Gymnase, Parking_visiteurs, RU, INSA_Shop, BU, Inf, Resid, Couloir, Mur); //Type pour les cartes
Type TCategorie = (Piece, Arme, Personnage);
Type TCouleur = (Black, Blue, Green, Cyan, Red, Magenta, Yellow, White);
Type TNomPiece = (Tillion, Labo, Gym, Parking, Self, Shop, Biblio, Infirmerie, Residence);  

Type TCarte = Record
    categorie : TCategorie;
    nom : TTout;
end;
  
Type TPaquet = Record
	liste : Array of TCarte;
	taille : Integer;
end;

Type TJoueur = Record
	nom : TPersonnages;
	main : TPaquet;
	x, y : Integer;
end;

Type TJoueurs = Record
	listeJoueurs : Array of TJoueur;
	taille : Integer;
end;

Type TCase = record
    estOccupee: Boolean;
    typePiece: TTout;
    couleur: TCouleur;
    joueurID : Integer; // 0 si pas de joueur, sinon numéro du joueur
end;

Type TPiece = record
    x,y,w,h : Integer;
    salle : TNomPiece;
end;

Type TPieces = array of TPiece;

Type TCharacter = record
    x, y: Integer;
    PionTextures: PSDL_Texture;
  end;

Type TCharacters = array[1..6] of TCharacter;

Type TTabInt = array of Integer;

implementation

end.