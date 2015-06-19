# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libipod/libipod-0.1.ebuild,v 1.2 2009/09/18 23:21:00 maekke Exp $

inherit eutils

DESCRIPTION="lightweight and fast library written in C for managing Apple iPods"
HOMEPAGE="http://libipod.sourceforge.net/"
SRC_URI="mirror://sourceforge/libipod/${P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-prototypes.patch
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README
}
