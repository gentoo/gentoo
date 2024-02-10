# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="Yarock_${PV}_Sources"
inherit cmake

DESCRIPTION="Qt-based music player"
HOMEPAGE="https://code.launchpad.net/yarock"
SRC_URI="https://launchpad.net/${PN}/1.x/${PV}/+download/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="mpv phonon vlc"

RDEPEND="
	dev-cpp/htmlcxx
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-libs/taglib
	x11-libs/libX11
	mpv? ( media-video/mpv:=[libmpv] )
	phonon? ( >=media-libs/phonon-4.11.0[qt5(+)] )
	vlc? ( media-video/vlc:= )
"
DEPEND="${RDEPEND}
	dev-qt/qtconcurrent:5
	dev-qt/qtx11extras:5
"
BDEPEND="
	dev-qt/linguist-tools:5
"

DOCS=( CHANGES.md README.md )

src_prepare() {
	cmake_src_prepare
	sed -e "/^install.*org.yarock.appdata.xml/s:share/appdata:share/metadata:" \
		-i CMakeLists.txt || die
	sed -e "/^Version/d" \
		-i data/org.yarock.desktop || die
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_QT5=ON
		-DENABLE_MPV=$(usex mpv)
		-DENABLE_PHONON=$(usex phonon)
		-DENABLE_VLC=$(usex vlc)
	)

	cmake_src_configure
}
