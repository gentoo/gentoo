# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A PGP packet visualizer"
HOMEPAGE="https://www.mew.org/~kazu/proj/pgpdump/"
SRC_URI="https://www.mew.org/~kazu/proj/pgpdump/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

DEPEND="
	app-arch/bzip2
	virtual/zlib:=
"
RDEPEND="${DEPEND}"
