# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
MY_PN=msu_ru_nsh_clunits

DESCRIPTION="Russian voices for Festival"
HOMEPAGE="https://sourceforge.net/projects/festlang.berlios/"
SRC_URI="mirror://sourceforge/project/festlang.berlios/${MY_PN}-${PV}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=app-accessibility/festival-1.96_beta"
DEPEND=""

src_install() {
	dodoc "${MY_PN}/README" || die "Could not install README"
	rm "${MY_PN}/{README,COPYING}"

	insinto "/usr/share/festival/voices/russian/"
	doins -r "${MY_PN}/" || die "Could not install Russian Voices"
}

pkg_postinst() {
	elog
	elog "    To enable russian voices run festval and use command:"
	elog "        (voice_msu_ru_nsh_clunits)"
	elog
	elog "    Please note that text input should have UTF-8 encoding."
	elog
}
