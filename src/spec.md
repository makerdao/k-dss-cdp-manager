# DssCdpManager acts

```act
behaviour add of DssCdpManager
interface add(uint256 x, uint256 y) internal

stack
    y : x : JMPTO : WS => JMPTO : x + y : WS

iff in range uint256
    x + y

if
    #sizeWordStack(WS) <= 100
```

```act
behaviour sub of DssCdpManager
interface sub(uint256 x, uint256 y) internal

stack
    y : x : JMPTO : WS => JMPTO : x - y : WS

iff in range uint256
    x - y

if
    #sizeWordStack(WS) <= 100
```

```act
behaviour open of DssCdpManager
interface open(bytes32 ilk, address usr)

types
    Cdpi    : uint256
    Urn     : address
    NewUrn  : address
    Last    : uint256
    Count   : uint256
    Own     : address
    Ilk     : bytes32
    First   : uint256
    Prev    : uint256
    Next    : uint256

storage
    cdpi                |-> Cdpi => Cdpi + 1
    urns[Cdpi + 1]      |-> Urn => NewUrn
    last[usr]           |-> Last => Cdpi + 1
    count[usr]          |-> Count => Count + 1
    owns[Cdpi + 1]      |-> Own => usr
    ilks[Cdpi + 1]      |-> Ilk => ilk
    first[usr]          |-> First => #if First == 0 #then Cdpi + 1 #else First #fi
    list[Cdpi + 1].prev |-> Prev => #if Last =/= 0 #then Last #else Prev #fi
    list[Last].next     |-> Next => #if Last =/= 0 #then Cdpi + 1 #else Next #fi

iff in range uint256
    Cdpi + 1
    Count + 1

iff
    VCallValue == 0
    usr =/= 0

returns Cdpi + 1

calls
    DssCdpManager.add
```

```act
behaviour give of DssCdpManager
interface give(uint256 cdp, address dst)

types
    Allow               : uint256
    Own                 : address
    CountOwn            : uint256
    CountDst            : uint256
    LastOwn             : uint256
    LastDst             : uint256
    FirstOwn            : uint256
    FirstDst            : uint256
    ListCdpPrev         : uint256
    ListCdpNext         : uint256
    ListLastDstNext     : uint256
    ListListCdpPrevNext : uint256
    ListListCdpNextPrev : uint256

storage
    allows[Own][cdp][CALLER_ID] |-> Allow
    owns[cdp]                   |-> Own => dst
    count[Own]                  |-> CountOwn => CountOwn - 1
    count[dst]                  |-> CountDst => CountDst + 1
    last[Own]                   |-> LastOwn => #if ListCdpNext == 0 #then ListCdpPrev #else LastOwn #fi
    last[dst]                   |-> LastDst => cdp
    first[Own]                  |-> FirstOwn => #if FirstOwn == cdp #then ListCdpNext #else FirstOwn #fi
    first[dst]                  |-> FirstDst => #if FirstDst == 0 #then cdp #else FirstDst #fi
    list[cdp].prev              |-> ListCdpPrev => LastDst
    list[cdp].next              |-> ListCdpNext => 0
    list[LastDst].next          |-> ListLastDstNext => cdp
    list[ListCdpPrev].next      |-> ListListCdpPrevNext => ListCdpNext
    list[ListCdpNext].prev      |-> ListListCdpNextPrev => #if ListCdpNext =/= 0 #then ListCdpPrev #else ListListCdpNextPrev #fi

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

calls
    DssCdpManager.add
    DssCdpManager.sub
```

```act
behaviour give2 of DssCdpManager
interface give(uint256 cdp, address dst)

types
    Allow   : uint256
    Own     : address

storage
    allows[Own][cdp][CALLER_ID] |-> Allow
    owns[cdp]                   |-> Own => dst

iff
    VCallValue == 0
    (CALLER_ID == Own) or (Allow == 1)
    dst =/= 0
    Own =/= dst

if
    Own == dst

calls
    DssCdpManager.add
    DssCdpManager.sub
```

```act
behaviour fluxIlk of DssCdpManager
interface flux(bytes32 ilk, uint256 cdp, address dst, uint256 wad)

types
    Vat     : address Vat
    Allow   : uint256
    Own     : address
    Urn     : address
    May     : uint256
    GemUrn  : uint256
    GemDst  : uint256

storage
    vat                         |-> Vat
    allows[Own][cdp][CALLER_ID] |-> Allow
    owns[cdp]                   |-> Own
    urns[cdp]                   |-> Urn

storage Vat
    can[Urn][ACCT_ID]   |-> May
    gem[ilk][Urn]       |-> GemUrn => GemUrn - wad
    gem[ilk][dst]       |-> GemDst => GemDst + wad

iff
    VCallValue == 0
    VCallDepth < 1024
    (ACCT_ID == Urn) or (May == 1)
    (CALLER_ID == Own) or (Allow == 1)

iff in range uint256
    GemUrn - wad
    GemDst + wad

if
    Urn =/= dst

calls
    Vat.flux-diff
```

```act
behaviour fluxIlk2 of DssCdpManager
interface flux(bytes32 ilk, uint256 cdp, address dst, uint256 wad)

types
    Vat     : address Vat
    Allow   : uint256
    Own     : address
    Urn     : address
    May     : uint256
    Gem     : uint256

storage
    vat                         |-> Vat
    allows[Own][cdp][CALLER_ID] |-> Allow
    owns[cdp]                   |-> Own
    urns[cdp]                   |-> Urn

storage Vat
    can[Urn][ACCT_ID]   |-> May
    gem[ilk][Urn]       |-> Gem => Gem

iff
    VCallValue == 0
    VCallDepth < 1024
    (ACCT_ID == Urn) or (May == 1)
    (CALLER_ID == Own) or (Allow == 1)

iff in range uint256
    Gem - wad

if
    Urn == dst

calls
    Vat.flux-same
```

# Vat acts

```act
behaviour adduu of Vat
interface add(uint256 x, uint256 y) internal

stack
    y : x : JMPTO : WS => JMPTO : x + y : WS

iff in range uint256
    x + y

if
    #sizeWordStack(WS) <= 100
```

```act
behaviour subuu of Vat
interface sub(uint256 x, uint256 y) internal

stack
    y : x : JMPTO : WS => JMPTO : x - y : WS

iff in range uint256
    x - y

if
    #sizeWordStack(WS) <= 100
```

```act
behaviour flux-diff of Vat
interface flux(bytes32 ilk, address src, address dst, uint256 wad)

for all
    May     : uint256
    Gem_src : uint256
    Gem_dst : uint256

storage
    can[src][CALLER_ID] |-> May
    gem[ilk][src]       |-> Gem_src => Gem_src - wad
    gem[ilk][dst]       |-> Gem_dst => Gem_dst + wad

iff
    // act: caller is `. ? : not` authorised
    (May == 1 or src == CALLER_ID)
    VCallValue == 0

iff in range uint256
    Gem_src - wad
    Gem_dst + wad

if
    src =/= dst

calls
    Vat.subuu
    Vat.adduu
```

```act
behaviour flux-same of Vat
interface flux(bytes32 ilk, address src, address dst, uint256 wad)

for all
    May     : uint256
    Gem_src : uint256

storage
    can[src][CALLER_ID] |-> May
    gem[ilk][src]       |-> Gem_src => Gem_src

iff
    // act: caller is `. ? : not` authorised
    (May == 1 or src == CALLER_ID)
    VCallValue == 0

iff in range uint256
    Gem_src - wad

if
    src == dst

calls
    Vat.subuu
    Vat.adduu
```
