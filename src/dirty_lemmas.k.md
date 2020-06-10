```k
// DssCdpManager_frob-nonzero_pass_rough (and probably others) lemma
rule pow256 -Int #unsigned(A) => (0 -Int A)
  requires A <Int 0
  andBool #rangeSInt(256, A)

// DssCdpManager_quit-*, DssCdpManager_enter-* and DssCdpManager_shift-* lemma
rule #signed(A) => A
  requires A >Int 0
  andBool #rangeSInt(256, A)

```
