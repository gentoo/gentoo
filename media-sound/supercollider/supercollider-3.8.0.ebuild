# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils readme.gentoo-r1

DESCRIPTION="An environment and a programming language for real time audio synthesis."
HOMEPAGE="https://supercollider.github.io/"
SRC_URI="https://github.com/supercollider/supercollider/releases/download/Version-${PV}/SuperCollider-${PV}-Source-linux.tar.bz2"

LICENSE="GPL-2 gpl3? ( GPL-3 )"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="avahi cpu_flags_x86_sse cpu_flags_x86_sse2 debug emacs +fftw gedit +gpl3 jack +portaudio qt5 server +sndfile static-libs vim wiimote"
REQUIRED_USE="^^ ( jack portaudio )"
RESTRICT="mirror"

RDEPEND="
	media-libs/alsa-lib
	sys-libs/readline:0=
	x11-libs/libX11
	x11-libs/libXt
	avahi? ( net-dns/avahi )
	fftw? ( sci-libs/fftw:3.0= )
	jack? ( virtual/jack )
	portaudio? ( media-libs/portaudio )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwebkit:5
		dev-qt/qtwidgets:5
	)
	sndfile? ( media-libs/libsndfile )
	wiimote? ( app-misc/cwiid )
	server? ( !app-admin/supernova )
"
DEPEND="${RDEPEND}
	dev-libs/icu
	virtual/pkgconfig
	emacs? ( virtual/emacs )
	gedit? ( app-editors/gedit )
	vim? ( app-editors/vim )
	qt5? (
		dev-qt/linguist-tools:5
		dev-qt/qtdeclarative:5
		dev-qt/qtconcurrent:5
	)
"

S="${WORKDIR}/SuperCollider-Source"

PATCHES=(
	"${FILESDIR}"/${PV}-no-opengl.patch
	"${FILESDIR}"/${PV}-no-qtsensors.patch
	"${FILESDIR}"/${PV}-no-qtpositioning.patch
)

src_configure() {
	local mycmakeargs=(
		-DAUDIOAPI=$(usex jack jack portaudio)
		-DINSTALL_HELP=ON
		-DNATIVE=ON
		-DSYSTEM_BOOST=OFF
		-DSYSTEM_YAMLCPP=OFF
		-DNO_AVAHI=$(usex !avahi)
		-DFFT_GREEN=$(usex !fftw)
		-DNO_GPL3=$(usex !gpl3)
		-DNO_LIBSNDFILE=$(usex !sndfile)
		-DSC_QT=$(usex qt5)
		-DSCLANG_SERVER=$(usex server)
		-DSUPERNOVA=$(usex server)
		-DLIBSCSYNTH=$(usex !static-libs)
		-DSSE=$(usex cpu_flags_x86_sse)
		-DSSE2=$(usex cpu_flags_x86_sse2)
		-DSC_IDE=$(usex qt5)
		-DSC_ED=$(usex gedit)
		-DSC_VIM=$(usex vim)
		-DSC_EL=$(usex emacs)
		-DSC_WII=$(usex wiimote)
	)

	use debug && mycmakeargs+=(
		-DSC_MEMORY_DEBUGGING=ON
		-DSN_MEMORY_DEBUGGING=ON
		-DGC_SANITYCHECK=ON
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	use vim && newdoc editors/scvim/README.md README.vim
	use emacs && newdoc editors/scel/README.md README.emacs
	use gedit && newdoc editors/sced/README.md README.gedit
}

pkg_postinst() {
	einfo
	einfo "Notice: SuperCollider is not very intuitive to get up and running."
	einfo "The best course of action to make sure that the installation was"
	einfo "successful and get you started with using SuperCollider is to take"
	einfo "a look through ${EROOT%/}/usr/share/doc/${PF}/README.md.bz2"
	einfo
}
