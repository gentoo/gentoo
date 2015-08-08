# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="viewer for ICC and CGATS profiles, argylls gamut vrml visualisations and video card gamma tables"
HOMEPAGE="http://www.oyranos.org/wiki/index.php?title=ICC_Examin"
SRC_URI="mirror://sourceforge/oyranos/ICC%20Examin/ICC%20Examin%20${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-admin/elektra
	media-libs/ftgl
	media-libs/libXcm
	>=media-libs/oyranos-0.9.5
	media-libs/tiff
	x11-libs/fltk
	x11-libs/libX11
	x11-libs/libXinerama
	x11-libs/libXpm
	x11-libs/libXrandr
	x11-libs/libXxf86vm"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.55-fix-xrandr-test.patch

	sed -e '/xdg-icon-resource\|xdg-desktop-menu/d' \
		-i makefile.in
}

src_configure() {
	tc-export CC CXX
	econf --enable-verbose \
		--disable-static
}
