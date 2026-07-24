# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Provides settings to X11 applications via the XSETTINGS specification"
HOMEPAGE="https://codeberg.org/derat/xsettingsd"
SRC_URI="https://codeberg.org/derat/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXfixes
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		$(cmake_use_find_package test GTest)
	)
	cmake_src_configure
}
