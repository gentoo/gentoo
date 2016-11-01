# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="py.test plugin to capture log messages"
HOMEPAGE="https://bitbucket.org/memedough/pytest-capturelog/overview"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="test"

RDEPEND="dev-python/py[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

# Not included
# https://bitbucket.org/memedough/pytest-capturelog/issues/5
RESTRICT=test

python_test() {
	PYTEST_PLUGINS=${PN/-/_} py.test -v -v test_capturelog.py || die
}
