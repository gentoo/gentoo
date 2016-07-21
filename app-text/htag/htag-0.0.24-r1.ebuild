# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-module

DESCRIPTION="random signature maker"
HOMEPAGE="http://www.earth.li/projectpurple/progs/htag.html"
SRC_URI="http://www.earth.li/projectpurple/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ppc ~sparc x86"
IUSE=""

src_install() {
	newbin htag.pl htag
	# establish "${D}"usr/share/doc/${PF}, mv 2 folders in 1 line
	perl-module_src_install
	mv ./{example-scripts,docs/sample-config/} "${ED}"usr/share/doc/${PF}/ || die
	dodoc docs/{MACRO_DESCRIPTION,README}

	insinto /usr/share/htag/plugins
	doins plugins/*

	insinto "${VENDOR_LIB}"
	doins HtagPlugin/HtagPlugin.pm
}
