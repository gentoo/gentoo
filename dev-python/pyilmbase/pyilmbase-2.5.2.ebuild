# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# boost is lacking py39 support as of 20200605
PYTHON_COMPAT=( python3_{6,7,8} )
CMAKE_ECLASS=cmake
inherit cmake-multilib python-r1

DESCRIPTION="IlmBase Python bindings"
HOMEPAGE="https://www.openexr.com"
SRC_URI="https://github.com/AcademySoftwareFoundation/openexr/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/25"
KEYWORDS="~amd64 ~x86"
IUSE="exceptions +numpy test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/boost-1.62.0-r1:=[python,${MULTILIB_USEDEP},${PYTHON_USEDEP}]
	~media-libs/ilmbase-${PV}:=[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	numpy? ( >=dev-python/numpy-1.10.4[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/openexr-${PV}/PyIlmBase"

PATCHES=(
	"${FILESDIR}/${P}-0001-Fix-pkgconfig-file-for-PyIlmBase-to-include-prefixes.patch"
)

DOCS=( README.md )

multilib_src_prepare() {
	cmake_src_prepare
	multilib_copy_sources
}

multilib_src_configure() {
	python_configure() {
		local mycmakeargs=(
			-DCMAKE_DISABLE_FIND_PACKAGE_Python2=ON
			-DPYILMBASE_INSTALL_PKG_CONFIG=ON
			-DPYIMATH_ENABLE_EXCEPTIONS=$(usex exceptions)
			-DPython3_EXECUTABLE="${PYTHON}"
			-DPython3_INCLUDE_DIR=$(python_get_includedir)
			-DPython3_LIBRARY=$(python_get_library_path)
		)
		cmake_src_configure
	}
	python_foreach_impl python_configure
}

multilib_src_compile() {
	python_foreach_impl cmake_src_compile
}

multilib_src_install() {
	python_install() {
		cmake_src_install
		if use numpy; then
			python_domodule "${BUILD_DIR}/${EPYTHON/./_}/imathnumpy.so"
			chmod +x "${D}/$(python_get_sitedir)/imathnumpy.so" || die
		fi
	}
	python_foreach_impl python_install
}

multilib_src_test() {
	python_foreach_impl cmake_src_test
}
