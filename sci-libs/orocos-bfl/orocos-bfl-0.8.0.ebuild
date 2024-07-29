# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Bayesian Filtering Library"
HOMEPAGE="https://orocos.org/bfl"
SRC_URI="https://people.mech.kuleuven.be/~tdelaet/bfl_tar/${P}-src.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/boost:="
DEPEND="${RDEPEND}
	test? ( dev-util/cppunit )"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/doxygen
		virtual/latex-base
	)"

src_prepare() {
	cmake_src_prepare

	sed -e 's:/lib:/${CMAKE_INSTALL_LIBDIR}:' \
		-i {,src/,src/bindings/rtt/}CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DLIBRARY_TYPE=shared
		# installs test binaries
		-DBUILD_EXAMPLES=NO
		-DBUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc ; then
		cd "${BUILD_DIR}" || die
		doxygen || die
		cd "${S}/docs" || die
		pdflatex getting_started_guide || die
		pdflatex getting_started_guide || die

		HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )
	fi
}

src_test() {
	cmake_build check
}

src_install() {
	cmake_src_install
	use doc && dodoc docs/getting_started_guide.pdf
}
