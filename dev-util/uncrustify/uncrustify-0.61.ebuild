# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit eutils

DESCRIPTION="C/C++/C#/D/Java/Pawn code indenter and beautifier"
HOMEPAGE="http://uncrustify.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~ppc-macos ~x64-macos ~x64-solaris ~x86-solaris"
IUSE="test"

DEPEND="test? ( =dev-lang/python-2* )"
RDEPEND=""

src_test() {
	cd tests
	python2 run_tests.py || die "tests failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"
}
