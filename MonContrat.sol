//SPDX-License-Identifier: Unlicense
// MonContrat.sol
pragma solidity ^0.8.7;

contract MonContrat {
    // Définir des variables d'état
    uint256 public compteur;
    address public proprietaire;
    address public newContractAddress; // Nouvelle adresse du contrat
    mapping(address => uint256) public balances;

    // Événement émis lorsqu'un utilisateur effectue une action
    event ActionEffectuee(address indexed utilisateur, uint256 valeur);
    event ContractUpgraded(address newAddress);

    // Modificateur pour restreindre l'accès à certaines fonctions
    modifier onlyOwner() {
        require(msg.sender == proprietaire, "Seul le proprietaire peut appeler cette fonction");
        _;
    }

    // Constructeur du contrat
    constructor() payable {
        proprietaire = msg.sender;
    }

// Fonction payable qui incrémente le compteur
    function envoyerFonds() external payable {
    require(msg.value > 0, "La valeur doit etre superieure a zero");
    
}

    function incrementerCompteur(uint256 valeur) external {
    require(valeur > 0, "La valeur doit etre superieure a zero");
    compteur += valeur;
    emit ActionEffectuee(msg.sender, valeur);
}

    // Fonction pour récupérer le solde du contrat
    function getSolde() external view returns (uint256) {
        return address(this).balance;
    }

    // Fonction pour transférer des fonds au propriétaire
    function retirerFonds() external onlyOwner {
        require(compteur >= 10, "Le compteur doit etre d'au moins 10");
        payable(proprietaire).transfer(address(this).balance);
    }

    // Fonction pour mettre à niveau le contrat vers une nouvelle version
    function upgradeContract(address _newContractAddress) external onlyOwner {
        newContractAddress = _newContractAddress;
        emit ContractUpgraded(_newContractAddress);
    }

    // Fonction pour migrer les fonds vers la nouvelle version du contrat
    function migrateFunds(address _newContractAddress) external onlyOwner {
        require(newContractAddress != address(0), "Nouvelle adresse de contrat non definie");
        payable(_newContractAddress).transfer(address(this).balance);
    }

    // Fonction pour définir le solde d'un utilisateur
    function definirSoldeUtilisateur(address utilisateur, uint256 montant) external onlyOwner {
        balances[utilisateur] = montant;
    }
}
