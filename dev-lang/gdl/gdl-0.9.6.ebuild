# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="3.0"
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils eutils python-r1 wxwidgets toolchain-funcs virtualx

DESCRIPTION="GNU Data Language"
HOMEPAGE="http://gnudatalanguage.sourceforge.net/"
SRC_URI="mirror://sourceforge/gnudatalanguage/${P}v2.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+eigen fftw grib gshhs hdf hdf5 imagemagick netcdf openmp
	  png proj postscript python static-libs udunits wxwidgets"

RDEPEND="
	dev-cpp/antlr-cpp:2=
	sci-libs/gsl:0=
	sci-libs/plplot:0=[-dynamic]
	sys-libs/ncurses:0=
	sys-libs/readline:0=
	sys-libs/zlib:0=
	x11-libs/libX11:0=
	fftw? ( sci-libs/fftw:3.0= )
	grib? ( sci-libs/grib_api:0= )
	gshhs? ( sci-geosciences/gshhs-data sci-geosciences/gshhs:0= )
	hdf? ( sci-libs/hdf:0= )
	hdf5? ( sci-libs/hdf5:0= )
	imagemagick? (
		|| (
			media-gfx/graphicsmagick[cxx]
			media-gfx/imagemagick[cxx]
			)
	)
	netcdf? ( sci-libs/netcdf )
	proj? ( sci-libs/proj )
	postscript? ( dev-libs/pslib )
	python? (
		${PYTHON_DEPS}
		dev-python/numpy[${PYTHON_USEDEP}]
	)
	udunits? ( sci-libs/udunits )
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )"

DEPEND="${RDEPEND}
	dev-java/antlr:0[java(+),script(+)]
	virtual/pkgconfig
	eigen? ( dev-cpp/eigen:3 )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	"${FILESDIR}"/0.9.2-include.patch
	"${FILESDIR}"/0.9.5-antlr.patch
	"${FILESDIR}"/0.9.5-png.patch
	"${FILESDIR}"/0.9.6-fix-file-move.patch
	"${FILESDIR}"/0.9.6-fix-python-function-call.patch
	"${FILESDIR}"/0.9.6-fun-fix.patch
	"${FILESDIR}"/0.9.6-python-use-path-and-startup.patch
	"${FILESDIR}"/0.9.6-disable-tests-hanging-under-xvfb-run.patch
	"${FILESDIR}"/0.9.6-gcc6.patch
	"${FILESDIR}"/0.9.6-formats.patch
)

pkg_pretend() {
	use openmp && [[ $(tc-getCXX)$ == *g++* ]] && \
		[[ ${MERGE_TYPE} != binary ]] && ! tc-has-openmp && \
		die "You are using gcc but without OpenMP capabilities that you requested"
}

src_prepare() {
	use wxwidgets && need-wxwidgets unicode
	use hdf5 && has_version sci-libs/hdf5[mpi] && export CXX=mpicxx

	# make sure antlr includes are from system and rebuild the sources with it
	# https://sourceforge.net/tracker/?func=detail&atid=618685&aid=3465878&group_id=97659
	rm -r src/antlr || die
	einfo "Regenerating grammar"
	pushd src > /dev/null
	local i
	for i in *.g; do antlr ${i} || die ; done
	popd > /dev/null

	# gentoo: avoid install files in datadir directory
	# and manually install them in src_install
	sed -e '/AUTHORS/d' -i CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	# MPI is still very buggy
	# x11=off does not compile
	local mycmakeargs=(
		-DMPICH=OFF
		-DBUNDLED_ANTLR=OFF
		-DX11=ON
		-DEIGEN3="(usex eigen)"
		-DFFTW="(usex fftw)"
		-DGRIB="(usex grib)"
		-DGSHHS="(usex gshhs)"
		-DHDF="(usex hdf)"
		-DHDF5="(usex hdf5)"
		-DLIBPROJ4="(usex proj)"
		-DNETCDF="(usex netcdf)"
		-DOPENMP="(usex openmp)"
		-DPNGLIB="(usex png)"
		-DPSLIB="(usex postscript)"
		-DUDUNITS="(usex udunits)"
		-DWXWIDGETS="(usex wxwidgets)"
	)
	if use imagemagick; then
		if has_version media-gfx/graphicsmagick[cxx]; then
			mycmakeargs+=( -DGRAPHICSMAGICK=ON -DMAGICK=OFF )
		else
			mycmakeargs+=( -DGRAPHICSMAGICK=OFF -DMAGICK=ON )
		fi
	else
		mycmakeargs+=( -DGRAPHICSMAGICK=OFF -DMAGICK=OFF )
	fi
	configuration() {
		mycmakeargs+=( $@ )
		cmake-utils_src_configure
	}
	configuration -DPYTHON_MODULE=OFF -DPYTHON=OFF
	use python && python_foreach_impl configuration -DPYTHON_MODULE=ON -DPYTHON=ON
}

src_compile() {
	cmake-utils_src_compile
	use python && python_foreach_impl cmake-utils_src_make
}

src_test() {
	# there is check target instead of the ctest to define some LDPATH
	virtx emake -C "${BUILD_DIR}" check
}

src_install() {
	cmake-utils_src_install
	if use python; then
		installation() {
			mv src/libgdl.so GDL.so || die
			python_domodule GDL.so
		}
		python_foreach_impl run_in_build_dir installation
		dodoc PYTHON.txt
	fi
	#dodoc AUTHORS README
	echo "GDL_PATH=\"+${EROOT%/}/usr/share/gnudatalanguage\"" > 50gdl
	doenvd 50gdl
}
