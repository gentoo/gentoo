# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# The upstream tag is v2.3.3-1 instead of v2.3.3
suffix="-1"

DESCRIPTION="Library for parsing mathematical expressions"
HOMEPAGE="https://beltoforion.de/en/muparser/"
SRC_URI="https://github.com/beltoforion/muparser/archive/refs/tags/v${PV}${suffix}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/muparser-${PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc openmp test"
RESTRICT="!test? ( test )"

S="${S}${suffix}"

PATCHES=(
)

src_configure() {
	mycmakeargs=(
		-DENABLE_OPENMP=$(usex openmp)
	)
	cmake_src_configure
}

src_test() {
	cmake_src_compile test
}

src_install() {
	cmake_src_install
}
