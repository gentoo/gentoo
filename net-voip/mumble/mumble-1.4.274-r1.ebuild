# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake flag-o-matic python-any-r1 xdg

DESCRIPTION="Mumble is an open source, low-latency, high quality voice chat software"
HOMEPAGE="https://wiki.mumble.info"
if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mumble-voip/mumble.git"
	EGIT_SUBMODULES=( '-*' celt-0.7.0-src celt-0.11.0-src themes/Mumble 3rdparty/rnnoise-src 3rdparty/FindPythonInterpreter )
else
	if [[ "${PV}" == *_pre* ]] ; then
		SRC_URI="https://dev.gentoo.org/~concord/distfiles/${P}.tar.xz"
	else
		MY_PV="${PV/_/-}"
		MY_P="${PN}-${MY_PV}"
		SRC_URI="https://github.com/mumble-voip/mumble/releases/download/v${MY_PV}/${MY_P}.tar.gz"
		S="${WORKDIR}/${PN}-src"
	fi
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
fi

SRC_URI+=" https://dev.gentoo.org/~concord/distfiles/${PN}-1.4-openssl3.patch.xz"
SRC_URI+=" https://dev.gentoo.org/~concord/distfiles/${PN}-1.4-crypto-threads.patch.xz"
SRC_URI+=" https://dev.gentoo.org/~concord/distfiles/${PN}-1.4-odr.patch.xz"

LICENSE="BSD MIT"
SLOT="0"
IUSE="+alsa +dbus debug g15 jack pipewire portaudio pulseaudio multilib nls +rnnoise speech test zeroconf"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/openssl-1.0.0b:0=
	dev-libs/poco[util,xml,zip]
	>=dev-libs/protobuf-2.2.0:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	>=media-libs/libsndfile-1.0.20[-minimal]
	>=media-libs/opus-1.3.1
	>=media-libs/speex-1.2.0
	media-libs/speexdsp
	sys-apps/lsb-release
	x11-libs/libX11
	x11-libs/libXi
	alsa? ( media-libs/alsa-lib )
	dbus? ( dev-qt/qtdbus:5 )
	g15? ( app-misc/g15daemon:= )
	jack? ( virtual/jack )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
	pipewire? ( media-video/pipewire )
	speech? ( >=app-accessibility/speech-dispatcher-0.8.0 )
	zeroconf? ( net-dns/avahi[mdnsresponder-compat] )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-qt/qtconcurrent:5
	dev-qt/qttest:5
	dev-libs/boost
	x11-base/xorg-proto
"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

PATCHES=(
	"${WORKDIR}/${PN}-1.4-openssl3.patch"
	"${WORKDIR}/${PN}-1.4-crypto-threads.patch"
	"${WORKDIR}/${PN}-1.4-odr.patch"
)

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	# required because of xdg.eclass also providing src_prepare
	cmake_src_prepare
}

src_configure() {

	local mycmakeargs=(
		-Dalsa="$(usex alsa)"
		-Dtests="$(usex test)"
		-Dbundled-celt="ON"
		-Dbundled-opus="OFF"
		-Dbundled-speex="OFF"
		-Ddbus="$(usex dbus)"
		-Dg15="$(usex g15)"
		-Djackaudio="$(usex jack)"
		-Doverlay="ON"
		-Dportaudio="$(usex portaudio)"
		-Doverlay-xcompile="$(usex multilib)"
		-Dpipewire="$(usex pipewire)"
		-Dpulseaudio="$(usex pulseaudio)"
		-Drnnoise="$(usex rnnoise)"
		-Dserver="OFF"
		-Dspeechd="$(usex speech)"
		-Dtranslations="$(usex nls)"
		-Dupdate="OFF"
		-Dwarnings-as-errors="OFF"
		-Dzeroconf="$(usex zeroconf)"
	)

	if [[ "${PV}" != 9999 ]] ; then
		mycmakeargs+=( -DBUILD_NUMBER="$(ver_cut 3)" )
	fi

	# https://bugs.gentoo.org/832978
	# fix tests (and possibly runtime issues) on arches with unsigned chars
	append-cxxflags -fsigned-char

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use amd64 && use multilib ; then
		# The 32bit overlay library gets built when multilib is enabled.
		# Install it into the correct 32bit lib dir.
		local libdir_64="/usr/$(get_libdir)/mumble"
		local libdir_32="/usr/$(get_abi_var LIBDIR x86)/mumble"
		dodir ${libdir_32}
		mv "${ED}"/${libdir_64}/libmumbleoverlay.x86.so* \
			"${ED}"/${libdir_32}/ || die
	fi

	insinto /usr/share/mumble
	doins -r samples
}

pkg_postinst() {
	xdg_pkg_postinst
	echo
	elog "Visit https://wiki.mumble.info/ for futher configuration instructions."
	elog "Run 'mumble-overlay <program>' to start the OpenGL overlay (after starting mumble)."
	echo
}
