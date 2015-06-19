# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/fireflies/fireflies-2.07-r1.ebuild,v 1.8 2014/06/21 19:27:12 ssuominen Exp $

EAPI=5
inherit autotools eutils multilib

DESCRIPTION="Fireflies screensaver: Wicked cool eye candy"
HOMEPAGE="http://somewhere.fscked.org/proj/fireflies/"
SRC_URI="http://somewhere.fscked.org/proj/${PN}/files/${P}.tar.gz"

LICENSE="GPL-2 HPND" # HPND is for libgfx, see src_unpack()
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="media-libs/libsdl
	virtual/glu
	virtual/opengl
	x11-libs/libX11"
DEPEND="${RDEPEND}"

DOCS=( ChangeLog debian/README.Debian README )

src_unpack() {
	unpack ${A}
	cd "${S}"
	tar -xzf libgfx-1.0.1.tar.gz
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-build_system.patch \
		"${FILESDIR}"/${P}-gcc4{3,4}.patch \
		"${FILESDIR}"/${P}-libgfx-libpng1{5,6}.patch

	eautoreconf
}

src_configure() {
	econf \
		--with-confdir=/usr/share/xscreensaver/config \
		--with-bindir="/usr/$(get_libdir)/misc/xscreensaver"
}
