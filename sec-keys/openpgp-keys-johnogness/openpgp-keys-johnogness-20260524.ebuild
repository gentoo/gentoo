# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	"4CE14D2AAAC6C2E31BF36920F51469ECE1E71FFB:johnogness:manual,openpgp,ubuntu"
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by John Ogness"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI+="
	https://www.linutronix.de/minicoredumper/files/0x4CE14D2AAAC6C2E31BF36920F51469ECE1E71FFB.asc
		-> ${P}-key-0x4CE14D2AAAC6C2E31BF36920F51469ECE1E71FFB.asc
"

KEYWORDS="~alpha amd64 arm64 ppc64 x86"
