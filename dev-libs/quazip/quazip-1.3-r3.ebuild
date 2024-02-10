# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake multibuild

DESCRIPTION="Simple C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
HOMEPAGE="https://stachenov.github.io/quazip/"
SRC_URI="https://github.com/stachenov/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
# SONAME of libquazip1-qt5.so, check QUAZIP_LIB_SOVERSION in CMakeLists.txt
SLOT="0/1.3"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ppc ppc64 ~riscv x86 ~amd64-linux ~x86-linux"
IUSE="+qt5 qt6 test"
REQUIRED_USE="|| ( qt5 qt6 )"

RESTRICT="!test? ( test )"

COMMON_DEPEND="
	qt5? ( dev-qt/qtcore:5 )
	qt6? (
		dev-qt/qtbase:6
		dev-qt/qt5compat:6
	)
	sys-libs/zlib[minizip]
"
DEPEND="${COMMON_DEPEND}
	test? (
		qt5? (
			dev-qt/qtnetwork:5
			dev-qt/qttest:5
		)
		qt6? (
			dev-qt/qtbase:6[network]
		)
	)
"
RDEPEND="${COMMON_DEPEND}
	!=dev-libs/quazip-1.1-r0:1
"

PATCHES=( "${FILESDIR}/${P}-cmake.patch" )

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt5) $(usev qt6) )
}

src_configure() {
	my_src_configure() {
		local mycmakeargs=(
			-DBUILD_TESTING=$(usex test)
		)
		if [[ ${MULTIBUILD_VARIANT} = qt5 ]]; then
			mycmakeargs+=(
				-DQUAZIP_QT_MAJOR_VERSION=5
			)
		elif [[ ${MULTIBUILD_VARIANT} = qt6 ]]; then
			mycmakeargs+=(
				-DQUAZIP_QT_MAJOR_VERSION=6
			)
		fi
		cmake_src_configure
	}

	multibuild_foreach_variant my_src_configure
}

src_compile() {
	my_src_compile() {
		cmake_src_compile
		use test && cmake_build qztest
	}

	multibuild_foreach_variant my_src_compile
}

src_test() {
	multibuild_foreach_variant cmake_src_test
}

src_install() {
	multibuild_foreach_variant cmake_src_install
}
