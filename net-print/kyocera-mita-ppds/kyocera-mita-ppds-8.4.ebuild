# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/kyocera-mita-ppds/kyocera-mita-ppds-8.4.ebuild,v 1.1 2011/01/26 12:43:18 flameeyes Exp $

DESCRIPTION="PPD description files for (some) Kyocera Mita Printers"
HOMEPAGE="http://www.kyoceramita.it/"
SRC_URI="Linux_PPDs_KSL${PV/\./_}.zip"

LICENSE="kyocera-mita-ppds"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE_LINGUAS="en fr de it pt es"

IUSE=""
for lingua in $IUSE_LINGUAS; do
	IUSE="${IUSE} linguas_$lingua"
done

RDEPEND="net-print/cups"
DEPEND="app-arch/unzip"

S="${WORKDIR}/PPD's_KSL_${PV}"

RESTRICT="fetch"

pkg_nofetch() {
	einfo "Please download ${A} from the following URL:"
	einfo "http://www.kyoceramita.it/index/Service_Departement__/Richiesta_di_Supporto_Tecnico/download_center.false.driver.FS1020D._.IT.html"
	einfo ""
	einfo "The FS-1020D driver from the Italian website provides PPDs for a"
	einfo "number of printers in six languages."
}

src_compile() { :; }

src_install() {
	insinto /usr/share/cups/model/KyoceraMita

	local installall=yes
	for lingua in $IUSE_LINGUAS; do
		if use linguas_$lingua; then
			installall=no
			break;
		fi
	done

	inslanguage() {
		if [[ ${installall} == yes ]] || use linguas_$1; then
			doins $2/*.ppd || die "failed to install $2 ppds"
		fi
	}

	inslanguage en English
	inslanguage fr French
	inslanguage de German
	inslanguage it Italian
	inslanguage pt Portuguese
	inslanguage es Spanish

	dohtml ReadMe.htm || die
}
