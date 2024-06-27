SHELL := /bin/bash

# Installing the tool
install:
	./scripts/install-from-source.sh

# Remove the tool
uninstall:
	sudo rm "${PREFIX}/bin/instoll"
	hash -r

checksum:
	./scripts/generate-checksum.sh

.PHONY: install uninstall checksum
