pragma solidity ^0.5.0;

import "/Users/shermanmonroe/Documents/GitHub/andrew/openzeppelin-solidity/contracts/access/Roles.sol";
import "./interface/ITrust.sol";
import "../VIP-181/interface/IATN.sol";

contract Trust is ITrust {

    /**
     * @dev The Authority Node is owned by a multisig wallet that requires 21 signatures. These signers are the Authority Nodes.
     */
    IATN public authority = IATN(address(0)); // TODO: insert ATN address

    using Roles for Roles.Role;

    event TrusteeAdded(address indexed account);
    event TrusteeRemoved(address indexed account);

    Roles.Role private _trustees;

    modifier trusteesOnly() {
        require(isTrustee(msg.sender), "Escrow: caller does not have the trustee role");
        _;
    }

    modifier authorityOnly() {
        require(getAuthority().isSubscribed(msg.sender), 'Escrow: caller is not Authority');
        _;
    }

    constructor () internal {
        _addTrustee(msg.sender);
    }

    function isTrustee(address account) public view returns (bool) {
        return _trustees.has(account);
    }

    function renounceTrust() public {
        _removeTrustee(msg.sender);
    }
    
    function getAuthority() public returns (IATN) {
        return authority;
    }

    function _addTrustee(address account) internal {
        require(account != address(0), 'Trust: zero address not allowed');
        _trustees.add(account);
        emit TrusteeAdded(account);
    }

    function _removeTrustee(address account) internal {
        _trustees.remove(account);
        emit TrusteeRemoved(account);
    }
}

