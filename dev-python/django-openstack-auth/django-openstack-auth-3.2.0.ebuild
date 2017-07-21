# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )

inherit distutils-r1

MY_PN=${PN//-/_}
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Django authentication backend for use with OpenStack Keystone Identity backend"
HOMEPAGE="http://django_openstack_auth.readthedocs.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

CDEPEND="
	>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
	!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-sphinx-4.7.0[${PYTHON_USEDEP}]"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pbr-2.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/hacking-0.12.0[${PYTHON_USEDEP}]
		<dev-python/hacking-0.14[${PYTHON_USEDEP}]
		>=dev-python/Babel-2.3.4[${PYTHON_USEDEP}]
		>=dev-python/coverage-4.0[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0[${PYTHON_USEDEP}]
		>=dev-python/mox3-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}] )
		${CDEPEND}
		doc? ( ${CDEPEND} )
	"
RDEPEND="
	>=dev-python/django-1.8[${PYTHON_USEDEP}]
	<dev-python/django-1.10[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-3.22.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-policy-1.17.0[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-3.8.0[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth-2.20.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	# Avoid warning in doc build due to missed file
	if use doc; then
		mkdir doc/source/_static || die
	fi
	distutils-r1_python_prepare_all
}

python_compile_all() {
	# under sphinx-1.3.1 the build outputs a harmless warning about change of
	# html_theme setting in conf.py. priot versions will have the right setting
	if use doc; then
		sphinx-build -b html -c doc/source/ doc/source/ doc/source/html || die
	fi
}

python_test() {
	"${PYTHON}" -m openstack_auth.tests.run_tests || die "Testsuite failed"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/source/html/. )
	distutils-r1_python_install_all
}
