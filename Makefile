SOURCES = src/prelude.smt2.md src/lemmas.k.md src/storage.k.md src/specs.md

specs: dapp
	klab build

dapp:
	git submodule sync --recursive
	git submodule update --init --recursive
	cd dss-cdp-manager && dapp --use solc:0.5.12 build

.PHONY: clean
clean:
	cd dss-cdp-manager && dapp clean
	rm -rf out/
