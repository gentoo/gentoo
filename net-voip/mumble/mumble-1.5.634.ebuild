# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit cmake flag-o-matic multilib python-any-r1 xdg

DESCRIPTION="Mumble is an open source, low-latency, high quality voice chat software"
HOMEPAGE="https://wiki.mumble.info"
if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mumble-voip/mumble.git"

	# needed for the included 3rdparty license script,
	# even if these components may not be compiled in
	EGIT_SUBMODULES=(
		'-*'
		3rdparty/cmake-compiler-flags
		3rdparty/FindPythonInterpreter
		3rdparty/flag-icons
		3rdparty/minhook
		3rdparty/renamenoise
		3rdparty/speexdsp
		3rdparty/tracy
	)
else
	if [[ "${PV}" == *_pre* ]] ; then
		SRC_URI="https://dev.gentoo.org/~concord/distfiles/${P}.tar.xz"
	else
		MY_PV="${PV/_/-}"
		MY_P="${PN}-${MY_PV}"
		SRC_URI="https://github.com/mumble-voip/mumble/releases/download/v${MY_PV}/${MY_P}.tar.gz"
		S="${WORKDIR}/${P/_*}"
	fi
	KEYWORDS="amd64 arm64 ppc64 x86"
fi

LICENSE="BSD MIT"
SLOT="0"
IUSE="+alsa debug g15 jack pipewire portaudio pulseaudio multilib nls +rnnoise speech test zeroconf"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-cpp/ms-gsl
	>=dev-libs/openssl-1.0.0b:0=
	dev-libs/poco[util,xml,zip]
	>=dev-libs/protobuf-2.2.0:=
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
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
	g15? ( app-misc/g15daemon:= )
	jack? ( virtual/jack )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-libs/libpulse )
	pipewire? ( media-video/pipewire )
	speech? ( >=app-accessibility/speech-dispatcher-0.8.0 )
	zeroconf? ( net-dns/avahi[mdnsresponder-compat] )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-cpp/nlohmann_json
	dev-qt/qtconcurrent:5
	dev-qt/qttest:5
	dev-libs/boost
	x11-base/xorg-proto
"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	sed '/TRACY_ON_DEMAND/s@ ON @ OFF @' -i src/CMakeLists.txt || die

	# required because of xdg.eclass also providing src_prepare
	cmake_src_prepare
}

src_configure() {

	local mycmakeargs=(
		-Dalsa="$(usex alsa)"
		-Dbundled-gsl="OFF"
		-Dbundled-json="OFF"
		-Dbundled-speex="OFF"
		-Dg15="$(usex g15)"
		-Djackaudio="$(usex jack)"
		-Doverlay="ON"
		-Dportaudio="$(usex portaudio)"
		-Doverlay-xcompile="$(usex multilib)"
		-Dpipewire="$(usex pipewire)"
		-Dpulseaudio="$(usex pulseaudio)"
		-Drenamenoise="$(usex rnnoise)"
		-Dserver="OFF"
		-Dspeechd="$(usex speech)"
		-Dtests="$(usex test)"
		-Dtracy="OFF"
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
