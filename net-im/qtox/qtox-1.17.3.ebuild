# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="qTox-${PV}"
inherit cmake xdg

DESCRIPTION="qTox is an instant messaging client using the encrypted p2p Tox protocol"
HOMEPAGE="https://qtox.github.io/"
SRC_URI="https://github.com/qTox/qTox/releases/download/v${PV}/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="notification spellcheck test X"

RESTRICT="!test? ( test )"

S="${WORKDIR}/qTox"

BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"
RDEPEND="
	|| (
		dev-qt/qtgui:5[gif,jpeg,png,X(-)]
		dev-qt/qtgui:5[gif,jpeg,png,xcb(-)]
	)
	dev-db/sqlcipher
	dev-libs/libsodium:=
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-gfx/qrencode:=
	media-libs/libexif:=
	media-libs/openal
	media-video/ffmpeg:=[webp,v4l]
	net-libs/tox:0/0.2[av]
	notification? ( x11-libs/snorenotify )
	spellcheck? ( kde-frameworks/sonnet:5 )
	X? (
		x11-libs/libX11
		x11-libs/libXScrnSaver
	)
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"

src_prepare() {
	cmake_src_prepare

	# bug 628574
	if ! use test; then
		sed -i CMakeLists.txt -e "/include(Testing)/d" || die
		sed -i cmake/Dependencies.cmake -e "/find_package(Qt5Test/d" || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE="Release"
		-DPLATFORM_EXTENSIONS=$(usex X)
		-DUPDATE_CHECK=OFF
		-DUSE_CCACHE=ON
		-DSPELL_CHECK=$(usex spellcheck)
		-DSVGZ_ICON=ON
		-DASAN=OFF
		-DDESKTOP_NOTIFICATIONS=$(usex notification)
		-DSTRICT_OPTIONS=OFF
		-DGIT_DESCRIBE="${PV}"
	)

	cmake_src_configure
}
