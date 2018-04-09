# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Codec for encoding data on paper"
HOMEPAGE="https://github.com/colindean/optar"
SRC_URI="https://github.com/colindean/${PN}/archive/${PV}-colindean.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+pgm2ps"

S="${WORKDIR}/${P}-colindean"

DEPEND="media-libs/libpng:*"
RDEPEND="${DEPEND}
	pgm2ps? ( media-gfx/imagemagick )"

src_install() {
	dobin optar unoptar
	if use pgm2ps ; then
		dobin pgm2ps
	fi
	einstalldocs
}
