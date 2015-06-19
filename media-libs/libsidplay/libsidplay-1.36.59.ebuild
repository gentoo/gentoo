# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libsidplay/libsidplay-1.36.59.ebuild,v 1.12 2012/05/16 02:25:49 ssuominen Exp $

EAPI=4
inherit eutils libtool

DESCRIPTION="C64 SID player library"
HOMEPAGE="http://critical.ch/distfiles/"
SRC_URI="http://critical.ch/distfiles/${P}.tgz"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="static-libs"

DOCS="AUTHORS DEVELOPER"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch
	elibtoolize # required for fbsd .so versioning
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	rm -f "${ED}"/usr/lib*/${PN}.la
}
