# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Cute PHP Library (cphplib)"
HOMEPAGE="http://cphplib.sourceforge.net/"
SRC_URI="mirror://sourceforge/cphplib/${P}.tar.bz2"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc"

DEPEND=">=dev-php/PEAR-DB-1.7.6-r1"
RDEPEND="${DEPEND}"
PATCHES=( "${FILESDIR}/constructor.patch" )

src_install() {
	local DOCS=( ChangeLog README TODO )
	local -a HTML_DOCS
	insinto "/usr/share/php/${PN}"
	doins -r i18n cphplib_formular.inc  cphplib.inc
	use doc && HTML_DOCS=( doc/packages.html doc/blank.html
		doc/classtrees_cphplib.html doc/index.html doc/cphplib/
		doc/errors.html doc/__filesource/ doc/elementindex.html
		doc/li_cphplib.html doc/elementindex_cphplib.html doc/media/ )
	einstalldocs
}
