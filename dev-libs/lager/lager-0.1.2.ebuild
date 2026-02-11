# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Library to assist value-oriented design"
HOMEPAGE="https://sinusoid.es/lager/"
SRC_URI="https://github.com/arximboldi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	dev-libs/zug
	dev-libs/immer
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCCACHE=no
		-Dlager_BUILD_DEBUGGER_EXAMPLES=OFF
		-Dlager_BUILD_DOCS=OFF # Check if docs are more complete on version bumps
		-Dlager_BUILD_EXAMPLES=OFF
		-Dlager_BUILD_FAILURE_TESTS=OFF
		-Dlager_BUILD_TESTS=OFF # Requires Qt5, same in git master as of 2026-02-11
	)
	cmake_src_configure
}
