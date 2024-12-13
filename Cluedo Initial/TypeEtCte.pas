Unit TypeEtCte;

interface

const
    MAX_PERSONNAGES = 6;

Type TPersonnages = (Duval, Jerome_YON, Yohann, Diane_Duval, Thomas_LECOURT, Jerome_Thibaut); // Type pour les joueurs
Type TCarte = (Amphi_Tillion, Labo, Cafeteria, Parking_visiteur, RU, BDE, BU, Infirmerie, Residence, Blouse, Stylo, Ordinateur_portable, Leocarte, Rapport_de_stage, Calculatrice, Dudu, Yon, Lepailleur, Diane, Lecourt, THIBAUT); //Type pour les cartes
Type TCouleur = (Black, Blue, Green, Cyan, Red, Magenta, Yellow, White);
Type TPiece = (Amphi_Tillionn, Laboo, Cafeteriaa, Parking_visiteurs, RUU, BDEE, BUU, Infirmeriee, Residencee, Couloir, Mur, Porte);
  
Type TPaquet = Array of TCarte;

Type TJoueur = Record
	nom : TPersonnages;
	main : TPaquet;
	x, y : Integer;
	piecePrecedente: TPiece;
	dansPiece: Boolean;
end;

Type TJoueurs =  Array of TJoueur;

Type TCase = record
    estOccupee: Boolean;
    typePiece: TPiece;
    couleur: TCouleur;
    joueurID : Integer; // 0 si pas de joueur, sinon numéro du joueur
end;

Type TPlateau = array[1..16, 1..21] of TCase;

Type Legende =  record
    Couleur: TCouleur;
    Texte: string;
  end;

TLegendes = array of Legende;

implementation

end.
