# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Recompress ZIP, PNG and MNG, considerably improving compression"
HOMEPAGE="http://www.advancemame.it/comp-readme.html"
SRC_URI="https://github.com/amadvance/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+ Apache-2.0 LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="test"

RDEPEND="app-arch/bzip2:=
	sys-libs/zlib:="
DEPEND="${RDEPEND}"
#	test? ( dev-util/valgrind )
#   test? ( app-text/tofrodos )

RESTRICT="test" #282441, #523212

src_configure() {
	local myconf=(
		--enable-bzip2
		$(use_enable test valgrind)
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	dodoc HISTORY
}
