# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils

DESCRIPTION="Bayesian Filtering Library"
HOMEPAGE="http://orocos.org/bfl"
SRC_URI="http://people.mech.kuleuven.be/~tdelaet/bfl_tar/${P}-src.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE="doc examples static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/boost:="
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		virtual/latex-base
	)
	test? ( dev-util/cppunit )"

src_prepare() {
	cmake-utils_src_prepare

	sed -e 's:/lib:/${CMAKE_INSTALL_LIBDIR}:' \
		-i "${S}/"{,src/,src/bindings/rtt/}CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		"-DLIBRARY_TYPE=$(usex static-libs both shared)"
		"-DBUILD_EXAMPLES=$(usex examples ON OFF)"
		"-DBUILD_TESTS=$(usex test ON OFF)"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc ; then
		cd "${BUILD_DIR}"
		doxygen || die
		cd "${S}/docs" || die
		pdflatex getting_started_guide || die
		pdflatex getting_started_guide || die
	fi
}

src_test() {
	cd "${BUILD_DIR}"
	emake check
}

src_install() {
	cmake-utils_src_install
	if use doc ; then
		dohtml -r "${BUILD_DIR}/doc/html/"
		dodoc "${S}/docs/getting_started_guide.pdf"
	fi
}
