# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1

DESCRIPTION="OpenStack logging config library, configuration for all openstack projects."
HOMEPAGE="https://pypi.python.org/pypi/oslo.log https://github.com/openstack/oslo.log"
SRC_URI="mirror://pypi/o/oslo.log/oslo.log-${PV}.tar.gz"
S="${WORKDIR}/oslo.log-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test"

CDEPEND=">=dev-python/pbr-1.8[${PYTHON_USEDEP}]"
RDEPEND="
	${CDEPEND}
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-3.14.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.16.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/debtcollector-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/pyinotify-0.9.6[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.4.2[${PYTHON_USEDEP}]"
DEPEND="
	${CDEPEND}
	test? ( ${RDEPEND}
		>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.5.1[${PYTHON_USEDEP}]
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
		!~dev-python/oslo-sphinx-3.4.0[${PYTHON_USEDEP}]
		>=dev-python/reno-1.8.0[${PYTHON_USEDEP}]
		>=dev-python/bandit-1.1.0[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests oslo_log/tests || die "Tests fail with ${EPYTHON}"
}
