# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 user

DESCRIPTION="Services for discovering, registering, and retrieving VM images"
HOMEPAGE="https://launchpad.net/glance"
SRC_URI="https://tarballs.openstack.org/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc mysql postgres +sqlite +swift test"
REQUIRED_USE="|| ( mysql postgres sqlite )"

CDEPEND=">=dev-python/pbr-1.6.0[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	test? (
		${RDEPEND}
		>=dev-python/Babel-1.3[${PYTHON_USEDEP}]
		<=dev-python/Babel-2.1.1[${PYTHON_USEDEP}]
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		<=dev-python/coverage-4.0.3[${PYTHON_USEDEP}]
		>=dev-python/fixtures-1.3.1[${PYTHON_USEDEP}]
		<=dev-python/fixtures-1.4.0-r9999[${PYTHON_USEDEP}]
		>=dev-python/mox3-0.7.0[${PYTHON_USEDEP}]
		<=dev-python/mox3-0.12.0[${PYTHON_USEDEP}]
		>=dev-python/mock-1.2[${PYTHON_USEDEP}]
		<=dev-python/mock-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
		>=dev-python/requests-2.5.2[${PYTHON_USEDEP}]
		!~dev-python/requests-2.8.0[${PYTHON_USEDEP}]
		<=dev-python/requests-2.8.1[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		<=dev-python/testrepository-0.0.20[${PYTHON_USEDEP}]
		>=dev-python/testresources-0.2.4[${PYTHON_USEDEP}]
		<=dev-python/testresources-1.0.0-r9999[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		<=dev-python/testscenarios-0.5[${PYTHON_USEDEP}]
		>=dev-python/testtools-1.4.0[${PYTHON_USEDEP}]
		<=dev-python/testtools-1.8.1[${PYTHON_USEDEP}]
		>=dev-python/psutil-1.1.1[${PYTHON_USEDEP}]
		<dev-python/psutil-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.10.0[${PYTHON_USEDEP}]
		<=dev-python/oslotest-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/pymysql-0.6.2[${PYTHON_USEDEP}]
		<=dev-python/pymysql-0.6.7[${PYTHON_USEDEP}]
		>=dev-python/psycopg-2.5[${PYTHON_USEDEP}]
		<=dev-python/psycopg-2.6.1[${PYTHON_USEDEP}]
		>=dev-python/pysendfile-2.0.0[${PYTHON_USEDEP}]
		<=dev-python/pysendfile-2.0.1[${PYTHON_USEDEP}]
		<=dev-python/qpid-python-0.32[$(python_gen_usedep 'python2_7')]
		>=dev-python/pyxattr-0.5.0[${PYTHON_USEDEP}]
		>=dev-python/python-swiftclient-2.2.0[${PYTHON_USEDEP}]
		<=dev-python/python-swiftclient-2.7.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
		<=dev-python/oslo-sphinx-4.1.0[${PYTHON_USEDEP}]
		>=dev-python/reno-0.1.1[${PYTHON_USEDEP}]
	)"

#note to self, wsgiref is a python builtin, no need to package it
#>=dev-python/wsgiref-0.1.2[${PYTHON_USEDEP}]

RDEPEND="
	${CDEPEND}
	sqlite? (
		>=dev-python/sqlalchemy-0.9.9[sqlite,${PYTHON_USEDEP}]
		<dev-python/sqlalchemy-1.0.10[sqlite,${PYTHON_USEDEP}]
	)
	mysql? (
		dev-python/mysql-python
		>=dev-python/sqlalchemy-0.9.9[${PYTHON_USEDEP}]
		<dev-python/sqlalchemy-1.0.10[${PYTHON_USEDEP}]
	)
	postgres? (
		dev-python/psycopg:2[${PYTHON_USEDEP}]
		>=dev-python/sqlalchemy-0.9.9[${PYTHON_USEDEP}]
		<dev-python/sqlalchemy-1.0.10[${PYTHON_USEDEP}]
	)
	~dev-python/anyjson-0.3.3[${PYTHON_USEDEP}]
	~dev-python/eventlet-0.17.4[${PYTHON_USEDEP}]
	>=dev-python/pastedeploy-1.5.0[${PYTHON_USEDEP}]
	<=dev-python/pastedeploy-1.5.2[${PYTHON_USEDEP}]
	>=dev-python/routes-1.12.3[${PYTHON_USEDEP}]
	!~dev-python/routes-2.0[${PYTHON_USEDEP}]
	!~dev-python/routes-2.1[$(python_gen_usedep 'python2_7')]
	<=dev-python/routes-2.2[${PYTHON_USEDEP}]
	>=dev-python/webob-1.2.3[${PYTHON_USEDEP}]
	<=dev-python/webob-1.5.1[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-migrate-0.9.6[${PYTHON_USEDEP}]
	<=dev-python/sqlalchemy-migrate-0.10.0[${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.7.5[${PYTHON_USEDEP}]
	<=dev-python/httplib2-0.9.2[${PYTHON_USEDEP}]
	>=dev-python/pycrypto-2.6[${PYTHON_USEDEP}]
	<=dev-python/pycrypto-2.6.1[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.9[${PYTHON_USEDEP}]
	<=dev-python/iso8601-0.1.11[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-2.3.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-config-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-2.3.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-concurrency-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-0.2.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-context-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-service-0.7.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-service-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-utils-2.6.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-utils-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.5.0[${PYTHON_USEDEP}]
	<=dev-python/stevedore-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/futurist-0.1.2[${PYTHON_USEDEP}]
	<=dev-python/futurist-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/taskflow-1.16.0[${PYTHON_USEDEP}]
	<=dev-python/taskflow-1.25.0[${PYTHON_USEDEP}]
	>=dev-python/keystonemiddleware-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/keystonemiddleware-2.4.0[${PYTHON_USEDEP}]
	<=dev-python/keystonemiddleware-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/WSME-0.7[${PYTHON_USEDEP}]
	<=dev-python/WSME-0.8.0[${PYTHON_USEDEP}]
	<=dev-python/paste-2.0.2[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/jsonschema-2.5.0[${PYTHON_USEDEP}]
	<dev-python/jsonschema-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-1.6.0[${PYTHON_USEDEP}]
	!~dev-python/python-keystoneclient-1.8.0[${PYTHON_USEDEP}]
	<=dev-python/python-keystoneclient-2.0.0-r9999[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.14[${PYTHON_USEDEP}]
	<=dev-python/pyopenssl-0.15.1[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	<=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-db-2.4.1[${PYTHON_USEDEP}]
	<=dev-python/oslo-db-4.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-1.5.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-i18n-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-1.8.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-log-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-messaging-1.16.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-1.17.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-1.17.1[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-2.6.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-2.6.1[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-2.7.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-2.8.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-2.8.1[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-2.9.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-3.1.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-messaging-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-middleware-2.8.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-middleware-3.3.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-policy-0.5.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-policy-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.4.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-serialization-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/retrying-1.2.3[${PYTHON_USEDEP}]
	!~dev-python/retrying-1.3.0[${PYTHON_USEDEP}]
	<=dev-python/retrying-1.3.3[${PYTHON_USEDEP}]
	>=dev-python/osprofiler-0.3.0[${PYTHON_USEDEP}]
	<=dev-python/osprofiler-0.3.1[${PYTHON_USEDEP}]
	>=dev-python/glance_store-0.7.1[${PYTHON_USEDEP}]
	!~dev-python/glance_store-0.9.0[${PYTHON_USEDEP}]
	<=dev-python/glance_store-0.9.1[${PYTHON_USEDEP}]
	>=dev-python/semantic_version-2.3.1[${PYTHON_USEDEP}]
	<=dev-python/semantic_version-2.4.2[${PYTHON_USEDEP}]
	>=dev-python/castellan-0.2.0[${PYTHON_USEDEP}]
	<=dev-python/castellan-0.3.1[${PYTHON_USEDEP}]
	>=dev-python/cryptography-1.0[${PYTHON_USEDEP}]
	<=dev-python/cryptography-1.1.2-r9999[${PYTHON_USEDEP}]
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
