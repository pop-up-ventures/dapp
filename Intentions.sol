// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.36;

//   Ungravel, ungravel.eth, GroupWalletFactory, GroupWalletMaster, GroupWallet, ProxyWallet, TokenMaster, ProxyToken, 
//   PrePaidContract, AuctionMaster, BiddingProxy, intDeedMaster, extDeedMaster, IntDeedProxy, 
//   Intentions, UngravelGlobalToken by pepihasenfuss.eth 2016-2026, Copyright (c) 2026,2027

//   Thanks to Ethereum pioneers and open-source contributors around ENS:
//
//   Intentions and Ungravel is entirely based on Ethereum Name Service, "ENS", the domain name registry.
//
//   It was inspired by the Parity sampleContract, Consensys-ERC20 and OpenZeppelin smart contracts and many others.
//
//   Ungravel extends ENS to 25+ different EVM chains: Ungravel EVM Names across chains create an Ungravel Unified Name Space, UUNS.
//   Using UUNS domain names, "peter.from-his-team-on.base" can send USDC to "tom.at-his-team-to.arc" or tim.from-his-group.usdg".
//   
//   Is UUNS, Ungravel Unified Name Space, available on other EVM chains?

//   Yes.
//
//   UUNS unifies >25+ different EVM chains, it is most versatile to move USDC assets safely across CCTP, to build teams on stablecoin rails.
//
//   UUNS is available at: ".usdc" | ".eth"    | ".base"  | ".hyper" | ".one"    | ".usdg" | ".monad" | ".ava" | ".uni"  | ".celo" |  ".sonic"  |  ".tempo"
//                         ".ink"  | ".plasma" | ".matic" | ".zora"  | ".stable" | ".op"   | ".wc"    | ".son" | ."phrs" | ".arc"  |  ".xlayer" |  ".mega"
//

//   Summary: UUNS & Intentions form a massive chain-abstracting economic infrastructure, a protocol 
//   providing the x-chain capital allocation layer, connecting underbanked economies to investors, globally.
//
//   It is an economic framework, published and live as open-source protocols and APIs,
//   ready to let agents build on top of it and compose services. GroupWalletMaster, GroupWalletFactory, TokenMaster,
//   AuctionMaster, Intentions and UngravelGlobalShares contracts are all built on top of UUNS. All provide open APIs
//   to the agentic economy. Ungravel GroupWallet dApp is only the front-end, the proverbial tip of the iceberg.
//   The underlying infrastrucure is huge and quite powerful. It spans a couple of hundred smart contracts across 25+ chains.

//   The underlying infrastructure required "ChainScript", the x-chain, chain agnostic middleware engine. ChainScript deploys
//   contracts, keeps track of versions and bytecode verification, automates most of contract QA, and checks contract 
//   integrity automatically. It is a highly composable script language, built to organize large contract deployments.
//   Later on, it developed into a middleware engine that wraps node and API communication and connects to human or
//   agentic interactoins. It is the missing infrastructure of the application layer, infrastrucute running inside of clients.
//   Ungravel GroupWallet / Arc GroupWallet / Virtual Enterprises are front-end dApps that run 100% on ChainScript rails.
//   In simple terms: Each menu item or high-level agent call runs its appropriate ChainScript.
//   
//   Seen from the application layer, ChainScript abstracts from nodes, from the APIs of node providers, from chains & EVMs,
//   it abstracts from the underlying, native blockchain currency, e.g. "Ether" or "USDC". It handles transaction 
//   management, fail-over, redundancy, cost-control, gas cost computation, error handling. It wraps complex blockchain
//   interaction into atomic, composable script commands. 
//
//   What is the main advantage for application running on ChainScript?
//   An application running on ChainScript may use one business logic, written once in ChainScript, to be run on
//   any EVM compatible chain. It connects user and agents with nodes and blockchains.

//******************************************************************************************************************************************************************************************
//   ENS, ENSRegistryWithFallback, PublicResolver, Resolver, FIFS-Registrar, Registrar, AuctionRegistrar, BaseRegistrar, ReverseRegistrar, DefaultReverseResolver, ETHRegistrarController,
//   PriceOracle, SimplePriceOracle, StablePriceOracle, ENSMigrationSubdomainRegistrar, CustomRegistrar, Root, RegistrarMigration are contracts of "ENS", by Nick Johnson and team.
//
//   Copyright (c) 2018, True Names Limited / ENS Labs Limited
//
//   Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//   The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//******************************************************************************************************************************************************************************************

//   Description of "Intentions" smart contract, "intentions.ungravel.usdc"
//
//   Intentions is a contract that organizes LOIs, Letters of Intent, to indicate that a group wants to invest in another group.
//   In addition, Intentions logs and stores information about external investments into any Ungravel Group.
//   The contract keeps track of who is investing into whom and stores the value of each investment decision. 
//   Of real transactions of value, not only intentions.
//
//   Therefore, it keeps track of the market cap of each Ungravel Group, aka each GroupWallet.
//   Intentions is required to organize Funding Auctions and to adjust market caps appropriately, right after each auction.
//
//   Hint: Market caps are 100% derived from completed, successfully performed investment transactions. Valuation are entirely
//   based on actual transactions and actual value deposited and invested. This is crucial to have the overall valuation of 
//   an "Ungravel Society", aka the "space" consisting of all groups combined, "pegged" to real economic activity, 
//   not to speculation.
//
//   As a result, UngravelGlobalShares contract reflects overall market cap of the entire space, 
//   each Global Share has a price tag pegged against real-world valuations, not a guess, not an estimation, 
//   not speculation, not memes or hot air. Only algorithms. And transactions. Only facts, not hype or buzz.

//   UUNS unifies >25+ different EVM chains, it is useful to move USDC safely building on CCTP & compliant stablecoin rails.
//
//   UUNS is available at: ".usdc" | ".eth"    | ".base"  | ".hyper" | ".one"    | ".usdg" | ".monad" | ".ava" | ".uni"  | ".celo" |  ".sonic"  |  ".tempo"
//                         ".ink"  | ".plasma" | ".matic" | ".zora"  | ".stable" | ".op"   | ".wc"    | ".son" | ."phrs" | ".arc"  |  ".xlayer" |  ".mega"


interface IAGWP {                                                                // Abstract and access to GWP, Group Wallet Proxy contract, the Voting and Multi-Sig-contract of each group, a proxy, belonging to the GroupWallet Master
  function getIsOwner(address _owner)         external view returns (bool);
  function getOwners()                        external view returns (address[] memory);
  function getTransactionsCount()             external view returns (uint256);
  function getTransactionRecord(uint256 _tNb) external view returns (uint256);
  function getGWF()                           external view returns (address);
  function getAllTransactions()               external view returns (uint256[] memory transArr);
  function getMasterCopy()                    external view returns (address);
  function nameAuctionBidBucketLabel(bytes32 labelhash, address deedContract) external;
}
abstract contract AbstractTokenProxyInt {                                      // TokenProxy gives access to the Group Shares contract, aka TokenProxy contract, that comes with each group, a proxy contract that belongs to TokenMaster
  function name() external virtual view returns (string memory);
  function sellPrice() external view virtual returns (uint256 sp);
  function buyPrice() external view virtual returns (uint256 bp);
  function owner() external view virtual returns (address ow);
  function balanceOf(address tokenOwner) external virtual view returns (uint256 thebalance);
  function drainShares(bytes32 dHash, address from, address toReceiver) external virtual;
  function drainLegacyShares(bytes32 dHash, address from, address toReceiver) external virtual;
  function approve_v2d(address spender, uint256 tokens) external virtual;
  function transferFrom_78S(address from, address toReceiver, uint256 amount) external virtual;
  function tokenAllow(address tokenOwner,address spender) external virtual view returns (uint256 tokens);
  function transfer_G8l(address toReceiver, uint256 amount) external virtual;
  function sell_LA2(uint256 amount) external virtual;
  function upgradeTokenMaster(bytes32 dHash, address master) external payable virtual;
  function upgradeGWM(bytes32 dHash, address master) external payable virtual;
  function substring(bytes memory self, uint256 offset, uint256 len) public pure virtual returns(bytes memory);
}
abstract contract AbstractBaseRInt {                                            // BaseRegistrar belongs to the ENS - Ethereum Naming Service
  event NameMigrated(uint256 indexed id, address indexed owner, uint256 expires);
  event NameRegistered(uint256 indexed id, address indexed owner, uint256 expires);
  event NameRenewed(uint256 indexed id, uint256 expires);
  bytes32 public baseNode;                                                      // The namehash of the TLD, this registrar owns (eg, .eth, or .arb)
}
abstract contract AbstractEthRegControllerInt {                                 // RegistrarController belongs to ENS, it handles the purchase and rent of domain names, s.a. "my-company.eth" | "your-company.arb"
  mapping(bytes32=>uint256) public commitments;
  uint256 public minCommitmentAge;
  uint256 public maxCommitmentAge;
  address public nameWrapper;
  function rentPrice(string memory name, uint256 duration) external view virtual returns(uint256);
  function available(string memory name) external virtual view returns(bool);
}
interface IENSInt {                                                             // ENS Registry grants access to domain names and domain name properties
  event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
  event Transfer(bytes32 indexed node, address owner);
  event NewResolver(bytes32 indexed node, address resolver);
  event NewTTL(bytes32 indexed node, uint64 ttl);
  event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
  function setSubnodeRecord(bytes32 node, bytes32 label, address sub_owner, address sub_resolver, uint64 sub_ttl) external;
  function setOwner(bytes32 node, address set_owner) external;
  function owner(bytes32 node) external view returns (address);
  function recordExists(bytes32 node) external view returns (bool);
}
interface IResolverInt {                                                        // ENS Resolver provides the address and properties of domain names, s.a. "your-company.base", it resolves domain names to EVM addresses
  event AddrChanged(bytes32 indexed node, address a);
  event AddressChanged(bytes32 indexed node, uint256 coinType, bytes newAddress);
  event NameChanged(bytes32 indexed node, string name);
  event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
  event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
  event TextChanged(bytes32 indexed node, string indexed indexedKey, string key);
  event ContenthashChanged(bytes32 indexed node, bytes hash);
  function ABI(bytes32 node, uint256 contentTypes) external view returns (uint256, bytes memory);
  function addr(bytes32 node) external view returns (address payable);
  function text(bytes32 node, string calldata key) external view returns (string memory);
  function name(bytes32 node) external view returns (string memory);
  function contenthash(bytes32 node) external view returns (bytes memory);
  function setABI(bytes32 node, uint256 contentType, bytes calldata data) external;
  function setAddr(bytes32 node, address r_addr) external;
  function setAddr(bytes32 node, uint256 coinType, bytes calldata a) external;
  function setName(bytes32 node, string calldata _name) external;
  function setText(bytes32 node, string calldata key, string calldata value) external;
  function setAuthorisation(bytes32 node, address target, bool isAuthorised) external;
}
abstract contract AbsAuctionRegistrarInt {                                      // Auction Registrar is Vickrey Auction, controlled by Ungravel GroupWallets, in order to sell group shares to investors and to tame competition
  enum Mode { Open, Auction, Owned, Forbidden, Reveal, empty, Over }
  function startAuction_ge0(bytes32 _hash, uint256 revealP) public virtual payable;
  function state_pln(bytes32 _hash) public virtual view returns (Mode);
  function entries(bytes32 _hash) public virtual view returns (Mode, address, uint256, uint256, uint256, uint256, uint256, uint256);
}
abstract contract AbstractRrInt {                                               // Reverse Resolver and Reverse Default Resolver give access to the domain name, if only an address is given
  IResolverInt public defaultResolver;
  function node(address addr) external virtual pure returns (bytes32);
  function setName(string memory name) external virtual returns (bytes32);
}
abstract contract AbstractGwfInt {                                              // Group Wallet Factory, GWF, main Ungravel entry point coordinating Ungravel Groups and all activities, deploying ProxyGroupWallet, GWP, and ProxyToken, aka TokenProxy
  IResolverInt                        public  RESOLVER_CONTRACT;
  AbstractEthRegControllerInt         public  CONTROLLER_CONTRACT;
  AbstractBaseRInt                    public  BASE;
  AbstractRrInt                       public  REVERSE_CONTRACT;
  AbsAuctionRegistrarInt              public  auctionContract;
  function getProxyToken(bytes32 _domainHash) external view virtual returns (address p);
  function getGWProxy(bytes32 _dHash) external view virtual returns (address);
  function getIsOwner(bytes32 _dHash,address _owner) external view virtual returns (bool);
  function getOwner(bytes32 _domainHash) external view virtual returns (address);
  function domainReport(string calldata _dom,uint256 command) external payable virtual returns (uint256 report, address gwpc, address ptc, address gwfc, bytes memory structure);
  function getGWF() external view virtual returns (address);
  function tld() public view virtual returns (string memory);
}

//---------------------------------------------------------------------------------------------

// Attention: Any Group may send a LetterOfIntent, LOI, to any other group, except of itself.
// Groups MUST be a part of Ungravel Society, they MUST belong to the Ungravel mesh of groups, to UUNS.
// Investors may send the intention to invest into any target group, e.g. "silvias-bakery.eth", a certain nb of shares,
// to indicate that investor considers to participate in a Funding Auction to acquire the desired nb of shares or more.
// If no group - aka external investor - indicates interest and the intention to invest and to participate in
// a Funding Auction, the fund raising group, e.g. "silvias-bakery.eth", cannot invite external investors to invest in a Funding Auction.
// The group may organize an internal funding round, aka, group members deposit funding and will get compensated with group shares.
// This provides liquidity to the group and members may acquire additional group shares, if they want.
// Group members may participate in any Funding Auction at any time. External investments require a valid and provable Letter of Intent, the LOI.

// *** Hint: LOIs are also important in order to participate in and to profit from Ungravel Global Token, aka Ungravel Global Shares, in the future.
//           (Ungravel Global Shares, UNGRAVELS) ***
//           Ungravel Global Shares will compensate investing groups and will provide additional liquidity to Ungravel Groups.

contract Intentions {
    address         internal immutable masterCopy;                                                      // owner of contract 
    AbstractGwfInt internal GWF;                                                                        // current GWF contract of chain aka GroupWallet Factory

    uint256                                         public UNG_Mcap;                                    // total market cap of Ungravel Society on current chain, s.a. "mcap.arbitrum.arb" | "mcap.base.base", total sum of GWP marketCaps x1000
    address[]                                       private investors;                                  // investor contract GWP addresses, array

    mapping(address investor => uint256 balance)                           private balances;            // balance of investor in ETH at the time of LoI
    mapping(address investor => mapping(address target => uint256 shares)) private intended;            // nb of GroupShares to be acquired while taking part in a Funding Auctions: "The Intention" - seen from the investor
    mapping(address target   => address[] investors)                       private intentInv;           // target GWP to array of investor GWP contracts, seen from target groups

    mapping(address investor => mapping(address target => uint256 investmentAmount)) private invested;  // ETH or native currency amount, paid in a Funding Auctions, having completed Finalize Auction, seen from investor
    mapping(address investor => mapping(address target => uint256 shares          )) private acquired;  // nb of GroupShares acquired, participating in a Funding Auctions, having completed Finalize Auction, seen from investor

    mapping(address target   => mapping(address investor => uint256 investmentAmount)) private funded;  // ETH or native currency amount, received in a Funding Auctions, having completed an Auction, seen from target group
    mapping(address target   => mapping(address investor => uint256 shares))           private sold;    // nb of GroupShares sold, running a Funding Auction, having completed the Auction, seen from target group

    mapping(address investor => mapping(address target   => bytes32 spices)) private spice;             // bytes32 = uint256 spice value, seen from the investor
    mapping(address groupWP  => uint256 mcap1000)                            private marketCap;         // uint256 = market cap of individual groups in ETH or native currency x1000

    // ----------------------------------------------------------------------------------------
    
    uint256 private _guardCounter  = 1;
    address constant private K_ADD00       = address(0);
    uint256 constant private K_AMASK       = 0x000000000000000000000000ffffffffffffffffffffffffffffffffffffffff; // address mask 160 bits
    uint256 constant private K_TYPEMASK    = 0xf000000000000000000000000000000000000000000000000000000000000000; // command type = 4 bits

    event Deposit(address from, uint256 value);
    event Deployment(address owner, address theContract);
    event DeploymentIntentions(address theContract, bytes32 dhash);
    event LetterOfIntent(address theInvestorAddress, address targetGWP_Address, uint256 nbOfShares);
    event StoreInvestment(address theInvestorAddress, address targetGWP_Address, uint256 nbOfShares, uint256 pricePaid);
    event StoreFunding(address targetGWP_Address, address theInvestorAddress, uint256 nbOfShares, uint256 pricePaid);
    event ChangeGWF(address oldGWF, address newGWF);
    event Withdraw(address to, uint256 amount);

    modifier nonReentrant() {
      _guardCounter += 1;
      uint256 localCounter = _guardCounter;
      _;
      require(localCounter == _guardCounter,"re-entrance attack prohibited");
    }

    modifier ungravelGW(IAGWP gwp) {                                                  // gwp MUST BE valid contract, a GroupWalletProxy belonging to Ungravel
      require(                                                                        // GWP uses GWF contract
               address(gwp)!=K_ADD00                     &&
               isContract(address(gwp))                  &&
               address(gwp.getGWF())==address(getGWF()),
               "* no UngravelGroup!"
             );

      require(                                                                        // the requested GWP owns its own dName, s.a. "silvias-bakery.eth" | "vitalik.arb" | "peters-bar.opt"
               hashOfGWP(gwp)!=0x0 &&
               getGWF().getOwner(hashOfGWP(gwp))==address(gwp),
               "* no UngravelGroup2!"
             );

      require(
               address(getGWP(hashOfGWP(gwp)))==address(gwp),
               "* no UngravelGroup3!"
             );                                                                       // GWP belongs to Ungravel Society

      require(__isGW(address(gwp)),"* no UngravelGroup4!");                           // GWP belongs to Ungravel Unified Name Space

      _;
    }
    modifier onlyGWP() {
       require(__isGW(msg.sender),"only GWP!");
      _;
    }
    modifier onlyOwner() {
       require(masterCopy==msg.sender,"only Owner!");
      _;
    }
    modifier onlyGroupWallets(address _gw1, address _gw2) {
             require(
                      address(_gw1)!=K_ADD00                      && 
                      address(_gw2)!=K_ADD00                      &&
                      isContract(address(_gw1))                   && 
                      isContract(address(_gw2))                   && 
                      __isGW(_gw1)                                && 
                      __isGW(_gw2)                                &&
                      address(IAGWP(_gw1).getGWF())==address(GWF) &&
                      address(IAGWP(_gw2).getGWF())==address(GWF) &&
                      __isGwpOfUuns(_gw1)                         &&
                      __isGwpOfUuns(_gw2)
     ,"only Owners!");

      _;
    }
    
    function __selfbalance() private view returns (uint256 self) {                       // returns the balance of this contract
        assembly {
          self :=selfbalance()
        }
    }
    function __isGW(address _gw) private view returns(bool) {
      return ( 
               address(_gw)!=address(0)                        &&  // check not 0x00
               isContract(_gw)                                 &&  // check is contract
               address(IAGWP(_gw).getGWF())==address(GWF)      &&  // check relies on same GWF
               hashOfGWP(IAGWP(_gw))!=0x0                      &&  // does refer to domain name hash
               GWF.getOwner(hashOfGWP(IAGWP(_gw)))==_gw        &&  // _gw is owner of hash
               GWF.getGWProxy(hashOfGWP(IAGWP(_gw)))==_gw          // hash owned by _gw ---> _gw is Ungravel Group! (qed)
             );
    }
    function __isGwpOfUuns(address _gwp) private view returns(bool r) {
      r = (address(_gwp)!=K_ADD00) && isContract(address(_gwp)) && (address(IAGWP(_gwp).getGWF())==address(getGWF()));
      if (r==false) return r;

      bytes32 h = hashOfGWP(IAGWP(_gwp));

      r =  r && (h!=0x0) && (getGWF().getOwner(h)==address(_gwp));                    // the requested GWP owns its own dName, s.a. "silvias-bakery.eth" | "vitalik.arb" | "peters-bar.opt"
      if (r==false) return r;

      r = r && (address(getGWP(h))==address(_gwp));                                   // GWP belongs to Ungravel Society
      if (r==false) return r;

      return (r && __isGW(address(_gwp)));                                            // GWP belongs to Ungravel Unified Name Space
    }
    function isContract(address addr) internal view returns (bool) {
      uint256 size;
      assembly { size := extcodesize(addr) }
      return size > 0;
    }

    function getMasterCopy() public view returns (address) {                          // get deployer address / for future use: Master Contract address
      return masterCopy;
    }

    function getGWF() public view returns (AbstractGwfInt) {                          // get GroupWallet Factory contract
      return GWF;
    }

    function getRegController() public view returns (AbstractEthRegControllerInt) {   // get controller contract of ENS, for renting and renewing domain names
      return AbstractEthRegControllerInt(getGWF().CONTROLLER_CONTRACT());
    }

    function getAuctionMaster() public view returns (AbsAuctionRegistrarInt) {        // get AuctionMaster contract address
      return AbsAuctionRegistrarInt(getGWF().auctionContract());
    }

    function hashOfGWP(IAGWP _gwp) internal view returns (bytes32) {                  // get domain name hash of GroupWalletProxy, GWP
      return bytes32(_gwp.getTransactionRecord(uint256(uint160(address(getGWF())))));
    }

    function getGWP(bytes32 _dhash) internal view returns (IAGWP) {                   // get GroupWallet Proxy contract address of Group(_dhash)
      address gwp = getGWF().getGWProxy(_dhash);
      require(gwp!=address(0)&&isContract(gwp),"GW");
      return IAGWP(gwp);
    }

    function getPTC(bytes32 _dhash) internal view returns (AbstractTokenProxyInt) {   // get GroupToken  Proxy contract address of Group(_dhash)
      return AbstractTokenProxyInt(getGWF().getProxyToken(_dhash));
    }

    function getName(bytes32 _dhash) internal view returns (string memory) {          // get GWP group name, from hash
      return getPTC(_dhash).name();
    }
    
    function getNodeHash(string memory dn) internal view returns (bytes32) {          // get domain hash of "ethereum-foundation"
      return keccak256( abi.encode( AbstractBaseRInt(GWF.BASE()).baseNode(), keccak256( abi.encodePacked(dn) ) ) ); // domain e.g. 'ethereum-foundation'
    }

    function getDomainHash(string memory dn) internal view returns (bytes32) {        // get domain name hash of "ethereum-foundation" + ".stable"
      bytes32 hash = keccak256( abi.encode( AbstractBaseRInt(GWF.BASE()).baseNode(), 
                        keccak256( substring( bytes(dn), delArr(dn)[0]+1, delArr(dn)[1] - delArr(dn)[0] -1 ) ) ) ); // domain e.g. 'ethereum-foundation'
      return keccak256( abi.encode( hash, keccak256( substring( bytes(dn), 0, delArr(dn)[0] ) ) ) );                // label  e.g. 'vitalik'
    }

    // UUNS - Ungravel Unified Name Space, providing safe master contract addresses, derived from EVM Names, thus, belonging to Ungravel Name Space
    //
    // The unified name space in detail: A group "ethereum.base" may invest into another group "blockchain.base".
    // Since both domain names belong to UUNS, any transaction and investment will be safe, inside the "gated community" of Ungravel.
    // If master contracts participate in transactions, Ungravel smart contracts can determine quite easily if the calling 
    // contract belongs to Ungravel or not. Each master contract is authenticated to call Ungravel methods, simply by checking
    // its domain name in UUNS. Any contract that will not be resolved to the calling address may be an intruder and will be rejected.
    // Therefore, UUNS for master contracts is an important part of Ungravel security and safe investments.
    //

    function getGlobalTokenAddr() public view returns (address) {                     // Ungravel Global Shares contract address, derived from EVM Names
     return IResolverInt(GWF.RESOLVER_CONTRACT()).addr(getDomainHash(string(bytes.concat(bytes("global.ungravel"),bytes(tld())))));
    }
    function getIntentionsEnsAddr() public view returns (address) {                   // this Intentions contract address, derived from EVM Names
      return IResolverInt(GWF.RESOLVER_CONTRACT()).addr(getDomainHash(string(bytes.concat(bytes("intentions.ungravel"),bytes(tld())))));
    }
    function getAuctionMasterEnsAddr() public view returns (address) {                // AuctionMaster contract address, derived from EVM Names
      return IResolverInt(GWF.RESOLVER_CONTRACT()).addr(getDomainHash(string(bytes.concat(bytes("auctionmaster.ungravel"),bytes(tld())))));
    }
    function getGWalletMasterEnsAddr() public view returns (address) {                // GW Master contract address, derived from EVM Names
      return IResolverInt(GWF.RESOLVER_CONTRACT()).addr(getDomainHash(string(bytes.concat(bytes("gwallet.ungravel"),bytes(tld())))));
    }
    function getTokenMasterEnsAddr() public view returns (address) {                  // TokenMaster contract address, derived from EVM Names
      return IResolverInt(GWF.RESOLVER_CONTRACT()).addr(getDomainHash(string(bytes.concat(bytes("tokenmaster.ungravel"),bytes(tld())))));
    }
    function getFactoryEnsAddr() public view returns (address) {                      // GroupWalletFactory contract address, derived from EVM Names
      return IResolverInt(GWF.RESOLVER_CONTRACT()).addr(getDomainHash(string(bytes.concat(bytes("factory.ungravel"),bytes(tld())))));
    }
    function getMulti4EnsAddr() public view returns (address) {                       // MultiCall4 contract address, derived from EVM Names
      return IResolverInt(GWF.RESOLVER_CONTRACT()).addr(getDomainHash(string(bytes.concat(bytes("multifour.ungravel"),bytes(tld())))));
    }
    function getExtDeedMasterEnsAddr() public view returns (address) {                // extDeedMaster contract address, derived from EVM Names
      return IResolverInt(GWF.RESOLVER_CONTRACT()).addr(getDomainHash(string(bytes.concat(bytes("external-deed.ungravel"),bytes(tld())))));
    }
    function getIntDeedMasterEnsAddr() public view returns (address) {                // intDeedMaster contract address, derived from EVM Names
      return IResolverInt(GWF.RESOLVER_CONTRACT()).addr(getDomainHash(string(bytes.concat(bytes("internal-deed.ungravel"),bytes(tld())))));
    }

    // Attention: Any Group may send a LetterOfIntent, LoI, to any other Group, except of itself.
    // Groups MUST be a part of Ungravel Society, they MUST belong to the Ungravel mesh of groups.
    // Investors may send the intention to invest into any target group, e.g. "silvias-bakery.eth", a certain nb of shares
    // to indicate that investor considers to participate in a Funding Auction to acquire the desired nb of shares or even more.
    // If no group - aka external investor - indicates interest and the intention to invest and to participate in
    // a Funding Auction, the fund raising group, e.g. "silvias-bakery.eth", cannot invite external investors to invest in a Funding Auction.
    // Group members may participate in any Auction at any time. External investments require a valid and provable Letter of Intent, LoI.

    // *** Hint: LoIs are also important in order to profit from Ungravel Global Token, aka Ungravel Global Shares, in the future. ***

    function saveLetterOfIntent(address target, uint256 nbOfShares) public payable nonReentrant ungravelGW(IAGWP(target)) onlyGWP { 
      require(address(target)!=K_ADD00&&isContract(address(target)),                    "LoI1!");       // target address is valid group wallet contract

      IAGWP  __gwp    = IAGWP(target);
      IAGWP  __gwpInv = IAGWP(msg.sender);

      require(address(__gwp)!=K_ADD00&&address(__gwp.getGWF())==address(getGWF()),      "LoI3!");       // target GWP and this contract based on same GWF
      require(address(__gwpInv)!=K_ADD00&&address(__gwpInv.getGWF())==address(getGWF()),"LoI4!");       // sender GWP and this contract based on same GWF

      (address loiTargetAddr,uint256 tNb)=intentTransactionRecord(IAGWP(address(msg.sender)));
      require(tNb>0&&isContract(loiTargetAddr)&&target==loiTargetAddr,                  "LoI5!");       // LOI Intention transaction to identify target GWP

      bytes32 hash = hashOfGWP(__gwp);                                                                  // tArr[uint256(uint160(address(getGWF())))];
      require(hash!=0x0,                                                                "LoI6!");       // did find the dHash of "silvias-bakery.eth" GroupWallet, e.g.
      require(address(getGWP(hash))==address(target),                                   "LoI16!");      // GWP is Group of GWF, aka GWP belongs to Ungravel Society

      AbstractTokenProxyInt __ptc = getPTC(hash);
      require(address(__ptc)!=K_ADD00,                                                  "LoI7!");       // did find the ProxyToken contract address of "silvias-bakery.eth"

      require(nbOfShares!=0&&nbOfShares<=__ptc.balanceOf(target),                        "LoI8!");       // target owns at least nb of shares intented to be acquired

      require(getGWF().getOwner(hash)==target,                                          "LoI9!");       // target GWP contract owns GWP name, s.a. "silvias-bakery.eth"

      bytes32 hashInv = hashOfGWP(__gwpInv);                                                            // tArr[uint256(uint160(address(getGWF())))];
      require(hashInv!=0x0,                                                             "LoI10!");      // did find the dHash of "investor.eth" GroupWallet
      require(getGWF().getOwner(hashInv)==address(msg.sender),                          "LoI11!");      // investor GWP contract owns GWP name, s.a. "investor.eth"
      require(address(getGWP(hashInv))==msg.sender,                                     "LoI17!");      // GWP is Group of GWF, aka GWP belongs to Ungravel Society

      require(hash!=hashInv,                                                             "LoI0!");       // target cannot be this GWP, groups MUST NOT invest in itself! Members can.

      // check balance and cost

      AbstractEthRegControllerInt ctrl = getRegController();                                             // ENS RegistrarController, contract to rent domain names
      require(ctrl.rentPrice("abcdef",uint(86400*365))<=msg.value,                      "LoI12!");       // pay a small "rent" comparable to domain names to prohibit LoI spam

      balances[address(msg.sender)] = address(msg.sender).balance;                                       // save current ETH balance of potential investor
      intended[msg.sender][target]  = nbOfShares;                                                        // save nb of shares intended to be acquired
      investors.push(address(msg.sender));                                                               // save contract address GWP of potential investor in an array

      intentInv[target].push(address(msg.sender));                                                       // push investor GWP for target GWP

      emit LetterOfIntent(msg.sender, target, nbOfShares);
    }

    // Store relevant investment decisions to qualify GroupWallets for the Ungravel Global Share
    // GWP that invest in other groups and completing a Funding Auction, qualify for a future stake of the Ungravel Global Share, aka Ungravel Global Token, UGT (Ungravel Global Share Drop)
    // Hint: storeInvestment() is only called by GWP and execute finalize for external investors, it is NOT called for internal auctions!

    function storeInvestment(uint256 _nbOfShares, address _gwp, uint256 _pricePaidEth, bytes32 _salt) public payable nonReentrant onlyGroupWallets(msg.sender,_gwp) { // send from the investing GWP
      require(address(_gwp)!=K_ADD00&&isContract(address(_gwp))&&address(IAGWP(_gwp).getGWF())==address(getGWF()),"* not an UngravelGroup!");
      require(_nbOfShares>0,"* not an UngravelGroup2!");
      require(_nbOfShares>0&&_pricePaidEth>0,"* not an UngravelGroup2b!");
      require(_nbOfShares>0&&_pricePaidEth>0&&(uint(_salt)!=0),"* not an UngravelGroup2c!");

      // save the nb of shares acquired, save the amount paid for the group shares, seen from the investor GWP

      acquired[msg.sender][_gwp] = _nbOfShares;                                                                                      // sender = investor did send _nbOfShares to receiving GWP
      invested[msg.sender][_gwp] = _pricePaidEth;                                                                                    // sender = investor did pay _price for _nbOfShares, re-adjusting group valuation


      // save the nb of group shares sold, save the amount received "the funding", for selling group shares, seen from the GWP that ran the Funding Auction and got funded

      sold[_gwp][msg.sender]     = _nbOfShares;                                                                                      // _gwp funded for selling _nbOfShares to sender = investor
      funded[_gwp][msg.sender]   = _pricePaidEth;                                                                                    // _gwp received _price ETH funding, group valuation adjusted appropriately

      spice[msg.sender][_gwp]    = _salt;                                                                                            // sender = investor stores the _salt = group name hash for this receiver

      uint256 cap                =  uint( uint(1.2e6 * 1e5 * uint(_pricePaidEth)) / _nbOfShares );                                   // recalculate new market cap of _gwp x 1000 in ETH or native currency (matic, BNB)

      if (cap!=0) {                                                                                                                  // avoiding surprises
        UNG_Mcap = UNG_Mcap - marketCap[_gwp];                                                                                       // delete the old market cap of group x1000
        if (cap>marketCap[_gwp]) marketCap[_gwp] = cap;                                                                              // update new market cap, if greater than old market cap
        UNG_Mcap = UNG_Mcap + cap;                                                                                                   // sum-up total market cap of Ungravel Society on this chain
      }

      emit StoreInvestment(msg.sender,_gwp,_nbOfShares,_pricePaidEth);
      emit StoreFunding(_gwp,msg.sender,_nbOfShares,_pricePaidEth);
    }

    function getSpice(address _gwp) public view returns (bytes32) {                                                                  // get spice of an investment decision, such as the "salt"
      require(__isGW(msg.sender)&&__isGW(_gwp),"GWspice");
      return spice[msg.sender][_gwp];
    }

    function getMarketCap() public view returns (uint256) {                                                                          // get market cap in ETH or natCurr of calling GWP
      return uint(marketCap[msg.sender] / 1000);
    }

    function mCap(address _gwp) public view returns (uint256) {                                                                      // get market cap in ETH or natCurr
      return uint(marketCap[_gwp] / 1000);
    }

    function getUNGmarketCap() public view returns (uint256) {                                                                       // get market cap in ETH or natCurr of Ungravel Society on current chain
      if (UNG_Mcap==0) return 0;
      return uint(UNG_Mcap / 1000);
    }
    
    function didInvestTo(address _gwp) public view returns (bool) {                                                                  // calling GWP did invest in a _gwp ?
      return ( __isGW(msg.sender) && __isGW(_gwp) && (acquired[msg.sender][_gwp]!=0) && (invested[msg.sender][_gwp]!=0) && (getSpice(_gwp)!=0x0) );
    }

    function didGetFundingFrom(address _gwp,address _inv) public view returns (bool) {                                               // The _gwp did receive funding from an _investor ?
      return ( __isGW(_gwp) && __isGW(_inv) && (sold[_gwp][_inv]!=0) && (funded[_gwp][_inv]!=0) && (spice[_inv][_gwp]!=0x0) );
    }

    function getFundingReport(address _gwp, address _inv) public view returns (uint256, bytes32, uint256, uint256, uint256, uint256) {
      require( 
               address(_gwp)!=address(0) && address(_inv)!=address(0) &&   // check 0x00 address
               isContract(address(_gwp)) && isContract(address(_inv)) &&   // check if contract code available or EOA
               address(IAGWP(_gwp).getGWF())==address(GWF)            &&   // refers to the same GWF
               address(IAGWP(_inv).getGWF())==address(GWF)            &&   // refers to the same GWF
               __isGW(_gwp) &&  __isGW(_inv)                               // both contracts are valid GWPs, inside UUNS
              ,"only GWF"
      );

      {
      bytes32 h = hashOfGWP(IAGWP(_gwp));
      require(h!=0x0&&getGWF().getOwner(h)==address(_gwp), "* no UG2");                                                              // the requested GWP owns its own dName, s.a. "silvias-bakery.eth" | "vitalik.arb" | "peters-bar.opt"
      require(address(getGWP(h))==address(_gwp),           "* no UG3");                                                              // GWP belongs to Ungravel Society
      }

      {
      bytes32 h = hashOfGWP(IAGWP(_inv));
      require(h!=0x0&&getGWF().getOwner(h)==address(_inv), "* no UG5");                                                              // the requested GWP owns its own dName, s.a. "silvias-bakery.eth" | "vitalik.arb" | "peters-bar.opt"
      require(address(getGWP(h))==address(_inv),           "* no UG6");                                                              // GWP belongs to Ungravel Society
      }

      return ( uint256(marketCap[address(_gwp)] / 1000), bytes32(spice[_inv][_gwp]), uint256(getIntendedLOIShares(_gwp,_inv)), uint256(acquired[_inv][_gwp]), uint256(invested[_inv][_gwp]), uint256(getUNGmarketCap()) );
    }
    
    function LoI_arrived_for_GWP(address target) public view returns (bool) {                                                        // Did a GroupWallet "target" receive a LoI from another group?
      return ( __isGW(target) && (IAGWP(target).getTransactionsCount()!=0) && (intentInv[target].length!=0) && (getIntendedNbOfShares(target)!=0) );
    }

    function getIntendedNbOfShares(address target) public view returns (uint256 t) {                                                 // In case "target" GWP - GroupWallet proxy did reveive a LoI, get the nb of shares investor may acquire * this can become expensive in the future *
      uint256 j = investors.length;
      if (j==0) return 0;

      delete t;
      uint256 i=0;
      do {
        if (intended[investors[i]][target]>0) t = intended[investors[i]][target];
        i++;
      } while(i<j); // * this can be expensive in the future *

      return t;
    }

    function getGroupLOIinvestors(address target) public view ungravelGW(IAGWP(target)) returns (address[] memory) {                 // return array of LOI investors addresses
      return intentInv[target];
    }


    function getIntendedLOIShares(address tg, address inv) public view ungravelGW(IAGWP(tg)) ungravelGW(IAGWP(inv)) returns (uint256 t) { // returns nb of shares of the investor that did send an LOI - or 0
      uint256 j = intentInv[tg].length;
      if (j==0) return 0;

      delete t;
      for(uint256 i=0; i<j; i++) {
        address invest = intentInv[tg][i];
        if (invest==inv) t = intended[invest][tg];
      }
      return t;
    }

    function intendedLOIShares(address inv) public view ungravelGW(IAGWP(msg.sender)) ungravelGW(IAGWP(inv)) returns (uint256 t) {        // called by GWP directly
      uint256 j = intentInv[msg.sender].length;
      if (j==0) return 0;

      delete t;
      for(uint256 i=0; i<j; i++) {
        address investor = intentInv[msg.sender][i];
        if (investor==inv) t= intended[inv][msg.sender];
      }

      return t;
    }


    function intendedLOIInvestorName(address _iv) public view ungravelGW(IAGWP(msg.sender)) ungravelGW(IAGWP(_iv)) returns (string memory t) { // called by GWP directlyg
      uint256 j = intentInv[msg.sender].length;
      if (j==0) return "";

      t = "";
      for(uint256 i=0; i<j; i++) {
        address inv = intentInv[msg.sender][i];
        if ((inv==_iv)&&(intended[inv][msg.sender]>0)) { 
          t = string(bytes.concat(bytes(bytes32ToStr(toLowerCaseBytes32(mb32(bytes(getName(hashOfGWP(IAGWP(inv)))))))),bytes(tld()))); // "Bee-jazz" gets "bee-jazz.eth"
        }
      }
      return t;
    }

    function getLOIInvestorName(address tg, address _iv) public view ungravelGW(IAGWP(tg)) ungravelGW(IAGWP(_iv)) returns (string memory t) {  // get name of LOI investor
      uint256 j = intentInv[tg].length;
      if (j==0) return "";

      t = "";
      for(uint256 i=0; i<j; i++) {
        address inv = intentInv[tg][i];
        if ((inv==_iv)&&(intended[inv][tg]>0)) { 
          t = string(bytes.concat(bytes(bytes32ToStr(toLowerCaseBytes32(mb32(bytes(getName(hashOfGWP(IAGWP(inv)))))))),bytes(tld()))); // "Bee-jazz" gets "bee-jazz.eth"
        }
      }
      return t;
    }

    // --------------------- strings -------------------------------------------
    
    function strlen(string memory s) internal pure returns (uint256 len) {
        uint256 i = 0;
        delete len;
        uint256 bytelength = bytes(s).length;
        for(len = 0; i < bytelength; len++) {
            bytes1 b = bytes(s)[i];
            if(b < 0x80) {
                i += 1;
            } else if (b < 0xE0) {
                i += 2;
            } else if (b < 0xF0) {
                i += 3;
            } else if (b < 0xF8) {
                i += 4;
            } else if (b < 0xFC) {
                i += 5;
            } else {
                i += 6;
            }
        }
        return len;
    }
    function mb32(bytes memory _data) private pure returns(bytes32 a) {
      // solium-disable-next-line security/no-inline-assembly
      assembly {
          a := mload(add(_data, 32))
      }
    }
    function bytes32ToStr(bytes32 _b) internal pure returns (string memory){ 
      bytes memory bArr = new bytes(32); 
      for (uint256 i;i<32;i++) { bArr[i] = _b[i]; } 
      return string(bArr); 
    }
    function toLowerCaseBytes32(bytes32 _in) internal pure returns (bytes32){
      if ( uint256(uint256(uint256(_in) & K_TYPEMASK) >> 252) <= 5 ) return bytes32(uint256(uint256(_in) | 0x2000000000000000000000000000000000000000000000000000000000000000 ));
      return _in;
    }
    function memcpy(uint256 dest, uint256 src, uint256 len) private pure {
        // Copy word-length chunks while possible
        for (; len >= 32; len -= 32) {
            // solium-disable-next-line security/no-inline-assembly
            assembly {
                mstore(dest, mload(src))
            }
            dest += 32;
            src += 32;
        }
        
        if (len==0) return;

        // Copy remaining bytes
        uint256 mask = 256 ** (32 - len) - 1;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            let srcpart := and(mload(src), not(mask))
            let destpart := and(mload(dest), mask)
            mstore(dest, or(destpart, srcpart))
        }
    }
    function substring(bytes memory self, uint256 offset, uint256 len) private pure returns(bytes memory) {
        require(offset + len <= self.length,"substring!!!");

        bytes memory ret = new bytes(len);
        uint256 dest;
        uint256 src;

        // solium-disable-next-line security/no-inline-assembly
        assembly {
            dest := add(ret, 32)
            src  := add(add(self, 32), offset)
        }
        memcpy(dest, src, len);

        return ret;
    }
    function delArr(string memory s) internal pure returns (uint8[] memory) {
        uint8[] memory delimiter = new uint8[](2);
        
        uint256 len;
        uint256 nb = 0;
        uint256 i = 0;
        uint256 bytelength = bytes(s).length;
        for(len = 0; i < bytelength; len++) {
            bytes1 b = bytes(s)[i];
            
            if (b==0x2e) {
              delimiter[nb] = uint8(i);
              nb++;
            }
              
            if(b < 0x80) {
                i += 1;
            } else if (b < 0xE0) {
                i += 2;
            } else if (b < 0xF0) {
                i += 3;
            } else if (b < 0xF8) {
                i += 4;
            } else if (b < 0xFC) {
                i += 5;
            } else {
                i += 6;
            }
        }

        return delimiter;
    }
    
    // --------------------- chain utils ----------------------------------------
  
    function intentTransactionRecord(IAGWP gwp) internal ungravelGW(gwp) view returns (address LOItargetAddr,uint256 tNb) {
      require(address(gwp)!=K_ADD00&&isContract(address(gwp)),"Intentions intentTRecord!");
      uint256 kTypeMask12 = 0xc000000000000000000000000000000000000000000000000000000000000000;

      uint256 t;
      uint256 i = gwp.getTransactionsCount();

      if (i==0) return (address(0),0);

      do {
        i--;
        t = gwp.getTransactionRecord(i);
      } while((i>0) && (t>0) && (t & kTypeMask12 != kTypeMask12));
      
      if (t & kTypeMask12 == kTypeMask12) return (address(uint160(t & K_AMASK)),i);
      else return (address(0),0);
    }

    function chain_tld(uint256 chainId) public pure returns (string memory) {
      if (chainId==1)        return ".eth";         // ethereum mainnet   
      if (chainId==10)       return ".op";          // optimism mainnet
      if (chainId==56)       return ".bsc";         // bscmain mainnet (binance bnb)
      if (chainId==100)      return ".gnosis";      // gnosis mainnet     ** discontinued **
      if (chainId==130)      return ".uni";         // unichain mainnet
      if (chainId==137)      return ".matic";       // polygon mainnet
      if (chainId==143)      return ".monad";       // monad mainnet
      if (chainId==146)      return ".sonic";       // sonic mainnet
      if (chainId==196)      return ".xlayer";      // xlayer mainnet
      if (chainId==480)      return ".wc";          // worldchain mainnet
      if (chainId==1135)     return ".lisk";        // lisk mainnet       ** discontinued **
      if (chainId==1868)     return ".son";         // soneium mainnet
      if (chainId==8453)     return ".base";        // base mainnet
      if (chainId==42161)    return ".one";         // arbitrumOne mainnet
      if (chainId==42220)    return ".celo";        // celo mainnet
      if (chainId==43114)    return ".ava";         // avalanche mainnet
      if (chainId==57073)    return ".ink";         // ink (kraken)
      if (chainId==59144)    return ".linea";       // linea mainnet
      if (chainId==81457)    return ".blast";       // blast mainnet      ** discontinued **
      if (chainId==167000)   return ".tko";         // taiko mainnet      ** discontinued **
      if (chainId==534352)   return ".scroll";      // scroll mainnet     ** discontinued **
      if (chainId==7777777)  return ".zora";        // zora mainnet
      if (chainId==5042002)  return ".arc";         // arc-testnet
      if (chainId==1244)     return ".eurc";        // arc-testnet2
      if (chainId==988)      return ".stable";      // stable mainnet
      if (chainId==9745)     return ".plasma";      // plasma mainnet
      if (chainId==9746)     return ".pyusd";       // paypal
      if (chainId==9747)     return ".usdt";        // USDT
      if (chainId==999)      return ".hyper";       // hyper mainnet
      if (chainId==4217)     return ".tempo";       // tempo mainnet
      if (chainId==688689)   return ".pharos";      // pharos testnet     ** discontinued **
      if (chainId==1672)     return ".phrs";        // pharos mainnet
      if (chainId==8217)     return ".kaia";        // kaia mainnet       ** discontinued **
      if (chainId==5042)     return ".usdc";        // arc-mainnetb
      if (chainId==4663)     return ".usdg";        // robinhood mainnet = "robinmain"
      if (chainId==4326)     return ".mega";        // megaeth mainnet   = "MegaETH"
      return "";
    }

    function chain_name(uint256 chainId) public pure returns (string memory) {
      if (chainId==1)        return "mainnet";      // ethereum mainnet   
      if (chainId==10)       return "optmain";      // optimism mainnet
      if (chainId==56)       return "bscmain";      // bscmain mainnet
      if (chainId==100)      return "gnosis";       // gnosis mainnet     ** discontinued **
      if (chainId==130)      return "unichain";     // unichain mainnet
      if (chainId==137)      return "polygon";      // polygon mainnet
      if (chainId==143)      return "monad";        // monad mainnet
      if (chainId==146)      return "sonic";        // sonic mainnet
      if (chainId==196)      return "xlayer";       // xlayer mainnet
      if (chainId==480)      return "worldchain";   // worldchain mainnet
      if (chainId==1135)     return "lisk";         // lisk mainnet       ** discontinued **
      if (chainId==1868)     return "soneium";      // soneium mainnet
      if (chainId==8453)     return "base";         // base mainnet
      if (chainId==42161)    return "arbmain";      // arbitrumOne mainnet
      if (chainId==42220)    return "celo";         // celo mainnet
      if (chainId==43114)    return "avalanche";    // avalanche mainnet
      if (chainId==59144)    return "linea";        // linea mainnet
      if (chainId==81457)    return "blast";        // blast mainnet      ** discontinued **
      if (chainId==167000)   return "taiko";        // taiko mainnet      ** discontinued **
      if (chainId==534352)   return "scroll";       // scroll mainnet     ** discontinued **
      if (chainId==7777777)  return "zora";         // zora mainnet
      if (chainId==5042002)  return "arc-testnet";  // arc-testnet
      if (chainId==1244)     return "eurc";         // arc-testnet2
      if (chainId==988)      return "stable";       // stable mainnet
      if (chainId==9745)     return "plasma";       // plasma mainnet
      if (chainId==9746)     return "pyusd";        // paypal
      if (chainId==9747)     return "usdt";         // USDT
      if (chainId==999)      return "hyper";        // hyper(liquid) mainnet
      if (chainId==4217)     return "tempo";        // tempo mainnet
      if (chainId==688689)   return "pharos";       // pharos testnet     ** discontinued **
      if (chainId==1672)     return "phrs";         // pharos mainnet
      if (chainId==8217)     return "kaia";         // kaia mainnet       ** discontinued **
      if (chainId==5042)     return "arc-mainnetb"; // arc-mainnetb mainnet
      if (chainId==4663)     return "robinmain";    // robinhood mainnet === "robinmain"
      if (chainId==4326)     return "megaeth";      // megaeth   mainnet === "MegaETH"
      if (chainId==57073)    return "ink";          // ink
      return "";
    }

    function tld() public view returns (string memory) {
      return chain_tld(block.chainid);
    }

    function chainName() public view returns (string memory) {
      return chain_name(block.chainid);
    }

    function setGWFContract(AbstractGwfInt gwfCtr) external onlyOwner payable {
      require(address(gwfCtr)!=address(0) && isContract(address(gwfCtr)), "gwf");
      emit ChangeGWF(address(GWF), address(gwfCtr));
      GWF = gwfCtr;
    }

    function version() public pure returns(uint256) {
      return 20010065;
    }

    function withdraw() external payable onlyOwner {
       if (__selfbalance()==0) return;
       uint bal = __selfbalance()-1;
       (bool success,) = payable(msg.sender).call{value:bal}("");
       require(success,"withdraw fails!");
       emit Withdraw(msg.sender, bal);
    }

    receive() external payable {
      emit Deposit(msg.sender, msg.value);
    }

    constructor (address _gwf) payable
    { 
      require(strlen(tld())>0&&address(_gwf)!=K_ADD00&&isContract(_gwf),"Intentions CONST!");
      require(version()>20010000,                                       "Intentions VERS!");
      require(strlen(chainName())>0,                                    "Intentions CHAIN!");

      masterCopy  = msg.sender;
      GWF         = AbstractGwfInt(_gwf);
      UNG_Mcap    = 0;

      AbstractRrInt(GWF.REVERSE_CONTRACT()).setName(string(bytes.concat(bytes("intentions.ungravel"),bytes(tld())))); // assigning reverse resolver record

      emit Deployment(msg.sender, address(this));
      emit DeploymentIntentions(address(this), bytes32(getNodeHash(string(bytes.concat(bytes(chainName())))))); // assigning "intentions.ungravel.usdc" while deployed (UUNS)
    }
}