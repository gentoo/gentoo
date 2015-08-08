# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ $PV == *9999* ]]; then
	EGIT_REPO_URI="git://github.com/bengardner/uncrustify.git
		https://github.com/bengardner/uncrustify.git"
	KEYWORDS=""
	SRC_URI=""
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~ppc-macos ~x64-macos ~x64-solaris ~x86-solaris"
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
fi

PYTHON_COMPAT=( python2_7 )

inherit python-any-r1

DESCRIPTION="C/C++/C#/D/Java/Pawn code indenter and beautifier"
HOMEPAGE="http://uncrustify.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE="test"

DEPEND="test? ( ${PYTHON_DEPS} )"

python_test() {
	cd tests
	${EPYTHON} run_tests.py || die "tests failed"
}
