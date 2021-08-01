# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit cmake python-single-r1

MY_PN="${PN^}"

DESCRIPTION="Imath basic math package"
HOMEPAGE="https://imath.readthedocs.io"
SRC_URI="https://github.com/AcademySoftwareFoundation/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
# re-keywording needed for (according to ilmbase keywords):
# ~mips ~x64-macos ~x86-solaris
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD"
SLOT="3/29"
IUSE="doc large-stack python static-libs test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

# blocker due to file collision #803347
RDEPEND="
	!dev-libs/imath:0
	sys-libs/zlib
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-libs/boost:=[python,${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
		')
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( $(python_gen_cond_dep 'dev-python/breathe[${PYTHON_USEDEP}]') )
	python? ( ${PYTHON_DEPS} )
"

PATCHES=( "${FILESDIR}"/${P}-0001-changes-needed-for-proper-slotting.patch )
DOCS=( CHANGES.md CONTRIBUTORS.md README.md SECURITY.md docs/PortingGuide2-3.md )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local majorver=$(ver_cut 1)

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DIMATH_ENABLE_LARGE_STACK=$(usex large-stack)
		-DIMATH_HALF_USE_LOOKUP_TABLE=ON
		-DIMATH_INSTALL_PKG_CONFIG=ON
		-DIMATH_OUTPUT_SUBDIR="${MY_PN}-${majorver}"
		-DIMATH_USE_CLANG_TIDY=OFF
		-DIMATH_USE_NOEXCEPT=ON
	)
	if use python; then
		mycmakeargs+=(
			# temp. disable for finding libboost_python310, #803032
			#-DBoost_NO_BOOST_CMAKE=OFF
			-DPYTHON=ON
			-DPython3_EXECUTABLE="${PYTHON}"
			-DPython3_INCLUDE_DIR=$(python_get_includedir)
			-DPython3_LIBRARY=$(python_get_library_path)
		)
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		pushd "${S}"/docs 2>/dev/null || die
		doxygen || die
		emake html
		popd 2>/dev/null || die
	fi
}

src_install() {
	use doc && HTML_DOCS=( "${S}/docs/_build/html/." )
	cmake_src_install
}
