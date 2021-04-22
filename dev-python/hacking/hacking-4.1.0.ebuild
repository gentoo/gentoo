# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="A client for the OpenStack Nova API"
HOMEPAGE="https://github.com/openstack/hacking/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~s390 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/flake8-3.8.0[${PYTHON_USEDEP}]
	<dev-python/flake8-3.9.0[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/coverage-4.5[${PYTHON_USEDEP}]
		>=dev-python/ddt-1.2.1[${PYTHON_USEDEP}]
		>=dev-python/eventlet-0.20.2[${PYTHON_USEDEP}]
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/subunit-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/stestr-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
		${RDEPEND}
	)
	doc? (
		>=dev-python/sphinx-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/openstackdocstheme-2.2.1[${PYTHON_USEDEP}]
		>=dev-python/reno-3.1.0[${PYTHON_USEDEP}]
	)"
DISTUTILS_IN_SOURCE_BUILD=1

python_compile_all() {
	use doc && sphinx-build -b html -c doc/source/ doc/source/ doc/source/html
}

python_test() {
	stestr init || die "stestr init died"
	stestr run || die "testsuite failed under ${EPYTHON}"
	flake8 "${PN}"/tests || die "flake8 drew error on a run over ${PN}/tests folder"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/source/html/. )
	distutils-r1_python_install_all
}
