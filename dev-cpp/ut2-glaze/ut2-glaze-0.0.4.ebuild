# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# it's a header-only lib, thus not cmake-multilib. However, examples and tests...
inherit cmake

DESCRIPTION="A stripped down fork of boost-ext ut2"
HOMEPAGE="https://github.com/openalgz/ut"
SRC_URI="https://github.com/openalgz/ut/archive/refs/tags/v${PV}.tar.gz -> ut2-openalgz-${PV}.tar.gz"

S="${WORKDIR}/ut-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test doc"
RESTRICT="!test? ( test )"

BDEPEND="dev-build/cmake"

# Build patches from Arniiiii, https://github.com/gentoo-mirror/ex_repo
PATCHES=(
	"${FILESDIR}/${P}-optional-test.patch"
	"${FILESDIR}/${P}-project-name.patch"
	"${FILESDIR}/${P}-fix-installing.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_INSTALL_RULES=OFF
		-DBUILD_TESTING=$(usex test ON OFF)
	)
	cmake_src_configure
}

src_install() {
	if use doc; then
		einstalldocs
	fi

	cmake_src_install
}
