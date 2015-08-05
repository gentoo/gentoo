# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/icc_examin/icc_examin-9999.ebuild,v 1.1 2015/08/05 11:22:54 xmw Exp $

EAPI=5

inherit eutils toolchain-funcs git-r3

DESCRIPTION="Viewer for ICC and CGATS profiles, argylls gamut vrml visualisations and GPU gamma tables"
HOMEPAGE="http://www.oyranos.org/wiki/index.php?title=ICC_Examin"
EGIT_REPO_URI="https://github.com/oyranos-cms/${PN/_/-}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="app-admin/elektra
	media-libs/ftgl
	media-libs/libXcm
	=media-libs/oyranos-9999
	media-libs/tiff:0
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
