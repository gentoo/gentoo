# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/arss/arss-0.2.3.ebuild,v 1.2 2013/03/04 18:49:20 kensington Exp $

EAPI=5
CMAKE_IN_SOURCE_BUILD="true"
MY_P=${P}-src

inherit cmake-utils

DESCRIPTION="Analysis & Resynthesis Sound Spectrograph"
HOMEPAGE="http://arss.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sci-libs/fftw"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}/src

DOCS=( ../AUTHORS ../ChangeLog )
