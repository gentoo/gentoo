# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Common styles for fluxbox, blackbox, and openbox"
HOMEPAGE="http://mkeadle.org/distfiles/"
SRC_URI="mirror://gentoo/${P}.tar.bz2
		http://mkeadle.org/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="|| ( x11-wm/fluxbox x11-wm/blackbox x11-wm/openbox )"

src_install() {

	insinto /usr/share/commonbox/backgrounds
	doins "${S}"/backgrounds/*

	insinto /usr/share/commonbox/styles
	doins "${S}"/styles/*

	dodoc README.commonbox-styles STYLES.authors

}
