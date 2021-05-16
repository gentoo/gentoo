# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Beautiful free fonts from exljbris Font Foundry"
HOMEPAGE="http://www.josbuivenga.demon.nl/"
SRC_URI="
	http://www.exljbris.com/dl/delicious-123.zip
	http://www.exljbris.com/dl/Diavlo_II_37b2.zip
	http://www.exljbris.com/dl/fontin2_pc.zip
	http://www.exljbris.com/dl/FontinSans_49.zip
	http://www.exljbris.com/dl/tallys_15b2.zip"

LICENSE="exljbris-free"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"

FONT_S="${S}"
FONT_SUFFIX="otf ttf"

src_prepare() {
	default
	mv Diavlo_II_37/*.otf . || die
}
