# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="BitTorrent client in C++ and Qt"
HOMEPAGE="http://www.qbittorrent.org/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/qBittorrent.git"
else
	MY_P=${P/_}
	SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.xz"
	KEYWORDS="amd64 ~arm ~ppc64 x86"
	S=${WORKDIR}/${MY_P}
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+dbus debug webui +X"
REQUIRED_USE="dbus? ( X )"

RDEPEND="
	>=dev-libs/boost-1.62.0-r1:=
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5[ssl]
	>=dev-qt/qtsingleapplication-2.6.1_p20130904-r1[qt5,X?]
	dev-qt/qtxml:5
	>=net-libs/rb_libtorrent-1.0.6
	sys-libs/zlib
	dbus? ( dev-qt/qtdbus:5 )
	X? (
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	virtual/pkgconfig"

DOCS=( AUTHORS Changelog CONTRIBUTING.md README.md TODO )

src_configure() {
	mycmakeargs=(
		-DQT5=ON
		-DSYSTEM_QTSINGLEAPPLICATION=ON
		-DDBUS=$(usex dbus)
		-DGUI=$(usex X)
		-DWEBUI=$(usex webui)
	)
	cmake-utils_src_configure
}
