# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

FORTRAN_NEEDED=fortran
FORTRAN_STANDARD="77 90"

inherit desktop fortran-2 python-single-r1 scons-utils toolchain-funcs

DESCRIPTION="Object-oriented tool suite for chemical kinetics, thermodynamics, and transport"
HOMEPAGE="https://www.cantera.org"
SRC_URI="https://github.com/Cantera/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+cti fortran pch +python test"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	python? ( cti )
	${PYTHON_REQUIRED_USE}
"

RDEPEND="
	${PYTHON_DEPS}
	python? (
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_MULTI_USEDEP}]
			dev-python/ruamel-yaml[${PYTHON_MULTI_USEDEP}]
		')
	)
	dev-cpp/yaml-cpp
	<sci-libs/sundials-5.3.0:0=
"

DEPEND="
	${RDEPEND}
	dev-cpp/eigen:3
	dev-libs/boost
	dev-libs/libfmt
	python? (
		$(python_gen_cond_dep '
			dev-python/cython[${PYTHON_MULTI_USEDEP}]
		')
	)
	test? (
		>=dev-cpp/gtest-1.8.0
		python? (
			$(python_gen_cond_dep '
				dev-python/h5py[${PYTHON_MULTI_USEDEP}]
				dev-python/pandas[${PYTHON_MULTI_USEDEP}]
			')
		)
	)
"

PATCHES=( "${FILESDIR}/${PN}-2.5.0_env.patch" )

pkg_setup() {
	fortran-2_pkg_setup
	python-single-r1_pkg_setup
}

## Full list of configuration options of Cantera is presented here:
## http://cantera.org/docs/sphinx/html/compiling/config-options.html
src_configure() {
	scons_vars=(
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		cc_flags="${CXXFLAGS}"
		cxx_flags="-std=c++11"
		debug="no"
		FORTRAN="$(tc-getFC)"
		FORTRANFLAGS="${FCFLAGS}"
		optimize_flags="-Wno-inline"
		renamed_shared_libraries="no"
		use_pch=$(usex pch)
		## In some cases other order can break the detection of right location of Boost: ##
		system_fmt="y"
		system_sundials="y"
		system_eigen="y"
		system_yamlcpp="y"
		env_vars="all"
		extra_inc_dirs="/usr/include/eigen3"
	)
	use test || scons_vars+=( googletest="none" )

	scons_targets=(
		f90_interface=$(usex fortran y n)
	)

	if use cti ; then
		local scons_python=$(usex python full minimal)
		scons_targets+=( python_package="${scons_python}" python_cmd="${EPYTHON}" )
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
	escons install stage_dir="${D}" libdirname="$(get_libdir)" python_prefix="$(python_get_sitedir)"
	if ! use cti ; then
		rm -r "${D}/usr/share/man" || die "Can't remove man files."
	else
		# Run the byte-compile of modules
		python_optimize "${D}/$(python_get_sitedir)/${PN}"
	fi

	# We install static libs unconditionally here
	# See https://github.com/gentoo/gentoo/pull/10017#discussion_r229210565
}

pkg_postinst() {
	if use cti && ! use python ; then
		elog "Cantera was build without 'python' use-flag therefore the CTI tools 'ck2cti' and 'ck2yaml"
		elog "will convert Chemkin files to Cantera format without verification of kinetic mechanism."
	fi

	local post_msg=$(usex fortran "and Fortran " "")
	elog "C++ ${post_msg}samples are installed to '/usr/share/${PN}/samples/' directory."

	if use python ; then
		elog "Python examples are installed to '$(python_get_sitedir)/${PN}/examples/' directories."
	fi
}
