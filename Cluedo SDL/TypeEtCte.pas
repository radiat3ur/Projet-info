Unit TypeEtCte;

interface

uses SDL2;

const
    MAX_PERSONNAGES = 6;
    MAX_CARTES = 21;
    SCREEN_WIDTH = 1920;  // Largeur de la fenêtre (espace supplémentaire pour les dés)
    SCREEN_HEIGHT = 1080;  // Hauteur de la fenêtre
    TILE_SIZE = 40;       // Taille d'une case (réduit pour adapter le plateau)
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
        (12, 4, 4, 4, 6, 8, 0, 4, 0, 4, 4, 4, 4, 0, 4, 0, 0, 0, 0, 0, 0, 6),
        (8, 1, 1, 1, 1, 0, 2, 9, 0, 1, 1, 1, 1, 0, 3, 8, 0, 0, 4, 4, 4, 2),
        (8, 4, 4, 4, 4, 0, 2, 8, 0, 0, 0, 0, 0, 0, 2, 8, 2, 8, 1, 1, 1, 2),
        (8, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 8, 0, 0, 0, 2),
        (8, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 2),
        (8, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 0, 0, 0, 2, 8, 2, 8, 0, 0, 0, 2),
        (12, 4, 4, 4, 6, 12, 6, 12, 4, 4, 4, 4, 4, 4, 6, 12, 6, 12, 4, 4, 4, 12)
    );

Type TPersonnage = (Duval, Eleve, Boutigny, Lecourt, Yohann, Yon, rien); // Type pour les joueurs
Type TNomCarte = (Blouse, Livre, Panier, Plateau, Reveil, Stethoscope, Dudu, Etudiant, DuoBoutigny, ThomasLecourt, YohannLepailleur, JeromeYon, Amphi, Laboratoire, Gymnase, Parking, RU, Shop, Bibliotheque, Infirmerie, Residence); //Type pour les cartes
Type TCategorie = (Piece, Arme, Personnage);
Type TCouleur = (Black, Blue, Green, Cyan, Red, Magenta, Yellow, White);
Type TNomPiece = (Tillion, Labo, Gym, Parking_visiteurs, Self, INSA_Shop, Biblio, Inf, Chambre);  

Type TCarte = Record
    categorie : TCategorie;
    nom : TNomCarte;
end;

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
    couleur: TCouleur;
    joueurID : Integer; // 0 si pas de joueur, sinon numéro du joueur
end;

Type TPiece = record
    x,y,w,h : Integer;
    salle : TNomPiece;
end;

Type TPieces = array of TPiece;

Type TTabInt = array of Integer;

Type test = array of TSDL_Rect;

const
  positionsInitiales: array[Duval..Yon] of record
    x, y: Integer;
  end = (
    (x: 15; y: 1), // Position prédéfinie pour Duval
    (x: 0; y: 4),  // Position prédéfinie pour Jerome_YON
    (x: 0; y: 17), // Position prédéfinie pour Yohann
    (x: 14; y: 2), // Position prédéfinie pour Diane_Duval
    (x: 21; y: 14),// Position prédéfinie pour Thomas_LECOURT
    (x: 21; y: 7)  // Position prédéfinie pour Jerome_Thibaut
  );

  personnagesDisponibles: array[0..5] of TPersonnage = (
    Duval, Eleve, Boutigny, Lecourt, Yohann, Yon
  );

Type TabTextures = array of PSDL_Texture;

implementation

end.