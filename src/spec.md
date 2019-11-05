# DssCdpManager acts

```act
behaviour add of DssCdpManager
interface add(uint256 x, uint256 y) internal

stack

    y : x : JMPTO : WS => JMPTO : x + y : WS

iff in range uint256

    x + y

if

    #sizeWordStack(WS) <= 1000
```

```act
behaviour sub of DssCdpManager
interface sub(uint256 x, uint256 y) internal

stack

    y : x : JMPTO : WS => JMPTO : x - y : WS

iff in range uint256

    x - y

if

    #sizeWordStack(WS) <= 1000
```

```act
behaviour toInt of DssCdpManager
interface toInt(uint256 x) internal

stack

    x : JMPTO : WS => JMPTO : #signed(x) : WS

iff in range int256

    x

if

    #sizeWordStack(WS) <= 1000
```

```act
behaviour vat of DssCdpManager
interface vat()

for all

    Vat : address

storage

    vat |-> Vat

iff

    VCallValue == 0

returns Vat
```

```act
behaviour cdpi of DssCdpManager
interface cdpi()

for all

    Cdpi : uint256

storage

    cdpi |-> Cdpi

iff

    VCallValue == 0

returns Cdpi
```

```act
behaviour urns of DssCdpManager
interface urns(uint256 cdp)

for all

    Urn : address

storage

    urns[cdp] |-> Urn

iff

    VCallValue == 0

returns Urn
```

```act
behaviour list of DssCdpManager
interface list(uint256 cdp)

for all

    Prev : uint256
    Next : uint256

storage

    list[cdp].prev |-> Prev
    list[cdp].next |-> Next

iff

    VCallValue == 0

returns Prev : Next
```

```act
behaviour owns of DssCdpManager
interface owns(uint256 cdp)

for all

    Own : address

storage

    owns[cdp] |-> Own

iff

    VCallValue == 0

returns Own
```

```act
behaviour ilks of DssCdpManager
interface ilks(uint256 cdp)

for all

    Ilk : bytes32

storage

    ilks[cdp] |-> Ilk

iff

    VCallValue == 0

returns Ilk
```

```act
behaviour first of DssCdpManager
interface first(address own)

for all

    First : uint256

storage

    first[own] |-> First

iff

    VCallValue == 0

returns First
```

```act
behaviour last of DssCdpManager
interface last(address own)

for all

    Last : uint256

storage

    last[own] |-> Last

iff

    VCallValue == 0

returns Last
```

```act
behaviour count of DssCdpManager
interface count(address own)

for all

    Count : uint256

storage

    count[own] |-> Count

iff

    VCallValue == 0

returns Count
```

```act
behaviour cdpCan of DssCdpManager
interface cdpCan(address own, uint256 cdp, address who)

for all

    Can : uint256

storage

    cdpCan[own][cdp][who] |-> Can

iff

    VCallValue == 0

returns Can
```

```act
behaviour urnCan of DssCdpManager
interface urnCan(address urn, address who)

for all

    Can : uint256

storage

    urnCan[urn][who] |-> Can

iff

    VCallValue == 0

returns Can
```

```act
behaviour cdpAllow-diff of DssCdpManager
interface cdpAllow(uint256 cdp, address usr, uint256 ok)

types

    CdpCan  : uint256
    Own     : address

storage

    owns[cdp]                   |-> Own
    cdpCan[Own][cdp][CALLER_ID] |-> CdpCan
    cdpCan[Own][cdp][usr]       |-> _ => ok

iff

    VCallValue == 0
    (CALLER_ID == Own) or (CdpCan == 1)

if
    CALLER_ID =/= usr
```

```act
behaviour cdpAllow-same of DssCdpManager
interface cdpAllow(uint256 cdp, address usr, uint256 ok)

types

    CdpCan  : uint256
    Own     : address

storage

    owns[cdp]                   |-> Own
    cdpCan[Own][cdp][CALLER_ID] |-> CdpCan => ok

iff

    VCallValue == 0
    (CALLER_ID == Own) or (CdpCan == 1)

if
    CALLER_ID == usr
```

```act
behaviour urnAllow of DssCdpManager
interface urnAllow(address usr, uint256 ok)

types

    UrnCan  : uint256

storage

    urnCan[CALLER_ID][usr] |-> _ => ok

iff

    VCallValue == 0
```

```NOT READY
behaviour open of DssCdpManager
interface open(bytes32 ilk, address usr)

types

    Vat     : address Vat
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

    vat                 |-> Vat
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

    Vat.hope
    DssCdpManager.add
```

```act
behaviour give-diff-own-dst of DssCdpManager
interface give(uint256 cdp, address dst)

types

    CdpCan              : uint256
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

    cdpCan[Own][cdp][CALLER_ID] |-> CdpCan
    owns[cdp]                   |-> Own => dst
    count[Own]                  |-> CountOwn => CountOwn - 1
    count[dst]                  |-> CountDst => CountDst + 1
    last[Own]                   |-> LastOwn => #if ListCdpNext == 0 #then ListCdpPrev #else LastOwn #fi
    last[dst]                   |-> LastDst => cdp
    first[Own]                  |-> FirstOwn => #if FirstOwn == cdp #then ListCdpNext #else FirstOwn #fi
    first[dst]                  |-> FirstDst => #if FirstDst == 0 #then cdp #else FirstDst #fi
    list[cdp].prev              |-> ListCdpPrev => LastDst
    list[cdp].next              |-> ListCdpNext => 0
    list[LastDst].next          |-> ListLastDstNext => #if LastDst =/= 0 #then cdp #else ListLastDstNext #fi
    list[ListCdpPrev].next      |-> ListListCdpPrevNext => #if ListCdpPrev =/= 0 #then ListCdpNext #else ListListCdpPrevNext #fi
    list[ListCdpNext].prev      |-> ListListCdpNextPrev => #if ListCdpNext =/= 0 #then ListCdpPrev #else ListListCdpNextPrev #fi

iff in range uint256

    CountOwn - 1
    CountDst + 1

iff

    VCallValue == 0
    (CALLER_ID == Own) or (CdpCan == 1)
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
failure give-same-own-dst of DssCdpManager
interface give(uint256 cdp, address dst)

types

    CdpCan  : uint256
    Own     : address

storage

    cdpCan[Own][cdp][CALLER_ID] |-> CdpCan
    owns[cdp]                   |-> Own => dst

iff

    VCallValue == 0
    (CALLER_ID == Own) or (CdpCan == 1)
    dst =/= 0
    Own =/= dst

if

    Own == dst

calls

    DssCdpManager.add
    DssCdpManager.sub
```

```act
behaviour flux-ilk-diff of DssCdpManager
interface flux(bytes32 ilk, uint256 cdp, address dst, uint256 wad)

types

    Vat     : address Vat
    CdpCan  : uint256
    Own     : address
    Urn     : address
    May     : uint256
    GemUrn  : uint256
    GemDst  : uint256

storage

    vat                         |-> Vat
    cdpCan[Own][cdp][CALLER_ID] |-> CdpCan
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
    (CALLER_ID == Own) or (CdpCan == 1)

iff in range uint256

    GemUrn - wad
    GemDst + wad

if

    Urn =/= dst

calls

    Vat.flux-diff
```

```act
behaviour flux-ilk-same of DssCdpManager
interface flux(bytes32 ilk, uint256 cdp, address dst, uint256 wad)

types

    Vat     : address Vat
    CdpCan  : uint256
    Own     : address
    Urn     : address
    May     : uint256
    Gem     : uint256

storage

    vat                         |-> Vat
    cdpCan[Own][cdp][CALLER_ID] |-> CdpCan
    owns[cdp]                   |-> Own
    urns[cdp]                   |-> Urn

storage Vat

    can[Urn][ACCT_ID]   |-> May
    gem[ilk][Urn]       |-> Gem => Gem

iff

    VCallValue == 0
    VCallDepth < 1024
    (ACCT_ID == Urn) or (May == 1)
    (CALLER_ID == Own) or (CdpCan == 1)

iff in range uint256

    Gem - wad

if

    Urn == dst

calls

    Vat.flux-same
```

```act
behaviour flux-diff of DssCdpManager
interface flux(uint256 cdp, address dst, uint256 wad)

types

    Vat     : address Vat
    CdpCan  : uint256
    Own     : address
    Urn     : address
    Ilk     : bytes32
    May     : uint256
    GemUrn  : uint256
    GemDst  : uint256

storage

    vat                         |-> Vat
    cdpCan[Own][cdp][CALLER_ID] |-> CdpCan
    owns[cdp]                   |-> Own
    urns[cdp]                   |-> Urn
    ilks[cdp]                   |-> Ilk

storage Vat

    can[Urn][ACCT_ID]   |-> May
    gem[Ilk][Urn]       |-> GemUrn => GemUrn - wad
    gem[Ilk][dst]       |-> GemDst => GemDst + wad

iff

    VCallValue == 0
    VCallDepth < 1024
    (ACCT_ID == Urn) or (May == 1)
    (CALLER_ID == Own) or (CdpCan == 1)

iff in range uint256

    GemUrn - wad
    GemDst + wad

if

    Urn =/= dst

calls

    Vat.flux-diff
```

```act
behaviour flux-same of DssCdpManager
interface flux(uint256 cdp, address dst, uint256 wad)

types

    Vat     : address Vat
    CdpCan  : uint256
    Own     : address
    Urn     : address
    Ilk     : bytes32
    May     : uint256
    Gem     : uint256

storage

    vat                         |-> Vat
    cdpCan[Own][cdp][CALLER_ID] |-> CdpCan
    owns[cdp]                   |-> Own
    urns[cdp]                   |-> Urn
    ilks[cdp]                   |-> Ilk

storage Vat

    can[Urn][ACCT_ID]   |-> May
    gem[Ilk][Urn]       |-> Gem => Gem

iff

    VCallValue == 0
    VCallDepth < 1024
    (ACCT_ID == Urn) or (May == 1)
    (CALLER_ID == Own) or (CdpCan == 1)

iff in range uint256

    Gem - wad

if

    Urn == dst

calls

    Vat.flux-same
```

```act
behaviour move-diff of DssCdpManager
interface move(uint256 cdp, address dst, uint256 rad)

types

    Vat     : address Vat
    CdpCan  : uint256
    Own     : address
    Urn     : address
    May     : uint256
    DaiUrn  : uint256
    DaiDst  : uint256

storage

    vat                         |-> Vat
    cdpCan[Own][cdp][CALLER_ID] |-> CdpCan
    owns[cdp]                   |-> Own
    urns[cdp]                   |-> Urn

storage Vat

    can[Urn][ACCT_ID]   |-> May
    dai[Urn]            |-> DaiUrn => DaiUrn - rad
    dai[dst]            |-> DaiDst => DaiDst + rad

iff

    VCallValue == 0
    VCallDepth < 1024
    (ACCT_ID == Urn) or (May == 1)
    (CALLER_ID == Own) or (CdpCan == 1)

iff in range uint256

    DaiUrn - rad
    DaiDst + rad

if

    Urn =/= dst

calls

    Vat.move-diff
```

```act
behaviour move-same of DssCdpManager
interface move(uint256 cdp, address dst, uint256 rad)

types

    Vat     : address Vat
    CdpCan  : uint256
    Own     : address
    Urn     : address
    May     : uint256
    Dai     : uint256

storage

    vat                         |-> Vat
    cdpCan[Own][cdp][CALLER_ID] |-> CdpCan
    owns[cdp]                   |-> Own
    urns[cdp]                   |-> Urn

storage Vat

    can[Urn][ACCT_ID]   |-> May
    dai[Urn]            |-> Dai => Dai

iff

    VCallValue == 0
    VCallDepth < 1024
    (ACCT_ID == Urn) or (May == 1)
    (CALLER_ID == Own) or (CdpCan == 1)

iff in range uint256

    Dai - rad

if

    Urn == dst

calls

    Vat.move-same
```

```act
behaviour frob-nonzero of DssCdpManager
interface frob(uint256 cdp, int dink, int dart)

for all

    Vat      : address Vat
    CdpCan   : uint256
    Own      : address
    Urn      : address
    Ilk      : bytes32
    Ilk_rate : uint256
    Ilk_line : uint256
    Ilk_spot : uint256
    Ilk_dust : uint256
    Ilk_Art  : uint256
    Urn_ink  : uint256
    Urn_art  : uint256
    Gem_iu   : uint256
    Dai_u    : uint256
    Debt     : uint256
    Line     : uint256
    Can_u    : uint256
    Live     : uint256

storage

    vat                         |-> Vat
    cdpCan[Own][cdp][CALLER_ID] |-> CdpCan
    owns[cdp]                   |-> Own
    urns[cdp]                   |-> Urn
    ilks[cdp]                   |-> Ilk

storage Vat

    ilks[Ilk].rate          |-> Ilk_rate
    ilks[Ilk].line          |-> Ilk_line
    ilks[Ilk].spot          |-> Ilk_spot
    ilks[Ilk].dust          |-> Ilk_dust
    Line                    |-> Line
    can[Urn][ACCT_ID]       |-> Can_u
    urns[Ilk][Urn].ink      |-> Urn_ink  => Urn_ink + dink
    urns[Ilk][Urn].art      |-> Urn_art  => Urn_art + dart
    ilks[Ilk].Art           |-> Ilk_Art  => Ilk_Art + dart
    gem[Ilk][Urn]           |-> Gem_iu   => Gem_iu  - dink
    dai[Urn]                |-> Dai_u    => Dai_u + (Ilk_rate * dart)
    debt                    |-> Debt     => Debt  + (Ilk_rate * dart)
    live                    |-> Live

iff in range uint256

    Urn_ink + dink
    Gem_iu  - dink
    (Urn_ink + dink) * Ilk_spot
    (Urn_art + dart) * Ilk_rate
    (Ilk_Art + dart) * Ilk_rate
    Dai_u + (Ilk_rate * dart)
    Debt  + (Ilk_rate * dart)

iff in range int256

    Ilk_rate
    Ilk_rate * dart

iff

    VCallValue == 0
    VCallDepth < 1024
    (CALLER_ID == Own) or (CdpCan == 1)
    Live == 1
    Ilk_rate =/= 0
    (dart <= 0) or (((Ilk_Art + dart) * Ilk_rate <= Ilk_line) and ((Debt + Ilk_rate * dart) <= Line))
    (dart <= 0 and dink >= 0) or ((((Urn_art + dart) * Ilk_rate) <= ((Urn_ink + dink) * Ilk_spot)))
    (u == ACCT_ID or Can_u == 1)
    ((Urn_art + dart) == 0) or (((Urn_art + dart) * Ilk_rate) >= Ilk_dust)

if

    dink =/= 0
    dart =/= 0

calls

    Vat.frob-same-nonzero
```

```act
behaviour frob-zero-dart of DssCdpManager
interface frob(uint256 cdp, int dink, int dart)

for all

    Vat      : address Vat
    CdpCan   : uint256
    Own      : address
    Urn      : address
    Ilk      : bytes32
    Ilk_rate : uint256
    Ilk_line : uint256
    Ilk_spot : uint256
    Ilk_dust : uint256
    Ilk_Art  : uint256
    Urn_ink  : uint256
    Urn_art  : uint256
    Gem_iu   : uint256
    Dai_u    : uint256
    Debt     : uint256
    Line     : uint256
    Can_u    : uint256
    Live     : uint256

storage

    vat                         |-> Vat
    cdpCan[Own][cdp][CALLER_ID] |-> CdpCan
    owns[cdp]                   |-> Own
    urns[cdp]                   |-> Urn
    ilks[cdp]                   |-> Ilk

storage Vat

    ilks[Ilk].rate      |-> Ilk_rate
    ilks[Ilk].line      |-> Ilk_line
    ilks[Ilk].spot      |-> Ilk_spot
    ilks[Ilk].dust      |-> Ilk_dust
    Line                |-> Line
    can[Urn][ACCT_ID]   |-> Can_u
    urns[Ilk][Urn].ink  |-> Urn_ink  => Urn_ink + dink
    urns[Ilk][Urn].art  |-> Urn_art  => Urn_art
    ilks[Ilk].Art       |-> Ilk_Art  => Ilk_Art
    gem[Ilk][Urn]       |-> Gem_iu   => Gem_iu  - dink
    dai[Urn]            |-> Dai_u    => Dai_u
    debt                |-> Debt     => Debt
    live                |-> Live

iff in range uint256

    Urn_ink + dink
    Gem_iu  - dink
    (Urn_ink + dink) * Ilk_spot
    Urn_art * Ilk_rate
    Ilk_Art * Ilk_rate

iff in range int256

    Ilk_rate

iff

    VCallValue == 0
    VCallDepth < 1024
    (CALLER_ID == Own) or (CdpCan == 1)
    Live == 1
    Ilk_rate =/= 0
    (dink >= 0) or (((Urn_art * Ilk_rate) <= ((Urn_ink + dink) * Ilk_spot)))
    (u == ACCT_ID or Can_u == 1)
    (Urn_art == 0) or ((Urn_art * Ilk_rate) >= Ilk_dust)

if

    dink =/= 0
    dart == 0

calls

    Vat.frob-same-zero-dart
```

```act
behaviour frob-zero-dink of DssCdpManager
interface frob(uint256 cdp, int dink, int dart)

for all

    Vat      : address Vat
    CdpCan   : uint256
    Own      : address
    Urn      : address
    Ilk      : bytes32
    Ilk_rate : uint256
    Ilk_line : uint256
    Ilk_spot : uint256
    Ilk_dust : uint256
    Ilk_Art  : uint256
    Urn_ink  : uint256
    Urn_art  : uint256
    Gem_iu   : uint256
    Dai_u    : uint256
    Debt     : uint256
    Line     : uint256
    Can_u    : uint256
    Live     : uint256

storage

    vat                         |-> Vat
    cdpCan[Own][cdp][CALLER_ID] |-> CdpCan
    owns[cdp]                   |-> Own
    urns[cdp]                   |-> Urn
    ilks[cdp]                   |-> Ilk

storage Vat

    ilks[Ilk].rate      |-> Ilk_rate
    ilks[Ilk].line      |-> Ilk_line
    ilks[Ilk].spot      |-> Ilk_spot
    ilks[Ilk].dust      |-> Ilk_dust
    Line                |-> Line
    can[Urn][ACCT_ID]   |-> Can_u
    urns[Ilk][Urn].ink  |-> Urn_ink  => Urn_ink
    urns[Ilk][Urn].art  |-> Urn_art  => Urn_art + dart
    ilks[Ilk].Art       |-> Ilk_Art  => Ilk_Art + dart
    gem[Ilk][Urn]       |-> Gem_iu   => Gem_iu
    dai[Urn]            |-> Dai_u    => Dai_u + (Ilk_rate * dart)
    debt                |-> Debt     => Debt  + (Ilk_rate * dart)
    live                |-> Live

iff in range uint256

    Urn_ink * Ilk_spot
    (Urn_art + dart) * Ilk_rate
    (Ilk_Art + dart) * Ilk_rate
    Dai_u + (Ilk_rate * dart)
    Debt  + (Ilk_rate * dart)

iff in range int256

    Ilk_rate
    Ilk_rate * dart

iff

    VCallValue == 0
    VCallDepth < 1024
    (CALLER_ID == Own) or (CdpCan == 1)
    Live == 1
    Ilk_rate =/= 0
    (dart <= 0) or (((Ilk_Art + dart) * Ilk_rate <= Ilk_line) and ((Debt + Ilk_rate * dart) <= Line))
    (dart <= 0) or (((Urn_art + dart) * Ilk_rate) <= (Urn_ink * Ilk_spot))
    (u == ACCT_ID or Can_u == 1)
    ((Urn_art + dart) == 0) or (((Urn_art + dart) * Ilk_rate) >= Ilk_dust)

if

    dink == 0
    dart =/= 0

calls

    Vat.frob-same-zero-dink
````

```act
behaviour frob-zero of DssCdpManager
interface frob(uint256 cdp, int dink, int dart)

for all

    Vat      : address Vat
    CdpCan   : uint256
    Own      : address
    Urn      : address
    Ilk      : bytes32
    Ilk_rate : uint256
    Ilk_line : uint256
    Ilk_spot : uint256
    Ilk_dust : uint256
    Ilk_Art  : uint256
    Urn_ink  : uint256
    Urn_art  : uint256
    Gem_iu   : uint256
    Dai_u    : uint256
    Debt     : uint256
    Line     : uint256
    Can_u    : uint256
    Live     : uint256

storage

    vat                         |-> Vat
    cdpCan[Own][cdp][CALLER_ID] |-> CdpCan
    owns[cdp]                   |-> Own
    urns[cdp]                   |-> Urn
    ilks[cdp]                   |-> Ilk

storage Vat

    ilks[Ilk].rate      |-> Ilk_rate
    ilks[Ilk].line      |-> Ilk_line
    ilks[Ilk].spot      |-> Ilk_spot
    ilks[Ilk].dust      |-> Ilk_dust
    Line                |-> Line
    can[Urn][ACCT_ID]   |-> Can_u
    urns[Ilk][Urn].ink  |-> Urn_ink  => Urn_ink
    urns[Ilk][Urn].art  |-> Urn_art  => Urn_art
    ilks[Ilk].Art       |-> Ilk_Art  => Ilk_Art
    gem[Ilk][Urn]       |-> Gem_iu   => Gem_iu
    dai[Urn]            |-> Dai_u    => Dai_u
    debt                |-> Debt     => Debt
    live                |-> Live

iff in range uint256

    Urn_ink * Ilk_spot
    Urn_art * Ilk_rate
    Ilk_Art * Ilk_rate

iff in range int256

    Ilk_rate

iff

    VCallValue == 0
    VCallDepth < 1024
    (CALLER_ID == Own) or (CdpCan == 1)
    Live == 1
    Ilk_rate =/= 0
    (Urn_art == 0) or ((Urn_art * Ilk_rate) >= Ilk_dust)

if

    dink == 0
    dart == 0

calls

    Vat.frob-same-zero
```

```act
behaviour quit-diff of DssCdpManager
interface quit(uint256 cdp, address dst)

types

    Vat     : address Vat
    CdpCan  : uint256
    UrnCan  : uint256
    Own     : address
    Urn     : address
    Ilk     : bytes32
    Can_urn : uint256
    Can_dst : uint256
    Rate    : uint256
    Spot    : uint256
    Dust    : uint256
    Ink_u   : uint256
    Art_u   : uint256
    Ink_v   : uint256
    Art_v   : uint256

storage

    vat                         |-> Vat
    cdpCan[Own][cdp][CALLER_ID] |-> CdpCan
    urnCan[dst][CALLER_ID]      |-> UrnCan
    owns[cdp]                   |-> Own
    urns[cdp]                   |-> Urn
    ilks[cdp]                   |-> Ilk

storage Vat

    can[Urn][ACCT_ID]   |-> Can_urn
    can[dst][ACCT_ID]   |-> Can_dst
    ilks[Ilk].rate      |-> Rate
    ilks[Ilk].spot      |-> Spot
    ilks[Ilk].dust      |-> Dust
    urns[Ilk][Urn].ink  |-> Ink_u => 0
    urns[Ilk][Urn].art  |-> Art_u => 0
    urns[Ilk][dst].ink  |-> Ink_v => Ink_v + Ink_u
    urns[Ilk][dst].art  |-> Art_v => Art_v + Art_u

iff

    VCallValue == 0
    VCallDepth < 1024

    (CALLER_ID == Own) or (CdpCan == 1)
    (CALLER_ID == dst) or (UrnCan == 1)

    (ACCT_ID == Urn) or (Can_urn == 1)
    (ACCT_ID == dst) or (Can_dst == 1)
    (Art_v + Art_u) * Rate <= (Ink_v + Ink_u) * Spot
    ((Art_v + Art_u) * Rate >= Dust) or (Art_v + Art_u == 0)

iff in range uint256

    Ink_v + Ink_u
    Art_v + Art_u
    (Ink_v + Ink_u) * Spot

iff in range int256

    Ink_u
    Art_u

if

    Urn =/= dst

calls

    DssCdpManager.toInt
    Vat.fork-diff
```

```act
behaviour quit-same of DssCdpManager
interface quit(uint256 cdp, address dst)

types

    Vat     : address Vat
    CdpCan  : uint256
    UrnCan  : uint256
    Own     : address
    Urn     : address
    Ilk     : bytes32
    Can_urn : uint256
    Rate    : uint256
    Spot    : uint256
    Dust    : uint256
    Ink_u   : uint256
    Art_u   : uint256

storage

    vat                         |-> Vat
    cdpCan[Own][cdp][CALLER_ID] |-> CdpCan
    urnCan[dst][CALLER_ID]      |-> UrnCan
    owns[cdp]                   |-> Own
    urns[cdp]                   |-> Urn
    ilks[cdp]                   |-> Ilk

storage Vat

    can[Urn][ACCT_ID]   |-> Can_urn
    ilks[Ilk].rate      |-> Rate
    ilks[Ilk].spot      |-> Spot
    ilks[Ilk].dust      |-> Dust
    urns[Ilk][Urn].ink  |-> Ink_u => Ink_u
    urns[Ilk][Urn].art  |-> Art_u => Art_u

iff

    VCallValue == 0
    VCallDepth < 1024

    (CALLER_ID == Own) or (CdpCan == 1)
    (CALLER_ID == dst) or (UrnCan == 1)

    (ACCT_ID == Urn) or (Can_urn == 1)
    Art_u * Rate <= Ink_u * Spot
    (Art_u * Rate >= Dust) or (Art_u == 0)

iff in range uint256

    Ink_u * Spot

iff in range int256

    Ink_u
    Art_u

if

    Urn == dst

calls

    DssCdpManager.toInt
    Vat.fork-same
```

```act
behaviour enter-diff of DssCdpManager
interface enter(address src, uint256 cdp)

types

    Vat     : address Vat
    UrnCan  : uint256
    CdpCan  : uint256
    Own     : address
    Urn     : address
    Ilk     : bytes32
    Can_src : uint256
    Can_urn : uint256
    Rate    : uint256
    Spot    : uint256
    Dust    : uint256
    Ink_u   : uint256
    Art_u   : uint256
    Ink_v   : uint256
    Art_v   : uint256

storage

    vat                         |-> Vat
    urnCan[src][CALLER_ID]      |-> UrnCan
    cdpCan[Own][cdp][CALLER_ID] |-> CdpCan
    owns[cdp]                   |-> Own
    urns[cdp]                   |-> Urn
    ilks[cdp]                   |-> Ilk

storage Vat

    can[src][ACCT_ID]   |-> Can_src
    can[Urn][ACCT_ID]   |-> Can_urn
    ilks[Ilk].rate      |-> Rate
    ilks[Ilk].spot      |-> Spot
    ilks[Ilk].dust      |-> Dust
    urns[Ilk][src].ink  |-> Ink_u => 0
    urns[Ilk][src].art  |-> Art_u => 0
    urns[Ilk][Urn].ink  |-> Ink_v => Ink_v + Ink_u
    urns[Ilk][Urn].art  |-> Art_v => Art_v + Art_u

iff

    VCallValue == 0
    VCallDepth < 1024

    (CALLER_ID == Own) or (CdpCan == 1)
    (CALLER_ID == src) or (UrnCan == 1)

    (ACCT_ID == src) or (Can_src == 1)
    (ACCT_ID == Urn) or (Can_urn == 1)
    (Art_v + Art_u) * Rate <= (Ink_v + Ink_u) * Spot
    ((Art_v + Art_u) * Rate >= Dust) or (Art_v + Art_u == 0)

iff in range uint256

    Ink_v + Ink_u
    Art_v + Art_u
    (Ink_v + Ink_u) * Spot

iff in range int256

    Ink_u
    Art_u

if

    Urn =/= dst

calls

    DssCdpManager.toInt
    Vat.fork-diff
```

```act
behaviour enter-same of DssCdpManager
interface enter(address src, uint256 cdp)

types

    Vat     : address Vat
    UrnCan  : uint256
    CdpCan  : uint256
    Own     : address
    Urn     : address
    Ilk     : bytes32
    Can_urn : uint256
    Rate    : uint256
    Spot    : uint256
    Dust    : uint256
    Ink_u   : uint256
    Art_u   : uint256

storage

    vat                         |-> Vat
    urnCan[src][CALLER_ID]      |-> UrnCan
    cdpCan[Own][cdp][CALLER_ID] |-> CdpCan
    owns[cdp]                   |-> Own
    urns[cdp]                   |-> Urn
    ilks[cdp]                   |-> Ilk

storage Vat

    can[src][ACCT_ID]   |-> Can_urn
    ilks[Ilk].rate      |-> Rate
    ilks[Ilk].spot      |-> Spot
    ilks[Ilk].dust      |-> Dust
    urns[Ilk][src].ink  |-> Ink_u => Ink_u
    urns[Ilk][src].art  |-> Art_u => Art_u

iff

    VCallValue == 0
    VCallDepth < 1024

    (CALLER_ID == dst) or (UrnCan == 1)
    (CALLER_ID == Own) or (CdpCan == 1)

    (ACCT_ID == Urn) or (Can_urn == 1)
    Art_u * Rate <= Ink_u * Spot
    (Art_u * Rate >= Dust) or (Art_u == 0)

iff in range uint256

    Ink_u * Spot

iff in range int256

    Ink_u
    Art_u

if

    Urn == src

calls

    DssCdpManager.toInt
    Vat.fork-same
```

```act
behaviour shift-diff of DssCdpManager
interface shift(uint256 cdpSrc, uint256 cdpDst)

types

    Vat         : address Vat
    CdpSrcCan   : uint256
    CdpDstCan   : uint256
    OwnSrc      : address
    OwnDst      : address
    UrnSrc      : address
    UrnDst      : address
    IlkSrc      : bytes32
    IlkDst      : bytes32
    Can_urn_src : uint256
    Can_urn_dst : uint256
    Rate        : uint256
    Spot        : uint256
    Dust        : uint256
    Ink_u       : uint256
    Art_u       : uint256
    Ink_v       : uint256
    Art_v       : uint256

storage

    vat                             |-> Vat
    cdpCan[Own][cdpSrc][CALLER_ID]  |-> CdpSrcCan
    cdpCan[Own][cdpDst][CALLER_ID]  |-> CdpDstCan
    owns[cdpSrc]                    |-> OwnSrc
    owns[cdpDst]                    |-> OwnDst
    urns[cdpSrc]                    |-> UrnSrc
    urns[cdpDst]                    |-> UrnDst
    ilks[cdpSrc]                    |-> IlkSrc
    ilks[cdpDst]                    |-> IlkDst

storage Vat

    can[UrnSrc][ACCT_ID]        |-> Can_urn_src
    can[UrnDst][ACCT_ID]        |-> Can_urn_dst
    ilks[IlkSrc].rate           |-> Rate
    ilks[IlkSrc].spot           |-> Spot
    ilks[IlkSrc].dust           |-> Dust
    urns[IlkSrc][UrnSrc].ink    |-> Ink_u => 0
    urns[IlkSrc][UrnSrc].art    |-> Art_u => 0
    urns[IlkSrc][UrnDst].ink    |-> Ink_v => Ink_v + Ink_u
    urns[IlkSrc][UrnDst].art    |-> Art_v => Art_v + Art_u

iff

    VCallValue == 0
    VCallDepth < 1024

    (CALLER_ID == OwnSrc) or (CdpSrcCan == 1)
    (CALLER_ID == OwnDst) or (CdpDstCan == 1)
    IlkSrc == IlkDst

    (ACCT_ID == UrnSrc) or (Can_urn_src == 1)
    (ACCT_ID == UrnDst) or (Can_urn_dst == 1)
    (Art_v + Art_u) * Rate <= (Ink_v + Ink_u) * Spot
    ((Art_v + Art_u) * Rate >= Dust) or (Art_v + Art_u == 0)

iff in range uint256

    Ink_v + Ink_u
    Art_v + Art_u
    (Ink_v + Ink_u) * Spot

iff in range int256

    Ink_u
    Art_u

if

    cdpSrc =/= cdpDst
    UrnSrc =/= UrnDst

calls

    DssCdpManager.toInt
    Vat.fork-diff
```

```act
behaviour shift-same of DssCdpManager
interface shift(uint256 cdpSrc, uint256 cdpDst)

types

    Vat         : address Vat
    CdpSrcCan   : uint256
    OwnSrc      : address
    UrnSrc      : address
    IlkSrc      : bytes32
    Can_urn_src : uint256
    Rate        : uint256
    Spot        : uint256
    Dust        : uint256
    Ink_u       : uint256
    Art_u       : uint256

storage

    vat                             |-> Vat
    cdpCan[Own][cdpSrc][CALLER_ID]  |-> CdpSrcCan
    owns[cdpSrc]                    |-> OwnSrc
    urns[cdpSrc]                    |-> UrnSrc
    ilks[cdpSrc]                    |-> IlkSrc

storage Vat

    can[UrnSrc][ACCT_ID]        |-> Can_urn_src
    ilks[IlkSrc].rate           |-> Rate
    ilks[IlkSrc].spot           |-> Spot
    ilks[IlkSrc].dust           |-> Dust
    urns[IlkSrc][UrnSrc].ink    |-> Ink_u => Ink_u
    urns[IlkSrc][UrnSrc].art    |-> Art_u => Art_u

iff

    VCallValue == 0
    VCallDepth < 1024

    (CALLER_ID == OwnSrc) or (CdpSrcCan == 1)

    (ACCT_ID == UrnSrc) or (Can_urn_src == 1)
    Art_u * Rate <= (Ink_u) * Spot
    (Art_u * Rate >= Dust) or (Art_u == 0)

iff in range uint256

    Ink_u * Spot

iff in range int256

    Ink_u
    Art_u

if

    cdpSrc == cdpDst

calls

    DssCdpManager.toInt
    Vat.fork-diff
```

# Vat acts

```act
behaviour addui of Vat
interface add(uint256 x, int256 y) internal

stack

   #unsigned(y) : x : JMPTO : WS => JMPTO : x + y : WS

iff in range uint256

   x + y

if

   #sizeWordStack(WS) <= 1015
```

```act
behaviour subui of Vat
interface sub(uint256 x, int256 y) internal

stack

    #unsigned(y) : x : JMPTO : WS => JMPTO : x - y : WS

iff in range uint256

    x - y

if

    #sizeWordStack(WS) <= 1015
```

```act
behaviour mului of Vat
interface mul(uint256 x, int256 y) internal

stack

    #unsigned(y) : x : JMPTO : WS => JMPTO : #unsigned(x * y) : WS

iff in range int256

    x
    x * y

if

    #sizeWordStack(WS) <= 1000
```

```act
behaviour adduu of Vat
interface add(uint256 x, uint256 y) internal

stack

    y : x : JMPTO : WS => JMPTO : x + y : WS

iff in range uint256

    x + y

if

    #sizeWordStack(WS) <= 1000
```

```act
behaviour subuu of Vat
interface sub(uint256 x, uint256 y) internal

stack

    y : x : JMPTO : WS => JMPTO : x - y : WS

iff in range uint256

    x - y

if

    #sizeWordStack(WS) <= 1000
```

```act
behaviour muluu of Vat
interface mul(uint256 x, uint256 y) internal

stack

    y : x : JMPTO : WS => JMPTO : x * y : WS

iff in range uint256

    x * y

if

    #sizeWordStack(WS) <= 1000
```

```act
behaviour hope of Vat
interface hope(address usr)

storage

    can[CALLER_ID][usr] |-> _ => 1

iff

    VCallValue == 0
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

```act
behaviour move-diff of Vat
interface move(address src, address dst, uint256 rad)

for all

    Dai_dst : uint256
    Dai_src : uint256
    May     : uint256

storage

    can[src][CALLER_ID] |-> May
    dai[src]            |-> Dai_src => Dai_src - rad
    dai[dst]            |-> Dai_dst => Dai_dst + rad

iff

    // act: caller is `. ? : not` authorised
    (May == 1 or src == CALLER_ID)
    VCallValue == 0

iff in range uint256

    Dai_src - rad
    Dai_dst + rad

if

    src =/= dst

calls

  Vat.adduu
  Vat.subuu
```

```act
behaviour move-same of Vat
interface move(address src, address dst, uint256 rad)

for all

    Dai_src : uint256
    May     : uint256

storage

    can[src][CALLER_ID] |-> May
    dai[src]            |-> Dai_src => Dai_src

iff

    // act: caller is `. ? : not` authorised
    (May == 1 or src == CALLER_ID)
    VCallValue == 0

iff in range uint256

    Dai_src - rad

if

    src == dst

calls

    Vat.subuu
    Vat.adduu
```

```act
behaviour frob-same-nonzero of Vat
interface frob(bytes32 i, address u, address v, address w, int dink, int dart)

for all

    Ilk_rate : uint256
    Ilk_line : uint256
    Ilk_spot : uint256
    Ilk_dust : uint256
    Ilk_Art  : uint256
    Urn_ink  : uint256
    Urn_art  : uint256
    Gem_iu   : uint256
    Dai_u    : uint256
    Debt     : uint256
    Line     : uint256
    Can_u    : uint256
    Live     : uint256

storage

    ilks[i].rate      |-> Ilk_rate
    ilks[i].line      |-> Ilk_line
    ilks[i].spot      |-> Ilk_spot
    ilks[i].dust      |-> Ilk_dust
    Line              |-> Line
    can[u][CALLER_ID] |-> Can_u
    urns[i][u].ink    |-> Urn_ink  => Urn_ink + dink
    urns[i][u].art    |-> Urn_art  => Urn_art + dart
    ilks[i].Art       |-> Ilk_Art  => Ilk_Art + dart
    gem[i][u]         |-> Gem_iu   => Gem_iu  - dink
    dai[u]            |-> Dai_u    => Dai_u + (Ilk_rate * dart)
    debt              |-> Debt     => Debt  + (Ilk_rate * dart)
    live              |-> Live

iff in range uint256

    Urn_ink + dink
    Gem_iu  - dink
    (Urn_ink + dink) * Ilk_spot
    (Urn_art + dart) * Ilk_rate
    (Ilk_Art + dart) * Ilk_rate
    Dai_u + (Ilk_rate * dart)
    Debt  + (Ilk_rate * dart)

iff in range int256

    Ilk_rate
    Ilk_rate * dart

iff

    VCallValue == 0
    Live == 1
    Ilk_rate =/= 0
    (dart <= 0) or (((Ilk_Art + dart) * Ilk_rate <= Ilk_line) and ((Debt + Ilk_rate * dart) <= Line))
    (dart <= 0 and dink >= 0) or ((((Urn_art + dart) * Ilk_rate) <= ((Urn_ink + dink) * Ilk_spot)))
    (u == CALLER_ID or Can_u == 1)
    ((Urn_art + dart) == 0) or (((Urn_art + dart) * Ilk_rate) >= Ilk_dust)

if

    u == v
    v == w
    u == w
    dink =/= 0
    dart =/= 0

calls

    Vat.addui
    Vat.subui
    Vat.mului
    Vat.muluu
```

```act
behaviour frob-same-zero-dart of Vat
interface frob(bytes32 i, address u, address v, address w, int dink, int dart)

for all

    Ilk_rate : uint256
    Ilk_line : uint256
    Ilk_spot : uint256
    Ilk_dust : uint256
    Ilk_Art  : uint256
    Urn_ink  : uint256
    Urn_art  : uint256
    Gem_iu   : uint256
    Dai_u    : uint256
    Debt     : uint256
    Line     : uint256
    Can_u    : uint256
    Live     : uint256

storage

    ilks[i].rate      |-> Ilk_rate
    ilks[i].line      |-> Ilk_line
    ilks[i].spot      |-> Ilk_spot
    ilks[i].dust      |-> Ilk_dust
    Line              |-> Line
    can[u][CALLER_ID] |-> Can_u
    urns[i][u].ink    |-> Urn_ink  => Urn_ink + dink
    urns[i][u].art    |-> Urn_art  => Urn_art
    ilks[i].Art       |-> Ilk_Art  => Ilk_Art
    gem[i][u]         |-> Gem_iu   => Gem_iu  - dink
    dai[u]            |-> Dai_u    => Dai_u
    debt              |-> Debt     => Debt
    live              |-> Live

iff in range uint256

    Urn_ink + dink
    Gem_iu  - dink
    (Urn_ink + dink) * Ilk_spot
    Urn_art * Ilk_rate
    Ilk_Art * Ilk_rate

iff in range int256

    Ilk_rate

iff

    VCallValue == 0
    Live == 1
    Ilk_rate =/= 0
    (dink >= 0) or (((Urn_art * Ilk_rate) <= ((Urn_ink + dink) * Ilk_spot)))
    (u == CALLER_ID or Can_u == 1)
    (Urn_art == 0) or ((Urn_art * Ilk_rate) >= Ilk_dust)

if

    u == v
    v == w
    u == w
    dink =/= 0
    dart == 0

calls

    Vat.addui
    Vat.subui
    Vat.mului
    Vat.muluu
```

```act
behaviour frob-same-zero-dink of Vat
interface frob(bytes32 i, address u, address v, address w, int dink, int dart)

for all

    Ilk_rate : uint256
    Ilk_line : uint256
    Ilk_spot : uint256
    Ilk_dust : uint256
    Ilk_Art  : uint256
    Urn_ink  : uint256
    Urn_art  : uint256
    Gem_iu   : uint256
    Dai_u    : uint256
    Debt     : uint256
    Line     : uint256
    Can_u    : uint256
    Live     : uint256

storage

    ilks[i].rate      |-> Ilk_rate
    ilks[i].line      |-> Ilk_line
    ilks[i].spot      |-> Ilk_spot
    ilks[i].dust      |-> Ilk_dust
    Line              |-> Line
    can[u][CALLER_ID] |-> Can_u
    urns[i][u].ink    |-> Urn_ink  => Urn_ink
    urns[i][u].art    |-> Urn_art  => Urn_art + dart
    ilks[i].Art       |-> Ilk_Art  => Ilk_Art + dart
    gem[i][u]         |-> Gem_iu   => Gem_iu
    dai[u]            |-> Dai_u    => Dai_u + (Ilk_rate * dart)
    debt              |-> Debt     => Debt  + (Ilk_rate * dart)
    live              |-> Live

iff in range uint256

    Urn_ink * Ilk_spot
    (Urn_art + dart) * Ilk_rate
    (Ilk_Art + dart) * Ilk_rate
    Dai_u + (Ilk_rate * dart)
    Debt  + (Ilk_rate * dart)

iff in range int256

    Ilk_rate
    Ilk_rate * dart

iff

    VCallValue == 0
    Live == 1
    Ilk_rate =/= 0
    (dart <= 0) or (((Ilk_Art + dart) * Ilk_rate <= Ilk_line) and ((Debt + Ilk_rate * dart) <= Line))
    (dart <= 0) or (((Urn_art + dart) * Ilk_rate) <= (Urn_ink * Ilk_spot))
    (u == CALLER_ID or Can_u == 1)
    ((Urn_art + dart) == 0) or (((Urn_art + dart) * Ilk_rate) >= Ilk_dust)

if

    u == v
    v == w
    u == w
    dink == 0
    dart =/= 0

calls

    Vat.addui
    Vat.subui
    Vat.mului
    Vat.muluu
```

```act
behaviour frob-same-zero of Vat
interface frob(bytes32 i, address u, address v, address w, int dink, int dart)

for all

    Ilk_rate : uint256
    Ilk_line : uint256
    Ilk_spot : uint256
    Ilk_dust : uint256
    Ilk_Art  : uint256
    Urn_ink  : uint256
    Urn_art  : uint256
    Gem_iu   : uint256
    Dai_u    : uint256
    Debt     : uint256
    Line     : uint256
    Can_u    : uint256
    Live     : uint256

storage

    ilks[i].rate      |-> Ilk_rate
    ilks[i].line      |-> Ilk_line
    ilks[i].spot      |-> Ilk_spot
    ilks[i].dust      |-> Ilk_dust
    Line              |-> Line
    can[u][CALLER_ID] |-> Can_u
    urns[i][u].ink    |-> Urn_ink  => Urn_ink
    urns[i][u].art    |-> Urn_art  => Urn_art
    ilks[i].Art       |-> Ilk_Art  => Ilk_Art
    gem[i][u]         |-> Gem_iu   => Gem_iu
    dai[u]            |-> Dai_u    => Dai_u
    debt              |-> Debt     => Debt
    live              |-> Live

iff in range uint256

    Urn_ink * Ilk_spot
    Urn_art * Ilk_rate
    Ilk_Art * Ilk_rate

iff in range int256

    Ilk_rate

iff

    VCallValue == 0
    Live == 1
    Ilk_rate =/= 0
    (Urn_art == 0) or ((Urn_art * Ilk_rate) >= Ilk_dust)

if

    u == v
    v == w
    u == w
    dink == 0
    dart == 0

calls

    Vat.addui
    Vat.subui
    Vat.mului
    Vat.muluu
```

```act
behaviour fork-diff of Vat
interface fork(bytes32 ilk, address src, address dst, int256 dink, int256 dart)

for all

    Can_src : uint256
    Can_dst : uint256
    Rate    : uint256
    Spot    : uint256
    Dust    : uint256
    Ink_u   : uint256
    Art_u   : uint256
    Ink_v   : uint256
    Art_v   : uint256

storage

    can[src][CALLER_ID] |-> Can_src
    can[dst][CALLER_ID] |-> Can_dst
    ilks[ilk].rate      |-> Rate
    ilks[ilk].spot      |-> Spot
    ilks[ilk].dust      |-> Dust
    urns[ilk][src].ink  |-> Ink_u => Ink_u - dink
    urns[ilk][src].art  |-> Art_u => Art_u - dart
    urns[ilk][dst].ink  |-> Ink_v => Ink_v + dink
    urns[ilk][dst].art  |-> Art_v => Art_v + dart

iff
    VCallValue == 0

    (src == CALLER_ID) or (Can_src == 1)
    (dst == CALLER_ID) or (Can_dst == 1)

    (Art_u - dart) * Rate <= (Ink_u - dink) * Spot
    (Art_v + dart) * Rate <= (Ink_v + dink) * Spot

    ((Art_u - dart) * Rate >= Dust) or (Art_u - dart == 0)
    ((Art_v + dart) * Rate >= Dust) or (Art_v + dart == 0)

iff in range uint256

    Ink_u - dink
    Ink_v + dink
    Art_u - dart
    Art_v + dart
    (Ink_u - dink) * Spot
    (Ink_v + dink) * Spot

if

    src =/= dst

calls

    Vat.addui
    Vat.subui
    Vat.muluu
```

```act
behaviour fork-same of Vat
interface fork(bytes32 ilk, address src, address dst, int256 dink, int256 dart)

for all

    Can_src : uint256
    Rate    : uint256
    Spot    : uint256
    Dust    : uint256
    Ink_u   : uint256
    Art_u   : uint256

storage

    can[src][CALLER_ID] |-> Can_src
    ilks[ilk].rate      |-> Rate
    ilks[ilk].spot      |-> Spot
    ilks[ilk].dust      |-> Dust
    urns[ilk][src].ink  |-> Ink_u => Ink_u
    urns[ilk][src].art  |-> Art_u => Art_u


iff

    VCallValue == 0

    (dink >= 0) or (Ink_u - dink <= maxUInt256)
    (dink <= 0) or (Ink_u - dink >= 0)
    (dart >= 0) or (Art_u - dart <= maxUInt256)
    (dart <= 0) or (Art_u - dart >= 0)

    Ink_u * Spot <= maxUInt256

    (src == CALLER_ID) or (Can_src == 1)

    Art_u * Rate <= Ink_u * Spot
    (Art_u * Rate >= Dust) or (Art_u == 0)

if

    src == dst

calls

    Vat.addui
    Vat.subui
    Vat.muluu
```
