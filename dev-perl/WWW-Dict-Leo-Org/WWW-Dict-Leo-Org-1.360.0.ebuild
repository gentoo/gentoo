# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/WWW-Dict-Leo-Org/WWW-Dict-Leo-Org-1.360.0.ebuild,v 1.1 2013/07/07 17:12:59 jlec Exp $

EAPI=5

MODULE_AUTHOR=TLINDEN
MODULE_VERSION=1.36
inherit perl-module

DESCRIPTION="Commandline interface to http://dict.leo.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/HTML-TableParser
	virtual/perl-DB_File"
DEPEND="${RDEPEND}"

src_install() {
	perl-module_src_install
	mv "${D}"/usr/bin/{l,L}eo || die
}

pkg_postinst() {
	elog "We renamed leo to Leo"
	elog "due to conflicts with app-editors/leo"
}
