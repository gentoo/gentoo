# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Provides cmake helper macros and targets for linux, especially fedora developers"
HOMEPAGE="https://pagure.io/cmake-fedora"
SRC_URI="https://pagure.io/cmake-fedora/archive/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

PATCHES=( "${FILESDIR}/${P}-no-release.patch" )

# FIXME: Test running in the build directory, while it want a file in source directory.
RESTRICT="test"

src_prepare() {
	sed -i \
		-e '/GITIGNORE/d' \
		-e '/INSTALL.*COPYING$/,/)$/d' \
		"${S}"/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_FEDORA_ENABLE_FEDORA_BUILD=0
		-DMANAGE_DEPENDENCY_PACKAGE_EXISTS_CMD=true
	)
	cmake_src_configure
}
