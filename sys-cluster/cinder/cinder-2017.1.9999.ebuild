# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1 eutils git-r3 linux-info user

DESCRIPTION="Cinder is the OpenStack Block storage service, a spin out of nova-volumes"
HOMEPAGE="https://launchpad.net/cinder"
SRC_URI="https://dev.gentoo.org/~prometheanfire/dist/openstack/cinder/ocata/cinder.conf.sample -> ocata-cinder.conf.sample
https://dev.gentoo.org/~prometheanfire/dist/openstack/cinder/ocata/policy.json -> ocata-cinder-policy.json
https://dev.gentoo.org/~prometheanfire/dist/openstack/cinder/ocata/volume.filters -> ocata-cinder-volume.filters"
EGIT_REPO_URI="https://github.com/openstack/cinder.git"
EGIT_BRANCH="stable/ocata"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="+api +scheduler +volume infiniband iscsi lvm mysql +memcached postgres rdma sqlite +tcp test +tgt"
REQUIRED_USE="|| ( mysql postgres sqlite ) iscsi? ( tgt ) infiniband? ( rdma )"

CDEPEND=">=dev-python/pbr-1.8[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	app-admin/sudo"

RDEPEND="
	${CDEPEND}
	>=dev-python/Babel-2.3.4[${PYTHON_USEDEP}]
	>=dev-python/decorator-3.4.0[${PYTHON_USEDEP}]
	dev-python/enum34[$(python_gen_usedep 'python2_7')]
	>=dev-python/eventlet-0.18.4[${PYTHON_USEDEP}]
	>=dev-python/greenlet-0.3.2[${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.7.5[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.11[${PYTHON_USEDEP}]
	virtual/python-ipaddress[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth-2.18.0[${PYTHON_USEDEP}]
	>=dev-python/keystonemiddleware-4.12.0[${PYTHON_USEDEP}]
	>=dev-python/lxml-2.3[${PYTHON_USEDEP}]
	!~dev-python/lxml-3.7.0[${PYTHON_USEDEP}]
	>=dev-python/oauth2client-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-3.14.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-config-3.18.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-3.8.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-2.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-db-4.15.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-3.11.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-messaging-5.14.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-middleware-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-policy-1.17.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-privsep-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-reports-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-rootwrap-5.0.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-service-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.18.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-versionedobjects-1.17.0[${PYTHON_USEDEP}]
	>=dev-python/osprofiler-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/paramiko-2.0[${PYTHON_USEDEP}]
	dev-python/paste[${PYTHON_USEDEP}]
	>=dev-python/pastedeploy-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/psutil-3.0.1[${PYTHON_USEDEP}]
	>=dev-python/pycrypto-2.6[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/python-barbicanclient-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-glanceclient-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-3.8.0[${PYTHON_USEDEP}]
	>=dev-python/python-novaclient-6.0.0[${PYTHON_USEDEP}]
	!~dev-python/python-novaclient-7.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-swiftclient-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/pytz-2013.6[${PYTHON_USEDEP}]
	>=dev-python/requests-2.10.0[${PYTHON_USEDEP}]
	!~dev-python/requests-2.12.2[${PYTHON_USEDEP}]
	>=dev-python/retrying-1.2.3[${PYTHON_USEDEP}]
	!~dev-python/retrying-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/routes-1.12.3[${PYTHON_USEDEP}]
	!~dev-python/routes-2.0[${PYTHON_USEDEP}]
	!~dev-python/routes-2.1[$(python_gen_usedep 'python2_7')]
	!~dev-python/routes-2.3[${PYTHON_USEDEP}]
	>=dev-python/taskflow-2.7.0[${PYTHON_USEDEP}]
	>=dev-python/rtslib-fb-2.1.43[${PYTHON_USEDEP}]
	!~dev-python/rtslib-fb-2.1.60[${PYTHON_USEDEP}]
	!~dev-python/rtslib-fb-2.1.61[${PYTHON_USEDEP}]
	>=dev-python/simplejson-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	sqlite? (
		>=dev-python/sqlalchemy-1.0.10[sqlite,${PYTHON_USEDEP}]
		<dev-python/sqlalchemy-1.1.0[sqlite,${PYTHON_USEDEP}]
	)
	mysql? (
		>=dev-python/pymysql-0.7.6[${PYTHON_USEDEP}]
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
	>=dev-python/stevedore-1.17.1[${PYTHON_USEDEP}]
	~dev-python/suds-0.6[${PYTHON_USEDEP}]
	>=dev-python/webob-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-vmware-2.17.0[${PYTHON_USEDEP}]
	>=dev-python/os-brick-1.8.0[${PYTHON_USEDEP}]
	>=dev-python/os-win-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/tooz-1.47.0[${PYTHON_USEDEP}]
	>=dev-python/google-api-python-client-1.4.2[${PYTHON_USEDEP}]
	>=dev-python/castellan-0.4.0[${PYTHON_USEDEP}]
	iscsi? (
		tgt? ( sys-block/tgt )
		sys-block/open-iscsi
	)
	lvm? ( sys-fs/lvm2 )
	memcached? ( net-misc/memcached )
	app-emulation/qemu
	sys-fs/sysfsutils"
# qemu is needed for image conversion

#PATCHES=(
#)

pkg_pretend() {
	linux-info_pkg_setup
	CONFIG_CHECK_MODULES=""
	if use tcp; then
		CONFIG_CHECK_MODULES+="SCSI_ISCSI_ATTRS ISCSI_TCP "
	fi
	if use rdma; then
		CONFIG_CHECK_MODULES+="INFINIBAND_ISER "
	fi
	if use infiniband; then
		CONFIG_CHECK_MODULES+="INFINIBAND_IPOIB INFINIBAND_USER_MAD INFINIBAND_USER_ACCESS"
	fi
	if linux_config_exists; then
		for module in ${CONFIG_CHECK_MODULES}; do
			linux_chkconfig_present ${module} || ewarn "${module} needs to be enabled"
		done
	fi
}

pkg_setup() {
	enewgroup cinder
	enewuser cinder -1 -1 /var/lib/cinder cinder
}

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}

python_test() {
	# Let's track progress of this # https://bugs.launchpad.net/swift/+bug/1249727
	nosetests -I test_wsgi.py cinder/tests/ || die "tests failed under python2.7"
}

python_install_all() {
	distutils-r1_python_install_all
	keepdir /etc/cinder
	dodir /etc/cinder/rootwrap.d

	for svc in api scheduler volume; do
		newinitd "${FILESDIR}/cinder.initd" cinder-${svc}
	done

	insinto /etc/cinder
	insopts -m0640 -o cinder -g cinder
	doins "etc/cinder/api-httpd.conf"
	doins "etc/cinder/logging_sample.conf"
	doins "etc/cinder/rootwrap.conf"
	doins "etc/cinder/api-paste.ini"
	newins "${DISTDIR}/ocata-cinder-policy.json" "policy.json"
	newins "${DISTDIR}/ocata-cinder.conf.sample" "cinder.conf.sample"
	insinto /etc/cinder/rootwrap.d
	newins "${DISTDIR}/ocata-cinder-volume.filters" "volume.filters"

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
