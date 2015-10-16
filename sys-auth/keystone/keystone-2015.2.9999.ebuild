# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1 git-2 user

DESCRIPTION="The Openstack authentication, authorization, and service catalog"
HOMEPAGE="https://launchpad.net/keystone"
EGIT_REPO_URI="https://github.com/openstack/keystone.git"
EGIT_BRANCH="stable/liberty"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="+sqlite memcached mongo mysql postgres ldap test"
REQUIRED_USE="|| ( mysql postgres sqlite )"

CDEPEND=">=dev-python/pbr-1.6[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	test? (
		${RDEPEND}
		>=dev-python/bashate-0.2[${PYTHON_USEDEP}]
		<=dev-python/bashate-0.3.1[${PYTHON_USEDEP}]
		memcached? (
			>=dev-python/python-memcached-1.48[${PYTHON_USEDEP}]
			<=dev-python/python-memcached-1.57[${PYTHON_USEDEP}]
		)
		mongo? (
			>=dev-python/pymongo-2.6.3[${PYTHON_USEDEP}]
			<dev-python/pymongo-3.0[${PYTHON_USEDEP}]
		)
		ldap? (
			>=dev-python/python-ldap-2.4[$(python_gen_usedep 'python2_7')]
			<=dev-python/python-ldap-2.4.20[$(python_gen_usedep 'python2_7')]
			>=dev-python/ldappool-1.0[$(python_gen_usedep 'python2_7')]
			<=dev-python/ldappool-1.0[$(python_gen_usedep 'python2_7')]
		)
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		<=dev-python/coverage-4.0[${PYTHON_USEDEP}]
		>=dev-python/fixtures-1.3.1[${PYTHON_USEDEP}]
		<=dev-python/fixtures-1.3.1[${PYTHON_USEDEP}]
		>=dev-python/lxml-2.3[${PYTHON_USEDEP}]
		<=dev-python/lxml-3.4.4[${PYTHON_USEDEP}]
		>=dev-python/mock-1.2[${PYTHON_USEDEP}]
		<=dev-python/mock-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.10.0[${PYTHON_USEDEP}]
		<=dev-python/oslotest-1.11.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
		>=dev-python/webtest-2.0[${PYTHON_USEDEP}]
		<=dev-python/webtest-2.0.18[${PYTHON_USEDEP}]
		>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
		<=dev-python/subunit-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		<=dev-python/testrepository-0.0.20[${PYTHON_USEDEP}]
		>=dev-python/testtools-1.4.0[${PYTHON_USEDEP}]
		<=dev-python/testtools-1.8.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
		<=dev-python/oslo-sphinx-3.2.0[${PYTHON_USEDEP}]
		>=dev-python/tempest-lib-0.8.0[${PYTHON_USEDEP}]
		<=dev-python/tempest-lib-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/requests-2.5.2[${PYTHON_USEDEP}]
		<=dev-python/requests-2.7.0[${PYTHON_USEDEP}]
	)"
RDEPEND="
	${CDEPEND}
	>=dev-python/webob-1.2.3-r1[${PYTHON_USEDEP}]
	<=dev-python/webob-1.4.1[${PYTHON_USEDEP}]
	>=dev-python/eventlet-0.17.4[${PYTHON_USEDEP}]
	<=dev-python/eventlet-0.17.4[${PYTHON_USEDEP}]
	>=dev-python/greenlet-0.3.2[${PYTHON_USEDEP}]
	<=dev-python/greenlet-0.4.9[${PYTHON_USEDEP}]
	>=dev-python/pastedeploy-1.5.0[${PYTHON_USEDEP}]
	<=dev-python/pastedeploy-1.5.2[${PYTHON_USEDEP}]
	<=dev-python/paste-2.0.2[${PYTHON_USEDEP}]
	>=dev-python/routes-1.12.3[${PYTHON_USEDEP}]
	!~dev-python/routes-2.0[${PYTHON_USEDEP}]
	!~dev-python/routes-2.1[$(python_gen_usedep 'python2_7')]
	<=dev-python/routes-2.2[${PYTHON_USEDEP}]
	>=dev-python/cryptography-1.0[${PYTHON_USEDEP}]
	<=dev-python/cryptography-1.0.1-r9999[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	<=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	sqlite? (
		>=dev-python/sqlalchemy-0.9.9[sqlite,${PYTHON_USEDEP}]
		<dev-python/sqlalchemy-1.1.0[sqlite,${PYTHON_USEDEP}]
	)
	mysql? (
		dev-python/mysql-python
		>=dev-python/sqlalchemy-0.9.9[${PYTHON_USEDEP}]
		<dev-python/sqlalchemy-1.1.0[${PYTHON_USEDEP}]
	)
	postgres? (
		dev-python/psycopg:2
		>=dev-python/sqlalchemy-0.9.9[${PYTHON_USEDEP}]
		<dev-python/sqlalchemy-1.1.0[${PYTHON_USEDEP}]
	)
	>=dev-python/sqlalchemy-migrate-0.9.6[${PYTHON_USEDEP}]
	<=dev-python/sqlalchemy-migrate-0.10.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.5.0[${PYTHON_USEDEP}]
	<=dev-python/stevedore-1.8.0[${PYTHON_USEDEP}]
	>=dev-python/passlib-1.6[${PYTHON_USEDEP}]
	<=dev-python/passlib-1.6.5[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-1.6.0[${PYTHON_USEDEP}]
	<=dev-python/python-keystoneclient-1.7.2[${PYTHON_USEDEP}]
	>=dev-python/keystonemiddleware-2.0.0[${PYTHON_USEDEP}]
	<=dev-python/keystonemiddleware-2.3.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-2.3.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-concurrency-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-2.3.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-config-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-0.2.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-context-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-messaging-1.16.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-1.17.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-1.17.1[${PYTHON_USEDEP}]
	<=dev-python/oslo-messaging-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-db-2.4.1[${PYTHON_USEDEP}]
	<=dev-python/oslo-db-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-1.5.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-i18n-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-1.8.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-log-1.11.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-middleware-2.8.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-middleware-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-policy-0.5.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-policy-0.11.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.4.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-serialization-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-service-0.7.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-service-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-2.0.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-utils-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/oauthlib-0.6.0[${PYTHON_USEDEP}]
	<=dev-python/oauthlib-1.0.3[${PYTHON_USEDEP}]
	>=dev-python/pysaml2-2.4.0[${PYTHON_USEDEP}]
	<=dev-python/pysaml2-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/dogpile-cache-0.5.4[${PYTHON_USEDEP}]
	<=dev-python/dogpile-cache-0.5.6[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/jsonschema-2.5.0[${PYTHON_USEDEP}]
	<dev-python/jsonschema-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/pycadf-1.1.0[${PYTHON_USEDEP}]
	<=dev-python/pycadf-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/msgpack-0.4.0[${PYTHON_USEDEP}]
	<=dev-python/msgpack-0.4.6[${PYTHON_USEDEP}]"

PATCHES=(
)

pkg_setup() {
	enewgroup keystone
	enewuser keystone -1 -1 /var/lib/keystone keystone
}

python_prepare_all() {
	# it's in git, but not in the tarball.....
	sed -i '/^hacking/d' test-requirements.txt || die
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
	insopts -m0640 -okeystone -gkeystone
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
