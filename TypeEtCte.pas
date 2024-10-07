Unit TypeEtCte;

interface

const
    MAX_PERSONNAGES = 6;
    MAX_CARTES = 21;

Type TPersonnages = (ProfAA, ProfBB, ProfCC, ProfDD, ProfEE, ProfFF); // Type pour les joueurs
Type TTout = (PieceA, PieceB, PieceC, PieceD, PieceE, PieceF, PieceG, PieceH, PieceI,ArmeA, ArmeB, ArmeC, ArmeD, ArmeE, ArmeF, ProfA, ProfB, ProfC, ProfD, ProfE, ProfF);
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