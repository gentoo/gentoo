# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CMAKE_IN_SOURCE_BUILD="true"
MY_P="${P}-src"

inherit cmake

DESCRIPTION="Analysis & Resynthesis Sound Spectrograph"
HOMEPAGE="http://arss.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="sci-libs/fftw:3.0="
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/src"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

DOCS=( ../AUTHORS ../ChangeLog )
