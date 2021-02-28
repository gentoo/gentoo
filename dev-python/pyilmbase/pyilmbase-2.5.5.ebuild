# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit cmake python-single-r1

DESCRIPTION="IlmBase Python bindings"
HOMEPAGE="https://www.openexr.com"
SRC_URI="https://github.com/AcademySoftwareFoundation/openexr/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/25"
KEYWORDS="amd64 ~x86"
IUSE="exceptions +numpy test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	${PYTHON_DEPS}
	~media-libs/ilmbase-${PV}:=
	sys-libs/zlib
	$(python_gen_cond_dep '
		>=dev-libs/boost-1.62.0-r1:=[python,${PYTHON_MULTI_USEDEP}]
		numpy? ( >=dev-python/numpy-1.10.4[${PYTHON_MULTI_USEDEP}] )
	')
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-admin/chrpath
	virtual/pkgconfig
"

S="${WORKDIR}/openexr-${PV}/PyIlmBase"

PATCHES=(
	"${FILESDIR}"/${PN}-2.5.2-0001-Fix-pkgconfig-file-for-PyIlmBase-to-include-prefixes.patch
)

DOCS=( README.md )

src_configure() {
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

src_install() {
	cmake_src_install
	if use numpy; then
		python_domodule "${BUILD_DIR}/${EPYTHON/./_}/imathnumpy.so"
		chmod +x "${D}/$(python_get_sitedir)/imathnumpy.so" || die
		chrpath -d "${D}/$(python_get_sitedir)/imathnumpy.so" || die
	fi
}
