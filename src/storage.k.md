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

syntax Int ::= "#DssCdpManager.lads" "[" Int "]" [function]
rule #DssCdpManager.lads[Cdp] => #hashedLocation("Solidity", 4, Cdp)

syntax Int ::= "#DssCdpManager.ilks" "[" Int "]" [function]
rule #DssCdpManager.ilks[Cdp] => #hashedLocation("Solidity", 5, Cdp)

syntax Int ::= "#DssCdpManager.first" "[" Int "]" [function]
rule #DssCdpManager.first[Usr] => #hashedLocation("Solidity", 6, Usr)

syntax Int ::= "#DssCdpManager.last" "[" Int "]" [function]
rule #DssCdpManager.last[Usr] => #hashedLocation("Solidity", 7, Usr)

syntax Int ::= "#DssCdpManager.count" "[" Int "]" [function]
rule #DssCdpManager.count[Usr] => #hashedLocation("Solidity", 8, Usr)

syntax Int ::= "#DssCdpManager.allows" "[" Int "]" "[" Int "]" "[" Int "]" [function]
rule #DssCdpManager.allows[Lad][Cdp][Usr] => #hashedLocation("Solidity", 9, Lad Cdp Usr)
```
