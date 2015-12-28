# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-module

DESCRIPTION="Combines the interactive nature of a Unix shell with the power of Perl"
HOMEPAGE="http://www.focusresearch.com/gregor/sw/psh/"
SRC_URI="http://www.focusresearch.com/gregor/download/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ppc x86"
# Package warrants USE doc & examples
IUSE="readline"

DEPEND="<dev-lang/perl-5.22.0"
RDEPEND="<dev-lang/perl-5.22.0
	readline? (
	dev-perl/Term-ReadLine-Gnu
	dev-perl/TermReadKey )"

SRC_TEST="do parallel"
myinst="SITEPREFIX=${D}/usr"

src_install() {
	perl-module_src_install
	dodoc examples/complete-examples doc/*
}
