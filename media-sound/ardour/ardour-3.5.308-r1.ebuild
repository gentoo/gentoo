# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ardour/ardour-3.5.308-r1.ebuild,v 1.3 2015/01/29 18:52:23 mgorny Exp $

EAPI=4

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads(+)'

inherit eutils toolchain-funcs flag-o-matic python-any-r1 waf-utils

DESCRIPTION="Digital Audio Workstation"
HOMEPAGE="http://ardour.org/"

if [ ${PV} = 9999 ]; then
	KEYWORDS=""
	EGIT_REPO_URI="http://git.ardour.org/ardour/ardour.git"
	inherit git-2
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/Ardour/ardour/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-2"
SLOT="3"
IUSE="altivec debug doc nls lv2 cpu_flags_x86_sse"

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
	>=media-sound/jack-audio-connection-kit-0.120
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
	>=media-libs/taglib-1.7
	net-misc/curl
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
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	doc? ( app-doc/doxygen[dot] )"
	if ! [ ${PV} = 9999 ]; then
		DEPEND="${DEPEND}"
	fi

src_unpack() {
	if [ ${PV} = 9999 ]; then
		git-2_src_unpack
	else
		unpack ${A}
	fi
}

src_prepare(){
	if ! [ ${PV} = 9999 ]; then
		PVTEMP=`echo "${PV}" | sed "s/\./-/2"`
		sed -e '/cmd = "git describe HEAD/,/utf-8/{s:cmd = \"git describe HEAD\":rev = \"'${PVTEMP}-gentoo'\":p;d}' -i "${S}"/wscript
		sed -e 's/'os.getcwd\(\),\ \'.git'/'os.getcwd\(\),\ \'libs/'' -i "${S}"/wscript
		sed -e 's/'os.path.exists\(\'.git'/'os.path.exists\(\'wscript/'' -i "${S}"/wscript

	fi
	epatch "${FILESDIR}"/${PN}-3.5.7-syslibs.patch
	sed 's/'FLAGS\'\,\ optimization_flags'/'FLAGS\'\,\ \'\''/g' -i "${S}"/wscript
}

src_configure() {
	tc-export CC CXX
	mkdir -p "${D}"
	waf-utils_src_configure \
		--destdir="${D}" \
		--prefix=/usr \
		--configdir=/etc \
		$(use lv2 && echo "--lv2" || echo "--no-lv2") \
		$(use nls && echo "--nls" || echo "--no-nls") \
		$(use debug && echo "--stl-debug" || echo "--optimize") \
		$((use altivec || use cpu_flags_x86_sse) && echo "--fpu-optimization" || echo "--no-fpu-optimization") \
		$(use doc && echo "--docs")
}

src_install() {
	waf-utils_src_install
	mv ${PN}.1 ${PN}${SLOT}.1
	doman ${PN}${SLOT}.1
	newicon icons/icon/ardour_icon_mac.png ${PN}${SLOT}.png
	make_desktop_entry ardour3 ardour3 ardour3 AudioVideo
}

pkg_postinst() {
	elog "If you are using Ardour and want to keep its development alive"
	elog "then please consider to do a donation upstream at ardour.org. Thanks!"
}
