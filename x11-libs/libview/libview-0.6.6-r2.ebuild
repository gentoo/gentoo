# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="no"

inherit autotools eutils flag-o-matic gnome2

DESCRIPTION="VMware's Incredibly Exciting Widgets"
HOMEPAGE="http://view.sourceforge.net"
SRC_URI="mirror://sourceforge/view/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

RDEPEND="
	>=x11-libs/gtk+-2.4.0:2
	 dev-cpp/gtkmm:2.4
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	# Fix the pkgconfig file
	epatch "${FILESDIR}"/${PN}-0.5.6-pcfix.patch
	eautoreconf -i
	gnome2_src_prepare
}

src_configure() {
	append-cxxflags -std=c++11
	gnome2_src_configure \
		--enable-deprecated \
		$(use_enable static-libs static)
}
