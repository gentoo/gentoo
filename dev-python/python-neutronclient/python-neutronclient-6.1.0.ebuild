# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1

DESCRIPTION="A client for the OpenStack Quantum API"
HOMEPAGE="https://launchpad.net/neutron"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
REQUIRED_USE="test? ( doc )"

CDEPEND=">=dev-python/pbr-1.6[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	test? (
		>=dev-python/coverage-4.0[${PYTHON_USEDEP}]
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/mox3-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-4.7.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.10.0[${PYTHON_USEDEP}]
		>=dev-python/python-openstackclient-3.3.0[${PYTHON_USEDEP}]
		>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/reno-1.8.0[${PYTHON_USEDEP}]
		>=dev-python/requests-mock-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testtools-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
	)
	doc? (
		>=dev-python/oslo-sphinx-4.7.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.2.1[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.4[${PYTHON_USEDEP}]
	)"

RDEPEND="
	${CDEPEND}
	>=dev-python/cliff-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/debtcollector-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.11[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.13[${PYTHON_USEDEP}]
	!~dev-python/netaddr-0.7.16[${PYTHON_USEDEP}]
	>=dev-python/osc-lib-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.18.0[${PYTHON_USEDEP}]
	>=dev-python/os-client-config-1.22.0[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth-2.17.0[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-3.8.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.10.0[${PYTHON_USEDEP}]
	!~dev-python/requests-2.12.2[${PYTHON_USEDEP}]
	>=dev-python/simplejson-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/Babel-2.3.4[${PYTHON_USEDEP}]"

python_prepare_all() {
	# built in...
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && "${PYTHON}" setup.py build_sphinx
}

python_test() {
	testr init
	testr run || die "tests failed under python2.7"
	flake8 neutronclient/tests || die "run by flake8 over tests folder yielded error"
}

python_install() {
	distutils-r1_python_install
	#stupid stupid
	local SITEDIR="${D%/}$(python_get_sitedir)" || die
	cd "${SITEDIR}" || die
	local egg=( python_neutronclient*.egg-info )
	#[[ -f ${egg[0]} ]] || die "python_quantumclient*.egg-info not found"
	ln -s "${egg[0]}" "${egg[0]/neutron/quantum}" || die
	ln -s neutronclient quantumclient || die
	ln -s neutron quantumclient/quantum || die
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )
	distutils-r1_python_install_all
}
