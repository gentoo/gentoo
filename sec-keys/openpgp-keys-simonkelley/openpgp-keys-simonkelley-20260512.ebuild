# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	D6EACBD6EE46B834248D111215CDDA6AE19135A2:simon:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Simon Kelley"
HOMEPAGE="https://thekelleys.org.uk/"
SRC_URI="https://thekelleys.org.uk/srkgpg.txt -> ${P}.asc"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
