# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="Beautiful free fonts from exljbris Font Foundry"
HOMEPAGE="https://www.exljbris.com/"
SRC_URI="
	https://www.exljbris.com/dl/DELICIOUS_21_OTF.zip
	https://www.exljbris.com/dl/Diavlo_II_37b2.zip
	https://www.exljbris.com/dl/fontin2_pc.zip
	https://www.exljbris.com/dl/FontinSans_49.zip
	https://www.exljbris.com/dl/tallys_15b2.zip"

LICENSE="exljbris-free"
SLOT="0"
KEYWORDS="~amd64 ~loong ~riscv ~x86"
RESTRICT="mirror"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"

FONT_S="${S}"
FONT_SUFFIX="otf ttf"

src_prepare() {
	default
	mv DELICIOUS_21_OTF/*.otf . || die
	mv Diavlo_II_37/*.otf . || die
}
