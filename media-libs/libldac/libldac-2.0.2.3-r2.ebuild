# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="LDAC codec library from AOSP"
HOMEPAGE="https://android.googlesource.com/platform/external/libldac/"
SRC_URI="https://github.com/EHfive/ldacBT/releases/download/v${PV}/ldacBT-${PV}.tar.gz"
S="${WORKDIR}/ldacBT"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"

PATCHES=( "${FILESDIR}/${P}-cmake4.patch" ) # bug 951991

multilib_src_configure() {
	local mycmakeargs=(
		-DLDAC_SOFT_FLOAT=OFF
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
	)

	cmake_src_configure
}
