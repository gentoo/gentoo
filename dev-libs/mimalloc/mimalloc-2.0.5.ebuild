# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="mimalloc is a compact general purpose allocator with excellent performance"
HOMEPAGE="https://github.com/microsoft/mimalloc"
SRC_URI="https://github.com/microsoft/mimalloc/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/2"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=(
		# TODO: build hardened variant?
		#-DMI_SECURE=$(usex hardened)

		-DMI_INSTALL_TOPLEVEL=ON
		-DMI_BUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	rm "${ED}/usr/$(get_libdir)/mimalloc.o" || die

	find "${ED}" -name '*.a' -delete || die
}
