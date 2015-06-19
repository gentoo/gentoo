# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/centerim/centerim-5.0.0_beta2.ebuild,v 1.1 2014/03/05 21:04:31 swegener Exp $

EAPI="5"

MY_P="${PN}5-${PV/_}"

DESCRIPTION="CenterIM is a ncurses ICQ/Yahoo!/AIM/IRC/MSN/Jabber/GaduGadu/RSS/LiveJournal Client"
SRC_URI="http://www.centerim.org/download/cim5/${MY_P}.tar.gz"
HOMEPAGE="http://www.centerim.org/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE="debug nls"

DEPEND=">=sys-libs/ncurses-5.2
	>=net-im/pidgin-2.7.0
	>=dev-libs/glib-2.16.0
	>=dev-libs/libsigc++-2.2.0"
RDEPEND="${DEPEND}
	nls? ( sys-devel/gettext )"
DEPEND="${DEPEND}
	virtual/pkgconfig"

S="${WORKDIR}"/${MY_P}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install
	rm -f "${D}"/usr/lib*/libcppconsui.{a,la}

	dodoc AUTHORS HACKING NEWS README TODO
}
