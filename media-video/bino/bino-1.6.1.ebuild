# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF="1"

inherit autotools-utils flag-o-matic

DESCRIPTION="Stereoscopic and multi-display media player"
HOMEPAGE="http://bino3d.org/"
SRC_URI="http://download.savannah.gnu.org/releases/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc libav lirc"

IUSE_VIDEO_CARDS="
	video_cards_nvidia"
IUSE+="${IUSE_VIDEO_CARDS}"

LANGS="en bg de fr ru zh_CN"
for X in ${LANGS} ; do
	IUSE+=" linguas_${X}"
done

RDEPEND=">=media-libs/glew-1.6.0
	>=media-libs/openal-1.15.1
	dev-qt/qtgui:4
	dev-qt/qtcore:4
	dev-qt/qtopengl:4
	>=media-libs/libass-0.9.9
	libav? ( >=media-video/libav-0.7:0= )
	!libav? ( >=media-video/ffmpeg-0.7:0= )
	lirc? ( app-misc/lirc )
	video_cards_nvidia? ( media-video/nvidia-settings )
	virtual/libintl"

DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README README.Linux )

PATCHES=(
	"${FILESDIR}/${PN}-1.4.2-lirc-detect.patch" # detect lirc
)

src_configure() {
	local myeconfargs=(
		$(use_with video_cards_nvidia xnvctrl)
		$(use_with lirc liblircclient)
		--without-equalizer
		--htmldir=/usr/share/doc/${PF}/html
	)
	use video_cards_nvidia && append-cppflags "-I/usr/include/NVCtrl" && append-ldflags "-I/usr/$(get_libdir)" && append-libs "Xext"
	use lirc && append-cppflags "-I/usr/include/lirc"  && append-libs "lirc_client"

	# Fix a compilation error because of a multiple definitions in glew
	append-ldflags "-zmuldefs"

	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	use doc || ( rm -rf "${D}"/usr/share/doc/${PF}/html && dohtml "${FILESDIR}/${PN}.html" )
}
