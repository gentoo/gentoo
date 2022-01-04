# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib

DESCRIPTION="Low bit rate speech codec"
HOMEPAGE="https://freedv.org/ https://www.rowetel.com/?page_id=452 https://github.com/drowe67/codec2"
SRC_URI="https://github.com/drowe67/codec2/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/1.0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~sparc x86"
IUSE="examples test"
# Not yet passing, but infrastructure added to run
RESTRICT="test"

multilib_src_configure() {
	local mycmakeargs=(
		-DUNITTEST=$(usex test)
		-DINSTALL_EXAMPLES=$(usex examples)
	)
	cmake_src_configure
}
