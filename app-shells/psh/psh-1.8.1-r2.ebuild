# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-module

DESCRIPTION="Combines the interactive nature of a Unix shell with the power of Perl"
HOMEPAGE="http://www.focusresearch.com/gregor/sw/psh/"
SRC_URI="http://www.focusresearch.com/gregor/download/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
# Package warrants USE doc & examples
IUSE="readline"

RDEPEND="
	readline? (
		dev-perl/Term-ReadLine-Gnu
		dev-perl/TermReadKey
	)
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

SRC_TEST="do parallel"
myinst="SITEPREFIX=${D}/usr"

PATCHES=(
	"${FILESDIR}/${P}-defined-array.patch"
)

src_install() {
	perl-module_src_install
	dodoc examples/complete-examples doc/*
}
