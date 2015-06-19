# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/swftools/swftools-0.9.2.ebuild,v 1.4 2013/12/01 21:29:35 pacho Exp $

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
	>=media-libs/t1lib-1.3.1
	media-libs/freetype
	virtual/jpeg
"
DEPEND="${RDEPEND}
	!<media-libs/ming-0.4.0_rc2
"

src_prepare() {
	epatch "${FILESDIR}"/${P}_nopdf.patch
	epatch "${FILESDIR}"/${P}_general.patch
	epatch "${FILESDIR}"/${P}_giflib.patch
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
