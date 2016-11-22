# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1 eutils git-r3 linux-info user

DESCRIPTION="A CloudFormation-compatible openstack-native cloud orchistration engine."
HOMEPAGE="https://launchpad.net/heat"
EGIT_REPO_URI="https://github.com/openstack/heat.git"
EGIT_BRANCH="stable/newton"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="+mysql +memcached postgres sqlite"
REQUIRED_USE="|| ( mysql postgres sqlite )"

CDEPEND=">=dev-python/pbr-1.6[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	app-admin/sudo"

RDEPEND="
	${CDEPEND}
	>=dev-python/Babel-2.3.4[${PYTHON_USEDEP}]
	>=dev-python/croniter-0.3.4[${PYTHON_USEDEP}]
	>=dev-python/cryptography-1.0.0[${PYTHON_USEDEP}]
	!~dev-python/cryptography-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/debtcollector-1.2.0
	>=dev-python/eventlet-0.18.4[${PYTHON_USEDEP}]
	>=dev-python/greenlet-0.3.2[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth-2.10.0[${PYTHON_USEDEP}]
	>=dev-python/keystonemiddleware-4.0.0[${PYTHON_USEDEP}]
	!~dev-python/keystonemiddleware-4.1.0[${PYTHON_USEDEP}]
	!~dev-python/keystonemiddleware-4.5.0[${PYTHON_USEDEP}]
	>=dev-python/lxml-2.3[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.13[${PYTHON_USEDEP}]
	!~dev-python/netaddr-0.7.16[${PYTHON_USEDEP}]
	>=dev-python/oslo-cache-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-3.14.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-3.8.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-2.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-db-4.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-db-4.13.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-db-4.13.2[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-1.14.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-messaging-5.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-middleware-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-policy-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-reports-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-service-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.16.0[${PYTHON_USEDEP}]
	>=dev-python/osprofiler-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-versionedobjects-1.13.0[${PYTHON_USEDEP}]
	>=dev-python/pastedeploy-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/pycrypto-2.6[${PYTHON_USEDEP}]
	>=dev-python/aodhclient-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/python-barbicanclient-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-ceilometerclient-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/python-cinderclient-1.6.0[${PYTHON_USEDEP}]
	!~dev-python/python-cinderclient-1.7.0[${PYTHON_USEDEP}]
	!~dev-python/python-cinderclient-1.7.1[${PYTHON_USEDEP}]
	>=dev-python/python-designateclient-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/python-glanceclient-2.3.0[${PYTHON_USEDEP}]
	!~dev-python/python-glanceclient-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/python-heatclient-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/python-keystoneclient-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/python-magnumclient-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-manilaclient-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/python-mistralclient-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-monascaclient-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/python-neutronclient-5.1.0[${PYTHON_USEDEP}]
	>=dev-python/python-novaclient-2.29.0[${PYTHON_USEDEP}]
	!~dev-python/python-novaclient-2.33.0[${PYTHON_USEDEP}]
	>=dev-python/python-openstackclient-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/python-senlinclient-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/python-swiftclient-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/python-troveclient-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/python-zaqarclient-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/pytz-2013.6[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.10.0[${PYTHON_USEDEP}]
	>=dev-python/retrying-1.2.3[${PYTHON_USEDEP}]
	!~dev-python/retrying-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/routes-1.12.3[${PYTHON_USEDEP}]
	!~dev-python/routes-2.0[${PYTHON_USEDEP}]
	!~dev-python/routes-2.1[$(python_gen_usedep 'python2_7')]
	!~dev-python/routes-2.3[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	sqlite? (
		>=dev-python/sqlalchemy-1.0.10[sqlite,${PYTHON_USEDEP}]
		<dev-python/sqlalchemy-1.1.0[sqlite,${PYTHON_USEDEP}]
	)
	mysql? (
		>=dev-python/pymysql-0.6.2[${PYTHON_USEDEP}]
		!~dev-python/pymysql-0.7.7[${PYTHON_USEDEP}]
		>=dev-python/sqlalchemy-1.0.10[${PYTHON_USEDEP}]
		<dev-python/sqlalchemy-1.1.0[${PYTHON_USEDEP}]
	)
	postgres? (
		>=dev-python/psycopg-2.5.0
		>=dev-python/sqlalchemy-1.0.10[${PYTHON_USEDEP}]
		<dev-python/sqlalchemy-1.1.0[${PYTHON_USEDEP}]
	)
	>=dev-python/sqlalchemy-migrate-0.9.6[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.16.0[${PYTHON_USEDEP}]

	>=dev-python/webob-1.2.3-r1[${PYTHON_USEDEP}]
	>=dev-python/yaql-1.1.0[${PYTHON_USEDEP}]"

#PATCHES=(
#)

pkg_setup() {
	enewgroup heat
	enewuser heat -1 -1 /var/lib/heat heat
}

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install
	diropts -m0750 -o heat -g heat
	keepdir /etc/heat
	dodir /etc/heat/environment.d
	dodir /etc/heat/templates

	for svc in api api-cfn engine; do
		newinitd "${FILESDIR}/heat.initd" heat-${svc}
	done

	insinto /etc/heat
	insopts -m0640 -o heat -g heat
	newins "${FILESDIR}/newton-heat.conf.sample" "heat.conf.sample"
	doins "etc/heat/api-paste.ini"
	doins "etc/heat/policy.json"
	insinto /etc/heat/templates
	doins "etc/heat/templates/"*
	insinto /etc/heat/environment.d
	doins "etc/heat/environment.d/default.yaml"

	dodir /var/log/heat
	fowners heat:heat /var/log/heat
}
