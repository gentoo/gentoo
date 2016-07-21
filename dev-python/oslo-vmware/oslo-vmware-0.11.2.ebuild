# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1

DESCRIPTION="Oslo VMware library for OpenStack projects"
HOMEPAGE="https://pypi.python.org/pypi/oslo.vmware"
SRC_URI="mirror://pypi/${PN:0:1}/oslo.vmware/oslo.vmware-${PV}.tar.gz"
S="${WORKDIR}/oslo.vmware-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/pbr-0.8[${PYTHON_USEDEP}]
		<dev-python/pbr-1.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/hacking-0.9.2[${PYTHON_USEDEP}]
		<dev-python/hacking-0.10[${PYTHON_USEDEP}]
		>=dev-python/pylint-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/fixtures-0.3.14[${PYTHON_USEDEP}]
		>=dev-python/mock-1.0[${PYTHON_USEDEP}]
		<dev-python/mock-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/mox3-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-0.9.36[${PYTHON_USEDEP}]
		!~dev-python/testtools-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
		<dev-python/oslo-sphinx-2.6.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)"
RDEPEND="
	>=dev-python/stevedore-1.3.0[${PYTHON_USEDEP}]
	<dev-python/stevedore-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.12[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.9[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-1.5.0[${PYTHON_USEDEP}]
	<dev-python/oslo-i18n-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.4.0[${PYTHON_USEDEP}]
	<dev-python/oslo-serialization-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-1.4.0[${PYTHON_USEDEP}]
	<dev-python/oslo-utils-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/Babel-1.3[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/suds-0.6[${PYTHON_USEDEP}]
	>=dev-python/eventlet-0.16.1[${PYTHON_USEDEP}]
	!~dev-python/eventlet-0.17.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.2.0[${PYTHON_USEDEP}]
	!~dev-python/requests-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.8.3[${PYTHON_USEDEP}]
	<dev-python/urllib3-1.11[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-1.8.0[${PYTHON_USEDEP}]
	<dev-python/oslo-concurrency-1.9.0[${PYTHON_USEDEP}]
"
python_prepare() {
	sed -i '/suds-jurko/d' requirements-py3.txt || die
}

python_test() {
	nosetests tests/ || die "test failed under ${EPYTHON}"
}
