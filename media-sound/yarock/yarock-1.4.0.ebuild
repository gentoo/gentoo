# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_P="Yarock_${PV}_Sources"
DESCRIPTION="Qt-based music player"
HOMEPAGE="https://seb-apps.github.io/yarock/"
SRC_URI="https://launchpad.net/${PN}/1.x/${PV}/+download/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="mpv phonon vlc"

BDEPEND="
	dev-qt/linguist-tools:5
"
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
	phonon? ( >=media-libs/phonon-4.10.1 )
	vlc? ( media-video/vlc:= )
"
DEPEND="${RDEPEND}
	dev-qt/qtconcurrent:5
	dev-qt/qtx11extras:5
"

DOCS=( CHANGES.md README.md )

S="${WORKDIR}/${MY_P}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_QT5=ON
		-DENABLE_MPV=$(usex mpv)
		-DENABLE_PHONON=$(usex phonon)
		-DENABLE_VLC=$(usex vlc)
	)

	cmake_src_configure
}
