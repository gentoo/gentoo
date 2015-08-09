# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Various formats to Open document format converter"
HOMEPAGE="http://libwpd.sf.net"
SRC_URI="mirror://sourceforge/libwpd/writerperfect-${PV}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="debug gsf +visio +wpg +wps"

RDEPEND="
	app-text/libwpd:0.9
	gsf? ( gnome-extra/libgsf )
	visio? ( media-libs/libvisio )
	wpg? ( app-text/libwpg:0.2 )
	wps? ( =app-text/libwps-0.2* )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

S=${WORKDIR}/writerperfect-${PV}

src_configure() {
	econf \
		--disable-werror \
		$(use_enable debug) \
		$(use_with gsf libgsf) \
		$(use_with wpg libwpg) \
		$(use_with wps libwps) \
		$(use_with visio libvisio)
}
