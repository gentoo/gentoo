# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 toolchain-funcs

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/dtschump/gmic.git"
	inherit git-r3
else
	SRC_URI="https://gmic.eu/files/source/${PN}_${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="GREYC's Magic Image Converter"
HOMEPAGE="https://gmic.eu/ https://github.com/dtschump/gmic"

LICENSE="CeCILL-2 GPL-3"
SLOT="0"
IUSE="cli curl ffmpeg fftw gimp graphicsmagick jpeg opencv openexr openmp png qt5 tiff X"
REQUIRED_USE="
	gimp? ( png fftw X )
	qt5? ( png fftw X )
"

# No test suite, hand-crafted Makefiles barf out on 'emake check'
RESTRICT="test"

MIN_QT_VER="5.2.0"
QT_DEPEND="
	>=dev-qt/qtcore-${MIN_QT_VER}:5=
	>=dev-qt/qtgui-${MIN_QT_VER}:5=
	>=dev-qt/qtnetwork-${MIN_QT_VER}:5=
	>=dev-qt/qtwidgets-${MIN_QT_VER}:5=
"
DEPEND="
	sys-libs/zlib:0=
	curl? ( net-misc/curl )
	fftw? ( sci-libs/fftw:3.0=[threads] )
	gimp? (
		media-gfx/gimp:0/2
		${QT_DEPEND}
	)
	graphicsmagick? ( media-gfx/graphicsmagick:0= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	opencv? ( >=media-libs/opencv-2.3.1a-r1:0= )
	openexr? (
		dev-libs/imath:=
		media-libs/openexr:=
	)
	png? ( media-libs/libpng:0= )
	qt5? ( ${QT_DEPEND} )
	tiff? ( media-libs/tiff:0 )
	X? (
		x11-libs/libX11
		x11-libs/libXext
	)"
RDEPEND="${DEPEND}
	ffmpeg? ( media-video/ffmpeg:0= )
"
BDEPEND="
	virtual/pkgconfig
	gimp? ( dev-qt/linguist-tools:5 )
	qt5? ( dev-qt/linguist-tools:5 )
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.5-makefile_automagic.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

gmic_emake() {
	emake -j1 -C src \
		GMIC_USE_CURL=$(usex curl) \
		GMIC_USE_EXR=$(usex openexr) \
		GMIC_USE_FFTW=$(usex fftw) \
		GMIC_USE_GRAPHICSMAGICK=$(usex graphicsmagick) \
		GMIC_USE_JPEG=$(usex jpeg) \
		GMIC_USE_OPENCV=$(usex opencv) \
		GMIC_USE_OPENMP=$(usex openmp) \
		GMIC_USE_PNG=$(usex png) \
		GMIC_USE_TIFF=$(usex tiff) \
		GMIC_USE_X11=$(usex X) \
		QMAKE="qmake5" \
		$@
}

# FIXME:
#  - do not pre-strip binaries
#  - honour user LDFLAGS on lib{,c}gmic.so
#  - fix multilib-strict violation on same
#  - nuke relative DT_RUNPATH on same
#  - GIMP plug-in dir should only be created if USE=gimp, otherwise it ends up being just /plug-ins
src_compile() {
	gmic_emake lib libc
	use cli && gmic_emake cli_shared
	use gimp && gmic_emake gimp_shared
	use qt5 && gmic_emake gmic_qt_shared
}
