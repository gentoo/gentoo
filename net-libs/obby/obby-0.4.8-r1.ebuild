# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit flag-o-matic multilib

DESCRIPTION="Library for collaborative text editing"
HOMEPAGE="http://gobby.0x539.de/"
SRC_URI="http://releases.0x539.de/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~x86"
IUSE="ipv6 nls static-libs zeroconf"

RDEPEND="
	net-libs/net6
	dev-libs/libsigc++:2
	zeroconf? ( net-dns/avahi[dbus] )
"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
"

src_configure() {
	append-cxxflags -std=c++11
	econf \
		$(use_enable ipv6) \
		$(use_enable nls) \
		$(use_enable static-libs static) \
		$(use_with zeroconf)
}

src_install() {
	default
	use static-libs || rm -f "${D}"/usr/$(get_libdir)/lib${PN}.la
}
