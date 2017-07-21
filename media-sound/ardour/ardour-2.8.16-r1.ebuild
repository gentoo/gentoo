# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils flag-o-matic toolchain-funcs scons-utils

DESCRIPTION="Digital Audio Workstation"
HOMEPAGE="http://ardour.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="altivec curl debug nls lv2 cpu_flags_x86_sse"

RDEPEND="media-libs/aubio
	media-libs/liblo
	sci-libs/fftw:3.0
	media-libs/freetype:2
	>=dev-libs/glib-2.10.1:2
	dev-cpp/glibmm:2
	>=x11-libs/gtk+-2.8.1:2
	>=dev-libs/libxml2-2.6:2
	>=media-libs/libsndfile-1.0.18
	>=media-libs/libsamplerate-0.1
	>=media-libs/rubberband-1.6.0
	>=media-libs/libsoundtouch-1.6.0
	media-libs/flac
	media-libs/raptor:2
	>=media-libs/liblrdf-0.4.0-r20
	virtual/jack
	>=gnome-base/libgnomecanvas-2
	media-libs/vamp-plugin-sdk
	dev-libs/libxslt
	dev-libs/libsigc++:2
	>=dev-cpp/gtkmm-2.16:2.4
	>=dev-cpp/libgnomecanvasmm-2.26:2.6
	media-libs/alsa-lib
	x11-libs/pango
	x11-libs/cairo
	media-libs/libart_lgpl
	virtual/libusb:0
	dev-libs/boost
	curl? ( net-misc/curl )
	lv2? (
		>=media-libs/slv2-0.6.1
		media-libs/lilv
		media-libs/suil
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-2.8.11-flags.patch \
		"${FILESDIR}"/${PN}-2.8.14-syslibs.patch \
		"${FILESDIR}"/${PN}-2.8.14-boost-150.patch
}

src_compile() {
	local FPU_OPTIMIZATION=$($(use altivec || use cpu_flags_x86_sse) && echo 1 || echo 0)
	tc-export CC CXX
	mkdir -p "${D}"

	escons \
		DESTDIR="${D}" \
		FPU_OPTIMIZATION="${FPU_OPTIMIZATION}" \
		PREFIX=/usr \
		SYSLIBS=1 \
		$(use_scons curl FREESOUND) \
		$(use_scons debug DEBUG) \
		$(use_scons nls NLS) \
		$(use_scons lv2 LV2)
}

src_install() {
	escons install
	doman ${PN}.1
	newicon icons/icon/ardour_icon_mac.png ${PN}.png
	make_desktop_entry ardour2 ardour2 ardour AudioVideo
}
