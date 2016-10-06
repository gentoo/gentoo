# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1 user

DESCRIPTION="The Openstack authentication, authorization, and service catalog"
HOMEPAGE="https://launchpad.net/keystone"
SRC_URI="https://tarballs.openstack.org/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+sqlite ldap memcached mongo mysql postgres test"
REQUIRED_USE="|| ( mysql postgres sqlite )"

CDEPEND=">=dev-python/pbr-1.6[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="
	${CDEPEND}
	>=dev-python/Babel-2.3.4[${PYTHON_USEDEP}]
	>=dev-python/webob-1.2.3-r1[${PYTHON_USEDEP}]
	>=dev-python/pastedeploy-1.5.0[${PYTHON_USEDEP}]
	dev-python/paste[${PYTHON_USEDEP}]
	>=dev-python/routes-1.12.3[${PYTHON_USEDEP}]
	!~dev-python/routes-2.0[${PYTHON_USEDEP}]
	!~dev-python/routes-2.1[$(python_gen_usedep 'python2_7')]
	!~dev-python/routes-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/cryptography-1.0[${PYTHON_USEDEP}]
	!~dev-python/cryptography-1.3.0[${PYTHON_USEDEP}]
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
		>=dev-python/psycopg-2.5.0[${PYTHON_USEDEP}]
		>=dev-python/sqlalchemy-1.0.10[${PYTHON_USEDEP}]
		<dev-python/sqlalchemy-1.1.0[${PYTHON_USEDEP}]
	)
	>=dev-python/sqlalchemy-migrate-0.9.6[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.16.0[${PYTHON_USEDEP}]
	>=dev-python/passlib-1.6[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/python-keystoneclient-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/keystonemiddleware-4.0.0[${PYTHON_USEDEP}]
	!~dev-python/keystonemiddleware-4.1.0[${PYTHON_USEDEP}]
	!~dev-python/keystonemiddleware-4.5.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-cache-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-3.8.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-3.14.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-2.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-messaging-5.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-db-4.10.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-db-4.13.1[${PYTHON_USEDEP}]
	!~dev-python/oslo-db-4.13.2[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-1.14.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-middleware-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-policy-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.16.0[${PYTHON_USEDEP}]
	>=dev-python/oauthlib-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/pysaml2-2.4.0[${PYTHON_USEDEP}]
	<dev-python/pysaml2-4.0.3[${PYTHON_USEDEP}]
	>=dev-python/dogpile-cache-0.6.2[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/jsonschema-2.5.0[${PYTHON_USEDEP}]
	<dev-python/jsonschema-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/pycadf-1.1.0[${PYTHON_USEDEP}]
	!~dev-python/pycadf-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/msgpack-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/osprofiler-1.4.0[${PYTHON_USEDEP}]
	memcached? (
		>=dev-python/python-memcached-1.56[${PYTHON_USEDEP}]
	)
	mongo? (
		>=dev-python/pymongo-3.0.2[${PYTHON_USEDEP}]
		!~dev-python/pymongo-3.1[${PYTHON_USEDEP}]
	)
	ldap? (
		>=dev-python/pyldap-2.4[${PYTHON_USEDEP}]
		>=dev-python/ldappool-2.0.0[${PYTHON_USEDEP}]
	)
	|| (
		www-servers/uwsgi[python,${PYTHON_USEDEP}]
		www-apache/mod_wsgi[${PYTHON_USEDEP}]
		www-servers/gunicorn[${PYTHON_USEDEP}]
	)"

#PATCHES=(
#)

pkg_setup() {
	enewgroup keystone
	enewuser keystone -1 -1 /var/lib/keystone keystone
}

python_prepare_all() {
	# it's in git, but not in the tarball.....
	sed -i '/^hacking/d' test-requirements.txt || die
	mkdir -p ${PN}/tests/tmp/ || die
	cp etc/keystone-paste.ini ${PN}/tests/tmp/ || die
	sed -i 's|/usr/local|/usr|g' httpd/keystone-uwsgi-* || die
	sed -i 's|python|python27|g' httpd/keystone-uwsgi-* || die
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

	diropts -m 0750
	keepdir /etc/keystone /var/log/keystone
	insinto /etc/keystone
	insopts -m0640 -okeystone -gkeystone
	doins etc/keystone.conf.sample etc/logging.conf.sample
	doins etc/default_catalog.templates etc/policy.json
	doins etc/policy.v3cloudsample.json etc/keystone-paste.ini
	insinto /etc/keystone/httpd
	doins httpd/*

	fowners keystone:keystone /etc/keystone /etc/keystone/httpd /var/log/keystone
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
