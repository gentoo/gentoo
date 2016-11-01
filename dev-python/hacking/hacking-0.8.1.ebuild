# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A client for the OpenStack Nova API"
HOMEPAGE="https://github.com/openstack-dev/hacking"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/pbr-0.5.21[${PYTHON_USEDEP}]
		<dev-python/pbr-1.0[${PYTHON_USEDEP}]
		test? ( >=dev-python/coverage-3.6[${PYTHON_USEDEP}]
			>=dev-python/fixtures-0.3.14[${PYTHON_USEDEP}]
			dev-python/subunit[${PYTHON_USEDEP}]
			>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
			>=dev-python/testrepository-0.0.17-r2[${PYTHON_USEDEP}]
			>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
			>=dev-python/testtools-0.9.32[${PYTHON_USEDEP}]
			${RDEPEND} )"
RDEPEND="~dev-python/pep8-1.4.5[${PYTHON_USEDEP}]
		>=dev-python/pyflakes-0.7.2[${PYTHON_USEDEP}]
		<dev-python/pyflakes-0.7.4[${PYTHON_USEDEP}]
		~dev-python/flake8-2.0[${PYTHON_USEDEP}]
		>=dev-python/six-1.4.1[${PYTHON_USEDEP}]"
DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	sed -e 's:intersphinx_mapping:#&:' -i doc/source/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && sphinx-build -b html -c doc/source/ doc/source/ doc/source/html
}

python_test() {
	# https://bugs.launchpad.net/hacking/+bug/1265520
	# Although fixed in trunk, the fix is a version change in pep8
	# which cannot be simply dropped in here.
	if python_is_python3; then
		sed -e 's:test_pep8:_&:' -i hacking/tests/test_doctest.py || die
	fi
	testr init || die "testr init died"
	testr run || die "testsuite failed under ${EPYTHON}"
	flake8 "${PN}"/tests || die "flake8 drew error on a run over ${PN}/tests folder"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/source/html/. )
	distutils-r1_python_install_all
}
