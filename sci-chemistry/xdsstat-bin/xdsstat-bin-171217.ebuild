# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/-bin}"

DESCRIPTION="Prints various statistics (that are not available from XDS itself)"
HOMEPAGE="https://strucbio.biologie.uni-konstanz.de/xdswiki/index.php/XDSSTAT"
SRC_URI="
	amd64? ( ftp://turn5.biologie.uni-konstanz.de/pub/${MY_PN}-linux64.bz2 )
	x86? ( ftp://turn5.biologie.uni-konstanz.de/pub/${MY_PN}-linux32.bz2 )
"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"
IUSE=""

RDEPEND="sci-chemistry/xds-bin"
DEPEND=""

RESTRICT="mirror"

QA_PREBUILT="opt/bin/*"

S="${WORKDIR}"

src_install() {
	exeinto /opt/bin
	newexe ${MY_PN}* ${MY_PN}
}
