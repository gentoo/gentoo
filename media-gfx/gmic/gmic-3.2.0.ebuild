# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="GREYC's Magic Image Converter"
HOMEPAGE="https://gmic.eu/ https://github.com/GreycLab/gmic"
SRC_URI="https://gmic.eu/files/source/${PN}_${PV}.tar.gz"

LICENSE="CeCILL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="cli curl ffmpeg fftw gimp graphicsmagick jpeg opencv openexr openmp png qt5 tiff X"

REQUIRED_USE="
	gimp? ( png fftw X )
	qt5? ( png fftw X )
"

MIN_QT_VER="5.2.0"
QT_DEPEND="
	>=dev-qt/qtcore-${MIN_QT_VER}:5
	>=dev-qt/qtgui-${MIN_QT_VER}:5
	>=dev-qt/qtnetwork-${MIN_QT_VER}:5
	>=dev-qt/qtwidgets-${MIN_QT_VER}:5
"
DEPEND="
	sys-libs/zlib:0=
	curl? ( net-misc/curl )
	fftw? ( sci-libs/fftw:3.0=[threads] )
	gimp? (
		media-gfx/gimp:0/2
		${QT_DEPEND}
	)
	graphicsmagick? ( media-gfx/graphicsmagick:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	opencv? ( >=media-libs/opencv-2.3.1a-r1:= )
	openexr? (
		dev-libs/imath:=
		media-libs/openexr:=
	)
	png? ( media-libs/libpng:= )
	qt5? ( ${QT_DEPEND} )
	tiff? ( media-libs/tiff:= )
	X? (
		x11-libs/libX11
		x11-libs/libXext
	)"
RDEPEND="${DEPEND}
	ffmpeg? ( media-video/ffmpeg:= )
"
BDEPEND="
	virtual/pkgconfig
	gimp? (
		dev-qt/linguist-tools:5
		media-gfx/gimp:0/2
	)
	qt5? ( dev-qt/linguist-tools:5 )
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.6-ar_so.patch
	"${FILESDIR}"/${PN}-3.2.0-grep38.patch
	"${FILESDIR}"/${PN}-3.2.0-makefile_automagic.patch
	"${FILESDIR}"/${PN}-3.2.0-relative_rpath.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

gmic_emake() {
	local mymakeargs=(
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		STRIP="/bin/true"
		LIB="$(get_libdir)"
		OPT_CFLAGS="${CXXFLAGS}"
		OPT_LIBS="${LDFLAGS}"
		GMIC_USE_CURL=$(usex curl)
		GMIC_USE_EXR=$(usex openexr)
		GMIC_USE_FFTW=$(usex fftw)
		GMIC_USE_GRAPHICSMAGICK=$(usex graphicsmagick)
		GMIC_USE_JPEG=$(usex jpeg)
		GMIC_USE_OPENCV=$(usex opencv)
		GMIC_USE_OPENMP=$(usex openmp)
		GMIC_USE_PNG=$(usex png)
		GMIC_USE_TIFF=$(usex tiff)
		GMIC_USE_X11=$(usex X)
		QMAKE="qmake5"
	)

	# Possibly unnecessary since 3.2.0, just in case though.
	tc-is-clang && mymakeargs+=( OPENMP_LIBS="-lomp" )

	emake -j1 -C src \
		"${mymakeargs[@]}" \
		$@
}

src_compile() {
	gmic_emake lib libc
	use cli && gmic_emake cli_shared
	use gimp && gmic_emake gimp_shared
	use qt5 && gmic_emake gmic_qt_shared
}

src_install() {
	# See below for why this has to name a directory even if USE=-gimp
	local gimp_plugindir="/deleteme"
	if use gimp; then
		if type gimptool &>/dev/null; then
			gimp_plugindir="$(gimptool --gimpplugindir)/plug-ins"
		elif type gimptool-2.0 &>/dev/null; then
			gimp_plugindir="$(gimptool-2.0 --gimpplugindir)/plug-ins"
		elif type gimptool-2.99 &>/dev/null; then
			gimp_plugindir="$(gimptool-2.99 --gimpplugindir)/plug-ins"
		else
			die "Cannot find GIMP plugin directory"
		fi
	fi

	gmic_emake DESTDIR="${ED}" PLUGINDIR="${gimp_plugindir}" install

	# Upstream build scripts create PLUGINDIR and write some files to it
	# regardless of whether the GIMP plug-in has been built or not, or even
	# when they haven't been able to execute gimptool to get the base path.
	use gimp || rm -rf "${ED}/${gimp_plugindir}"

	# These are already gzipped in the source tarballs
	find "${ED}/usr/share/man" -name "*.gz" -exec gunzip {} \; || die
}
