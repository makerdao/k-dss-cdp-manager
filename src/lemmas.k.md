```k
// uadd
// lemmas for necessity
rule notBool(chop(A +Int B) <Int A) => A +Int B <=Int maxUInt256
  requires #rangeUInt(256, A)
  andBool #rangeUInt(256, B)

// usub
// lemmas for necessity
rule notBool(A -Word B >Int A) => (A -Int B >=Int minUInt256)
  requires #rangeUInt(256, A)
  andBool #rangeUInt(256, B)

// hashed storage offsets never overflow (probabilistic assumption):
rule chop(keccakIntList(L) +Int N) => keccakIntList(L) +Int N
  requires N <=Int 100

// solidity also needs:
rule chop(keccakIntList(L)) => keccakIntList(L)
// and
rule chop(N +Int keccakIntList(L)) => keccakIntList(L) +Int N
  requires N <=Int 100

// Address masking
syntax Int ::= "Mask12_32" [function]
// 0xffffffffffffffffffffffff0000000000000000000000000000000000000000
rule Mask12_32 => 115792089237316195423570985007226406215939081747436879206741300988257197096960 [macro]

rule Mask12_32 &Int A => 0
  requires #rangeAddress(A)

syntax Int ::= "keccak30"
syntax Int ::= "keccak30PlusOne"
rule keccak30 => 24465873643947496235832446106509767096567058095563226156125564318740882468607 [macro]
rule keccak30PlusOne => 24465873643947496235832446106509767096567058095563226156125564318740882468608 [macro]

// Concrete hash collission
rule keccakIntList(C) +Int B ==K keccak30 => false
  requires 0 <=Int B andBool B <=Int 20
  andBool C =/=K (3 0 .IntList)

rule keccak30 ==K keccakIntList(C) +Int B => false
  requires 0 <=Int B andBool B <=Int 20
  andBool C =/=K (3 0 .IntList)

rule keccakIntList(C) ==K keccak30 => false
  requires C =/=K (3 0 .IntList)

rule keccak30 ==K keccakIntList(C) => false
  requires C =/=K (3 0 .IntList)

rule keccakIntList(C) ==K keccak30PlusOne => false

rule keccak30PlusOne ==K keccakIntList(C) => false

rule WM [ N := #take(I, W) ] => (WM [ N := (W [ 0 ] : .WordStack) ]) [ (N +Int 1) := (#take(I -Int 1, #drop(1, W))) ]
  requires I >=Int 1

rule WM [ N := #take(I, #drop(J, W)) ] => WM [ N := (W [ J ] : .WordStack) ] [ (N +Int 1) := (#take(I -Int 1, #drop(J +Int 1, W))) ]
  requires I >=Int 1
```
