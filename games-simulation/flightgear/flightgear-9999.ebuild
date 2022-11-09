# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake bash-completion-r1 toolchain-funcs git-r3

DESCRIPTION="Open Source Flight Simulator"
HOMEPAGE="https://www.flightgear.org/"
EGIT_REPO_URI="git://git.code.sf.net/p/${PN}/${PN}
	git://mapserver.flightgear.org/${PN}"
EGIT_BRANCH="next"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"
IUSE="cpu_flags_x86_sse2 dbus debug examples gdal openmp qt5 +udev +utils vim-syntax"

# Needs --fg-root with path to flightgear-data passed to test runner passed,
# not really worth patching
RESTRICT="test"

# zlib is some strange auto-dep from simgear
COMMON_DEPEND="
	dev-db/sqlite:3
	dev-games/openscenegraph[jpeg,png]
	~dev-games/simgear-${PV}[gdal=]
	media-libs/openal
	>=media-libs/plib-1.8.5
	>=media-libs/speex-1.2.0:0
	media-libs/speexdsp:0
	media-sound/gsm
	sys-libs/zlib
	virtual/glu
	x11-libs/libX11
	dbus? ( >=sys-apps/dbus-1.6.18-r1 )
	gdal? ( >=sci-libs/gdal-2.0.0:0 )
	qt5? (
		>=dev-qt/qtcore-5.7.1:5
		>=dev-qt/qtdeclarative-5.7.1:5
		>=dev-qt/qtgui-5.7.1:5
		>=dev-qt/qtnetwork-5.7.1:5
		>=dev-qt/qtwidgets-5.7.1:5
	)
	udev? ( virtual/udev )
	utils? (
		media-libs/freeglut
		media-libs/freetype:2
		media-libs/glew:0
		media-libs/libpng:0
		virtual/opengl
		qt5? ( >=dev-qt/qtwebsockets-5.7.1:5 )
	)
"
# libXi and libXmu are build-only-deps according to FindGLUT.cmake
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	utils? (
		x11-libs/libXi
		x11-libs/libXmu
	)
"
RDEPEND="${COMMON_DEPEND}
	~games-simulation/${PN}-data-${PV}
"
BDEPEND="qt5? ( >=dev-qt/linguist-tools-5.7.1:5 )"

PATCHES=(
	"${FILESDIR}/${PN}-2020.3.5-cmake.patch"
)

DOCS=(AUTHORS ChangeLog NEWS README Thanks)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DENABLE_AUTOTESTING=OFF
		-DENABLE_COMPOSITOR=OFF
		-DENABLE_FGCOM=$(usex utils)
		-DENABLE_FGELEV=$(usex utils)
		-DENABLE_FGJS=$(usex utils)
		-DENABLE_FGVIEWER=$(usex utils)
		-DENABLE_GDAL=$(usex gdal)
		-DENABLE_GPSSMOOTH=$(usex utils)
		-DENABLE_HID_INPUT=$(usex udev)
		-DENABLE_JS_DEMO=$(usex utils)
		-DENABLE_JSBSIM=ON
		-DENABLE_LARCSIM=ON
		-DENABLE_METAR=$(usex utils)
		-DENABLE_OPENMP=$(usex openmp)
		-DENABLE_PLIB_JOYSTICK=ON # NOTE look for defaults changes in CMake
		-DENABLE_PROFILE=OFF
		-DENABLE_QT=$(usex qt5)
		-DENABLE_RTI=OFF
		-DENABLE_SIMD=$(usex cpu_flags_x86_sse2)
		-DENABLE_STGMERGE=ON
		-DENABLE_SWIFT=OFF # swift pilot client not packaged yet
		-DENABLE_TERRASYNC=$(usex utils)
		-DENABLE_TRAFFIC=$(usex utils)
		-DENABLE_UIUC_MODEL=ON
		-DENABLE_YASIM=ON
		-DEVENT_INPUT=$(usex udev)
		-DFG_BUILD_TYPE=Nightly
		-DFG_DATA_DIR=/usr/share/${PN}
		-DJSBSIM_TERRAIN=ON
		-DOSG_FSTREAM_EXPORT_FIXED=OFF # TODO also see simgear
		-DSP_FDMS=ON
		-DSYSTEM_CPPUNIT=OFF # NOTE we do not build tests anyway
		-DSYSTEM_FLITE=OFF
		-DSYSTEM_HTS_ENGINE=OFF
		-DSYSTEM_SPEEX=ON
		-DSYSTEM_GSM=ON
		-DSYSTEM_SQLITE=ON
		-DUSE_AEONWAVE=OFF
		-DUSE_DBUS=$(usex dbus)
		-DWITH_FGPANEL=$(usex utils)
	)
	if use gdal && use utils; then
		mycmakeargs+=(-DENABLE_DEMCONVERT=ON)
	else
		mycmakeargs+=(-DENABLE_DEMCONVERT=OFF)
	fi
	if use qt5 && use utils; then
		mycmakeargs+=(-DENABLE_FGQCANVAS=ON)
	else
		mycmakeargs+=(-DENABLE_FGQCANVAS=OFF)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# Install bash completion (TODO zsh)
	# Uncomment below when scripts stops writing files...
#	sed -e "s|/usr/local/share/FlightGear|${GAMES_DATADIR}/${PN}|" \
#		-i scripts/completion/fg-completion.bash || die 'unable to replace FG_ROOT'
#	newbashcomp scripts/completion/fg-completion.bash ${PN}

	# Install examples and other misc files
	if use examples; then
		docompress -x /usr/share/doc/"${PF}"/{examples,tools}
		docinto examples
		dodoc -r scripts/java scripts/perl scripts/python
		docinto examples/c++
		dodoc -r scripts/example/*
		docinto tools
		dodoc -r scripts/atis scripts/tools/*
	fi

	# Install nasal script syntax
	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins scripts/syntax/{ac3d,nasal}.vim
		insinto /usr/share/vim/vimfiles/ftdetect/
		doins "${FILESDIR}"/{ac3d,nasal}.vim
	fi
}

pkg_postinst() {
	einfo "Please note that data files location changed to /usr/share/flightgear"
	if use qt5; then
		einfo "To use launcher, run fgfs with '--launcher' parameter"
	fi
}
