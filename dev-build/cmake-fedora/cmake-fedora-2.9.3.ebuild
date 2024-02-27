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

# fails 1 of 7
RESTRICT="test"

src_prepare() {
	sed -i \
		-e '/GITIGNORE/d' \
		-e '/INSTALL.*COPYING$/,/)$/d' \
		"${S}"/CMakeLists.txt || die

	cmake_src_prepare
}
