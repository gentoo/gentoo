# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit autotools eutils

DESCRIPTION="An ncurses based app to show a scrolling screen from the Matrix"
HOMEPAGE="http://www.asty.org/cmatrix"
SRC_URI="http://www.asty.org/${PN}/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ~ppc64 sparc x86"
IUSE="X"

DEPEND="X? ( x11-apps/mkfontdir )
	sys-libs/ncurses"

src_unpack() {
	unpack ${A}
	# patch Makefile.am to make sure the fonts installations don't violate the
	# sandbox.
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gentoo.patch
	if use X ; then
		epatch "${FILESDIR}"/${P}-fontdir.patch
	fi
	eautoreconf
}

src_install() {
	dodir /usr/share/consolefonts || die 'dodir failed'
	dodir /usr/lib/kbd/consolefonts || die 'dodir failed'
	if use X;then
	   dodir /usr/share/fonts/misc || die 'dodir failed'
	fi
	emake DESTDIR="${D}" install || die 'emake install failed'
}

pkg_postinst() {
	if use X; then
		if [ -d "${ROOT}"usr/share/fonts/misc ] ; then
			einfo ">>> Running mkfontdir on ${ROOT}usr/share/fonts/misc"
			mkfontdir "${ROOT}"usr/share/fonts/misc || die 'mkfontdir failed'
		fi
	fi
}
