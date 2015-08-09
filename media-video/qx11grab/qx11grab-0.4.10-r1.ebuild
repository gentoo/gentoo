# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="X11 desktop video grabber tray"
HOMEPAGE="http://qx11grab.hjcms.de/"
SRC_URI="http://qx11grab.hjcms.de/downloads/${PV}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="libav kde opengl pulseaudio"

RDEPEND="
	>=dev-qt/qtcore-4.7.4:4
	>=dev-qt/qtdbus-4.7.4:4
	>=dev-qt/qtgui-4.7.4:4[accessibility]
	>=media-libs/alsa-lib-1.0.26
	>=media-libs/fontconfig-2.4
	>=media-libs/freetype-2.4:2
	>=sys-apps/dbus-1.6.4
	>=x11-libs/libX11-1.3.4
	>=x11-libs/libXrandr-1.3
	libav? ( >=media-video/libav-9:0=[X,encode,truetype] )
	!libav? ( >=media-video/ffmpeg-1.1:0=[X,encode,truetype] )
	kde? ( kde-base/kdelibs:4 )
	opengl? ( >=dev-qt/qtopengl-4.7.4:4 )
	pulseaudio? ( media-sound/pulseaudio )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	kde? ( dev-util/automoc )
"
PDEPEND="virtual/freedesktop-icon-theme"

src_prepare() {
	cmake-utils_src_prepare

	# install docs into standard Gentoo location
	sed -i -e "/DESTINATION share/ s:\${CMAKE_PROJECT_NAME}:doc/${PF}:" \
		CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable kde KDE_SUPPORT)
		$(cmake-utils_use_enable opengl)
		$(cmake-utils_use_enable pulseaudio PULSE)
	)
	cmake-utils_src_configure
}
