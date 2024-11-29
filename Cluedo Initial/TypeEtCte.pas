Unit TypeEtCte;

interface

const
    MAX_PERSONNAGES = 6;
    MAX_CARTES = 21;

Type TPersonnages = (Duval, Jerome_YON, Yohann, Diane_Duval, Thomas_LECOURT, Jerome_Thibaut); // Type pour les joueurs
Type TTout = (Blouse, Stylo, Ordinateur_portable, Leocarte, Rapport_de_stage, Calculatrice, Dudu, Yon, Lepailleur, Diane, Lecourt, THIBAUT, Amphi_Tillion, Labo, Cafeteria, Parking_visiteurs, RU, BDE, BU, Infirmerie, Residence, Couloir, Mur); //Type pour les cartes
Type TCategorie = (Piece, Arme, Personnage);
Type TCouleur = (Black, Blue, Green, Cyan, Red, Magenta, Yellow, White);
  

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

Type TPlateau = array[1..16, 1..21] of TCase;

implementation

end.
