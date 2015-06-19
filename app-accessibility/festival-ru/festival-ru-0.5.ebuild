# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/festival-ru/festival-ru-0.5.ebuild,v 1.2 2014/08/06 06:24:38 patrick Exp $

EAPI="2"
MY_PN=msu_ru_nsh_clunits

DESCRIPTION="Russian voices for Festival"
HOMEPAGE="http://festlang.berlios.de/russian.html"
SRC_URI="mirror://berlios/festlang/${MY_PN}-${PV}.tar.bz2"

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
