# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="libmt32emu_${PV//./_}"
inherit cmake

DESCRIPTION="Library for emulating the Roland MT-32, CM-32L, CM-64 and LAPC-I"
HOMEPAGE="https://github.com/munt/munt"
SRC_URI="https://github.com/munt/munt/archive/${MY_P}.tar.gz"
S="${WORKDIR}/munt-${MY_P}/mt32emu"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-2.6.1-docs.patch
	"${FILESDIR}"/${P}-cmake4.patch # bug 951838
)

src_configure() {
	local libdir=${EPREFIX}/usr/$(get_libdir)

	local mycmakeargs=(
		-DLIB_INSTALL_DIR="${libdir}"
		-Dlibmt32emu_PKGCONFIG_INSTALL_PREFIX="${libdir}"
	)

	cmake_src_configure
}
