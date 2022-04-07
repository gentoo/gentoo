# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_ECLASS=cmake
inherit cmake-multilib

DESCRIPTION="OpenEXR ILM Base libraries"
HOMEPAGE="https://www.openexr.com/"
SRC_URI="https://github.com/AcademySoftwareFoundation/openexr/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/openexr-${PV}/IlmBase"

LICENSE="BSD"
SLOT="0/25" # based on SONAME
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE="large-stack static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="!media-libs/openexr:3"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( README.md )

src_prepare() {
	if use abi_x86_32 && use test; then
		eapply "${FILESDIR}"/${PN}-2.5.4-0001-disable-failing-test-on-x86_32.patch
	fi

	multilib_foreach_abi cmake_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DILMBASE_BUILD_BOTH_STATIC_SHARED=$(usex static-libs)
		-DILMBASE_ENABLE_LARGE_STACK=$(usex large-stack)
		-DILMBASE_INSTALL_PKG_CONFIG=ON
	)

	cmake_src_configure
}
