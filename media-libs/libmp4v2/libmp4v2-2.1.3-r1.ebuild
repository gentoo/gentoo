# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=${P/lib}

inherit cmake

DESCRIPTION="Functions for accessing ISO-IEC:14496-1:2001 MPEG-4 standard"
HOMEPAGE="https://mp4v2.org/"
SRC_URI="https://github.com/enzo1982/mp4v2/releases/download/v${PV}/${MY_P}.tar.bz2"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="utils"
# Tests need DejaGnu but are non-existent (just an empty framework)
RESTRICT="test"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${PN}-2.0.0-unsigned-int-cast.patch"
	"${FILESDIR}/${P}-mem-leaks-1.patch"
	"${FILESDIR}/${P}-mem-leaks-2.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_UTILS=$(usex utils)
	)
	cmake_src_configure
}
