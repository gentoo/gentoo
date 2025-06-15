# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_P="${PN}-v${PV}"
DESCRIPTION="Adaptive Entropy Coding library"
HOMEPAGE="https://gitlab.dkrz.de/k202009/libaec"
SRC_URI="https://gitlab.dkrz.de/k202009/libaec/-/archive/v${PV}/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD-2"
SLOT="0/2"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="+szip test"
RESTRICT="!test? ( test )"

RDEPEND="szip? ( !sci-libs/szip )"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DBUILD_STATIC_LIBS=OFF
		-DCMAKE_INSTALL_LIBDIR=$(get_libdir)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# avoid conflict with szip (easier than patching)
	if ! use szip; then
		rm "${ED}"/usr/include/szlib.h || die
		rm "${ED}"/usr/$(get_libdir)/libsz* || die
		rm "${ED}"/usr/share/doc/${PF}/README.SZIP || die
	fi
}
