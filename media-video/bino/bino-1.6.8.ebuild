# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic qmake-utils xdg

DESCRIPTION="Stereoscopic and multi-display media player"
HOMEPAGE="https://bino3d.org/"
SRC_URI="https://bino3d.org/releases/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc lirc video_cards_nvidia"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	>=media-libs/glew-1.6.0:0=
	>=media-libs/libass-0.9.9
	>=media-libs/openal-1.15.1
	virtual/libintl
	>=media-video/ffmpeg-0.7:0=
	lirc? ( app-misc/lirc )
	video_cards_nvidia? ( x11-drivers/nvidia-drivers[tools,static-libs] )"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	if use video_cards_nvidia; then
		append-cppflags "-I${ESYSROOT}/usr/include/NVCtrl"
		append-ldflags "-L${ESYSROOT}/usr/$(get_libdir)/opengl/nvidia/lib -L${ESYSROOT}/usr/$(get_libdir)"
		append-libs "Xext"
	fi

	if use lirc; then
		append-cppflags "-I${ESYSROOT}/usr/include/lirc"
		append-libs "lirc_client"
	fi

	# Fix a compilation error because of a multiple definitions error in glew
	append-ldflags "-zmuldefs"

	export MOC="$(qt5_get_bindir)"/moc
	export RCC="$(qt5_get_bindir)"/rcc

	econf \
		$(use_with video_cards_nvidia xnvctrl) \
		$(use_with lirc) \
		$(use_enable debug) \
		--without-equalizer \
		--with-qt-version=5
}

src_install() {
	default

	if ! use doc; then
		rm -rf "${ED}"/usr/share/doc/${PF}/html || die
	fi
}
