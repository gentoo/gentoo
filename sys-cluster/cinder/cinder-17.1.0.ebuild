# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_7 python3_8 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 eutils linux-info

DESCRIPTION="Cinder is the OpenStack Block storage service, a spin out of nova-volumes"
HOMEPAGE="https://launchpad.net/cinder"

if [[ ${PV} == *9999 ]];then
	inherit git-r3
	SRC_URI="https://dev.gentoo.org/~prometheanfire/dist/openstack/cinder/victoria/cinder.conf.sample -> cinder.conf.sample-${PV}"
	EGIT_REPO_URI="https://github.com/openstack/cinder.git"
	EGIT_BRANCH="stable/victoria"
else
	SRC_URI="https://dev.gentoo.org/~prometheanfire/dist/openstack/cinder/victoria/cinder.conf.sample -> cinder.conf.sample-${PV}
	https://tarballs.openstack.org/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+api +scheduler +volume infiniband iscsi lvm mysql +memcached postgres rdma sqlite +tcp test +tgt"
RESTRICT="!test? ( test )"
REQUIRED_USE="|| ( mysql postgres sqlite ) iscsi? ( tgt ) infiniband? ( rdma )"

DEPEND=">=dev-python/pbr-5.4.1[${PYTHON_USEDEP}]
	app-admin/sudo"

#	>=dev-python/oauth2client-1.5.0[${PYTHON_USEDEP}]  # do not include, upstream depricated
RDEPEND="
	>=dev-python/pbr-5.4.1[${PYTHON_USEDEP}]
	>=dev-python/decorator-4.1.0[${PYTHON_USEDEP}]
	>=dev-python/eventlet-0.26.0[${PYTHON_USEDEP}]
	>=dev-python/greenlet-0.4.15[${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.9.1[${PYTHON_USEDEP}]
	>=dev-python/importlib_metadata-1.7.0[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.12[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth-3.14.0[${PYTHON_USEDEP}]
	>=dev-python/keystonemiddleware-4.21.0[${PYTHON_USEDEP}]
	>=dev-python/lxml-4.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-6.11.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-3.26.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-2.23.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-db-6.0.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-3.44.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-messaging-6.4.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-middleware-3.31.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-policy-1.44.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-privsep-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-reports-1.18.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-rootwrap-5.8.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-2.25.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-service-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-upgradecheck-0.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.40.2[${PYTHON_USEDEP}]
	>=dev-python/oslo-versionedobjects-1.31.2[${PYTHON_USEDEP}]
	>=dev-python/osprofiler-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-20.4[${PYTHON_USEDEP}]
	>=dev-python/paramiko-2.7.1[${PYTHON_USEDEP}]
	>=dev-python/paste-2.0.2[${PYTHON_USEDEP}]
	>=dev-python/pastedeploy-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/psutil-3.2.2[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.2.1[${PYTHON_USEDEP}]
	>=dev-python/python-barbicanclient-4.9.0[${PYTHON_USEDEP}]
	>=dev-python/python-glanceclient-2.15.0[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-3.15.0[${PYTHON_USEDEP}]
	>=dev-python/python-novaclient-9.1.0[${PYTHON_USEDEP}]
	>=dev-python/python-swiftclient-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/pytz-2015.7[${PYTHON_USEDEP}]
	>=dev-python/requests-2.18.0[${PYTHON_USEDEP}]
	!~dev-python/requests-2.20.0[${PYTHON_USEDEP}]
	>=dev-python/routes-2.3.1[${PYTHON_USEDEP}]
	>=dev-python/taskflow-3.8.0[${PYTHON_USEDEP}]
	>=dev-python/rtslib-fb-2.1.65[${PYTHON_USEDEP}]
	>=dev-python/six-1.11.0[${PYTHON_USEDEP}]
	sqlite? (
		>=dev-python/sqlalchemy-1.3.0[sqlite,${PYTHON_USEDEP}]
	)
	mysql? (
		>=dev-python/pymysql-0.7.6[${PYTHON_USEDEP}]
		!~dev-python/pymysql-0.7.7[${PYTHON_USEDEP}]
		>=dev-python/sqlalchemy-1.3.0[sqlite,${PYTHON_USEDEP}]
	)
	postgres? (
		>=dev-python/psycopg-2.5.0[${PYTHON_USEDEP}]
		>=dev-python/sqlalchemy-1.3.0[sqlite,${PYTHON_USEDEP}]
	)
	>=dev-python/sqlalchemy-migrate-0.13.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.31.0[${PYTHON_USEDEP}]
	>=dev-python/tabulate-0.8.5[${PYTHON_USEDEP}]
	>=dev-python/tenacity-6.1.0[${PYTHON_USEDEP}]
	>=dev-python/webob-1.7.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.24.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-vmware-2.35.0[${PYTHON_USEDEP}]
	>=dev-python/os-brick-4.0.1[${PYTHON_USEDEP}]
	>=dev-python/os-win-4.2.0[${PYTHON_USEDEP}]
	>=dev-python/tooz-1.58.0[${PYTHON_USEDEP}]
	>=dev-python/google-api-python-client-1.4.2[${PYTHON_USEDEP}]
	>=dev-python/castellan-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/cryptography-2.1.4[${PYTHON_USEDEP}]
	>=dev-python/cursive-0.2.1[${PYTHON_USEDEP}]
	>=dev-python/zstd-1.4.5.0[${PYTHON_USEDEP}]
	iscsi? (
		tgt? ( sys-block/tgt )
		sys-block/open-iscsi
	)
	lvm? ( sys-fs/lvm2 )
	memcached? ( net-misc/memcached )
	app-emulation/qemu
	sys-fs/sysfsutils
	acct-user/cinder
	acct-group/cinder"
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

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	# only used for docs
	sed -i '/^sphinx-feature-classification/d' requirements.txt || die
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
	doins "etc/cinder/resource_filters.json"
	newins "${DISTDIR}/cinder.conf.sample-${PV}" "cinder.conf.sample"
	insinto /etc/cinder/rootwrap.d
	doins "etc/cinder/rootwrap.d/volume.filters"

	dodir /var/log/cinder
	fowners cinder:cinder /var/log/cinder

	#add sudoers definitions for user nova
	insinto /etc/sudoers.d/
	insopts -m 0440 -o root -g root
	newins "${FILESDIR}/cinder.sudoersd" cinder
	# stupid python
	rm -r "${ED}"/usr/etc
}

pkg_postinst() {
	if use iscsi ; then
		elog "Cinder needs tgtd to be installed and running to work with iscsi"
		elog "it also needs 'include /var/lib/cinder/volumes/*' in /etc/tgt/targets.conf"
	fi
}
