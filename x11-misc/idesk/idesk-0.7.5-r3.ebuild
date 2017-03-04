# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Utility to place icons on the root window"
HOMEPAGE="http://idesk.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="
	media-libs/freetype
	dev-libs/glib:2
	>=media-libs/imlib2-1.4[X]
	media-libs/libart_lgpl
	dev-libs/libxml2
	x11-libs/gtk+:2
	x11-libs/pango
	x11-libs/startup-notification
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-glibc-2.12.patch ) #333515

src_prepare() {
	default
	sed -i \
		-e 's,/usr/local/,/usr/,' \
		examples/default.lnk || die
}

src_configure() {
	econf --enable-libsn
}
