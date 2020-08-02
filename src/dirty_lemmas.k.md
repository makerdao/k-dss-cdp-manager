```k
// DssCdpManager_open_pass_rough lemma
// Mask 0xffffffffffffffffffffffff0000000000000000000000000000000000000000
rule 115792089237316195423570985007226406215939081747436879206741300988257197096960 &Int A => 0
  requires #rangeAddress(A)

// DssCdpManager_frob-nonzero_fail_rough and DssCdpManager_frob-zero-dink_fail_rough lemmas
rule chop(A *Int #unsigned(B)) => A *Int B
  requires #rangeUInt(256, A)
  andBool #rangeSInt(256, B)
  andBool #rangeUInt(256, A *Int B)

rule (#sgnInterp(sgn(chop(A *Int B)), abs(chop(A *Int B)) /Int B) ==K A) => #rangeSInt(256, A *Int B)
  requires #rangeUInt(256, A)
  andBool #rangeSInt(256, B)
  andBool B >Int 0

rule (#sgnInterp(sgn(chop(A *Int #unsigned(B))) *Int -1, abs(chop(A *Int #unsigned(B))) /Int (0 -Int B)) ==K A) => #rangeSInt(256, A *Int B)
  requires #rangeUInt(256, A)
  andBool #rangeSInt(256, B)
  andBool B <Int 0
//

````
