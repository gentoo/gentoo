# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Recompress ZIP, PNG and MNG, considerably improving compression"
HOMEPAGE="
	https://www.advancemame.it/comp-readme.html
	https://github.com/amadvance/advancecomp/
"
SRC_URI="
	https://github.com/amadvance/advancecomp/releases/download/v${PV}/${P}.tar.gz
"

LICENSE="GPL-2+ Apache-2.0 LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	app-arch/bzip2:=
	sys-libs/zlib:=
"
DEPEND="
	${RDEPEND}
"

# Tests seem to rely on exact output:
# https://sourceforge.net/p/advancemame/bugs/270/
RESTRICT="test"

src_configure() {
	local myconf=(
		--enable-bzip2
		# (--disable-* arguments are mishandled)
		# --disable-debug
		# --disable-valgrind
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	dodoc HISTORY
}
