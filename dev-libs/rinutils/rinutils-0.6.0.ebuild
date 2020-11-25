# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Set of C headers containing macros and static functions"
HOMEPAGE="https://www.shlomifish.org/open-source/projects/ https://github.com/shlomif/rinutils"
SRC_URI="https://github.com/shlomif/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

src_configure() {
	local mycmakeargs=(
		-DDISABLE_APPLYING_RPATH=OFF
		-DWITH_TEST_SUITE=OFF # tests require perl
	)

	cmake_src_configure
}
