# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

MY_PV="${PV//./_}"
MY_P=${PN}_${MY_PV}

DESCRIPTION="Graphical viewer for chromatogram files"
HOMEPAGE="http://www.geospiza.com/finchtv/"
SRC_URI="http://www.geospiza.com/finchtv/download/programs/linux/${MY_P}.tar.gz"

LICENSE="finchtv"
SLOT="0"
KEYWORDS="~amd64 x86 ~amd64-linux ~x86-linux"

S="${WORKDIR}/${MY_P}"

QA_PREBUILT="opt/bin/*"

src_install() {
	exeinto /opt/bin
	doexe finchtv

	dodoc ReleaseNotes.txt

	docinto examples
	dodoc -r SampleData/.
	docompress -x /usr/share/doc/${PF}/examples

	docinto html
	dodoc -r Help/.

	newicon Help/media/FinchTV_Mac_App.png ${PN}.png
}
