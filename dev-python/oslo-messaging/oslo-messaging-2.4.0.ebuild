# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1

DESCRIPTION="Messaging API for RPC and notifications over a number of different messaging transports"
HOMEPAGE="https://pypi.python.org/pypi/oslo.messaging"
SRC_URI="mirror://pypi/${PN:0:1}/oslo.messaging/oslo.messaging-${PV}.tar.gz"
S="${WORKDIR}/oslo.messaging-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

CDEPEND="
	>=dev-python/pbr-1.4[${PYTHON_USEDEP}]
	<dev-python/pbr-2.0[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	test? (
		>=dev-python/fixtures-1.3.1[${PYTHON_USEDEP}]
		>=dev-python/mock-1.2[${PYTHON_USEDEP}]
		>=dev-python/mox3-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.10.0[${PYTHON_USEDEP}]
		dev-python/qpid-python[$(python_gen_usedep 'python2*')]
		>=dev-python/redis-py-2.10.0[${PYTHON_USEDEP}]
		>=dev-python/pyzmq-14.3.1[${PYTHON_USEDEP}]
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
	)"
RDEPEND="
	${CDEPEND}
	>=dev-python/futurist-0.1.2[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-1.8.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-service-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/cachetools-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/eventlet-0.17.4[${PYTHON_USEDEP}]
	>=dev-python/greenlet-0.3.2[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/py-amqp-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/kombu-3.0.7[${PYTHON_USEDEP}]
	>=dev-python/oslo-middleware-2.4.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-middleware-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/aioeventlet-0.4[${PYTHON_USEDEP}]
	>=dev-python/trollius-1.0.0[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests tests/ || die "test failed under ${EPYTHON}"
}
