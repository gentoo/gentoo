# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="SWF Tools is a collection of SWF manipulation and generation utilities"
HOMEPAGE="http://www.swftools.org/"
SRC_URI="http://www.swftools.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="
	app-text/poppler
	media-libs/freetype:2
	media-libs/giflib:0=
	>=media-libs/t1lib-1.3.1:5
	virtual/jpeg:0
"
DEPEND="${RDEPEND}
	!<media-libs/ming-0.4.0_rc2
"

src_prepare() {
	epatch "${FILESDIR}"/${P}_nopdf.patch
	epatch "${FILESDIR}"/${P}_general.patch
	epatch "${FILESDIR}"/${P}_giflib.patch
	epatch "${FILESDIR}"/${P}_giflib5.patch
}

src_configure() {
	econf --enable-poppler
	# disable the python interface; there's no configure switch; bug 118242
	echo "all install uninstall clean:" > lib/python/Makefile
}

src_compile() {
	emake FLAGS="${CFLAGS}"
}

src_install() {
	einstall
	dodoc AUTHORS ChangeLog
}
