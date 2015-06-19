# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/openbox-menu/openbox-menu-0.5.1.ebuild,v 1.3 2014/11/03 09:36:58 ago Exp $

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Another dynamic menu generator for Openbox"
HOMEPAGE="http://mimasgpc.free.fr/openbox-menu_en.html"
SRC_URI="https://bitbucket.org/fabriceT/${PN}/downloads/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+icons svg"
REQUIRED_USE="svg? ( icons )"

CDEPEND="
	dev-libs/glib:2
	lxde-base/menu-cache
	x11-libs/gtk+:2
"
RDEPEND="
	${CDEPEND}
	icons? ( x11-wm/openbox[imlib,svg?] )
	!icons? ( x11-wm/openbox )
"
DEPEND="
	${CDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.5.0-build.patch
	epatch_user
	tc-export CC PKG_CONFIG
}

src_compile() {
	emake \
		$(usex icons 'ICONS=1' 'ICONS=0') \
		$(usex svg 'SVG_ICONS=1' 'SVG_ICONS=0')
}
