# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	56C3E775E72B0C8B1C0C1BD0B5DB77409B11B601:maxbaz:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Max Baz"
HOMEPAGE="https://maximbaz.com/"
SRC_URI="https://maximbaz.com/pgp_keys.asc -> ${P}.asc"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
