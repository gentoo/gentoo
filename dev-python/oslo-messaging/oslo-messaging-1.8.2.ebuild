# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/oslo-messaging/oslo-messaging-1.8.2.ebuild,v 1.1 2015/04/28 16:37:58 prometheanfire Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Messaging API for RPC and notifications over a number of different messaging transports"
HOMEPAGE="https://pypi.python.org/pypi/oslo.messaging"
SRC_URI="mirror://pypi/${PN:0:1}/oslo.messaging/oslo.messaging-${PV}.tar.gz"
S="${WORKDIR}/oslo.messaging-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/pbr-0.8[${PYTHON_USEDEP}]
		<dev-python/pbr-1.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/hacking-0.10[${PYTHON_USEDEP}]
		<dev-python/hacking-0.11[${PYTHON_USEDEP}]
		>=dev-python/fixtures-0.3.14[${PYTHON_USEDEP}]
		>=dev-python/mock-1.0[${PYTHON_USEDEP}]
		>=dev-python/mox3-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-0.9.36[${PYTHON_USEDEP}]
		!~dev-python/testtools-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.2.0[${PYTHON_USEDEP}]
		dev-python/qpid-python[${PYTHON_USEDEP}]
		>=dev-python/redis-py-2.10.0[${PYTHON_USEDEP}]
		>=dev-python/pyzmq-14.3.1[${PYTHON_USEDEP}]
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.2.0[${PYTHON_USEDEP}]
	)"
RDEPEND="
	>=dev-python/oslo-config-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/eventlet-0.16.1[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/kombu-2.5.8[${PYTHON_USEDEP}]
	>=dev-python/oslo-middleware-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/futures-2.1.6[${PYTHON_USEDEP}]
	>=dev-python/aioeventlet-0.4[${PYTHON_USEDEP}]
	>=dev-python/trollius-1.0.0[${PYTHON_USEDEP}]
"

# This time half the doc files are missing; Do you want them?

python_test() {
	nosetests tests/ || die "test failed under ${EPYTHON}"
}
