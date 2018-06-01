# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1 user

DESCRIPTION="Services for discovering, registering, and retrieving VM images"
HOMEPAGE="https://launchpad.net/glance"

if [[ ${PV} == *9999 ]];then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/openstack/glance.git"
	EGIT_BRANCH="stable/pike"
else
	SRC_URI="https://tarballs.openstack.org/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="doc mysql postgres +sqlite +swift"
REQUIRED_USE="|| ( mysql postgres sqlite )"

CDEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"

#note to self, wsgiref is a python builtin, no need to package it
#>=dev-python/wsgiref-0.1.2[${PYTHON_USEDEP}]

RDEPEND="
	${CDEPEND}
	sqlite? (
		>=dev-python/sqlalchemy-1.0.10[sqlite,${PYTHON_USEDEP}]
		!~dev-python/sqlalchemy-1.1.5[sqlite,${PYTHON_USEDEP}]
		!~dev-python/sqlalchemy-1.1.6[sqlite,${PYTHON_USEDEP}]
		!~dev-python/sqlalchemy-1.1.7[sqlite,${PYTHON_USEDEP}]
		!~dev-python/sqlalchemy-1.1.8[sqlite,${PYTHON_USEDEP}]
	)
	mysql? (
		>=dev-python/pymysql-0.7.6[${PYTHON_USEDEP}]
		!~dev-python/pymysql-0.7.7[${PYTHON_USEDEP}]
		>=dev-python/sqlalchemy-1.0.10[${PYTHON_USEDEP}]
		!~dev-python/sqlalchemy-1.1.5[${PYTHON_USEDEP}]
		!~dev-python/sqlalchemy-1.1.6[${PYTHON_USEDEP}]
		!~dev-python/sqlalchemy-1.1.7[${PYTHON_USEDEP}]
		!~dev-python/sqlalchemy-1.1.8[${PYTHON_USEDEP}]
	)
	postgres? (
		>=dev-python/psycopg-2.5.0[${PYTHON_USEDEP}]
		>=dev-python/sqlalchemy-1.0.10[${PYTHON_USEDEP}]
		!~dev-python/sqlalchemy-1.1.5[${PYTHON_USEDEP}]
		!~dev-python/sqlalchemy-1.1.6[${PYTHON_USEDEP}]
		!~dev-python/sqlalchemy-1.1.7[${PYTHON_USEDEP}]
		!~dev-python/sqlalchemy-1.1.8[${PYTHON_USEDEP}]
	)
	>=dev-python/eventlet-0.18.4[${PYTHON_USEDEP}]
	!~dev-python/eventlet-0.20.1[${PYTHON_USEDEP}]
	<dev-python/eventlet-0.21.0[${PYTHON_USEDEP}]
	>=dev-python/pastedeploy-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/routes-2.3.1[${PYTHON_USEDEP}]
	>=dev-python/webob-1.7.1[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-migrate-0.11.0[${PYTHON_USEDEP}]
	>=dev-python/python-sqlparse-0.2.2[${PYTHON_USEDEP}]
	>=dev-python/alembic-0.8.10[${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.7.5[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-4.0.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-config-4.3.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-config-4.4.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-3.8.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-2.14.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.20.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]
	>=dev-python/futurist-0.11.0[${PYTHON_USEDEP}]
	!~dev-python/futurist-0.15.0[${PYTHON_USEDEP}]
	>=dev-python/taskflow-2.7.0[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/keystonemiddleware-4.12.0[${PYTHON_USEDEP}]
	>=dev-python/WSME-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/prettytable-0.7.0[${PYTHON_USEDEP}]
	<dev-python/prettytable-0.8.0[${PYTHON_USEDEP}]
	dev-python/paste[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/jsonschema-2.5.0[${PYTHON_USEDEP}]
	<dev-python/jsonschema-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-3.8.0[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.14[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-db-4.24.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-2.1.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-i18n-3.15.2[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-3.22.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-messaging-5.24.2[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-5.25.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-middleware-3.27.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-policy-1.23.0[${PYTHON_USEDEP}]
	>=dev-python/retrying-1.2.3[${PYTHON_USEDEP}]
	!~dev-python/retrying-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/osprofiler-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/glance_store-0.22.0[${PYTHON_USEDEP}]
	>=dev-python/debtcollector-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/cryptography-1.6[${PYTHON_USEDEP}]
	!~dev-python/cryptography-2.0[${PYTHON_USEDEP}]
	>=dev-python/cursive-0.1.2[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.11[${PYTHON_USEDEP}]
	>=dev-python/monotonic-0.6[${PYTHON_USEDEP}]
"

#PATCHES=(
#)

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

python_install_all() {
	distutils-r1_python_install_all

	newinitd "${FILESDIR}/glance.initd" glance-api

	diropts -m 0750 -o glance -g glance
	dodir /var/log/glance /var/lib/glance/images /var/lib/glance/scrubber
	keepdir /etc/glance
	keepdir /var/log/glance
	keepdir /var/lib/glance/images
	keepdir /var/lib/glance/scrubber

	insinto /etc/glance
	insopts -m 0640 -o glance -g glance
	doins -r etc/*.ini etc/*.conf etc/*.sample etc/*.json etc/meta*

	use doc && local HTML_DOCS=( doc/build/html/. )
	distutils-r1_python_install_all
}
