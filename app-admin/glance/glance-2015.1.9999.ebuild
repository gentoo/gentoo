# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3 user

DESCRIPTION="Services for discovering, registering, and retrieving
virtual machine images"
HOMEPAGE="https://launchpad.net/glance"
EGIT_REPO_URI="https://github.com/openstack/glance.git"
EGIT_BRANCH="stable/kilo"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="doc mysql postgres +sqlite +swift test"
REQUIRED_USE="|| ( mysql postgres sqlite )"

DEPEND="
		dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/pbr-0.8.0[${PYTHON_USEDEP}]
		<dev-python/pbr-1.0[${PYTHON_USEDEP}]
		test? (
			${RDEPEND}
			>=dev-python/Babel-1.3[${PYTHON_USEDEP}]
			>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
			>=dev-python/fixtures-0.3.14[${PYTHON_USEDEP}]
			<dev-python/fixtures-1.3.0[${PYTHON_USEDEP}]
			>=dev-python/mox3-0.7.0[${PYTHON_USEDEP}]
			<dev-python/mox3-0.8.0[${PYTHON_USEDEP}]
			>=dev-python/mock-1.0[${PYTHON_USEDEP}]
			<dev-python/mock-1.1.0[${PYTHON_USEDEP}]
			>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
			!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
			<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
			>=dev-python/requests-2.2.0[${PYTHON_USEDEP}]
			!~dev-python/requests-2.4.0[${PYTHON_USEDEP}]
			>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
			>=dev-python/testtools-0.9.36[${PYTHON_USEDEP}]
			!~dev-python/testtools-1.2.0[${PYTHON_USEDEP}]
			>=dev-python/psutil-1.1.1[${PYTHON_USEDEP}]
			<dev-python/psutil-2.0.0[${PYTHON_USEDEP}]
			>=dev-python/oslotest-1.5.1[${PYTHON_USEDEP}]
			<dev-python/oslotest-1.6.0[${PYTHON_USEDEP}]
			dev-python/mysql-python[${PYTHON_USEDEP}]
			dev-python/psycopg[${PYTHON_USEDEP}]
			~dev-python/pysendfile-2.0.1[${PYTHON_USEDEP}]
			dev-python/qpid-python[${PYTHON_USEDEP}]
			>=dev-python/pyxattr-0.5.0[${PYTHON_USEDEP}]
			>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
			<dev-python/oslo-sphinx-2.6.0[${PYTHON_USEDEP}]
			>=dev-python/elasticsearch-py-1.3.0[${PYTHON_USEDEP}]
		)"

#note to self, wsgiref is a python builtin, no need to package it
#>=dev-python/wsgiref-0.1.2[${PYTHON_USEDEP}]

RDEPEND="
	>=dev-python/greenlet-0.3.2[${PYTHON_USEDEP}]
	sqlite? (
		>=dev-python/sqlalchemy-0.9.7[sqlite,${PYTHON_USEDEP}]
		<=dev-python/sqlalchemy-0.9.99[sqlite,${PYTHON_USEDEP}]
	)
	mysql? (
		dev-python/mysql-python
		>=dev-python/sqlalchemy-0.9.7[${PYTHON_USEDEP}]
		<=dev-python/sqlalchemy-0.9.99[${PYTHON_USEDEP}]
	)
	postgres? (
		dev-python/psycopg:2
		>=dev-python/sqlalchemy-0.9.7[${PYTHON_USEDEP}]
		<=dev-python/sqlalchemy-0.9.99[${PYTHON_USEDEP}]
	)
	>=dev-python/anyjson-0.3.3[${PYTHON_USEDEP}]
	>=dev-python/eventlet-0.16.1[${PYTHON_USEDEP}]
	!~dev-python/eventlet-0.17.0[${PYTHON_USEDEP}]
	>=dev-python/pastedeploy-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/routes-1.12.3[${PYTHON_USEDEP}]
	!~dev-python/routes-2.0[${PYTHON_USEDEP}]
	>=dev-python/webob-1.2.3[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-migrate-0.9.5[${PYTHON_USEDEP}]
	!~dev-python/sqlalchemy-migrate-0.9.8[${PYTHON_USEDEP}]
	<dev-python/sqlalchemy-migrate-0.10.0[${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.7.5[${PYTHON_USEDEP}]
	>=dev-python/kombu-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/pycrypto-2.6[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.9[${PYTHON_USEDEP}]
	dev-python/ordereddict[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-1.9.3[${PYTHON_USEDEP}]
	<dev-python/oslo-config-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-1.8.2[${PYTHON_USEDEP}]
	<dev-python/oslo-concurrency-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-0.2.0[${PYTHON_USEDEP}]
	<dev-python/oslo-context-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-1.4.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-utils-1.4.1[${PYTHON_USEDEP}]
	<dev-python/oslo-utils-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.3.0[${PYTHON_USEDEP}]
	<dev-python/stevedore-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/taskflow-0.7.1[${PYTHON_USEDEP}]
	<dev-python/taskflow-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/keystonemiddleware-1.5.0[${PYTHON_USEDEP}]
	<dev-python/keystonemiddleware-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/WSME-0.6[${PYTHON_USEDEP}]
	<dev-python/WSME-0.7[${PYTHON_USEDEP}]
	dev-python/posix_ipc[${PYTHON_USEDEP}]
	swift? (
		>=dev-python/python-swiftclient-2.2.0[${PYTHON_USEDEP}]
		<dev-python/python-swiftclient-2.5.0[${PYTHON_USEDEP}]
	)
	>=dev-python/oslo-vmware-0.11.1[${PYTHON_USEDEP}]
	<dev-python/oslo-vmware-0.12.0[${PYTHON_USEDEP}]
	dev-python/paste[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.0.0[${PYTHON_USEDEP}]
	<dev-python/jsonschema-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-1.2.0[${PYTHON_USEDEP}]
	<dev-python/python-keystoneclient-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.11[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-db-1.7.0[${PYTHON_USEDEP}]
	<dev-python/oslo-db-1.8.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-1.5.0[${PYTHON_USEDEP}]
	<dev-python/oslo-i18n-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-1.0.0[${PYTHON_USEDEP}]
	<dev-python/oslo-log-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-messaging-1.8.0[${PYTHON_USEDEP}]
	<dev-python/oslo-messaging-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-policy-0.3.1[${PYTHON_USEDEP}]
	<dev-python/oslo-policy-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.4.0[${PYTHON_USEDEP}]
	<dev-python/oslo-serialization-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/retrying-1.2.3[${PYTHON_USEDEP}]
	!~dev-python/retrying-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/osprofiler-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/glance_store-0.3.0[${PYTHON_USEDEP}]
	<dev-python/glance_store-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/semantic_version-2.3.1[${PYTHON_USEDEP}]
"

PATCHES=(
)

pkg_setup() {
	enewgroup glance
	enewuser glance -1 -1 /var/lib/glance glance
}

python_prepare_all() {
	sed -i '/xattr/d' test-requirements.txt || die
	sed -i '/pysendfile/d' test-requirements.txt || die
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && "${PYTHON}" setup.py build_sphinx
}

python_test() {
	# https://bugs.launchpad.net/glance/+bug/1251105
	# https://bugs.launchpad.net/glance/+bug/1242501
	testr init
	testr run --parallel || die "failed testsuite under python2.7"
}

python_install() {
	distutils-r1_python_install

	for svc in api registry scrubber; do
		newinitd "${FILESDIR}/glance.initd" glance-${svc}
	done

	diropts -m 0750 -o glance -g glance
	dodir /var/log/glance /var/lib/glance/images /var/lib/glance/scrubber
	keepdir /etc/glance
	keepdir /var/log/glance
	keepdir /var/lib/glance/images
	keepdir /var/lib/glance/scrubber

	insinto /etc/glance
	insopts -m 0640 -o glance -g glance
	doins etc/*.ini
	doins etc/*.conf
	doins etc/*.sample
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )
	distutils-r1_python_install_all
}
