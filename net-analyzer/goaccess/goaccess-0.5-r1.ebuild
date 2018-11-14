# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils

DESCRIPTION="A real-time Apache log analyzer and interactive viewer that runs in a terminal"
HOMEPAGE="http://goaccess.prosoftcorp.com"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="geoip unicode"

RDEPEND="
	dev-libs/glib:2
	sys-libs/ncurses:0=[unicode?]
	geoip? ( dev-libs/geoip )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	# respect CFLAGS, bug #451806
	sed -i -e '/AM_CFLAGS/s/-g//' Makefile.am || die 'sed failed'
	autotools-utils_src_prepare
}

src_configure() {
	# configure does not properly recognise '--disable-something'
	local myeconfargs=(
		$(usex geoip '--enable-geoip' '' '' '')
		$(usex unicode '--enable-utf8' '' '' '')
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile CFLAGS="${CFLAGS}"
}
