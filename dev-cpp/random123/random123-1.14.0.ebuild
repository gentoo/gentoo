# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="library of counter-based random number generators (CBRNGs)"
HOMEPAGE="https://www.deshawresearch.com/resources_random123.html"
SRC_URI="https://github.com/DEShawResearch/random123/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_configure() {
	tc-export CC CXX
}

src_install() {
	insinto /usr/include/Random123
	doins -r include/Random123
}
