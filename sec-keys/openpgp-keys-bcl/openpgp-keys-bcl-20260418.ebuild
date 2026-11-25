# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	# Oldest key
	B4C6B451E4FA8B4232CA191E117E8C168EFE3A7F:old:manual
	# Old key
	33C686A096DC124777D99326D29845A70F5017DE:old2:manual
	# ed25519
	F9EFF62D0139C8D8D14CDB721C8AFE4A0CE55DF7:bcl:manual
	# ed25519 (redhat)
	872F3A8A0B84905AFFBC8766FF9868A2D488A5A9:rh:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Brian C. Lane"
HOMEPAGE="https://www.brianlane.com/about-brian-c-lane/"
SRC_URI+=" https://www.brianlane.com/publickeys.txt -> ${P}.gpg"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
