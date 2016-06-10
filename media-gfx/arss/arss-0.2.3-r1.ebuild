# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
CMAKE_IN_SOURCE_BUILD="true"
MY_P=${P}-src

inherit cmake-utils

DESCRIPTION="Analysis & Resynthesis Sound Spectrograph"
HOMEPAGE="http://arss.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sci-libs/fftw:3.0="
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}/src

DOCS=( ../AUTHORS ../ChangeLog )
