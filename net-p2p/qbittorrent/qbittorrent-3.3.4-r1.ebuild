# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit qmake-utils

DESCRIPTION="BitTorrent client in C++ and Qt"
HOMEPAGE="http://www.qbittorrent.org/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/qBittorrent.git"
else
	MY_P=${P/_}
	SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
	S=${WORKDIR}/${MY_P}
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+dbus debug +qt5 webui +X"
REQUIRED_USE="
	dbus? ( X )
"

RDEPEND="
	dev-libs/boost:=
	>=net-libs/rb_libtorrent-1.0.6
	sys-libs/zlib
	!qt5? (
		>=dev-libs/qjson-0.8.1[qt4(+)]
		dev-qt/qtcore:4[ssl]
		>=dev-qt/qtsingleapplication-2.6.1_p20130904-r1[qt4,X?]
		dbus? ( dev-qt/qtdbus:4 )
		X? ( dev-qt/qtgui:4 )
	)
	qt5? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5[ssl]
		>=dev-qt/qtsingleapplication-2.6.1_p20130904-r1[qt5,X?]
		dev-qt/qtxml:5
		dbus? ( dev-qt/qtdbus:5 )
		X? (
			dev-qt/qtgui:5
			dev-qt/qtwidgets:5
		)
	)
"
DEPEND="${RDEPEND}
	qt5? ( dev-qt/linguist-tools:5 )
	virtual/pkgconfig
"

DOCS=(AUTHORS Changelog CONTRIBUTING.md README.md TODO)

src_configure() {
	econf \
		--with-qjson=system \
		--with-qtsingleapplication=system \
		$(use_enable dbus qt-dbus) \
		$(use_enable debug) \
		$(use_enable webui) \
		$(use_enable X gui) \
		$(use_enable !X systemd) \
		$(use_with !qt5 qt4)

	if use qt5; then
		eqmake5
	else
		eqmake4
	fi
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
