Unit TypeEtCte;

interface

const
    MAX_PERSONNAGES = 6;
    MAX_CARTES = 21;

Type TPersonnages = (Duval, Jerome_YON, Yohann, Diane_Duval, Thomas_LECOURT, Jerome_Thibaut); // Type pour les joueurs
Type TTout = (Amphi_Tillion, Labo, Cafeteria, Parking_visiteur, MAGRC_02_04_06, BDE, Bibliotheque, Infirmerie, Residence, Blouse, Stylo, Ordinateur_portable, Leocarte, Rapport_de_stage, Calculatrice, Dudu, Yon, Lepailleur, Diane, Lecourt, THIBAUT); //Type pour les cartes
Type TCategorie = (Piece, Arme, Personnage);

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
end;

Type TJoueurs = Record
	listeJoueurs : Array of TJoueur;
	taille : Integer;
end;

implementation

end.
