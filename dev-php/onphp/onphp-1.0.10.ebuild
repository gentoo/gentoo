# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="onPHP is the LGPL'ed multi-purpose object-oriented PHP framework"
HOMEPAGE="http://onphp.org/"
SRC_URI="http://onphp.org/download/${P}.tar.bz2
		doc? ( http://onphp.org/download/${PN}-api-${PV}.tar.bz2 )"
LICENSE="LGPL-2"
SLOT="0"
IUSE="doc"

DEPEND=""
RDEPEND="dev-lang/php"

src_install() {
	dodoc `find doc -maxdepth 1 -type f -print`

	if use doc ; then
		dohtml -r "${WORKDIR}/${PN}-api-${PV}/"*
	fi

	insinto "/usr/share/php/${PN}"
	doins global.inc.php.tpl
	doins -r core main meta
}
