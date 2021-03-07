# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="PPD description files for (some) Kyocera Mita Printers"
HOMEPAGE="http://www.kyoceramita.it/"
SRC_URI="Linux_PPDs_KSL${PV/\./_}.zip"

LICENSE="kyocera-mita-ppds"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="l10n_de +l10n_en l10n_es l10n_fr l10n_it l10n_pt"
REQUIRED_USE="|| ( l10n_de l10n_en l10n_es l10n_fr l10n_it l10n_pt )"
RESTRICT="fetch bindist"

RDEPEND="net-print/cups"
DEPEND="app-arch/unzip"

S="${WORKDIR}/PPD's_KSL_${PV}"

pkg_nofetch() {
	einfo "Please download ${A} from the following URL:"
	einfo "http://www.kyoceramita.it/index/Service_Departement__/Richiesta_di_Supporto_Tecnico/download_center.false.driver.FS1020D._.IT.html"
	einfo ""
	einfo "The FS-1020D driver from the Italian website provides PPDs for a"
	einfo "number of printers in six languages."
}

src_install() {
	insinto /usr/share/cups/model/KyoceraMita

	inslanguage() {
		if use l10n_$1; then
			doins $2/*.ppd
		fi
	}

	inslanguage en English
	inslanguage fr French
	inslanguage de German
	inslanguage it Italian
	inslanguage pt Portuguese
	inslanguage es Spanish

	docinto html
	dodoc ReadMe.htm
}
