# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
inherit cmake python-single-r1

DESCRIPTION="IlmBase Python bindings"
HOMEPAGE="https://www.openexr.com"
SRC_URI="https://github.com/AcademySoftwareFoundation/openexr/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/openexr-${PV}/PyIlmBase"

LICENSE="BSD"
SLOT="0/25"
KEYWORDS="amd64 ~x86"
IUSE="exceptions test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	${PYTHON_DEPS}
	~media-libs/openexr-${PV}:=
	sys-libs/zlib
	$(python_gen_cond_dep '
		>=dev-libs/boost-1.62.0-r1:=[python,${PYTHON_USEDEP}]
		>=dev-python/numpy-1.10.4[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-0001-disable-py2-for-boost.patch
	"${FILESDIR}"/${P}-0002-install-imathnumpy.so.patch
	"${FILESDIR}"/${P}-0003-fix-pkgconfig-file.patch
)

DOCS=( README.md )

src_configure() {
	local mycmakeargs=(
		# starting with boost-1.76.0 we ship the cmake config files
		-DBoost_NO_BOOST_CMAKE=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_Python2=ON
		-DPYILMBASE_INSTALL_PKG_CONFIG=ON
		-DPYIMATH_ENABLE_EXCEPTIONS=$(usex exceptions)
		-DPython3_EXECUTABLE="${PYTHON}"
		-DPython3_INCLUDE_DIR=$(python_get_includedir)
		-DPython3_LIBRARY=$(python_get_library_path)
	)
	cmake_src_configure
}
