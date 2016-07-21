# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Calamaris parses the logfiles of a wide variety of Web proxy servers and generates reports"
HOMEPAGE="http://cord.de/calamaris-home-page"
SRC_URI="http://cord.de/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"

RDEPEND="
	dev-lang/perl
	dev-perl/GDGraph
"

src_prepare() {
	sed -i \
		-e "s:\(use lib\).*$:\1 '/usr/share/';:" \
		calamaris || die
}

src_install() {
	dobin calamaris calamaris-cache-convert

	insinto /usr/share/${PN}
	doins *.pm

	doman calamaris.1

	dodoc BUGS CHANGES EXAMPLES EXAMPLES.v3 README TODO calamaris.conf
}
