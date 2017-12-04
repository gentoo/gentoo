# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="${P}-Source"
inherit cmake-utils

DESCRIPTION="Provides cmake helper macros and targets for linux, especially fedora developers"
HOMEPAGE="https://pagure.io/cmake-fedora"
SRC_URI="https://releases.pagure.org/cmake-fedora/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_P}
CMAKE_IN_SOURCE_BUILD=1

# fails 1 of 7
RESTRICT="test"

PATCHES=( "${FILESDIR}/${P}-no-release.patch" )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_FEDORA_ENABLE_FEDORA_BUILD=0
		-DMANAGE_DEPENDENCY_PACKAGE_EXISTS_CMD=true
	)
	cmake-utils_src_configure
}
