# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="2.8"
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils eutils python-r1 wxwidgets toolchain-funcs virtualx

DESCRIPTION="GNU Data Language"
HOMEPAGE="http://gnudatalanguage.sourceforge.net/"
SRC_URI="mirror://sourceforge/gnudatalanguage/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+eigen fftw grib gshhs hdf hdf5 imagemagick netcdf openmp
	proj postscript	python static-libs udunits wxwidgets"

RDEPEND="
	sci-libs/gsl:0=
	sci-libs/plplot:0=[-dynamic]
	sys-libs/ncurses:5=
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
	wxwidgets? ( x11-libs/wxGTK:2.8[X,-odbc] )"

DEPEND="${RDEPEND}
	>=dev-java/antlr-2.7.7-r5:0[cxx,java,script]
	virtual/pkgconfig
	eigen? ( dev-cpp/eigen:3 )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	"${FILESDIR}"/0.9.2-antlr.patch
	"${FILESDIR}"/0.9.2-include.patch
	"${FILESDIR}"/0.9.2-proj4.patch
	"${FILESDIR}"/0.9.2-semaphore.patch
	"${FILESDIR}"/0.9.3-plwidth.patch
	"${FILESDIR}"/0.9.4-gsl.patch
	"${FILESDIR}"/0.9.4-python.patch
	"${FILESDIR}"/0.9.4-reorder.patch
	"${FILESDIR}"/0.9.4-plplot.patch
	"${FILESDIR}"/0.9.4-python2.patch
)

pkg_setup() {
	use openmp && [[ $(tc-getCXX)$ == *g++* ]] && ! tc-has-openmp && \
		die "You have openmp enabled but your current g++ does not support it"
}

src_prepare() {
	cmake-utils_src_prepare

	use hdf5 && has_version sci-libs/hdf5[mpi] && export CXX=mpicxx

	# make sure antlr includes are from system and rebuild the sources with it
	# https://sourceforge.net/tracker/?func=detail&atid=618685&aid=3465878&group_id=97659
	rm -r src/antlr || die
	einfo "Regenerating grammar"
	pushd src > /dev/null
	local i
	for i in *.g; do antlr ${i} || die ; done
	popd > /dev/null

	# gentoo: use proj instead of libproj4 (libproj4 last update: 2004)
	sed -i \
		-e 's:proj4:proj:' \
		-e 's:lib_proj\.h:proj_api\.h:g' \
		CMakeModules/FindLibproj4.cmake src/math_utl.hpp || die

	# gentoo: avoid install files in datadir directory
	sed -i \
		-e '/AUTHORS/d' \
		CMakeLists.txt || die
}

src_configure() {
	# MPI is still very buggy
	# x11=off does not compile
	local mycmakeargs=(
		-DMPICH=OFF
		-DBUNDLED_ANTLR=OFF
		-DX11=ON
		$(cmake-utils_use fftw)
		$(cmake-utils_use eigen EIGEN3)
		$(cmake-utils_use grib)
		$(cmake-utils_use gshhs)
		$(cmake-utils_use hdf)
		$(cmake-utils_use hdf5)
		$(cmake-utils_use netcdf)
		$(cmake-utils_use openmp)
		$(cmake-utils_use proj LIBPROJ4)
		$(cmake-utils_use postscript PSLIB)
		$(cmake-utils_use udunits)
		$(cmake-utils_use wxwidgets)
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
	Xemake -C "${BUILD_DIR}" check
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

	echo "GDL_PATH=\"+${EROOT%/}/usr/share/gnudatalanguage\"" > 50gdl
	doenvd 50gdl
}
