# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1 eutils linux-info user

DESCRIPTION="A CloudFormation-compatible openstack-native cloud orchestration engine."
HOMEPAGE="https://launchpad.net/heat"
SRC_URI="https://dev.gentoo.org/~prometheanfire/dist/openstack/heat/heat.conf.sample.pike -> heat.conf.sample-${PV}
	https://tarballs.openstack.org/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="+mysql +memcached postgres sqlite"
REQUIRED_USE="|| ( mysql postgres sqlite )"

CDEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	app-admin/sudo"

RDEPEND="
	${CDEPEND}
	>=dev-python/Babel-2.3.4[${PYTHON_USEDEP}]
	!~dev-python/Babel-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/croniter-0.3.4[${PYTHON_USEDEP}]
	>=dev-python/cryptography-1.6.0[${PYTHON_USEDEP}]
	!~dev-python/cryptography-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/debtcollector-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/eventlet-0.18.4[${PYTHON_USEDEP}]
	!~dev-python/eventlet-0.20.1[${PYTHON_USEDEP}]
	<dev-python/eventlet-0.21.0[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/keystonemiddleware-4.12.0[${PYTHON_USEDEP}]
	>=dev-python/lxml-2.3[${PYTHON_USEDEP}]
	!~dev-python/lxml-3.7.0[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.13[${PYTHON_USEDEP}]
	!~dev-python/netaddr-0.7.16[${PYTHON_USEDEP}]
	>=dev-python/openstacksdk-0.9.17[${PYTHON_USEDEP}]
	>=dev-python/oslo-cache-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-4.0.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-config-4.3.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-config-4.4.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-3.8.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-2.14.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-db-4.24.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-2.1.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-i18n-3.15.2[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-3.22.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-messaging-5.24.2[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-5.25.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-middleware-3.27.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-policy-1.23.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-reports-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.10.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-serialization-2.19.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-service-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.20.0[${PYTHON_USEDEP}]
	>=dev-python/osprofiler-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-versionedobjects-1.17.0[${PYTHON_USEDEP}]
	>=dev-python/pastedeploy-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/pycrypto-2.6[${PYTHON_USEDEP}]
	>=dev-python/aodhclient-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/python-barbicanclient-4.0.0[${PYTHON_USEDEP}]
	!~dev-python/python-barbicanclient-4.5.0[${PYTHON_USEDEP}]
	!~dev-python/python-barbicanclient-4.5.1[${PYTHON_USEDEP}]
	>=dev-python/python-ceilometerclient-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/python-cinderclient-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/python-designateclient-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/python-glanceclient-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/python-heatclient-1.6.1[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-3.8.0[${PYTHON_USEDEP}]
	>=dev-python/python-magnumclient-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-manilaclient-1.12.0[${PYTHON_USEDEP}]
	>=dev-python/python-mistralclient-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/python-monascaclient-1.7.0[${PYTHON_USEDEP}]
	>=dev-python/python-neutronclient-6.3.0[${PYTHON_USEDEP}]
	>=dev-python/python-novaclient-9.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-openstackclient-3.11.0[${PYTHON_USEDEP}]
	>=dev-python/python-saharaclient-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/python-senlinclient-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/python-swiftclient-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/python-troveclient-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/python-zaqarclient-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-zunclient-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/pytz-2013.6[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.14.2[${PYTHON_USEDEP}]
	>=dev-python/tenacity-3.2.1[${PYTHON_USEDEP}]
	>=dev-python/routes-2.3.1[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
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
	>=dev-python/sqlalchemy-migrate-0.11.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]
	>=dev-python/webob-1.7.1[${PYTHON_USEDEP}]
	>=dev-python/yaql-1.1.0[${PYTHON_USEDEP}]"

PATCHES=(
)

pkg_setup() {
	enewgroup heat
	enewuser heat -1 -1 /var/lib/heat heat
}

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
	diropts -m0750 -o heat -g heat
	keepdir /etc/heat
	dodir /etc/heat/environment.d
	dodir /etc/heat/templates

	for svc in api api-cfn engine; do
		newinitd "${FILESDIR}/heat.initd" heat-${svc}
	done

	insinto /etc/heat
	insopts -m0640 -o heat -g heat
	newins "${DISTDIR}/heat.conf.sample-${PV}" "heat.conf.sample"
	doins "etc/heat/api-paste.ini"
	doins "etc/heat/policy.json"
	insinto /etc/heat/templates
	doins "etc/heat/templates/"*
	insinto /etc/heat/environment.d
	doins "etc/heat/environment.d/default.yaml"

	dodir /var/log/heat
	fowners heat:heat /var/log/heat
}
