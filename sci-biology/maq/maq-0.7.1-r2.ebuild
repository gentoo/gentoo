# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Mapping and Assembly with Qualities, mapping NGS reads to reference genomes"
HOMEPAGE="http://maq.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.bz2
	mirror://sourceforge/${PN}/calib-36.dat.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-flags.patch
	"${FILESDIR}"/${P}-bfr-overfl.patch
	"${FILESDIR}"/${P}-gcc-4.7.patch
	"${FILESDIR}"/${P}-remove-64bit-flag.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	insinto /usr/share/${PN}
	doins "${WORKDIR}"/*.dat

	doman maq.1
	dodoc ${PN}.pdf
}
