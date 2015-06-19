# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/festival-fi/festival-fi-20041119.ebuild,v 1.5 2012/10/19 19:15:29 ago Exp $

EAPI="2"
inherit eutils

DESCRIPTION="Finnish diphones and text to speech script for festival"
HOMEPAGE="http://www.ling.helsinki.fi/suopuhe"
SRC_URI="http://www.ling.helsinki.fi/suopuhe/download/hy_fi_mv_diphone-${PV}.tgz
	http://phon.joensuu.fi/suopuhe/tulosaineisto/suo_fi_lj-1.0g-20051204.tgz
	http://www.ling.helsinki.fi/suopuhe/download/lavennin-${PV}.tgz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="perl"

RDEPEND=">=app-accessibility/festival-1.96_beta"
DEPEND=""

src_prepare(){
	cd "${WORKDIR}/lavennin/bin"
	epatch "${FILESDIR}/${P}_lavennin_path.patch"
}

src_install() {
	cd "${WORKDIR}"
	dodoc festival/lib/voices/finnish/hy_fi_mv_diphone/README.mv
	rm festival/lib/voices/finnish/hy_fi_mv_diphone/{README.mv,LICENSE}
	insinto /usr/share/festival/
	cd festival/lib/
	doins -r voices/
	cd "${WORKDIR}/lavennin/"
	newdoc README.txt README.lavennin
	dodoc man/*.shtml

	if use perl; then

		newbin bin/lavennin suopuhe-lavennin
		dodir /usr/share/suopuhe/data/
		insinto /usr/share/suopuhe
		doins -r data

		elog "TTS perl script installed as suopuhe-lavennin"
	fi
}
