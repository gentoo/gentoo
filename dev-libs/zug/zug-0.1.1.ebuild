# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Transducers for C++"
HOMEPAGE="https://sinusoid.es/zug/"
SRC_URI="https://github.com/arximboldi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Boost-1.0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""
#RESTRICT="!test? ( test )"
SLOT=0

RDEPEND="
"
DEPEND="${RDEPEND}"
BDEPEND="
"

src_configure() {

	local mycmakeargs=(
		-Dzug_BUILD_DOCS=OFF
		-Dzug_BUILD_EXAMPLES=OFF
		-Dzug_BUILD_TESTS=OFF
	)

	cmake_src_configure
}
