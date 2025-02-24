# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Qt-based music player"
HOMEPAGE="https://github.com/sebaro/Yarock"
SRC_URI="https://github.com/sebaro/Yarock/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN^}-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="mpv +qtmedia vlc"

REQUIRED_USE="|| ( mpv qtmedia vlc )"

RDEPEND="
	dev-cpp/htmlcxx
	dev-qt/qtbase:6[dbus,gui,network,sql,sqlite,widgets,xml]
	media-libs/taglib:=
	x11-libs/libX11
	mpv? ( media-video/mpv:=[libmpv] )
	qtmedia? ( dev-qt/qtmultimedia:6 )
	vlc? ( media-video/vlc:= )
"
DEPEND="${RDEPEND}
	dev-qt/qtbase:6[concurrent]
"
BDEPEND="dev-qt/qttools:6[linguist]"

DOCS=( CHANGES.md README.md )

PATCHES=(
	# TODO(?): https://github.com/sebaro/Yarock/issues/1#issuecomment-2398941145
	"${FILESDIR}"/${PN}-1.4.0-taglib2-include.patch
	# Pending: https://github.com/sebaro/Yarock/pull/3
	"${FILESDIR}"/${P}-assorted-fixes.patch
)

src_prepare() {
	cmake_src_prepare
	sed -e "/^Version/d" \
		-i data/org.yarock.desktop || die
	mv data/{org.,}yarock.desktop || die
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_PHONON=OFF # questionable benefit over vlc directly
		-DENABLE_MPV=$(usex mpv)
		-DENABLE_QTMULTIMEDIA=$(usex qtmedia)
		-DENABLE_VLC=$(usex vlc)
	)

	cmake_src_configure
}
