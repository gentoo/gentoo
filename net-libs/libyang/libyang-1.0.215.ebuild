# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib

DESCRIPTION="YANG data modeling language library"
HOMEPAGE="https://github.com/CESNET/libyang"
SRC_URI="https://github.com/CESNET/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="doc test"

RDEPEND="dev-libs/libpcre[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	doc? ( app-doc/doxygen[dot] )
"

RESTRICT="!test? ( test )"

multilib_src_configure() {
	local mycmakeargs=(
		-DENABLE_BUILD_TESTS=$(usex test)
		-DENABLE_LYD_PRIV=yes
		-DGEN_LANGUAGE_BINDINGS=no
	)
	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile

	multilib_is_native_abi && use doc && cmake_src_compile doc
}

multilib_src_install_all() {
	use doc && dodoc -r "${S}"/doc/*
}
