# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

P_LOHIT="Lohit_14-04-2007"
P_MOHUA="Mohua_07-09-05"
P_AZAD="Godhuli_03-09-2005"
P_PUJA="Puja-17-06-2006"
P_DURGA="Durga_03-09-2005"
P_SARASWATII="Saraswatii_03-09-2005"
P_SHARIFA="Sharifa_03-09-2005"
P_SUMIT="Sumit_03-09-2005"
P_PUNARBHABA="Punarbhaba_27-02-2006"
P_SOLAIMANLIPI="SolaimanLipi_20-04-07"
P_RUPALI="Rupali_01-02-2007"

DESCRIPTION="A collection of Free fonts for the Bangla (Bengali) script"
HOMEPAGE="http://ekushey.org/index.php/page/otf_bangla_fonts"
SRC_URI="https://downloads.sourceforge.net/ekushey/${P_LOHIT}.ttf
	https://downloads.sourceforge.net/ekushey/${P_MOHUA}.ttf
	https://downloads.sourceforge.net/ekushey/${P_AZAD}.ttf
	https://downloads.sourceforge.net/ekushey/${P_PUJA}.ttf
	https://downloads.sourceforge.net/ekushey/${P_DURGA}.ttf
	https://downloads.sourceforge.net/ekushey/${P_SARASWATII}.ttf
	https://downloads.sourceforge.net/ekushey/${P_SHARIFA}.ttf
	https://downloads.sourceforge.net/ekushey/${P_SUMIT}.ttf
	https://downloads.sourceforge.net/ekushey/${P_PUNARBHABA}.ttf
	https://downloads.sourceforge.net/ekushey/${P_SOLAIMANLIPI}.ttf
	https://downloads.sourceforge.net/ekushey/${P_RUPALI}.ttf"

LICENSE="GPL-2+ OFL-1.0"
SLOT="0"
KEYWORDS="amd64 ~loong ~riscv x86"
IUSE=""

FONT_SUFFIX="ttf"

src_unpack() {
	local f
	mkdir "${S}" || die
	for f in ${A}; do
		cp "${DISTDIR}/${f}" "${S}/${f%%[_-]*}.ttf"
	done
}
