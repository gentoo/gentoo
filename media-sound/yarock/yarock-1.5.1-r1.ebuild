# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Qt-based music player"
HOMEPAGE="https://github.com/sebaro/Yarock"
SRC_URI="https://github.com/sebaro/Yarock/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN^}-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="mpv +qtmedia"

REQUIRED_USE="|| ( mpv qtmedia )"

RDEPEND="
	dev-cpp/htmlcxx
	dev-qt/qtbase:6[dbus,gui,network,sql,sqlite,widgets,xml]
	media-libs/taglib:=
	x11-libs/libX11
	mpv? ( media-video/mpv:=[libmpv] )
	!mpv? ( dev-qt/qtmultimedia:6 )
"
DEPEND="${RDEPEND}
	dev-qt/qtbase:6[concurrent]
"
BDEPEND="dev-qt/qttools:6[linguist]"

DOCS=( CHANGES.md README.md )

src_prepare() {
	rm -r src/shortcuts || die # bug 957913, not actually used
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_PHONON=OFF
		-DENABLE_VLC=OFF
		-DENABLE_MPV=$(usex mpv)
		-DENABLE_QTMULTIMEDIA=$(usex qtmedia)
	)

	cmake_src_configure
}
