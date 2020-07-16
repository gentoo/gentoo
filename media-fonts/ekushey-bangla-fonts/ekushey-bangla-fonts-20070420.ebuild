# Copyright 1999-2019 Gentoo Authors
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
SRC_URI="mirror://sourceforge/ekushey/${P_LOHIT}.ttf
	mirror://sourceforge/ekushey/${P_MOHUA}.ttf
	mirror://sourceforge/ekushey/${P_AZAD}.ttf
	mirror://sourceforge/ekushey/${P_PUJA}.ttf
	mirror://sourceforge/ekushey/${P_DURGA}.ttf
	mirror://sourceforge/ekushey/${P_SARASWATII}.ttf
	mirror://sourceforge/ekushey/${P_SHARIFA}.ttf
	mirror://sourceforge/ekushey/${P_SUMIT}.ttf
	mirror://sourceforge/ekushey/${P_PUNARBHABA}.ttf
	mirror://sourceforge/ekushey/${P_SOLAIMANLIPI}.ttf
	mirror://sourceforge/ekushey/${P_RUPALI}.ttf"

LICENSE="GPL-2+ OFL"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

FONT_SUFFIX="ttf"

src_unpack() {
	local f
	mkdir "${S}" || die
	for f in ${A}; do
		cp "${DISTDIR}/${f}" "${S}/${f%%[_-]*}.ttf"
	done
}
