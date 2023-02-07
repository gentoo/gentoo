# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="The ANTLR 4 C++ Runtime"
HOMEPAGE="https://www.antlr.org/"
SRC_URI="https://www.antlr.org/download/antlr4-cpp-runtime-${PV}-source.zip -> ${P}.zip"
S="${WORKDIR}"

LICENSE="BSD"
SLOT="4"
KEYWORDS="amd64 ~arm ppc x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/gtest )"
BDEPEND="app-arch/unzip"

PATCHES=( "${FILESDIR}"/${PV}-GNUInstallDirs.patch )

src_configure() {
	local mycmakeargs=(
		-DANTLR_BUILD_CPP_TESTS=$(usex test)
	)
	cmake_src_configure
}
