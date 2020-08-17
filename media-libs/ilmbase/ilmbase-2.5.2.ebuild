# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib flag-o-matic

DESCRIPTION="OpenEXR ILM Base libraries"
HOMEPAGE="http://openexr.com/"
SRC_URI="https://github.com/AcademySoftwareFoundation/openexr/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/25" # based on SONAME
KEYWORDS="amd64 -arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE="large-stack static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/openexr-${PV}/IlmBase"

MULTILIB_WRAPPED_HEADERS=( /usr/include/OpenEXR/IlmBaseConfigInternal.h )

PATCHES=( "${FILESDIR}"/${P}-musl.patch )

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DILMBASE_BUILD_BOTH_STATIC_SHARED=$(usex static-libs)
		-DILMBASE_ENABLE_LARGE_STACK=$(usex large-stack)
		-DILMBASE_INSTALL_PKG_CONFIG=ON
	)

	# Disable use of ucontext.h wrt #482890
	if use hppa || use ppc || use ppc64; then
		mycmakeargs+=(
			-DILMBASE_HAVE_UCONTEXT_H=OFF
		)
	fi

	# needed for running tests with x86_32
	# see https://github.com/AcademySoftwareFoundation/openexr/issues/346
	if use abi_x86_32 && use test; then
		append-cppflags -ffloat-store
	fi

	cmake_src_configure
}
