# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

MY_P="Yarock_${PV}_Sources"
DESCRIPTION="Qt-based music player"
HOMEPAGE="https://seb-apps.github.io/yarock/"
SRC_URI="https://launchpad.net/${PN}/1.x/${PV}/+download/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="phonon"

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
	!phonon? ( media-video/vlc:= )
	phonon? ( >=media-libs/phonon-4.10.1 )
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	dev-qt/qtconcurrent:5
	dev-qt/qtx11extras:5
"

DOCS=( CHANGES.md README.md )

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${P}-desktop.patch"
	"${FILESDIR}/${P}-phonon.patch"
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_QT5=ON
		-DENABLE_MPV=OFF
		-DENABLE_PHONON=$(usex phonon ON OFF)
		-DENABLE_VLC=$(usex phonon OFF ON)
	)

	cmake-utils_src_configure
}
