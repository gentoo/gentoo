# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	# openpgp: missing user ID
	"D9199745B0545F2E8197062B0F92290A445B9007:mbunkus:github,manual,ubuntu"
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Moritz Bunkus"
HOMEPAGE="https://www.bunkus.org/"
SRC_URI+=" https://www.bunkus.org/gpg-pub-moritzbunkus.txt -> ${P}-gpg-pub-moritzbunkus.txt"

KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
