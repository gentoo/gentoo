# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# Still appears to no support >=py3.3
PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="A more pythonic replacement for the unittest module and nose"
HOMEPAGE="https://github.com/Yelp/testify http://pypi.python.org/pypi/testify/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND} )"

python_prepare_all() {
	# Correct typo in setup.py
	sed -e 's:mock,:mock:' -i setup.py || die
	# Correct use of local importing in test_ file
	sed -e s':from .test_runner_subdir:from test.test_runner_subdir:' \
		-e s':from .test_runner_bucketing:from test.test_runner_bucketing:' \
		-i test/test_runner_test.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	PYTHONPATH="${PYTHONPATH}:${S}"
	for test in test/*_test.py;
	do
		"${PYTHON}" $test || die "test $test failed under ${EPYTHON}"
	done
}
