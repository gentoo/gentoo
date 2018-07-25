# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Finnish diphones and text to speech script for festival"
HOMEPAGE="http://www.ling.helsinki.fi/suopuhe"
SRC_URI="http://www.ling.helsinki.fi/suopuhe/download/hy_fi_mv_diphone-${PV}.tgz
	http://phon.joensuu.fi/suopuhe/tulosaineisto/suo_fi_lj-1.0g-20051204.tgz
	http://www.ling.helsinki.fi/suopuhe/download/lavennin-${PV}.tgz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="perl"

RDEPEND="
	>=app-accessibility/festival-1.96_beta
	dev-lang/perl"
DEPEND=""

S=${WORKDIR}
PATCHES=( "${FILESDIR}"/${P}_lavennin_path.patch )

src_install() {
	dodoc festival/lib/voices/finnish/hy_fi_mv_diphone/README.mv
	rm festival/lib/voices/finnish/hy_fi_mv_diphone/{README.mv,LICENSE} || die

	insinto /usr/share/festival
	doins -r festival/lib/voices
	cd "${WORKDIR}"/lavennin/ || die
	newdoc README.txt README.lavennin
	dodoc man/*.shtml

	if use perl; then
		newbin bin/lavennin suopuhe-lavennin

		insinto /usr/share/suopuhe
		doins -r data

		elog "TTS perl script installed as suopuhe-lavennin"
	fi
}
