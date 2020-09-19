# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils

DESCRIPTION="Mumble is an open source, low-latency, high quality voice chat software"
HOMEPAGE="https://wiki.mumble.info"
if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mumble-voip/mumble.git"
	EGIT_SUBMODULES=( '-*' celt-0.7.0-src celt-0.11.0-src themes/Mumble 3rdparty/rnnoise-src )
else
	if [[ "${PV}" == *_pre* ]] ; then
		SRC_URI="https://dev.gentoo.org/~polynomial-c/dist/${P}.tar.xz"
	else
		MY_PV="${PV/_/-}"
		MY_P="${PN}-${MY_PV}"
		SRC_URI="https://github.com/mumble-voip/mumble/releases/download/${MY_PV}/${MY_P}.tar.gz
			https://dl.mumble.info/${MY_P}.tar.gz"
		S="${WORKDIR}/${P/_*}"
	fi
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="BSD MIT"
SLOT="0"
IUSE="+alsa +dbus debug g15 jack libressl portaudio pulseaudio +rnnoise speech test zeroconf"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	>=dev-libs/protobuf-2.2.0:=
	>=media-libs/libsndfile-1.0.20[-minimal]
	>=media-libs/speex-1.2.0
	media-libs/speexdsp
	sys-apps/lsb-release
	x11-libs/libX11
	x11-libs/libXi
	alsa? ( media-libs/alsa-lib )
	dbus? ( dev-qt/qtdbus:5 )
	g15? ( app-misc/g15daemon )
	jack? ( virtual/jack )
	!libressl? ( >=dev-libs/openssl-1.0.0b:0= )
	libressl? ( dev-libs/libressl )
	>=media-libs/opus-1.3.1
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
	speech? ( >=app-accessibility/speech-dispatcher-0.8.0 )
	zeroconf? ( net-dns/avahi[mdnsresponder-compat] )
"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.41.0
	x11-base/xorg-proto
"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

src_configure() {

	local mycmakeargs=(
		"-Dbundled-celt=ON"
		"-Dbundled-opus=OFF"
		"-Dbundled-speex=OFF"
		"-Doverlay=ON"
		"-Dtranslations=OFF"
		"-Dserver=OFF"
		"-Dupdate=OFF"
		"-Dalsa=$(usex alsa)"
		"-Ddbus=$(usex dbus)"
		"-Dg15=$(usex g15)"
		"-Djackaudio=$(usex jack)"
		"-Dportaudio=$(usex portaudio)"
		"-Dpulseaudio=$(usex pulseaudio)"
		"-Drnnoise=$(usex rnnoise)"
		"-Dspeechd=$(usex speech)"
		"-DBUILD_TESTING=$(usex test)"
		"-Dzeroconf=$(usex zeroconf)"
	)

	CMAKE_BUILD_TYPE=$(usex debug Debug Release) \
	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	echo
	elog "Visit https://wiki.mumble.info/ for futher configuration instructions."
	elog "Run mumble-overlay to start the OpenGL overlay (after starting mumble)."
	echo
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
