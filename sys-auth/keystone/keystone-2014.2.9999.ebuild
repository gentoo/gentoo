# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/keystone/keystone-2014.2.9999.ebuild,v 1.7 2015/04/14 16:10:06 prometheanfire Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-2 user

DESCRIPTION="The Openstack authentication, authorization, and service catalog"
HOMEPAGE="https://launchpad.net/keystone"
EGIT_REPO_URI="https://github.com/openstack/keystone.git"
EGIT_BRANCH="stable/juno"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="+sqlite mysql postgres ldap test"
REQUIRED_USE="|| ( mysql postgres sqlite )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pbr-0.8[${PYTHON_USEDEP}]
	<dev-python/pbr-1.0[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		>=dev-python/hacking-0.9.2[${PYTHON_USEDEP}]
		<dev-python/hacking-0.10[${PYTHON_USEDEP}]
		>=dev-python/bashate-0.2[${PYTHON_USEDEP}]
		dev-lang/python[sqlite]
		>=dev-python/python-memcached-1.48[${PYTHON_USEDEP}]
		>=dev-python/pymongo-2.5[${PYTHON_USEDEP}]
		<dev-python/pymongo-3.0[${PYTHON_USEDEP}]
		ldap? (
			dev-python/python-ldap[${PYTHON_USEDEP}]
			>=dev-python/ldappool-1.0[${PYTHON_USEDEP}]
		)
		dev-python/pysaml2[${PYTHON_USEDEP}]
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		<dev-python/coverage-3.7.2[${PYTHON_USEDEP}]
		>=dev-python/fixtures-0.3.14[${PYTHON_USEDEP}]
		<dev-python/fixtures-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/lxml-2.3[${PYTHON_USEDEP}]
		<dev-python/lxml-3.5[${PYTHON_USEDEP}]
		>=dev-python/mock-1.0[${PYTHON_USEDEP}]
		<dev-python/mock-1.0.2[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.1.0[${PYTHON_USEDEP}]
		<dev-python/oslotest-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
		>=dev-python/webtest-2.0[${PYTHON_USEDEP}]
		<dev-python/webtest-2.0.19[${PYTHON_USEDEP}]
		>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
		<dev-python/subunit-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		<dev-python/testrepository-0.0.21[${PYTHON_USEDEP}]
		>=dev-python/testtools-0.9.34[${PYTHON_USEDEP}]
		!~dev-python/testtools-1.4.0[${PYTHON_USEDEP}]
		<dev-python/testtools-1.5.1[${PYTHON_USEDEP}]
		~dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/httplib2-0.7.5[${PYTHON_USEDEP}]
		>=dev-python/requests-2.1.0[${PYTHON_USEDEP}]
		!~dev-python/requests-2.4.0[${PYTHON_USEDEP}]
		>=dev-python/keyring-2.1[${PYTHON_USEDEP}]
		!~dev-python/keyring-3.3[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.2.0[${PYTHON_USEDEP}]
		<dev-python/oslo-sphinx-2.5.1[${PYTHON_USEDEP}]
		>=dev-python/kombu-2.5.0[${PYTHON_USEDEP}]
		<dev-python/kombu-3.0.24[${PYTHON_USEDEP}]
		<dev-python/lockfile-0.10[${PYTHON_USEDEP}]
		<dev-python/stevedore-1.2.1[${PYTHON_USEDEP}]
	)"
RDEPEND="
	>=dev-python/webob-1.2.3-r1[${PYTHON_USEDEP}]
	<dev-python/webob-1.5[${PYTHON_USEDEP}]
	>=dev-python/eventlet-0.15.1[${PYTHON_USEDEP}]
	<dev-python/eventlet-0.15.3[${PYTHON_USEDEP}]
	>=dev-python/greenlet-0.3.2[${PYTHON_USEDEP}]
	<dev-python/greenlet-0.4.3[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.12[${PYTHON_USEDEP}]
	<dev-python/netaddr-0.7.14[${PYTHON_USEDEP}]
	>=dev-python/pastedeploy-1.5.0[${PYTHON_USEDEP}]
	<dev-python/pastedeploy-1.5.3[${PYTHON_USEDEP}]
	<dev-python/paste-1.7.5.2[${PYTHON_USEDEP}]
	>=dev-python/routes-1.12.3[${PYTHON_USEDEP}]
	!~dev-python/routes-2.0[${PYTHON_USEDEP}]
	<dev-python/routes-2.2[${PYTHON_USEDEP}]
	>=dev-python/six-1.7.0[${PYTHON_USEDEP}]
	<dev-python/six-1.9.1[${PYTHON_USEDEP}]
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
	~dev-python/sqlalchemy-migrate-0.9.1[${PYTHON_USEDEP}]
	<dev-python/passlib-1.6.3[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.9[${PYTHON_USEDEP}]
	<dev-python/iso8601-0.1.11[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-0.10.0[${PYTHON_USEDEP}]
	>=dev-python/keystonemiddleware-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-1.4.0[${PYTHON_USEDEP}]
	<dev-python/oslo-config-1.6.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-messaging-1.4.0[${PYTHON_USEDEP}]
	<dev-python/oslo-messaging-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-db-1.0.0[${PYTHON_USEDEP}]
	<dev-python/oslo-db-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-1.0.0[${PYTHON_USEDEP}]
	<dev-python/oslo-i18n-1.3.2[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.0.0[${PYTHON_USEDEP}]
	<dev-python/oslo-serialization-1.2.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-1.0.0[${PYTHON_USEDEP}]
	<dev-python/oslo-utils-1.2.2[${PYTHON_USEDEP}]
	~dev-python/Babel-1.3[${PYTHON_USEDEP}]
	>=dev-python/oauthlib-0.6.0[${PYTHON_USEDEP}]
	<dev-python/oauthlib-0.7.3[${PYTHON_USEDEP}]
	>=dev-python/dogpile-cache-0.5.3[${PYTHON_USEDEP}]
	<dev-python/dogpile-cache-0.5.7[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.0.0[${PYTHON_USEDEP}]
	<dev-python/jsonschema-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/pycadf-0.6.0[${PYTHON_USEDEP}]
	<dev-python/pycadf-0.7.0[${PYTHON_USEDEP}]
	<dev-python/posix_ipc-0.9.10[${PYTHON_USEDEP}]"

PATCHES=(
)

pkg_setup() {
	enewgroup keystone
	enewuser keystone -1 -1 /var/lib/keystone keystone
}

python_prepare_all() {
	# it's in git, but not in the tarball.....
	mkdir -p ${PN}/tests/tmp/ || die
	cp etc/keystone-paste.ini ${PN}/tests/tmp/ || die
	distutils-r1_python_prepare_all
}

# Ignore (naughty) test_.py files & 1 test that connect to the network
#-I 'test_keystoneclient*' \
python_test() {
	nosetests -I 'test_keystoneclient*' \
		-e test_static_translated_string_is_Message \
		-e test_get_token_id_error_handling \
		-e test_provider_token_expiration_validation \
		-e test_import --process-restartworker --process-timeout=60 || die "testsuite failed under python2.7"
}

python_install() {
	distutils-r1_python_install
	newconfd "${FILESDIR}/keystone.confd" keystone
	newinitd "${FILESDIR}/keystone.initd" keystone

	diropts -m 0750
	keepdir /etc/keystone /var/log/keystone
	insinto /etc/keystone
	doins etc/keystone.conf.sample etc/logging.conf.sample
	doins etc/default_catalog.templates etc/policy.json
	doins etc/policy.v3cloudsample.json etc/keystone-paste.ini

	fowners keystone:keystone /etc/keystone /var/log/keystone
}

pkg_postinst() {
	elog "You might want to run:"
	elog "emerge --config =${CATEGORY}/${PF}"
	elog "if this is a new install."
	elog "If you have not already configured your openssl installation"
	elog "please do it by modifying /etc/ssl/openssl.cnf"
	elog "BEFORE issuing the configuration command."
	elog "Otherwise default values will be used."
}

pkg_config() {
	if [ ! -d "${ROOT}"/etc/keystone/ssl ] ; then
		einfo "Press ENTER to configure the keystone PKI, or Control-C to abort now..."
		read
		"${ROOT}"/usr/bin/keystone-manage pki_setup --keystone-user keystone --keystone-group keystone
	else
		einfo "keystone PKI certificates directory already present, skipping configuration"
	fi
}
