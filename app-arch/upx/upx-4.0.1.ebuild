# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Ultimate Packer for eXecutables (free version using UCL compression and not NRV)"
HOMEPAGE="https://upx.github.io/"
SRC_URI="https://github.com/upx/upx/releases/download/v${PV}/${P}-src.tar.xz"
S="${WORKDIR}/${P}-src"

LICENSE="GPL-2+ UPX-exception" # Read the exception before applying any patches
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc x86"

RDEPEND="!app-arch/upx-bin"
BDEPEND="app-arch/xz-utils[extra-filters]"

src_configure() {
	local mycmakeargs=(
		-DUPX_CONFIG_DISABLE_WERROR=ON
	)
	cmake_src_configure
}

src_test() {
	# Don't run tests in parallel, #878977
	cmake_src_test -j1
}
