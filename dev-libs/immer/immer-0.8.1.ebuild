# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A library of persistent and immutable data structures written in C++"
HOMEPAGE="https://sinusoid.es/immer/"
SRC_URI="https://github.com/arximboldi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Boost-1.0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""
#RESTRICT="!test? ( test )"
SLOT=0

RDEPEND="
dev-libs/boost
"
DEPEND="${RDEPEND}"
BDEPEND="
"

src_configure() {

	local mycmakeargs=(
		-Dimmer_BUILD_DOCS=OFF
		-Dimmer_BUILD_EXAMPLES=OFF
		-Dimmer_BUILD_EXTRAS=OFF
		-Dimmer_BUILD_TESTS=OFF
	)

	cmake_src_configure
}
