# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="A compact general purpose allocator with excellent performance"
HOMEPAGE="https://github.com/microsoft/mimalloc"
SRC_URI="https://github.com/microsoft/mimalloc/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/2"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~m68k ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="hardened test valgrind"
RESTRICT="!test? ( test )"

DEPEND="valgrind? ( dev-debug/valgrind )"

src_configure() {
	local mycmakeargs=(
		-DMI_SECURE=$(usex hardened)
		-DMI_INSTALL_TOPLEVEL=ON
		-DMI_BUILD_TESTS=$(usex test)
		-DMI_BUILD_OBJECT=OFF
		-DMI_BUILD_STATIC=OFF
		-DMI_TRACK_VALGRIND=$(usex valgrind)
		-DMI_LIBC_MUSL=$(usex elibc_musl)
	)

	cmake-multilib_src_configure
}
