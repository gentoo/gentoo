# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	8DFF53E18F2ABC8D8F3C92237EE0FC4DCC014E3D:asn:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Andreas Schneider"
HOMEPAGE="https://cryptomilk.org/"
SRC_URI="https://cryptomilk.org/0x8DFF53E18F2ABC8D8F3C92237EE0FC4DCC014E3D_asn_cryptomilk_org_gpgkey.asc"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
