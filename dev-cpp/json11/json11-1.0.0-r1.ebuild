# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake edo

DESCRIPTION="A tiny JSON library for C++11"
HOMEPAGE="https://github.com/dropbox/json11"
SRC_URI="https://github.com/dropbox/json11/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${P}-fix-multiarch-install.patch
	"${FILESDIR}"/${PN}-1.0.0-json11.pc-do-not-state-the-defaults.patch
	"${FILESDIR}"/${PN}-1.0.0-include-cstdint.patch
)

src_configure() {
	local mycmakeargs=(
		-DJSON11_BUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}

src_test() {
	cmake_src_test

	edo "${BUILD_DIR}"/json11_test
}
