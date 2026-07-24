# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	"AADF2EDF5529F1702772C8A2DEC4D246931EF49B:janmojzis:github"
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by Jan Mojžíš"
HOMEPAGE="https://github.com/janmojzis/"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
