# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A mock object framework for Python, loosely based on EasyMock for Java"
HOMEPAGE="https://pypi.org/project/mox/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ~ppc64 ~s390 ~sh ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

python_test() {
	${PYTHON} mox_test.py || die
}
