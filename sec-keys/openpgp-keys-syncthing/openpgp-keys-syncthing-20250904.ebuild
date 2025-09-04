# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	"FBA2E162F2F44657B38F0309E5665F9BD5970C47:syncthing:manual"
)

inherit sec-keys

DESCRIPTION="OpenPGP key used to sign Syncthing releases"
HOMEPAGE="https://syncthing.net/"
SRC_URI+="
	https://syncthing.net/release-key.txt -> ${P}-release-key.txt
"

KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
