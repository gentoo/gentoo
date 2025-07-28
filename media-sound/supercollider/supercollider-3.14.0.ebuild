# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic xdg

DESCRIPTION="Environment and programming language for real time audio synthesis"
HOMEPAGE="https://supercollider.github.io/"
SRC_URI="https://github.com/supercollider/supercollider/releases/download/Version-${PV/_/-}/SuperCollider-${PV/_/-}-Source.tar.bz2"
S="${WORKDIR}/SuperCollider-${PV/_/-}-Source"

LICENSE="GPL-2 gpl3? ( GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ableton-link cpu_flags_x86_sse cpu_flags_x86_sse2 debug emacs +fftw +gpl3 jack qt6 server +sndfile static-libs vim webengine X +zeroconf"

REQUIRED_USE="qt6? ( X ) webengine? ( qt6 )"

BDEPEND="
	virtual/pkgconfig
	qt6? ( dev-qt/qttools:6[linguist] )
"
RDEPEND="
	dev-cpp/yaml-cpp:=
	dev-libs/boost:=
	media-libs/alsa-lib
	sys-libs/readline:0=
	virtual/libudev:=
	fftw? ( sci-libs/fftw:3.0= )
	jack? ( virtual/jack )
	!jack? ( media-libs/portaudio )
	qt6? (
		dev-qt/qtbase:6[gui,network,widgets]
		dev-qt/qtsvg:6
	)
	sndfile? ( media-libs/libsndfile )
	X? (
		x11-libs/libX11
		x11-libs/libXt
	)
	zeroconf? ( net-dns/avahi )
"
DEPEND="${RDEPEND}
	dev-libs/icu
	emacs? ( >=app-editors/emacs-23.1:* )
	qt6? ( dev-qt/qtbase:6[concurrent] )
	vim? ( app-editors/vim )
"

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/927071
	# https://github.com/supercollider/supercollider/issues/6245
	append-flags -fno-strict-aliasing
	filter-lto

	local mycmakeargs=(
		-DSC_CLANG_USES_LIBSTDCPP=ON
		-DINSTALL_HELP=ON
		-DSYSTEM_BOOST=ON
		-DSYSTEM_YAMLCPP=ON
		-DUSE_CCACHE=OFF
		-DSC_ABLETON_LINK=$(usex ableton-link)
		-DSSE=$(usex cpu_flags_x86_sse)
		-DSSE2=$(usex cpu_flags_x86_sse2)
		-DSC_EL=$(usex emacs)
		-DFFT_GREEN=$(usex !fftw)
		-DNO_GPL3=$(usex !gpl3)
		-DAUDIOAPI=$(usex jack jack portaudio)
		-DSC_IDE=$(usex qt6)
		-DSC_QT=$(usex qt6)
		-DSCLANG_SERVER=$(usex server)
		-DSUPERNOVA=$(usex server)
		-DNO_LIBSNDFILE=$(usex !sndfile)
		-DLIBSCSYNTH=$(usex !static-libs)
		-DSC_VIM=$(usex vim)
		-DSC_USE_QTWEBENGINE=$(usex webengine)
		-DNO_X11=$(usex !X)
		-DNO_AVAHI=$(usex !zeroconf)
	)

	use debug && mycmakeargs+=(
		-DSC_MEMORY_DEBUGGING=ON
		-DSN_MEMORY_DEBUGGING=ON
		-DGC_SANITYCHECK=ON
	)

	append-flags $(usex debug '' -DNDEBUG)

	cmake_src_configure
}

src_test() {
	export QT_QPA_PLATFORM=offscreen
	cmake_src_test
}

src_install() {
	cmake_src_install

	use emacs && newdoc editors/sc-el/README.md README.emacs
	use vim && newdoc editors/scvim/README.md README.vim
}

pkg_postinst() {
	einfo "Notice: SuperCollider is not very intuitive to get up and running."
	einfo "The best course of action to make sure that the installation was"
	einfo "successful and get you started with using SuperCollider is to take"
	einfo "a look through ${EROOT}/usr/share/doc/${PF}/README.md.bz2"
	xdg_pkg_postinst
}
