# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="package to manage versions by scm tags via setuptools"
HOMEPAGE="https://github.com/pypa/setuptools_scm https://pypi.python.org/pypi/setuptools_scm"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}]
		dev-vcs/git
		dev-vcs/mercurial )"

python_test() {
	py.test -v -v -x || die "tests failed under ${EPYTHON}"
}
