```act
behaviour testGive of DssCdpManager
interface testGive(uint256 cdp, address dst)

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
    list[ListCdpNext].prev |-> ListListCdpNextPrev

iff in range uint256
    CountOwn - 1
    CountDst + 1

iff
    VCallValue == 0
    (CALLER_ID == Own) or (Allow == 1)
    dst =/= 0

if
    ListListCdpNextPrev == 1
    Own =/= dst
    cdp =/= LastDst
    cdp =/= ListCdpPrev
    cdp =/= ListCdpNext
    LastDst =/= ListCdpPrev
```
    
    ListCdpPrev =/= ListCdpNext
    LastDst =/= ListCdpNext

    


```
behaviour testOpen of DssCdpManager
interface testOpen(bytes32 ilk, address guy)

types
    Cdpi : uint256
    Urn : address
    NewUrn : address

storage
    cdpi |-> Cdpi => Cdpi + 1
    urns[Cdpi + 1] |-> Urn => NewUrn

iff in range uint256
    Cdpi + 1

iff
    VCallValue == 0

returns Cdpi + 1
```