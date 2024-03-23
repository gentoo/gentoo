# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

FORTRAN_NEEDED=fortran
FORTRAN_STANDARD="77 90"

inherit fortran-2 python-single-r1 scons-utils toolchain-funcs

DESCRIPTION="Object-oriented tool suite for chemical kinetics, thermodynamics, and transport"
HOMEPAGE="https://www.cantera.org"
SRC_URI="https://github.com/Cantera/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="fortran hdf5 lapack +python test"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

RDEPEND="
	${PYTHON_DEPS}
	dev-cpp/yaml-cpp
	hdf5? ( sci-libs/HighFive )
	!lapack? ( sci-libs/sundials:0= )
	lapack? (
		>=sci-libs/sundials-6.5.0:0=[lapack?]
		virtual/lapack
	)
	python? (
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/ruamel-yaml[${PYTHON_USEDEP}]
		')
	)
"

DEPEND="
	${RDEPEND}
	dev-cpp/eigen:3
	dev-libs/boost:=
	dev-libs/libfmt
	python? (
		$(python_gen_cond_dep '
			dev-python/cython[${PYTHON_USEDEP}]
			dev-python/pip[${PYTHON_USEDEP}]
		')
	)
	test? (
		>=dev-cpp/gtest-1.11.0
		python? (
			$(python_gen_cond_dep '
				dev-python/h5py[${PYTHON_USEDEP}]
				dev-python/pandas[${PYTHON_USEDEP}]
				dev-python/pytest[${PYTHON_USEDEP}]
				dev-python/scipy[${PYTHON_USEDEP}]
			')
		)
	)
"

PATCHES=(
	"${FILESDIR}/${P}_env.patch"
	"${FILESDIR}/${P}_enable_python-3.12.patch"
)

pkg_setup() {
	fortran-2_pkg_setup
	python-single-r1_pkg_setup
}

## Full list of configuration options of Cantera is presented here:
## http://cantera.org/docs/sphinx/html/compiling/config-options.html
src_configure() {
	scons_vars=(
		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		cc_flags="${CXXFLAGS}"
		cxx_flags="-std=c++17"
		debug="no"
		FORTRAN="$(tc-getFC)"
		FORTRANFLAGS="${FCFLAGS}"
		optimize_flags="-Wno-inline"
		renamed_shared_libraries="no"
		use_pch="no"
		## In some cases other order can break the detection of right location of Boost: ##
		system_fmt="y"
		system_sundials="y"
		system_eigen="y"
		system_yamlcpp="y"
		hdf_support=$(usex hdf5 y n)
		system_blas_lapack=$(usex lapack y n)
		env_vars="all"
		extra_inc_dirs="/usr/include/eigen3"
		use_rpath_linkage="yes"
		extra_lib_dirs="/usr/$(get_libdir)/${PN}"
	)
	use hdf5 && scons_vars+=( system_highfive="y" )
	use lapack && scons_vars+=( blas_lapack_libs="lapack,blas" )
	use test || scons_vars+=( googletest="none" )

	scons_targets=(
		f90_interface=$(usex fortran y n)
	)

	if use python ; then
		scons_targets+=( python_package="full" python_cmd="${EPYTHON}" )
	else
		scons_targets+=( python_package="none" )
	fi
}

src_compile() {
	escons build "${scons_vars[@]}" "${scons_targets[@]}" prefix="/usr"
}

src_test() {
	escons test
}

src_install() {
	escons install stage_dir="${D}" libdirname="$(get_libdir)"
	if ! use python ; then
		rm -r "${D}/usr/share/man" || die "Can't remove man files."
	else
		# Run the byte-compile of modules
		python_optimize "${D}$(python_get_sitedir)/${PN}"
	fi

	# User could remove this line if require static libs for development purpose
	find "${ED}" -name '*.a' -delete || die
}

pkg_postinst() {
	local post_msg=$(usex fortran "and Fortran " "")
	elog "C++ ${post_msg}samples are installed to '/usr/share/${PN}/samples/' directory."
}
