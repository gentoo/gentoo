# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/exljbris-free/exljbris-free-20100320.ebuild,v 1.4 2011/06/14 10:53:11 pva Exp $

inherit font

DESCRIPTION="Beautiful free fonts from exljbris Font Foundry"
HOMEPAGE="http://www.josbuivenga.demon.nl/"
SRC_URI="http://www.exljbris.com/dl/delicious-123.zip
	http://www.exljbris.com/dl/Diavlo_II_37b2.zip
	http://www.exljbris.com/dl/fontin2_pc.zip
	http://www.exljbris.com/dl/FontinSans_49.zip
	http://www.exljbris.com/dl/tallys_15b2.zip"

LICENSE="exljbris-free"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="otf ttf"

src_unpack() {
	unpack ${A}
	cd "${S}"

	mv "${S}"/Diavlo_II_37/*.otf "${S}"
}
