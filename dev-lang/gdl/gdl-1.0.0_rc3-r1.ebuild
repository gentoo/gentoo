# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0-gtk3"
PYTHON_COMPAT=( python3_{7..9} )

# gdl's build system is a travesty, and actually calls
# itself in the testsuite, which is something that ninja
# obviously doesn't support.
CMAKE_MAKEFILE_GENERATOR=emake

inherit cmake python-r1 toolchain-funcs virtualx wxwidgets

DESCRIPTION="GNU Data Language"
HOMEPAGE="https://github.com/gnudatalanguage/gdl"
SRC_URI="https://github.com/gnudatalanguage/gdl/archive/v$(ver_cut 1-3)-rc.$(ver_cut 5).tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+eigen fftw glpk graphicsmagick gshhs hdf hdf5 +imagemagick netcdf
	openmp png proj postscript python tiff udunits wxwidgets"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-cpp/antlr-cpp:2=
	dev-libs/expat
	sci-libs/gsl:0=
	sci-libs/plplot:0=[X,cxx,-dynamic]
	sys-libs/ncurses:0=
	sys-libs/readline:0=
	sys-libs/zlib
	x11-libs/libX11
	fftw? ( sci-libs/fftw:3.0= )
	glpk? ( sci-mathematics/glpk:= )
	gshhs? (
		sci-geosciences/gshhs-data
		sci-geosciences/gshhs:0=
	)
	hdf? ( sci-libs/hdf:0= )
	hdf5? ( sci-libs/hdf5:0= )
	imagemagick? (
		!graphicsmagick? ( media-gfx/imagemagick:=[cxx] )
		graphicsmagick? ( media-gfx/graphicsmagick:=[cxx] )
	)
	netcdf? ( sci-libs/netcdf:= )
	proj? ( sci-libs/proj:= )
	postscript? ( dev-libs/pslib )
	python? (
		${PYTHON_DEPS}
		dev-python/numpy[${PYTHON_USEDEP}]
	)
	tiff? (
		media-libs/tiff
		sci-libs/libgeotiff
	)
	udunits? ( sci-libs/udunits )
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )"
DEPEND="${RDEPEND}
	eigen? ( dev-cpp/eigen:3 )"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
	python? ( app-admin/chrpath )"

S="${WORKDIR}/${PN}-$(ver_cut 1-3)-rc.$(ver_cut 5)"

PATCHES=( "${FILESDIR}"/${PN}-1.0.0_rc3-cmake.patch )

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	use wxwidgets && setup-wxwidgets unicode
	use hdf5 && has_version sci-libs/hdf5[mpi] && export CXX=mpicxx

	# remove bundled antlr
	rm -r src/antlr || die

	# gentoo: avoid install files in datadir directory
	# and manually install them in src_install
	sed -e '/AUTHORS/d' -i CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	# MPI is still very buggy
	# x11=off does not compile
	local mycmakeargs=(
		-DMPI=OFF
		-DREADLINE=ON
		-DX11=ON
		-DEXPAT=ON
		-DEIGEN3=$(usex eigen)
		-DFFTW=$(usex fftw)
		-DGRIB=OFF
		-DGLPK=$(usex glpk)
		-DHDF=$(usex hdf)
		-DHDF5=$(usex hdf5)
		-DLIBPROJ4=$(usex proj)
		-DNETCDF=$(usex netcdf)
		-DOPENMP=$(usex openmp)
		-DPNGLIB=$(usex png)
		-DUDUNITS2=$(usex udunits)
		-DWXWIDGETS=$(usex wxwidgets)
		-DGRAPHICSMAGICK=$(usex imagemagick $(usex graphicsmagick))
		-DMAGICK=$(usex imagemagick $(usex !graphicsmagick))
		-DTIFF=$(usex tiff)
		-DGEOTIFF=$(usex tiff)
		-DSHAPELIB=OFF
		-DPLPLOTDIR="${EPREFIX}"/usr/$(get_libdir)
	)

	configuration() {
		mycmakeargs+=( "$@" )
		cmake_src_configure
	}
	configuration -DPYTHON_MODULE=OFF -DPYTHON=OFF
	use python && python_foreach_impl configuration -DPYTHON_MODULE=ON -DPYTHON=ON
}

src_compile() {
	cmake_src_compile
	use python && python_foreach_impl cmake_src_compile
}

src_test() {
	# there is check target instead of the ctest to define some LDPATH
	virtx cmake_build check
}

src_install() {
	cmake_src_install
	if use python; then
		installation() {
			chrpath -d src/GDL.so || die
			python_domodule src/GDL.so
		}
		python_foreach_impl run_in_build_dir installation
		dodoc PYTHON.txt
	fi

	newenvd - 50gdl <<-_EOF_
		GDL_PATH="+${EPREFIX}/usr/share/gnudatalanguage"
	_EOF_
}
