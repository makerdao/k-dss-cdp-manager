### DssCdpManager

```k
syntax Int::= "#DssCdpManager.vat" [function]
rule #DssCdpManager.vat => 0

syntax Int::= "#DssCdpManager.cdpi" [function]
rule #DssCdpManager.cdpi => 1

syntax Int ::= "#DssCdpManager.urns" "[" Int "]" [function]
rule #DssCdpManager.urns[Cdp] => #hashedLocation("Solidity", 2, Cdp)

syntax Int ::= "#DssCdpManager.list" "[" Int "].prev" [function]
rule #DssCdpManager.list[Usr].prev => #hashedLocation("Solidity", 3, Usr)

syntax Int ::= "#DssCdpManager.list" "[" Int "].next" [function]
rule #DssCdpManager.list[Usr].next => #hashedLocation("Solidity", 3, Usr) +Int 1

syntax Int ::= "#DssCdpManager.owns" "[" Int "]" [function]
rule #DssCdpManager.owns[Cdp] => #hashedLocation("Solidity", 4, Cdp)

syntax Int ::= "#DssCdpManager.ilks" "[" Int "]" [function]
rule #DssCdpManager.ilks[Cdp] => #hashedLocation("Solidity", 5, Cdp)

syntax Int ::= "#DssCdpManager.first" "[" Int "]" [function]
rule #DssCdpManager.first[Usr] => #hashedLocation("Solidity", 6, Usr)

syntax Int ::= "#DssCdpManager.last" "[" Int "]" [function]
rule #DssCdpManager.last[Usr] => #hashedLocation("Solidity", 7, Usr)

syntax Int ::= "#DssCdpManager.count" "[" Int "]" [function]
rule #DssCdpManager.count[Usr] => #hashedLocation("Solidity", 8, Usr)

syntax Int ::= "#DssCdpManager.allows" "[" Int "][" Int "][" Int "]" [function]
rule #DssCdpManager.allows[Lad][Cdp][Usr] => #hashedLocation("Solidity", 9, Lad Cdp Usr)

```

### Vat

```k
syntax Int ::= "#Vat.wards" "[" Int "]" [function]
rule #Vat.wards[A] => #hashedLocation("Solidity", 0, A)

syntax Int ::= "#Vat.can" "[" Int "][" Int "]" [function]
rule #Vat.can[A][B] => #hashedLocation("Solidity", 1, A B)

syntax Int ::= "#Vat.ilks" "[" Int "].Art" [function]
rule #Vat.ilks[Ilk].Art => #hashedLocation("Solidity", 2, Ilk) +Int 0

syntax Int ::= "#Vat.ilks" "[" Int "].rate" [function]
rule #Vat.ilks[Ilk].rate => #hashedLocation("Solidity", 2, Ilk) +Int 1

syntax Int ::= "#Vat.ilks" "[" Int "].spot" [function]
rule #Vat.ilks[Ilk].spot => #hashedLocation("Solidity", 2, Ilk) +Int 2

syntax Int ::= "#Vat.ilks" "[" Int "].line" [function]
rule #Vat.ilks[Ilk].line => #hashedLocation("Solidity", 2, Ilk) +Int 3

syntax Int ::= "#Vat.ilks" "[" Int "].dust" [function]
rule #Vat.ilks[Ilk].dust => #hashedLocation("Solidity", 2, Ilk) +Int 4

syntax Int ::= "#Vat.urns" "[" Int "][" Int "].ink" [function]
rule #Vat.urns[Ilk][Usr].ink => #hashedLocation("Solidity", 3, Ilk Usr)

syntax Int ::= "#Vat.urns" "[" Int "][" Int "].art" [function]
rule #Vat.urns[Ilk][Usr].art => #hashedLocation("Solidity", 3, Ilk Usr) +Int 1

syntax Int ::= "#Vat.gem" "[" Int "][" Int "]" [function]
rule #Vat.gem[Ilk][Usr] => #hashedLocation("Solidity", 4, Ilk Usr)

syntax Int ::= "#Vat.dai" "[" Int "]" [function]
rule #Vat.dai[A] => #hashedLocation("Solidity", 5, A)

syntax Int ::= "#Vat.sin" "[" Int "]" [function]
rule #Vat.sin[A] => #hashedLocation("Solidity", 6, A)

syntax Int ::= "#Vat.debt" [function]
rule #Vat.debt => 7

syntax Int ::= "#Vat.vice" [function]
rule #Vat.vice => 8

syntax Int ::= "#Vat.Line" [function]
rule #Vat.Line => 9

syntax Int ::= "#Vat.live" [function]
rule #Vat.live => 10
```
