```act
behaviour open of DssCdpManager
interface open(bytes32 ilk, address guy)

types
    Cdpi : uint256
    Last : uint256
    Count : uint256
    Urn : address
    NewUrn : address
    Own : address
    Ilk : bytes32
    First : uint256
    Prev : uint256
    Next : uint256

storage
    cdpi |-> Cdpi => Cdpi + 1
    last[guy] |-> Last => Cdpi + 1
    count[guy] |-> Count => Count + 1
    urns[Cdpi + 1] |-> Urn => NewUrn
    owns[Cdpi + 1] |-> Own => guy
    ilks[Cdpi + 1] |-> Ilk => ilk
    first[guy] |-> First => #if First == 0 #then Cdpi + 1 #else First #fi
    list[Cdpi + 1].prev |-> Prev => #if Last =/= 0 #then Last #else Prev #fi
    list[Last].next |-> Next => #if Last =/= 0 #then Cdpi + 1 #else Next #fi

iff in range uint256
    Cdpi + 1
    Count + 1

iff
    Own == CALLER_ID
    VCallValue == 0

returns Cdpi + 1
```

if
    NewUrn == #newAddr(ACCT_ID, NONCE)
    (notBool (NewUrn in_keys(ACCTS)))

```act
behaviour give of DssCdpManager
interface give(uint256 cdp, address dst)

types
    Allow : uint256
    Own : address
    CountOwn : uint256
    CountDst : uint256
    LastOwn : uint256
    LastDst : uint256
    FirstOwn : uint256
    FirstDst : uint256
    ListCdpPrev : uint256
    ListCdpNext : uint256
    ListLastDstNext : uint256
    ListListCdpPrevNext : uint256
    ListListCdpNextPrev : uint256

storage
    allows[Own][cdp][CALLER_ID] |-> Allow => Allow
    owns[cdp] |-> Own => dst
    count[Own] |-> CountOwn => CountOwn - 1
    count[dst] |-> CountDst => CountDst + 1
    last[Own] |-> LastOwn => #if ListCdpNext == 0 #then ListCdpPrev #else LastOwn #fi
    last[dst] |-> LastDst => cdp
    first[Own] |-> FirstOwn => #if FirstOwn == cdp #then ListCdpNext #else FirstOwn #fi
    first[dst] |-> FirstDst => #if FirstDst == 0 #then cdp #else FirstDst #fi
    list[cdp].prev |-> ListCdpPrev => LastDst
    list[cdp].next |-> ListCdpNext => 0
    list[LastDst].next |-> ListLastDstNext => cdp
    list[ListCdpPrev].next |-> ListListCdpPrevNext => ListCdpNext
    list[ListCdpNext].prev |-> ListListCdpNextPrev => #if ListCdpNext =/= 0 #then ListCdpPrev #else ListListCdpNextPrev #fi

iff in range uint256
    CountOwn - 1
    CountDst + 1

iff
    VCallValue == 0
    (CALLER_ID == Own) or (Allow == 1)
    dst =/= 0

if
    Own =/= dst
    cdp =/= LastDst
    cdp =/= ListCdpPrev
    cdp =/= ListCdpNext
    LastDst =/= ListCdpPrev
```

```act
behaviour giveSameOwnDst of DssCdpManager
interface give(uint256 cdp, address dst)

types
    Own : address

storage
    owns[cdp] |-> Own

iff
    VCallValue == 0
    Own =/= dst

if
    Own == dst
```
