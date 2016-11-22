# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

DESCRIPTION="A client for the OpenStack Nova API"
HOMEPAGE="https://github.com/openstack-dev/hacking"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

RDEPEND="~dev-python/pep8-1.5.6[${PYTHON_USEDEP}]
		~dev-python/pyflakes-0.8.1[${PYTHON_USEDEP}]
		~dev-python/flake8-2.1.0[${PYTHON_USEDEP}]
		>=dev-python/six-1.6.0[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/pbr-0.8[${PYTHON_USEDEP}]
		<dev-python/pbr-1.0[${PYTHON_USEDEP}]
	test? ( >=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		>=dev-python/fixtures-0.3.14[${PYTHON_USEDEP}]
		>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-0.9.34[${PYTHON_USEDEP}]
		${RDEPEND} )
	doc? ( >=dev-python/sphinx-1.2.1[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/oslo-sphinx[${PYTHON_USEDEP}]' python2_7 ) )"
DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	# Prevent d'loading and correct ?typo to oslosphinx in conf.py
	sed -e 's:intersphinx_mapping:#&:' \
		-e 's:oslosphinx:oslo.sphinx:' \
		-i doc/source/conf.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && sphinx-build -b html -c doc/source/ doc/source/ doc/source/html
}

python_test() {
	testr init || die "testr init died"
	testr run || die "testsuite failed under ${EPYTHON}"
	flake8 "${PN}"/tests || die "flake8 drew error on a run over ${PN}/tests folder"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/source/html/. )
	distutils-r1_python_install_all
}
