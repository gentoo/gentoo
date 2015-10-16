# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1 eutils git-2 linux-info user

DESCRIPTION="Cinder is the OpenStack Block storage service, a spin out of nova-volumes"
HOMEPAGE="https://launchpad.net/cinder"
EGIT_REPO_URI="https://github.com/openstack/cinder.git"
EGIT_BRANCH="stable/liberty"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="+api +scheduler +volume iscsi lvm mysql +memcached postgres sqlite test"
REQUIRED_USE="|| ( mysql postgres sqlite )"

CDEPEND=">=dev-python/pbr-1.6[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	app-admin/sudo
	test? (
		${RDEPEND}
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		<=dev-python/coverage-4.0[${PYTHON_USEDEP}]
		>=dev-python/ddt-0.7.0[${PYTHON_USEDEP}]
		<=dev-python/ddt-1.0.0[${PYTHON_USEDEP}]
		~dev-python/fixtures-1.3.1[${PYTHON_USEDEP}]
		>=dev-python/mock-1.2[${PYTHON_USEDEP}]
		<=dev-python/mock-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/mox3-0.7.0[${PYTHON_USEDEP}]
		<=dev-python/mox3-0.10.0[${PYTHON_USEDEP}]
		>=dev-python/pymysql-0.6.2[${PYTHON_USEDEP}]
		<=dev-python/pymysql-0.6.6[${PYTHON_USEDEP}]
		>=dev-python/psycopg-2.5[${PYTHON_USEDEP}]
		<=dev-python/psycopg-2.6.1[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.10.0[${PYTHON_USEDEP}]
		<=dev-python/oslotest-1.11.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
		>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
		<=dev-python/subunit-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/testtools-1.4.0[${PYTHON_USEDEP}]
		<=dev-python/testtools-1.8.0[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		<=dev-python/testrepository-0.0.20[${PYTHON_USEDEP}]
		>=dev-python/testresources-0.2.4[${PYTHON_USEDEP}]
		<=dev-python/testresources-0.2.7-r9999[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		<=dev-python/testscenarios-0.5[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
		<=dev-python/oslo-sphinx-3.2.0[${PYTHON_USEDEP}]
		>=dev-python/os-testr-0.1.0[${PYTHON_USEDEP}]
		<=dev-python/os-testr-0.3.0[${PYTHON_USEDEP}]
		>=dev-python/tempest-lib-0.8.0[${PYTHON_USEDEP}]
		<=dev-python/tempest-lib-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/bandit-0.13.2[${PYTHON_USEDEP}]
		<=dev-python/bandit-0.13.2[${PYTHON_USEDEP}]
	)"

RDEPEND="
	${CDEPEND}
	~dev-python/anyjson-0.3.3[${PYTHON_USEDEP}]
	>=dev-python/Babel-1.3[${PYTHON_USEDEP}]
	<=dev-python/Babel-2.0[${PYTHON_USEDEP}]
	<=dev-python/enum34-1.0.4[$(python_gen_usedep 'python2_7')]
	>=dev-python/eventlet-0.17.4[${PYTHON_USEDEP}]
	<=dev-python/eventlet-0.17.4[${PYTHON_USEDEP}]
	>=dev-python/greenlet-0.3.2[${PYTHON_USEDEP}]
	<=dev-python/greenlet-0.4.9[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.9[${PYTHON_USEDEP}]
	<=dev-python/iso8601-0.1.10[${PYTHON_USEDEP}]
	>=dev-python/keystonemiddleware-2.0.0[${PYTHON_USEDEP}]
	<=dev-python/keystonemiddleware-2.3.1[${PYTHON_USEDEP}]
	>=dev-python/kombu-3.0.7[${PYTHON_USEDEP}]
	<=dev-python/kombu-3.0.26[${PYTHON_USEDEP}]
	>=dev-python/lxml-2.3[${PYTHON_USEDEP}]
	<=dev-python/lxml-3.4.4[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.12[${PYTHON_USEDEP}]
	!~dev-python/netaddr-0.7.16[${PYTHON_USEDEP}]
	<=dev-python/netaddr-0.7.18[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-2.3.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-config-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-2.3.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-concurrency-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-0.2.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-context-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-db-2.4.1[${PYTHON_USEDEP}]
	<=dev-python/oslo-db-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-1.8.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-log-1.11.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-messaging-1.16.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-1.17.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-1.17.1[${PYTHON_USEDEP}]
	<=dev-python/oslo-messaging-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-middleware-2.8.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-middleware-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-policy-0.5.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-policy-0.11.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-reports-0.1.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-reports-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-rootwrap-2.0.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-rootwrap-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.4.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-serialization-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-service-0.7.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-service-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-2.0.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-utils-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-versionedobjects-0.9.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-versionedobjects-0.10.0[${PYTHON_USEDEP}]
	~dev-python/osprofiler-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/paramiko-1.13.0[${PYTHON_USEDEP}]
	<=dev-python/paramiko-1.15.2[${PYTHON_USEDEP}]
	<=dev-python/paste-2.0.2[${PYTHON_USEDEP}]
	>=dev-python/pastedeploy-1.5.0[${PYTHON_USEDEP}]
	<=dev-python/pastedeploy-1.5.2[${PYTHON_USEDEP}]
	>=dev-python/pycrypto-2.6[${PYTHON_USEDEP}]
	<=dev-python/pycrypto-2.6.1[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.0.1[${PYTHON_USEDEP}]
	<=dev-python/pyparsing-2.0.3[${PYTHON_USEDEP}]
	~dev-python/python-barbicanclient-3.3.0[${PYTHON_USEDEP}]
	>=dev-python/python-glanceclient-0.18.0[${PYTHON_USEDEP}]
	<=dev-python/python-glanceclient-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/python-novaclient-2.28.1[${PYTHON_USEDEP}]
	<=dev-python/python-novaclient-2.30.1[${PYTHON_USEDEP}]
	>=dev-python/python-swiftclient-2.2.0[${PYTHON_USEDEP}]
	<=dev-python/python-swiftclient-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.5.2[${PYTHON_USEDEP}]
	<=dev-python/requests-2.7.0[${PYTHON_USEDEP}]
	>=dev-python/retrying-1.2.3[${PYTHON_USEDEP}]
	!~dev-python/retrying-1.3.0[${PYTHON_USEDEP}]
	<=dev-python/retrying-1.3.3[${PYTHON_USEDEP}]
	>=dev-python/routes-1.12.3[${PYTHON_USEDEP}]
	!~dev-python/routes-2.0[${PYTHON_USEDEP}]
	!~dev-python/routes-2.1[$(python_gen_usedep 'python2_7')]
	<=dev-python/routes-2.2[${PYTHON_USEDEP}]
	>=dev-python/taskflow-1.16.0[${PYTHON_USEDEP}]
	<=dev-python/taskflow-1.21.0[${PYTHON_USEDEP}]
	>=dev-python/rtslib-fb-2.1.41[${PYTHON_USEDEP}]
	<=dev-python/rtslib-fb-2.1.57[${PYTHON_USEDEP}]
	~dev-python/six-1.9.0[${PYTHON_USEDEP}]
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
	~dev-python/suds-0.6[${PYTHON_USEDEP}]
	>=dev-python/webob-1.2.3-r1[${PYTHON_USEDEP}]
	<=dev-python/webob-1.4.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-1.5.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-i18n-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-vmware-0.16.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-vmware-1.21.0[${PYTHON_USEDEP}]
	>=dev-python/os-brick-0.4.0[${PYTHON_USEDEP}]
	<=dev-python/os-brick-0.5.0[${PYTHON_USEDEP}]
	iscsi? (
		sys-block/tgt
		sys-block/open-iscsi
	)
	lvm? ( sys-fs/lvm2 )
	memcached? ( net-misc/memcached )
	app-emulation/qemu
	sys-fs/sysfsutils"
# qemu is needed for image conversion

PATCHES=(

)

pkg_setup() {
	linux-info_pkg_setup
	CONFIG_CHECK_MODULES="ISCSI_TCP"
	if linux_config_exists; then
		for module in ${CONFIG_CHECK_MODULES}; do
			linux_chkconfig_present ${module} || ewarn "${module} needs to be built as module (builtin doesn't work)"
		done
	fi
	enewgroup cinder
	enewuser cinder -1 -1 /var/lib/cinder cinder
}

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}

python_compile() {
		distutils-r1_python_compile
		mv cinder/test.py cinder/test.py.bak || die
		./tools/config/generate_sample.sh -b ./ -p cinder -o etc/cinder || die
		mv cinder/test.py.bak cinder/test.py || die
}

python_test() {
	# Let's track progress of this # https://bugs.launchpad.net/swift/+bug/1249727
	nosetests -I test_wsgi.py cinder/tests/ || die "tests failed under python2.7"
}

python_install() {
	distutils-r1_python_install
	keepdir /etc/cinder
	dodir /etc/cinder/rootwrap.d

	for svc in api scheduler volume; do
		newinitd "${FILESDIR}/cinder.initd" cinder-${svc}
	done

	insinto /etc/cinder
	insopts -m0640 -o cinder -g cinder
	newins "${S}/etc/cinder/cinder.conf.sample" "cinder.conf"
	newins "${S}/etc/cinder/api-paste.ini" "api-paste.ini"
	newins "${S}/etc/cinder/logging_sample.conf" "logging_sample.conf"
	newins "${S}/etc/cinder/policy.json" "policy.json"
	newins "${S}/etc/cinder/rootwrap.conf" "rootwrap.conf"
	insinto /etc/cinder/rootwrap.d
	newins "${S}/etc/cinder/rootwrap.d/volume.filters" "volume.filters"

	dodir /var/log/cinder
	fowners cinder:cinder /var/log/cinder

	#add sudoers definitions for user nova
	insinto /etc/sudoers.d/
	insopts -m 0440 -o root -g root
	newins "${FILESDIR}/cinder.sudoersd" cinder
}

pkg_postinst() {
	if use iscsi ; then
		elog "Cinder needs tgtd to be installed and running to work with iscsi"
		elog "it also needs 'include /var/lib/cinder/volumes/*' in /etc/tgt/targets.conf"
	fi
}
