# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic xdg-utils

DESCRIPTION="Stereoscopic and multi-display media player"
HOMEPAGE="https://bino3d.org/"
SRC_URI="https://bino3d.org/releases/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug doc libav lirc video_cards_nvidia"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	>=media-libs/glew-1.6.0:0=
	>=media-libs/libass-0.9.9
	>=media-libs/openal-1.15.1
	virtual/libintl
	libav? ( >=media-video/libav-0.7:0= )
	!libav? ( >=media-video/ffmpeg-0.7:0= )
	lirc? ( app-misc/lirc )
	video_cards_nvidia? ( x11-drivers/nvidia-drivers[tools,static-libs] )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	# Qt5 now requires C++11, #649282
	append-cxxflags -std=c++11

	if use video_cards_nvidia; then
		append-cppflags "-I/usr/include/NVCtrl"
		append-ldflags "-L/usr/$(get_libdir)/opengl/nvidia/lib -L/usr/$(get_libdir)"
		append-libs "Xext"
	fi
	if use lirc; then
		append-cppflags "-I/usr/include/lirc"
		append-libs "lirc_client"
	fi

	# Fix a compilation error because of a multiple definitions in glew
	append-ldflags "-zmuldefs"

	econf \
		$(use_with video_cards_nvidia xnvctrl) \
		$(use_with lirc) \
		$(use_enable debug) \
		--without-equalizer \
		--with-qt-version=5 \
		--htmldir=/usr/share/doc/${PF}/html

}

src_install() {
	default
	if ! use doc; then
		rm -rf "${D}"/usr/share/doc/${PF}/html || die
	fi
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
