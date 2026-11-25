# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic xdg

DESCRIPTION="Open Source Flight Simulator"
HOMEPAGE="https://www.flightgear.org/"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/flightgear/${PN}.git"
	EGIT_BRANCH="next"
else
	SRC_URI="https://gitlab.com/flightgear/flightgear/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi
LICENSE="GPL-2"
SLOT="0"
IUSE="cpu_flags_x86_sse2 dbus gdal qt6 +udev +utils"

# Needs --fg-root with path to flightgear-data passed to test runner passed,
# not really worth patching
RESTRICT="test"

# zlib is some strange auto-dep from simgear
# TODO add osgXR
COMMON_DEPEND="
	dev-db/sqlite:3
	>=dev-games/openscenegraph-3.6.0[jpeg,png]
	~dev-games/simgear-${PV}[gdal=]
	media-libs/libglvnd[X]
	media-libs/openal
	>=media-libs/plib-1.8.5
	virtual/zlib:=
	virtual/glu
	x11-libs/libX11
	dbus? ( >=sys-apps/dbus-1.6.18-r1 )
	gdal? ( >=sci-libs/gdal-2.0.0:= )
	qt6? (
		dev-qt/qtbase:6[gui,network,widgets]
		dev-qt/qtdeclarative:6
	)
	udev? ( virtual/udev )
	utils? (
		media-libs/freeglut
		media-libs/freetype:2
		media-libs/glew:0
		media-libs/libpng:0=
		>=media-libs/speex-1.2.0:0
		media-libs/speexdsp:0
		media-sound/gsm
	)
"
# libXi and libXmu are build-only-deps according to FindGLUT.cmake
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	x11-base/xorg-proto
	utils? (
		x11-libs/libXi
		x11-libs/libXmu
	)
"
RDEPEND="${COMMON_DEPEND}
	~games-simulation/${PN}-data-${PV}
	qt6? ( dev-qt/qtsvg:6 )
"
BDEPEND="qt6? ( dev-qt/qttools:6[linguist] )"

DOCS=(AUTHORS ChangeLog NEWS README Thanks)

PATCHES=(
	"${FILESDIR}/${PN}-2024.1.1-cmake.patch"
	"${FILESDIR}/0003-make-fglauncher-a-static-library.patch"
	"${FILESDIR}/0005-make-fgqmlui-a-static-library.patch"
	"${FILESDIR}/0006-fgviewer-fix-crash-on-exit.patch"

	# https://gitlab.com/flightgear/flightgear/-/work_items/3527
	"${FILESDIR}/${PN}-2024.1.7-fix_gdal.patch"
)

src_configure() {
	# -Werror=lto-type-mismatch, -Werror=odr
	# https://bugs.gentoo.org/859217
	# https://sourceforge.net/p/flightgear/codetickets/2908/
	filter-lto

	# avoid -O3 -g
	CMAKE_BUILD_TYPE="Release"
	append-cppflags -DNDEBUG

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DCHECK_FOR_QT5=OFF
		-DCHECK_FOR_QT6=ON
		-DENABLE_AUTOTESTING=OFF
		-DENABLE_FGCOM=$(usex utils)
		-DENABLE_FGELEV=$(usex utils)
		-DENABLE_FGJS=$(usex utils)
		-DENABLE_FGVIEWER=$(usex utils)
		-DENABLE_GDAL=$(usex gdal)
		-DENABLE_GPSSMOOTH=$(usex utils)
		-DENABLE_HID_INPUT=$(usex udev)
		-DENABLE_IAX=$(usex utils)
		-DENABLE_JS_DEMO=$(usex utils)
		-DENABLE_JSBSIM=ON
		-DENABLE_LARCSIM=ON
		-DENABLE_METAR=$(usex utils)
		-DENABLE_PLIB_JOYSTICK=ON # NOTE look for defaults changes in CMake
		-DENABLE_QT=$(usex qt6)
		-DENABLE_RTI=OFF
		-DENABLE_SENTRY=OFF # sentry-native masked
		-DENABLE_HUD=ON
		-DENABLE_PUI=ON
		-DENABLE_SIMD=$(usex cpu_flags_x86_sse2)
		-DENABLE_STGMERGE=ON
		-DENABLE_SWIFT=OFF # swift pilot client not packaged yet
		-DENABLE_TRAFFIC=$(usex utils)
		-DENABLE_UIUC_MODEL=ON
		-DENABLE_VR=OFF
		-DENABLE_YASIM=ON
		-DEVENT_INPUT=$(usex udev)
		-DFG_DATA_DIR="${EPREFIX}/usr/share/${PN}"
		-DJSBSIM_TERRAIN=ON
		-DOSG_FSTREAM_EXPORT_FIXED=OFF # TODO also see simgear
		-DSP_FDMS=ON
		-DSYSTEM_CPPUNIT=OFF # NOTE we do not build tests anyway
		-DSYSTEM_FLITE=OFF
		-DSYSTEM_HTS_ENGINE=OFF
		-DSYSTEM_SPEEX=ON
		-DSYSTEM_GSM=ON
		-DSYSTEM_SQLITE=ON
		-DSYSTEM_OSGXR=ON
		-DUSE_AEONWAVE=OFF
		-DUSE_DBUS=$(usex dbus)
		-DWITH_FGPANEL=$(usex utils)
		-DENABLE_FGQCANVAS=OFF # still Qt5-only, bug 968375
	)
	if [[ PV == *9999 ]]; then
		mycmakeargs+=( -DFG_BUILD_TYPE=Nightly )
	else
		mycmakeargs+=( -DFG_BUILD_TYPE=Release )
	fi
	if use gdal && use utils; then
		mycmakeargs+=( -DENABLE_DEMCONVERT=ON )
	else
		mycmakeargs+=( -DENABLE_DEMCONVERT=OFF )
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# Install bash completion (TODO zsh)
	# Uncomment below when scripts stops writing files...
	#sed -e "s|/usr/local/share/FlightGear|${GAMES_DATADIR}/${PN}|" \
	#	-i scripts/completion/fg-completion.bash || die 'unable to replace FG_ROOT'
	#newbashcomp scripts/completion/fg-completion.bash ${PN}

	# Install examples and other misc files
	docompress -x /usr/share/doc/"${PF}"/{examples,tools}
	docinto examples
	dodoc -r scripts/java scripts/perl scripts/python
	docinto examples/c++
	dodoc -r scripts/example/*
	docinto tools
	dodoc -r scripts/atis scripts/tools/*

	# Install nasal script syntax
	insinto /usr/share/vim/vimfiles/syntax
	doins scripts/syntax/{ac3d,nasal}.vim
	insinto /usr/share/vim/vimfiles/ftdetect/
	doins "${FILESDIR}"/{ac3d,nasal}.vim

	# delete duplicate files for AppDir
	rm -r "${ED}"/usr/appdir || die
}

pkg_postinst() {
	xdg_pkg_postinst

	if use qt6; then
		einfo "To use launcher, run fgfs with '--launcher' parameter"
	fi
}
