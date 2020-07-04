# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic

DESCRIPTION="View and manage contents of your wine cellar"
HOMEPAGE="http://xcave.free.fr/index-en.php"
SRC_URI="http://${PN}.free.fr/backbone.php?what=download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

RDEPEND="
	x11-libs/gtk+:2
	dev-libs/libxml2:2
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/${PN}-2.4.0-pkg-config.patch
)

src_prepare() {
	mkdir m4 || die
	default
	eautoreconf
}

src_configure() {
	append-cflags -fcommon
	default
}
src_install() {
	default

	rm -rv "${ED}"/usr/doc || die
}
