# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Advanced SAT solver with C++ and command-line interfaces"
HOMEPAGE="https://github.com/msoos/cryptominisat/"
SRC_URI="https://github.com/msoos/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2 MIT"
RESTRICT="test"  # tests require many convoluted bundled (git) modules

RDEPEND="
	dev-libs/boost:=
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}"

src_configure() {
	local -a mycmakeargs=(
		-DNOBREAKID=ON
		-DNOM4RI=ON
		-DENABLE_TESTING=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	dodir /usr/share/man
	mv "${ED}"/usr/man "${ED}"/usr/share/man || die
}
