# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="eXtensible Data Model and Format"
HOMEPAGE="http://xdmf.org/index.php/Main_Page"
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

LICENSE="VTK"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

RESTRICT="!test? ( test )"

BDEPEND="
	doc? ( app-doc/doxygen )
"
RDEPEND="
	dev-libs/boost:=
	dev-libs/libxml2:2
	sci-libs/hdf5:=
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-module.patch
	"${FILESDIR}"/${P}-cannot-find-hdf5-bug-591302.patch
	"${FILESDIR}"/${P}-cmake-3.12.patch
)

src_prepare() {
	sed \
		-e "/DESTINATION/s:lib:$(get_libdir):g" \
		-e "/INSTALL/s:lib:$(get_libdir):g" \
		-i CMakeLists.txt core/CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=1
		-DXDMF_BUILD_DOCUMENTATION=$(usex doc)
		-DBUILD_TESTING=$(usex test)
		-DXDMF_WRAP_PYTHON=OFF
		-DXDMF_WRAP_JAVA=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	dosym XdmfConfig.cmake /usr/share/cmake/Modules/${PN}Config.cmake
}
