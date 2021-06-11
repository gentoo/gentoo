# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic readme.gentoo-r1 xdg-utils

DESCRIPTION="Environment and programming language for real time audio synthesis"
HOMEPAGE="https://supercollider.github.io/"
SRC_URI="https://github.com/supercollider/supercollider/releases/download/Version-${PV}/SuperCollider-${PV}-Source.tar.bz2"

LICENSE="GPL-2 gpl3? ( GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse cpu_flags_x86_sse2 debug emacs +fftw gedit +gpl3 jack qt5 server +sndfile static-libs vim webengine X zeroconf"

REQUIRED_USE="
	qt5? ( X )
	webengine? ( qt5 )
"

BDEPEND="
	virtual/pkgconfig
	qt5? ( dev-qt/linguist-tools:5 )
"
RDEPEND="
	dev-cpp/yaml-cpp:=
	>=dev-libs/boost-1.70.0:=
	media-libs/alsa-lib
	sys-libs/readline:0=
	virtual/libudev:=
	fftw? ( sci-libs/fftw:3.0= )
	jack? ( virtual/jack )
	!jack? ( media-libs/portaudio )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtprintsupport:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
	)
	server? ( !app-admin/supernova )
	sndfile? ( media-libs/libsndfile )
	webengine? (
		dev-qt/qtwebchannel:5
		dev-qt/qtwebengine:5[widgets]
		dev-qt/qtwebsockets:5
	)
	X? (
		x11-libs/libX11
		x11-libs/libXt
	)
	zeroconf? ( net-dns/avahi )
"
DEPEND="${RDEPEND}
	dev-libs/icu
	emacs? ( >=app-editors/emacs-23.1:* )
	gedit? ( app-editors/gedit )
	qt5? ( dev-qt/qtconcurrent:5 )
	vim? ( app-editors/vim )
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.10.2-no-ccache.patch
	"${FILESDIR}"/${P}-fewer-qt-deps.patch # Upstream PR 4991
	"${FILESDIR}"/${P}-fix-libscsynth-linker-issue.patch # Upstream issue 4992
	"${FILESDIR}"/${P}-boost-1.74.patch # bug 760489
)

S="${WORKDIR}/SuperCollider-${PV}-Source"

src_configure() {
	local mycmakeargs=(
		-DINSTALL_HELP=ON
		-DSYSTEM_BOOST=ON
		-DSYSTEM_YAMLCPP=ON
		-DSSE=$(usex cpu_flags_x86_sse)
		-DSSE2=$(usex cpu_flags_x86_sse2)
		-DSC_EL=$(usex emacs)
		-DFFT_GREEN=$(usex !fftw)
		-DSC_ED=$(usex gedit)
		-DNO_GPL3=$(usex !gpl3)
		-DAUDIOAPI=$(usex jack jack portaudio)
		-DSC_IDE=$(usex qt5)
		-DSC_QT=$(usex qt5)
		-DSCLANG_SERVER=$(usex server)
		-DSUPERNOVA=$(usex server)
		-DNO_LIBSNDFILE=$(usex !sndfile)
		-DLIBSCSYNTH=$(usex !static-libs)
		-DSC_VIM=$(usex vim)
		-DNO_X11=$(usex !X)
		-DNO_AVAHI=$(usex !zeroconf)
	)

	use qt5 && mycmakeargs+=(
		-DSC_USE_QTWEBENGINE=$(usex webengine)
	)

	use debug && mycmakeargs+=(
		-DSC_MEMORY_DEBUGGING=ON
		-DSN_MEMORY_DEBUGGING=ON
		-DGC_SANITYCHECK=ON
	)

	append-flags $(usex debug '' -DNDEBUG)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	use emacs && newdoc editors/scel/README.md README.emacs
	use gedit && newdoc editors/sced/README.md README.gedit
	use vim && newdoc editors/scvim/README.md README.vim
}

src_test() {
	export QT_QPA_PLATFORM=offscreen
	cmake_src_test
}

pkg_postinst() {
	einfo "Notice: SuperCollider is not very intuitive to get up and running."
	einfo "The best course of action to make sure that the installation was"
	einfo "successful and get you started with using SuperCollider is to take"
	einfo "a look through ${EROOT}/usr/share/doc/${PF}/README.md.bz2"

	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
