# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ engine for simulating rigid bodies in 2D games"
HOMEPAGE="https://box2d.org/"
SRC_URI="https://github.com/erincatto/box2d/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="doc"

BDEPEND="doc? ( app-text/doxygen media-gfx/graphviz )"

src_configure() {
	local mycmakeargs=(
		# would fetch dougbinks/enkiTS from the network in the sandbox, and
		# unit tests need a static build anyway (they poke internal symbols)
		-DBOX2D_SAMPLES=OFF
		-DBOX2D_BENCHMARKS=OFF
		-DBOX2D_UNIT_TESTS=OFF
		-DBOX2D_DOCS=$(usex doc)
	)
	cmake_src_configure
}
