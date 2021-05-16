# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

MY_P="${PN}5-${PV/_}"

DESCRIPTION="Ncurses ICQ/Yahoo!/AIM/IRC/MSN/Jabber/GaduGadu/RSS/LiveJournal client"
SRC_URI="http://www.centerim.org/download/cim5/${MY_P}.tar.gz"
HOMEPAGE="http://www.centerim.org/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE="debug nls"

DEPEND=">=sys-libs/ncurses-5.2:=
	>=net-im/pidgin-2.7.0
	>=dev-libs/glib-2.16.0
	>=dev-libs/libsigc++-2.2.0:2"
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
