# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils multilib

DESCRIPTION="Fireflies screensaver: Wicked cool eye candy"
HOMEPAGE="http://somewhere.fscked.org/proj/fireflies/"
SRC_URI="http://somewhere.fscked.org/proj/${PN}/files/${P}.tar.gz"

LICENSE="GPL-2 HPND" # HPND is for libgfx, see src_unpack()
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="media-libs/libsdl
	virtual/glu
	virtual/opengl
	x11-libs/libX11"
DEPEND="${RDEPEND}"

DOCS=( ChangeLog debian/README.Debian README TODO )

src_unpack() {
	unpack ${A}
	cd "${S}"
	tar -xzf libgfx-1.0.1.tar.gz
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-build_system.patch \
		"${FILESDIR}"/${P}-glx-detection.patch \
		"${FILESDIR}"/${P}-linking.patch \
		"${FILESDIR}"/${P}-gcc4{3,4}.patch \
		"${FILESDIR}"/${P}-libgfx-libpng1{5,6}.patch

	eautoreconf
}

src_configure() {
	econf \
		--with-confdir=/usr/share/xscreensaver/config \
		--with-bindir="/usr/$(get_libdir)/misc/xscreensaver"
}

src_install() {
	exeinto /usr/lib  # FHS: internal binaries
	newexe {,${PN}-}add-xscreensaver

	default
}
