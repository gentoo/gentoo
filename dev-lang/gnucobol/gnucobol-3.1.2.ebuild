# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A free/libre COBOL compiler"
HOMEPAGE="https://gnucobol.sourceforge.io/"
SRC_URI="mirror://sourceforge/${PN}/$(ver_cut 1-2)/${P}.tar.xz"

LICENSE="GPL-3 LGPL-3 FDL-1.3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="berkdb json nls xml"

RDEPEND="
	dev-libs/gmp:=
	sys-libs/ncurses:=
	json? ( dev-libs/json-c:= )
	xml? ( dev-libs/libxml2 )
	berkdb? ( sys-libs/db:4.8= )
"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/libtool"

DOCS=( AUTHORS ChangeLog NEWS README README.md )

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-ncurses.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_with berkdb db) \
		$(use_with json) \
		$(use_with xml xml2) \
		$(use_enable nls)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
