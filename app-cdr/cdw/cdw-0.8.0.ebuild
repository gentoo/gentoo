# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cdw/cdw-0.8.0.ebuild,v 1.5 2015/07/16 04:06:40 mr_bones_ Exp $

EAPI=5
inherit eutils

DESCRIPTION="An ncurses based console frontend for cdrtools and dvd+rw-tools"
HOMEPAGE="http://cdw.sourceforge.net"
SRC_URI="mirror://sourceforge/cdw/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="virtual/cdrtools
	app-cdr/dvd+rw-tools
	dev-libs/libburn
	dev-libs/libcdio[-minimal]
	sys-libs/ncurses[unicode]"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/${P}-uclibc.patch
}

src_install() {
	DOCS="AUTHORS ChangeLog NEWS README THANKS cdw.conf" \
		default
}
