# Copyright 1999-2018 Gentoo Foundation
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
