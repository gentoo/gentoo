# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="A more pythonic replacement for the unittest module and nose"
HOMEPAGE="https://github.com/Yelp/testify https://pypi.org/project/testify/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]
	>=dev-python/six-1.7.3[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND} )"

python_prepare_all() {
	# Correct typo in setup.py
	sed -e 's:mock,:mock:' -i setup.py || die

	# Correct use of local importing in pertinent test_ files
	sed -e s':from .test:from test:' \
		-i test/test_runner_test.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	einfo; einfo "Output reporting exceptions \"ImportError: No module named <module>\""
	einfo "are instances of exceptions expected to be raised, similar to xfails by nose"; einfo""
	for test in test/test_*_test.py;
	do
		"${PYTHON}" $test || die "test $test failed under ${EPYTHON}"
	done
}
