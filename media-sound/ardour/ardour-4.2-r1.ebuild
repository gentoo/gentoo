# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads(+)'
inherit eutils toolchain-funcs flag-o-matic python-any-r1 waf-utils

DESCRIPTION="Digital Audio Workstation"
HOMEPAGE="http://ardour.org/"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="http://git.ardour.org/ardour/ardour.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/Ardour/ardour/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-2"
SLOT="4"
IUSE="altivec doc jack lv2 cpu_flags_x86_sse"

RDEPEND="
	>=dev-cpp/glibmm-2.32.0
	>=dev-cpp/gtkmm-2.16:2.4
	>=dev-cpp/libgnomecanvasmm-2.26:2.6
	dev-libs/boost:=
	>=dev-libs/glib-2.10.1:2
	dev-libs/libsigc++:2
	>=dev-libs/libxml2-2.6:2
	dev-libs/libxslt
	>=gnome-base/libgnomecanvas-2
	media-libs/alsa-lib
	media-libs/aubio
	media-libs/flac
	media-libs/freetype:2
	media-libs/libart_lgpl
	media-libs/liblo
	>=media-libs/liblrdf-0.4.0-r20
	>=media-libs/libsamplerate-0.1
	>=media-libs/libsndfile-1.0.18
	>=media-libs/libsoundtouch-1.6.0
	media-libs/raptor:2
	>=media-libs/rubberband-1.6.0
	>=media-libs/taglib-1.7
	media-libs/vamp-plugin-sdk
	net-misc/curl
	sci-libs/fftw:3.0
	virtual/libusb:0
	x11-libs/cairo
	>=x11-libs/gtk+-2.8.1:2
	x11-libs/pango
	jack? ( >=media-sound/jack-audio-connection-kit-0.120 )
	lv2? (
		>=media-libs/slv2-0.6.1
		media-libs/lilv
		media-libs/sratom
		dev-libs/sord
		>=media-libs/suil-0.6.10
		>=media-libs/lv2-1.4.0
	)"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=media-sound/jack-audio-connection-kit-0.120
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )"

src_prepare(){
	if ! [[ ${PV} == *9999* ]]; then
		epatch "${FILESDIR}"/${PN}-4.x-revision-naming.patch
		touch "${S}/libs/ardour/revision.cc"
	fi
	use lv2 || epatch "${FILESDIR}"/${PN}-4.0-lv2.patch
	epatch "${FILESDIR}"/${PN}-3.5.403-sse.patch
	sed -e 's/'FLAGS\'\,\ compiler_flags'/'FLAGS\'\,\ program_flags'/g' \
		-i "${S}"/wscript
	sed -e 's/'compiler_flags.append\ \(\'-DPROGRAM_'/'program_flags.append\ \(\'-DPROGRAM_'/g' \
		-i "${S}"/wscript
	sed -e '/compiler_flags\ \=\ \[\]/a \ \ \ \ program_flags\ \=\ \[\]' \
		-i "${S}"/wscript
	append-flags "-lboost_system"
}

src_configure() {
	if use cpu_flags_x86_sse; then
		MARCH=$(get-flag march)
		for ARCHWOSSE in i686 i486; do
			if [[ ${MARCH} == ${ARCHWOSSE} ]]; then
				for SSEOPT in -msse -msse2 -msse3 -mssse3 -msse4 -msse4.1 -msse4.2; do
					is-flag ${SSEOPT} && SSEON="yes"
				done
				if [[ -z ${SSEON} ]]; then
					append-flags -msse
					elog "You enabled sse but use an march that does not support sse!"
					elog "We add -msse to the cflags now, but please consider switching your march in make.conf!"
				fi
			fi
		done
	fi
	tc-export CC CXX
	mkdir -p "${D}"
	waf-utils_src_configure \
		--destdir="${D}" \
		--prefix=/usr \
		--configdir=/etc \
		--optimize \
		--nls \
		$(usex jack "--with-backends=alsa,jack" "--with-backends=alsa  --libjack=weak") \
		$(usex lv2 "--lv2" "--no-lv2") \
		$({ use altivec || use cpu_flags_x86_sse; } && echo "--fpu-optimization" || echo "--no-fpu-optimization") \
		$(usex doc "--docs" '')
}

src_install() {
	waf-utils_src_install
	mv ${PN}.1 ${PN}${SLOT}.1
	doman ${PN}${SLOT}.1
	newicon icons/icon/ardour_icon_mac.png ${PN}${SLOT}.png
	make_desktop_entry ardour4 ardour4 ardour4 AudioVideo
}

pkg_postinst() {
	elog "If you are using Ardour and want to keep its development alive"
	elog "then please consider to make a donation upstream at ${HOMEPAGE}"
}
