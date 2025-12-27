# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Simple Qt6 or GTK+3 interface for capturing and viewing video from v4l2 devices"
HOMEPAGE="https://guvcview.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/source/${PN}-src-${PV}.tar.bz2"
S="${WORKDIR}/${PN}-src-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gsl pulseaudio qt6 sfml"

BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"
RDEPEND="
	media-libs/libpng:=
	media-libs/libv4l
	media-libs/portaudio
	media-video/ffmpeg:=
	virtual/libusb:1
	virtual/udev
	gsl? ( sci-libs/gsl:= )
	pulseaudio? ( media-libs/libpulse )
	qt6? ( dev-qt/qtbase:6[gui,widgets]	)
	!qt6? (
		dev-libs/glib:2
		x11-libs/gtk+:3
	)
	sfml? (
		media-libs/libglvnd
		>=media-libs/libsfml-3:=
	)
	!sfml? ( media-libs/libsdl2 )
"
# linux-headers: bug 448260
DEPEND="
	${RDEPEND}
	virtual/os-headers
	!qt6? ( x11-base/xorg-proto )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.1-set-metainfo-dir.patch
	"${FILESDIR}"/${PN}-2.2.2-musl.patch
)

src_prepare() {
	use gsl || sed -i /pkg.check.modules.GSL/d gview_render/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_DEVKIT=ON
		-DUSE_DEBIANMENU=OFF
		-DUSE_PULSE=$(usex pulseaudio)
		-DUSE_GTK3=$(usex !qt6)
		-DUSE_QT6=$(usex qt6)
		-DUSE_SDL2=$(usex !sfml)
		-DUSE_SFML=$(usex sfml)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	gunzip "${ED}"/usr/share/man/man1/guvcview.1.gz || die
}
