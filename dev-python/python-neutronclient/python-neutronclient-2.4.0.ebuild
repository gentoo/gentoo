# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-neutronclient/python-neutronclient-2.4.0.ebuild,v 1.2 2015/07/07 16:18:31 zlogene Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1

DESCRIPTION="A client for the OpenStack Quantum API"
HOMEPAGE="https://launchpad.net/neutron"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
REQUIRED_USE="test? ( doc )"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pbr-0.8[${PYTHON_USEDEP}]
	<dev-python/pbr-1.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/hacking-0.10.0[${PYTHON_USEDEP}]
		<dev-python/hacking-0.11[${PYTHON_USEDEP}]
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		>=dev-python/fixtures-0.3.14[${PYTHON_USEDEP}]
		>=dev-python/mox3-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/mock-1.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
		<dev-python/oslo-sphinx-2.6.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.5.1[${PYTHON_USEDEP}]
		<dev-python/oslotest-1.6.0[${PYTHON_USEDEP}]
		>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/requests-mock-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testtools-0.9.36[${PYTHON_USEDEP}]
		<dev-python/testtools-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/tempest-lib-0.4.0[${PYTHON_USEDEP}]
	)
	doc? (
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
	)"

RDEPEND="
	>=dev-python/cliff-1.10.0[${PYTHON_USEDEP}]
	<dev-python/cliff-1.11.0[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.9[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.12[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-1.5.0[${PYTHON_USEDEP}]
	<dev-python/oslo-i18n-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.4.0[${PYTHON_USEDEP}]
	<dev-python/oslo-serialization-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-1.4.0[${PYTHON_USEDEP}]
	<dev-python/oslo-utils-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.2.0[${PYTHON_USEDEP}]
	!~dev-python/requests-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/simplejson-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/Babel-1.3[${PYTHON_USEDEP}]"

python_prepare_all() {
	# built in...
	sed -i '/argparse/d' requirements.txt
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
