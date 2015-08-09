# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

IUSE=""

DESCRIPTION="an audio player, primarily for the console"
HOMEPAGE="http://splay.sourceforge.net/"
SRC_URI="http://splay.sourceforge.net/tgz/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${P}-gcc43.patch"
	cd "${S}/apps"
	epatch "${FILESDIR}/${P}-external-id3lib.diff"
	epatch "${FILESDIR}/${P}-gcc43-2.patch"
}

src_compile() {
	# Force compilation to omit X support according to BUG #5856
	# even when qt is present on the system.
	export ac_cv_lib_qt_main=no
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	# Specify man-page to prevent xsplay.1 from being installed
	einstall man_MANS=splay.1 || die "einstall failed"
	dodoc AUTHORS ChangeLog README README.LIB NEWS
}
