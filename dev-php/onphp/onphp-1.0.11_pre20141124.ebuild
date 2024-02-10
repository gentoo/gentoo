# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vcs-snapshot

KEYWORDS="~amd64 ~x86"

DESCRIPTION="onPHP is the LGPL'ed multi-purpose object-oriented PHP framework"
HOMEPAGE="https://github.com/onPHP/onphp-framework/"
SRC_URI="https://github.com/onPHP/onphp-framework/archive/706ddd5a2a33bd65a13c4e3ec8c46c5ce700133c.tar.gz -> ${P}.tar.gz
	doc? ( http://onphp.org/download/${PN}-api-1.0.10.tar.bz2 )
"
LICENSE="LGPL-2"
SLOT="0"
IUSE="doc"

DEPEND=""
RDEPEND="dev-lang/php:*"

src_install() {
	rm doc/LICENSE || die
	dodoc $(find doc -maxdepth 1 -type f -print)
	if use doc ; then
		local HTML_DOCS=( "${WORKDIR}/${PN}-api-1.0.10/" )
		einstalldocs
	fi
	insinto "/usr/share/php/${PN}"
	doins global.inc.php.tpl
	doins -r core main meta
}
