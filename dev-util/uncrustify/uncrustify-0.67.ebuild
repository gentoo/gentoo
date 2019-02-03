# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ $PV == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
	KEYWORDS="~amd64 ~x86"
	SRC_URI=""
	scm_eclass=git-r3
else
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~ppc-macos ~x64-macos ~x64-solaris ~x86-solaris"
	SRC_URI="https://github.com/${PN}/${PN}/archive/${P}.tar.gz"
	S=${WORKDIR}/${PN}-${P}
fi

inherit cmake-utils ${scm_eclass}

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
