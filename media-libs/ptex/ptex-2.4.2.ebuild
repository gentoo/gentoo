# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Per-Face Texture Mapping for Production Rendering"
HOMEPAGE="https://ptex.us/"
SRC_URI="https://github.com/wdas/ptex/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="static-libs"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"
BDEPEND="app-doc/doxygen"

RESTRICT="test"

src_prepare() {
	# https://github.com/wdas/ptex/issues/41
	cat <<-EOF > version || die
	v${PV}
	EOF
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}/html"
		-DPTEX_BUILD_STATIC_LIBS=$(usex static-libs)
	)
	cmake_src_configure
}
