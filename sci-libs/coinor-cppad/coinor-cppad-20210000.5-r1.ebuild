# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="emake" # needed for tests
inherit cmake

DESCRIPTION="COIN-OR C++ Algorithmic Differentiation"
HOMEPAGE="https://projects.coin-or.org/CppAD/"
SRC_URI="https://github.com/coin-or/CppAD/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/CppAD-${PV}"

LICENSE="EPL-2.0"
SLOT="0/${PV}" # soname is bumped every versions
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="adolc doc eigen ipopt"

# adolc currently can't build tests and ipopt fails them.
RESTRICT="adolc? ( test ) ipopt? ( test )"

# No need for RDEPEND.
DEPEND="
	dev-libs/boost
	adolc? ( sci-libs/adolc )
	eigen? ( dev-cpp/eigen )
	ipopt? ( sci-libs/ipopt )"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen[dot]
		virtual/latex-base
	)"

PATCHES=( "${FILESDIR}"/${P}-pkgconfig.patch )

src_prepare() {
	cmake_src_prepare
	# Gentoo uses coin/ rather than coin-or/ for includes.
	sed -i 's/<coin-or/<coin/' \
		cppad_ipopt/src/cppad_ipopt_nlp.hpp \
		include/cppad/ipopt/solve_callback.hpp || die
}

src_configure() {
	local mycmakeargs=(
		-Dcmake_install_libdirs=$(get_libdir)
		-Dinclude_adolc=$(usex adolc)
		-Dinclude_cppadcg=no
		-Dinclude_eigen=$(usex eigen)
		-Dinclude_ipopt=$(usex ipopt)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	if use doc; then
		bin/doxyfile.sh ${PV} dox.log doc && doxygen doxyfile || die
	fi
}

src_test() {
	cmake_build check
}

src_install() {
	cmake_src_install
	use doc && dodoc -r doc/html

	# Remove superfluous .pc file.
	rm -r "${ED}"/usr/share/pkgconfig || die
}
