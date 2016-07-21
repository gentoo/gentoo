# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils

DESCRIPTION="Basic CD Player for blackbox wm"
HOMEPAGE="http://tranber1.free.fr/bbcd.html"
SRC_URI="http://tranber1.free.fr/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86 ~x86-fbsd"
IUSE=""

RDEPEND="media-libs/libcdaudio
	x11-libs/libX11"

src_prepare() {
	epatch "${FILESDIR}"/${P}_${PV}a.diff
	epatch "${FILESDIR}"/${P}-gcc3.3.patch
	epatch "${FILESDIR}"/${P}-gcc4.3.patch
}

src_install () {
	emake DESTDIR="${D}" install
	rm -rf "${D}"/usr/doc || die
	dodoc AUTHORS BUGS ChangeLog NEWS README
}
