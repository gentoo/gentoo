# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

IUSE=""

DESCRIPTION="Dictionary data for the Arab dictionary project duali"
HOMEPAGE="http://www.arabeyes.org/project.php?proj=Duali"
SRC_URI="mirror://sourceforge/arabeyes/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64 ia64 ppc ~sparc alpha ~hppa ~mips"

DEPEND="app-text/duali"

src_compile() {
	dict2db --path ./ || die
}

src_install() {
	insinto /usr/share/duali
	if [[ -e stems.db ]]; then
		doins stems.db prefixes.db suffixes.db || die
	else
		doins stemsdb prefixesdb suffixesdb || die
	fi
	doins tableab tableac tablebc || die
	dodoc README
}
