// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract RwaRegistry {
    address public admin;
    uint256 public nextAssetId = 1;

    struct Asset {
        string referenceCode;
        string metadataURI;
        uint256 totalUnits;
        bool active;
    }

    mapping(uint256 => Asset) public assets;
    mapping(uint256 => mapping(address => uint256)) public units;
    mapping(address => bool) public approved;

    event InvestorApprovalChanged(address indexed investor, bool approved);
    event AssetRegistered(uint256 indexed assetId, string referenceCode, uint256 totalUnits);
    event UnitsIssued(uint256 indexed assetId, address indexed investor, uint256 amount);
    event UnitsTransferred(uint256 indexed assetId, address indexed from, address indexed to, uint256 amount);

    modifier onlyAdmin() { require(msg.sender == admin, "not admin"); _; }

    constructor() { admin = msg.sender; approved[msg.sender] = true; }

    function setApproved(address investor, bool status) external onlyAdmin {
        approved[investor] = status;
        emit InvestorApprovalChanged(investor, status);
    }

    function registerAsset(string calldata code, string calldata uri, uint256 totalUnits)
        external onlyAdmin returns (uint256 id)
    {
        require(bytes(code).length > 0 && totalUnits > 0, "invalid asset");
        id = nextAssetId++;
        assets[id] = Asset(code, uri, totalUnits, true);
        emit AssetRegistered(id, code, totalUnits);
    }

    function issue(uint256 id, address investor, uint256 amount) external onlyAdmin {
        Asset storage a = assets[id];
        require(a.active && approved[investor] && amount > 0, "not eligible");
        require(totalIssued(id) + amount <= a.totalUnits, "supply exceeded");
        units[id][investor] += amount;
        totalIssued[id] += amount;
        emit UnitsIssued(id, investor, amount);
    }

    function transferUnits(uint256 id, address to, uint256 amount) external {
        require(approved[msg.sender] && approved[to] && amount > 0, "not eligible");
        require(units[id][msg.sender] >= amount, "insufficient units");
        units[id][msg.sender] -= amount;
        units[id][to] += amount;
        emit UnitsTransferred(id, msg.sender, to, amount);
    }

    mapping(uint256 => uint256) public totalIssued;
}
