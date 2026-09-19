# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="A compact general purpose allocator with excellent performance"
HOMEPAGE="https://github.com/microsoft/mimalloc"
SRC_URI="https://github.com/microsoft/mimalloc/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/3"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~m68k ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="debug test"
RESTRICT="!test? ( test )"

src_configure() {
	# hardened + valgrind could be restored w/ multibuild.eclass. They
	# install renamed libraries which break reverse dependencies.
	local mycmakeargs=(
		-DMI_DEBUG_FULL=$(usex debug)
		-DMI_SECURE=OFF
		-DMI_INSTALL_TOPLEVEL=ON
		-DMI_BUILD_TESTS=$(usex test)
		-DMI_BUILD_OBJECT=OFF
		-DMI_BUILD_STATIC=OFF
		-DMI_TRACK_VALGRIND=OFF
		-DMI_LIBC_MUSL=$(usex elibc_musl)
		# Don't inject -march=XXX
		-DMI_OPT_ARCH=OFF
	)

	cmake-multilib_src_configure
}
