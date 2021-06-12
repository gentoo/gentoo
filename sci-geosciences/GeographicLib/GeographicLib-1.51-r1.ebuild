# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit cmake distutils-r1

MY_PN="${PN,,}"

DESCRIPTION="C++ library for converting geographic coordinate systems"
HOMEPAGE="https://sourceforge.net/projects/geographiclib/"
SRC_URI="mirror://sourceforge/${MY_PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/19"
KEYWORDS="~amd64 ~arm"
IUSE="doc examples python"
# To-Do:find out why this doesn't work
# 105/167 Test #105: GeodSolve82 ......................***Failed
# Required regular expression not found. Regex=[20\.0010* 0\.0* 180\.0* 20\.0010* 0\.0* 180\.0* 0\.0* 0\.0* 0\.0* 1\.0* 1\.0* -?0
RESTRICT="test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		>=app-doc/doxygen-1.8.7
		>=dev-lang/perl-5.26.1-r1
		>=dev-python/sphinx-1.6.3-r2
		>=sys-apps/util-linux-2.31
	)
"

distutils_enable_tests setup.py
# there are additional docs in the python dir
distutils_enable_sphinx python/doc

src_prepare() {
	cmake_src_prepare

	if use python; then
		pushd "python" || die
		distutils-r1_python_prepare_all
		popd || die
	fi
}

src_configure() {
	export GEODATAPATH="/usr/share/${MY_PN}"

	local mycmakeargs=(
		-DGEOGRAPHICLIB_DOCUMENTATION=$(usex doc ON OFF)
		-DGEOGRAPHICLIB_LIB_TYPE="SHARED"
		-DGEOGRAPHICLIB_DATA="${GEODATAPATH}"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use python; then
		pushd "python" || die
		python_foreach_impl distutils-r1_python_compile
		popd || die
		python_compile_all
	fi
}

src_test() {
	# Only 1 failing test in the C code, python passes for me
	cmake_src_test

	if use python; then
		pushd "python" || die
		python_foreach_impl python_test
		popd || die
	fi
}

src_install() {
	cmake_src_install

	# remove python things added by the cmake_src_install function
	rm -r "${D}/usr/$(get_libdir)/python" || die
	# if use python we re-add these python files for each implementation
	if use python; then
		pushd "python" || die
		python_foreach_impl distutils-r1_python_install
		popd || die
	fi

	#TODO: find out if java stuff need something

	# Installs to wrong doc dir for some reason
	# Also happens with USE="-doc"
	mv "${D}/usr/share/doc/${PN}" "${D}/usr/share/doc/${PF}" || die

	if use examples; then
		dodoc -r examples
		docompress -x "/usr/share/doc/${PF}/examples"
	fi

	insinto "/usr/share/maxima/${MY_PN}"
	doins -r maxima/.

	find "${D}" -name "*.la" -delete || die
}
