# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="A set of programs for dealing with numbers from the command line"
SRC_URI="http://suso.suso.org/programs/num-utils/downloads/${P}.tar.gz"
HOMEPAGE="http://suso.suso.org/programs/num-utils/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=""
RDEPEND="
	dev-lang/perl
	!<sci-chemistry/gromacs-4"

src_compile() {
	emake || die
}

src_install () {
	make ROOT="${D}" install || die
	dodoc CHANGELOG GOALS MANIFEST README VERSION WARNING
}
