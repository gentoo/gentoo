# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Provides settings to X11 applications via the XSETTINGS specification"
HOMEPAGE="https://github.com/derat/xsettingsd"
SRC_URI="https://github.com/derat/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )
"
BDEPEND=">=dev-util/cmake-3.15"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		$(cmake_use_find_package test GTest)
	)
	cmake_src_configure
}
