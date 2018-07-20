# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic

DESCRIPTION="Stereoscopic and multi-display media player"
HOMEPAGE="http://bino3d.org/"
SRC_URI="http://download.savannah.gnu.org/releases/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug doc libav lirc video_cards_nvidia"

RDEPEND="
	>=media-libs/glew-1.6.0:0=
	>=media-libs/openal-1.15.1
	dev-qt/qtgui:5
	dev-qt/qtcore:5
	dev-qt/qtopengl:5
	>=media-libs/libass-0.9.9
	libav? ( >=media-video/libav-0.7:0= )
	!libav? ( >=media-video/ffmpeg-0.7:0= )
	lirc? ( app-misc/lirc )
	video_cards_nvidia? ( || ( x11-drivers/nvidia-drivers[tools,static-libs] media-video/nvidia-settings ) )
	virtual/libintl
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	use video_cards_nvidia && append-cppflags "-I/usr/include/NVCtrl" \
		&& append-ldflags "-L/usr/$(get_libdir)/opengl/nvidia/lib \
		-L/usr/$(get_libdir)" && append-libs "Xext"
	use lirc && append-cppflags "-I/usr/include/lirc" \
		&& append-libs "lirc_client"

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
	use doc || ( rm -rf "${D}"/usr/share/doc/${PF}/html && dohtml "${FILESDIR}/${PN}.html" )
}
