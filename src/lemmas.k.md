# Vat and general lemmas

```k
rule (#if C #then A #else B #fi *Int X) <=Int maxUInt256 => true
  requires A *Int X <=Int maxUInt256
  andBool B *Int X <=Int maxUInt256
```

# dss lemmas

### special fixed-point arithmetic

```k
syntax Int ::= "#Wad" [function]
// -----------------------------
rule #Wad => 1000000000000000000           [macro]

syntax Int ::= "#Ray" [function]
// -----------------------------
rule #Ray => 1000000000000000000000000000  [macro]

syntax Int ::= "#rmul" "(" Int "," Int ")" [function]
rule #rmul(X, Y) => (X *Int Y) /Int #Ray
```

### hashed storage

```k
// hashed storage offsets never overflow (probabilistic assumption):
rule chop(keccakIntList(L) +Int N) => keccakIntList(L) +Int N
  requires N <=Int 100

// solidity also needs:
rule chop(keccakIntList(L)) => keccakIntList(L)
// and
rule chop(N +Int keccakIntList(L)) => keccakIntList(L) +Int N
  requires N <=Int 100
```

### miscellaneous

```k
rule WS ++ .WordStack => WS

rule #sizeWordStack ( #padToWidth ( 32 , #asByteStack ( #unsigned ( W ) ) ) ) => 32
  requires #rangeSInt(256, W)

// custom ones:
rule #asWord(#padToWidth(32, #asByteStack(#unsigned(X)))) => #unsigned(X)
  requires #rangeSInt(256, X)

rule #take(N, #padToWidth(N, WS) ) => #padToWidth(N, WS)
```

### signed 256-bit integer arithmetic

```k
rule #unsigned(X) ==K 0 => X ==Int 0
  requires #rangeSInt(256, X)

// rule 0 <Int #unsigned(X) => 0 <Int X
//   requires #rangeSInt(256, X)

// usub
// lemmas for necessity
// rule A <=Int A -Word B => 0 <=Int A -Int B
//   requires #rangeUInt(256, A)
//   andBool #rangeUInt(256, B)

// addui
// lemmas for sufficiency
rule chop(A +Int #unsigned(B)) => A +Int B
  requires #rangeUInt(256, A)
  andBool #rangeSInt(256, B)
  andBool #rangeUInt(256, A +Int B)

rule A <=Int chop(A +Int #unsigned(B)) => A +Int B <=Int maxUInt256
  requires #rangeUInt(256, A)
  andBool #rangeSInt(256, B)
  andBool 0 <Int B

rule chop(A +Int #unsigned(B)) <=Int A => 0 <=Int A +Int B
  requires #rangeUInt(256, A)
  andBool #rangeSInt(256, B)
  andBool B <Int 0

// subui
// lemmas for sufficiency
rule A -Word #unsigned(B) => A -Int B
  requires #rangeUInt(256, A)
  andBool #rangeSInt(256, B)
  andBool #rangeUInt(256, A -Int B)

 rule A -Word #unsigned(B) <=Int A => minUInt256 <=Int A -Int B
   requires #rangeUInt(256, A)
   andBool #rangeSInt(256, B)
   andBool 0 <=Int B

 rule A <Int A -Word #unsigned(B) => A -Int B <=Int maxUInt256
   requires #rangeUInt(256, A)
   andBool #rangeSInt(256, B)
   andBool B <Int 0

rule A -Word #unsigned(B) <Int A => maxUInt256 <Int A -Int B
   requires #rangeUInt(256, A)
   andBool #rangeSInt(256, B)
   andBool B <Int 0

rule (A +Int pow256) -Int #unsigned(B) => A -Int B
   requires #rangeUInt(256, A)
   andBool #rangeSInt(256, B)
   andBool #rangeUInt(256, A -Int B)
   andBool B <Int 0

// mului
// lemmas for sufficiency
rule A *Int #unsigned(B) => #unsigned(A *Int B)
  requires #rangeUInt(256, A)
  andBool #rangeSInt(256, B)
  andBool #rangeSInt(256, A *Int B)

rule abs(#unsigned(A *Int B)) /Int abs(#unsigned(B)) => A
  requires #rangeUInt(256, A)
  andBool #rangeSInt(256, B)
  andBool #rangeSInt(256, A *Int B)
  andBool notBool (#unsigned(B) ==Int 0)

rule abs(B) ==K 0 => B ==K 0

rule #sgnInterp(sgn(#unsigned(A *Int B)) *Int sgn(#unsigned(B)), A) => A
  requires #rangeSInt(256, A *Int B)
  andBool #rangeUInt(256, A)
  andBool #rangeSInt(256, B)

// lemmas for necessity
rule #signed(X) <Int 0 => notBool #rangeSInt(256, X)
   requires #rangeUInt(256, X)

rule (chop(A *Int B) /Int B ==K A) => #rangeUInt(256, A *Int B)
  requires #rangeUInt(256, A)
  andBool #rangeUInt(256, B)

rule (#sgnInterp(sgn(chop(A *Int #unsigned(B))) *Int sgn(#unsigned(B)), abs(chop(A *Int #unsigned(B))) /Int abs(#unsigned(B))) ==K A) => #rangeSInt(256, A *Int B)
  requires #rangeUInt(256, A)
  andBool #rangeSInt(256, B)
  andBool B =/=Int 0
```

from `dirty_lemmas.k.md` on 23/08/2019:

```k
rule WM[ N := #take(X, WS) ] => WM [ N := #asByteStackInWidth(#asWord(#take(X, WS)), X) ]

rule 0 -Word X => #unsigned(0 -Int X)
  requires 0 <=Int X andBool X <=Int pow255
/*
  proof:

  1) rule W0 -Word W1 => chop( (W0 +Int pow256) -Int W1 ) requires W0 <Int W1
  2) rule chop ( I:Int ) => I modInt pow256 [concrete, smt-lemma]
  3) rule W0 -Word W1 => chop( W0 -Int W1 ) requires W0 >=Int W1

  Assume X != 0:

  0 < X                   : 0 -W X =(1)=> chop( pow256 - X )
  0 < pow256 - X < pow256 : chop( pow256 - X ) =(2)=> pow256 - X

  Assume X == 0:

  0 == X                  : 0 -W 0 =(3)=> chop( 0 - 0 )
*/

rule #range(WS [ X := #padToWidth(32, Y) ], Z, 32, WSS) => #range(WS, Z, 32, WSS)
  requires Z +Int 32 <Int X

// possibly wrong but i'll keep using it as a hack
rule #sizeWordStack(#range(WS, Y, Z, WSS)) => Z

rule A -Word B <=Int A => 0 <=Int A -Int B
 requires #rangeUInt(256, A)
  andBool #rangeUInt(256, B)

rule A <=Int chop(A +Int B) => A +Int B <=Int maxUInt256
 requires #rangeUInt(256, A)
  andBool #rangeUInt(256, B)

rule #sgnInterp(sgn(chop(A *Int #unsigned(B))) *Int -1, abs(chop(A *Int #unsigned(B))) /Int (pow256 -Int #unsigned(B))) ==K A => #rangeSInt(256, A *Int B)
 requires #rangeUInt(256, A)
 andBool #rangeSInt(256, B)
 andBool B <Int 0

rule #sgnInterp(sgn(chop(A *Int #unsigned(B))), abs(chop(A *Int #unsigned(B))) /Int #unsigned(B)) ==K A => #rangeSInt(256, A *Int B)
 requires #rangeUInt(256, A)
 andBool #rangeSInt(256, B)
 andBool 0 <Int B

// Lemmas for Vat_frob_fail
rule A +Int #unsigned(B) => A +Int B
  requires #rangeUInt(256, A)
  andBool  #rangeUInt(256, B)
  andBool  #rangeUInt(256, A +Int B)

rule A +Int #unsigned(B) => A
  requires B ==K 0

// lemma for Jug_drip
rule A -Word B => #unsigned(A -Int B)
 requires #rangeSInt(256, A)
  andBool #rangeSInt(256, B)
  andBool 0 <=Int B
  andBool 0 <=Int A

// lemmas for End_skim
rule (A +Int (0 -Int B)) => A -Int B
rule (A *Int (0 -Int B)) => (0 -Int (A *Int B))
rule (A -Int (0 -Int B)) => A +Int B

//lemmas for End_bail
rule (0 -Int A) <Int B => (0 -Int B) <Int A
  requires (notBool #isConcrete(A))
  andBool #isConcrete(B)
rule (0 -Int A) <=Int B => (0 -Int B) <=Int A
  requires (notBool #isConcrete(A))
  andBool #isConcrete(B)
rule A <=Int (0 -Int B) => B <=Int 0 -Int A
  requires (notBool #isConcrete(B))
  andBool #isConcrete(A)
rule A <Int (0 -Int B) => B <Int 0 -Int A
  requires (notBool #isConcrete(B))
  andBool #isConcrete(A)

// Lemmas dealing with stupid 0
rule (0 -Int X) *Int Y => 0 -Int (X *Int Y)
rule (0 -Int X) /Int Y => 0 -Int (X /Int Y)

rule #unsigned( X *Int Y ) /Int #unsigned( Y ) => X
  requires #rangeSInt(256, X *Int Y)
  andBool #rangeSInt(256, X)
  andBool #rangeSInt(256, Y)
  andBool 0 <=Int X
  andBool 0 <Int Y

rule A +Int B => A
  requires B ==K 0
  andBool #isVariable(A)
  andBool #isVariable(B)

rule A +Int B => B
  requires A ==K 0
  andBool #isVariable(A)
  andBool #isVariable(B)

// lemma for Cat_bite-full to prevent unsigned(0 - X) division
rule pow256 -Int #unsigned(0 -Int X) => X
  requires X >Int 0

// lemma to deal with deep nested calls - gas stuff
rule X -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (A5 +Int (A6 +Int (A7 +Int (A8 +Int (A9 +Int (A10 +Int (A11 +Int (A12 +Int (A13 +Int (A14 +Int (A15 +Int (A16 +Int (A17 +Int (X +Int AS)))))))))))))))))) => 0 -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (A5 +Int (A6 +Int (A7 +Int (A8 +Int (A9 +Int (A10 +Int (A11 +Int (A12 +Int (A13 +Int (A14 +Int (A15 +Int (A16 +Int (A17 +Int AS)))))))))))))))))
rule X -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (A5 +Int (A6 +Int (A7 +Int (A8 +Int (A9 +Int (A10 +Int (A11 +Int (A12 +Int (A13 +Int (A14 +Int (A15 +Int (A16 +Int (X +Int AS))))))))))))))))) => 0 -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (A5 +Int (A6 +Int (A7 +Int (A8 +Int (A9 +Int (A10 +Int (A11 +Int (A12 +Int (A13 +Int (A14 +Int (A15 +Int (A16 +Int AS))))))))))))))))
rule X -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (A5 +Int (A6 +Int (A7 +Int (A8 +Int (A9 +Int (A10 +Int (A11 +Int (A12 +Int (A13 +Int (A14 +Int (A15 +Int (X +Int AS)))))))))))))))) => 0 -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (A5 +Int (A6 +Int (A7 +Int (A8 +Int (A9 +Int (A10 +Int (A11 +Int (A12 +Int (A13 +Int (A14 +Int (A15 +Int AS)))))))))))))))
rule X -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (A5 +Int (A6 +Int (A7 +Int (A8 +Int (A9 +Int (A10 +Int (A11 +Int (A12 +Int (A13 +Int (A14 +Int (X +Int AS))))))))))))))) => 0 -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (A5 +Int (A6 +Int (A7 +Int (A8 +Int (A9 +Int (A10 +Int (A11 +Int (A12 +Int (A13 +Int (A14 +Int AS))))))))))))))
rule X -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (A5 +Int (A6 +Int (A7 +Int (A8 +Int (A9 +Int (A10 +Int (A11 +Int (A12 +Int (A13 +Int (X +Int AS)))))))))))))) => 0 -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (A5 +Int (A6 +Int (A7 +Int (A8 +Int (A9 +Int (A10 +Int (A11 +Int (A12 +Int (A13 +Int AS)))))))))))))
rule X -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (A5 +Int (A6 +Int (A7 +Int (A8 +Int (A9 +Int (A10 +Int (A11 +Int (A12 +Int (X +Int AS))))))))))))) => 0 -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (A5 +Int (A6 +Int (A7 +Int (A8 +Int (A9 +Int (A10 +Int (A11 +Int (A12 +Int AS))))))))))))
rule X -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (A5 +Int (A6 +Int (A7 +Int (A8 +Int (A9 +Int (A10 +Int (A11 +Int (X +Int AS)))))))))))) => 0 -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (A5 +Int (A6 +Int (A7 +Int (A8 +Int (A9 +Int (A10 +Int (A11 +Int AS)))))))))))
rule X -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (A5 +Int (A6 +Int (A7 +Int (A8 +Int (A9 +Int (A10 +Int (X +Int AS))))))))))) => 0 -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (A5 +Int (A6 +Int (A7 +Int (A8 +Int (A9 +Int (A10 +Int AS))))))))))
rule X -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (A5 +Int (A6 +Int (A7 +Int (A8 +Int (A9 +Int (X +Int AS)))))))))) => 0 -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (A5 +Int (A6 +Int (A7 +Int (A8 +Int (A9 +Int AS)))))))))
rule X -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (A5 +Int (A6 +Int (A7 +Int (A8 +Int (X +Int AS))))))))) => 0 -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (A5 +Int (A6 +Int (A7 +Int (A8 +Int AS))))))))
rule X -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (A5 +Int (A6 +Int (A7 +Int (X +Int AS)))))))) => 0 -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (A5 +Int (A6 +Int (A7 +Int AS)))))))
rule X -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (A5 +Int (A6 +Int (X +Int AS))))))) => 0 -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (A5 +Int (A6 +Int AS))))))
rule X -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (A5 +Int (X +Int AS)))))) => 0 -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (A5 +Int AS)))))
rule X -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int (X +Int AS))))) => 0 -Int (A1 +Int (A2 +Int (A3 +Int (A4 +Int AS))))
rule X -Int (A1 +Int (A2 +Int (A3 +Int (X +Int AS)))) => 0 -Int (A1 +Int (A2 +Int (A3 +Int AS)))
rule X -Int (A1 +Int (A2 +Int (X +Int AS))) => 0 -Int (A1 +Int (A2 +Int AS))

// Vat_fork-same_fail lemma
rule X +Int (pow256 -Int #unsigned(Y)) => X -Int Y
  requires Y <Int 0
  andBool  0 <=Int X -Int Y

rule #unsigned(X) -Int (pow256 +Int X) => 0
  requires X <Int 0
```

# DssCdpManager lemmas

```k
// Concrete hash collission

syntax Int ::= "keccak30"
syntax Int ::= "keccak30PlusOne"
rule keccak30 => 24465873643947496235832446106509767096567058095563226156125564318740882468607 [macro]
rule keccak30PlusOne => 24465873643947496235832446106509767096567058095563226156125564318740882468608 [macro]

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

```k
// DssCdpManager_frob-nonzero_pass_rough (and probably others) lemma
rule pow256 -Int #unsigned(A) => (0 -Int A)
  requires A <Int 0
  andBool #rangeSInt(256, A)

// DssCdpManager_quit-*, DssCdpManager_enter-* and DssCdpManager_shift-* lemmas
rule #signed(A) => A
  requires A >Int 0
  andBool #rangeSInt(256, A)

rule #unsigned(A) => A
  requires A >Int 0
  andBool #rangeSInt(256, A)
```
