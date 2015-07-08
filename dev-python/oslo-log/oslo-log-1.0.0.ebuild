# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/oslo-log/oslo-log-1.0.0.ebuild,v 1.3 2015/07/08 20:35:33 zlogene Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1

DESCRIPTION="OpenStack logging config library provides standardized configuration for all openstack projects."
HOMEPAGE="http://pypi.python.org/pypi/oslo.log https://github.com/openstack/oslo.log"
SRC_URI="mirror://pypi/o/oslo.log/oslo.log-${PV}.tar.gz"
S="${WORKDIR}/oslo.log-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	>=dev-python/Babel-1.3[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.9[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.2.0[${PYTHON_USEDEP}]"
DEPEND="
	>=dev-python/pbr-0.8[${PYTHON_USEDEP}]
	<dev-python/pbr-1.0[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		>=dev-python/hacking-0.9.2[${PYTHON_USEDEP}]
		<dev-python/hacking-0.10[${PYTHON_USEDEP}]
		>=dev-python/fixtures-0.3.14[${PYTHON_USEDEP}]
		>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-0.9.36[${PYTHON_USEDEP}]
		!~dev-python/testtools-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/mock-1.0[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)"

python_test() {
	nosetests oslo_log/tests || die "Tests fail with ${EPYTHON}"
}
