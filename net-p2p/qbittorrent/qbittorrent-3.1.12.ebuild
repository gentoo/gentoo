# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit eutils python-r1 qmake-utils qt4-r2

DESCRIPTION="BitTorrent client in C++ and Qt"
HOMEPAGE="http://www.qbittorrent.org/"
MY_P=${P/_}
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc64 x86"

IUSE="dbus debug geoip +X"

# geoip and python are runtime deps only (see INSTALL file)
CDEPEND="
	dev-libs/boost:=
	dev-qt/qtcore:4
	>=dev-qt/qtsingleapplication-2.6.1_p20130904-r1[qt4(+),X?]
	>=net-libs/rb_libtorrent-0.16.17
	<net-libs/rb_libtorrent-1.0.0
	dbus? ( dev-qt/qtdbus:4 )
	X? ( dev-qt/qtgui:4 )
"
DEPEND="${CDEPEND}
	virtual/pkgconfig
"
RDEPEND="${CDEPEND}
	${PYTHON_DEPS}
	geoip? ( dev-libs/geoip )
"

S=${WORKDIR}/${MY_P}
DOCS=(AUTHORS Changelog README.md TODO)

src_prepare() {
	epatch_user
	qt4-r2_src_prepare
}

src_configure() {
	# Custom configure script, econf fails
	local myconf=(
		./configure
		--prefix="${EPREFIX}/usr"
		--qtdir="$(qt4_get_libdir)"
		--with-libboost-inc="${EPREFIX}/usr/include/boost"
		--with-qtsingleapplication=system
		$(use dbus  || echo --disable-qt-dbus)
		$(use debug && echo --enable-debug)
		$(use geoip || echo --disable-geoip-database)
		$(use X     || echo --disable-gui)
	)

	echo "${myconf[@]}"
	"${myconf[@]}" || die "configure failed"
	eqmake4
}
