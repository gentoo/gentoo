# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Dictionary data for the Arab dictionary project duali"
HOMEPAGE="http://www.arabeyes.org/project.php?proj=Duali"
SRC_URI="mirror://sourceforge/arabeyes/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~sparc ~x86"
IUSE=""

DEPEND=">=app-text/duali-0.2.0-r1"
RDEPEND=""

src_compile() {
	dict2db --path ./ || die 'failed to compile databases'
}

src_install() {
	dodoc README

	insinto /usr/share/duali
	doins tableab tableac tablebc

	# The dict2db script (and the spellchecker itself) use the python
	# anydbm module, which means we kinda don't know what file suffix is
	# going to pop out in src_compile. The fact that app-text/duali
	# requires python[gdbm] means that we should at least get the gdbm
	# database format (e.g. stemsdb) if not stems.db.
	if [[ -e stems.db ]]; then
		doins stems.db prefixes.db suffixes.db
	else
		doins stemsdb prefixesdb suffixesdb
	fi
}
