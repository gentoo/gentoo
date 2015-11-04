# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

inherit distutils-r1

DESCRIPTION="Plugin for nose or py.test that automatically reruns flaky tests"
HOMEPAGE="https://pypi.python.org/pypi/flaky https://github.com/box/flaky"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/genty[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

# https://github.com/box/flaky/issues/72
RESTRICT=test

python_test() {
	nosetests --with-flaky --exclude="pytest|test_nose_options_example" test/ || die
	py.test -k 'example and not nose and not options' --doctest-modules test/·||·die
	py.test -p no:flaky test/test_flaky_pytest_plugin.py·||·die
	nosetests --with-flaky --force-flaky --max-runs 2 test/test_nose_options_example.py ·||·die
	py.test --force-flaky --max-runs 2  test/test_pytest_options_example.py ||·die
}
