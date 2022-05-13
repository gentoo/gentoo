# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv x86"
SRC_URI="https://github.com/martinus/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Fast & memory efficient hashtable based on robin hood hashing for C++11/14/17/20"
HOMEPAGE="https://github.com/martinus/robin-hood-hashing"

LICENSE="MIT"
SLOT="0"

src_configure() {
	local mycmakeargs=(
		-DRH_STANDALONE_PROJECT=OFF
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/share/"
	)
	cmake_src_configure
}
