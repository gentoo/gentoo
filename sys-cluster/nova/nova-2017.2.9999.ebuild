# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1 eutils git-r3 linux-info multilib user

DESCRIPTION="Cloud computing fabric controller (main part of an IaaS system) in Python"
HOMEPAGE="https://launchpad.net/nova"
SRC_URI="https://dev.gentoo.org/~prometheanfire/dist/openstack/nova/pike/nova.conf.sample -> nova.conf.sample-${PV}"
EGIT_REPO_URI="https://github.com/openstack/nova.git"
EGIT_BRANCH="stable/pike"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="+compute compute-only iscsi +memcached mysql +novncproxy openvswitch postgres +rabbitmq sqlite"
REQUIRED_USE="
	!compute-only? ( || ( mysql postgres sqlite ) )
	compute-only? ( compute !rabbitmq !memcached !mysql !postgres !sqlite )"

CDEPEND="
	>=dev-python/setuptools-16.0[${PYTHON_USEDEP}]
	!~dev-python/setuptools-24.0.0[${PYTHON_USEDEP}]
	!~dev-python/setuptools-34.0.0[${PYTHON_USEDEP}]
	!~dev-python/setuptools-34.0.1[${PYTHON_USEDEP}]
	!~dev-python/setuptools-34.0.2[${PYTHON_USEDEP}]
	!~dev-python/setuptools-34.0.3[${PYTHON_USEDEP}]
	!~dev-python/setuptools-34.1.0[${PYTHON_USEDEP}]
	!~dev-python/setuptools-34.1.1[${PYTHON_USEDEP}]
	!~dev-python/setuptools-34.2.0[${PYTHON_USEDEP}]
	!~dev-python/setuptools-34.3.0[${PYTHON_USEDEP}]
	!~dev-python/setuptools-34.3.1[${PYTHON_USEDEP}]
	!~dev-python/setuptools-34.3.2[${PYTHON_USEDEP}]
	!~dev-python/setuptools-36.2.0[${PYTHON_USEDEP}]
	>=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0"
DEPEND="
	${CDEPEND}
	app-admin/sudo"

RDEPEND="
	${CDEPEND}
	compute-only? (
		>=dev-python/sqlalchemy-1.0.10[${PYTHON_USEDEP}]
		!~dev-python/sqlalchemy-1.1.5[sqlite,${PYTHON_USEDEP}]
		!~dev-python/sqlalchemy-1.1.6[sqlite,${PYTHON_USEDEP}]
		!~dev-python/sqlalchemy-1.1.7[sqlite,${PYTHON_USEDEP}]
		!~dev-python/sqlalchemy-1.1.8[sqlite,${PYTHON_USEDEP}]
	)
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
	>=dev-python/decorator-3.4.0[${PYTHON_USEDEP}]
	>=dev-python/eventlet-0.18.4[${PYTHON_USEDEP}]
	!~dev-python/eventlet-0.20.1[${PYTHON_USEDEP}]
	<dev-python/eventlet-0.21.0[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.8[${PYTHON_USEDEP}]
	!~dev-python/jinja-2.9.0[${PYTHON_USEDEP}]
	!~dev-python/jinja-2.9.1[${PYTHON_USEDEP}]
	!~dev-python/jinja-2.9.2[${PYTHON_USEDEP}]
	!~dev-python/jinja-2.9.3[${PYTHON_USEDEP}]
	!~dev-python/jinja-2.9.4[${PYTHON_USEDEP}]
	>=dev-python/keystonemiddleware-4.12.0[${PYTHON_USEDEP}]
	>=dev-python/lxml-2.3[${PYTHON_USEDEP}]
	!~dev-python/lxml-3.7.0[${PYTHON_USEDEP}]
	>=dev-python/routes-2.3.1[${PYTHON_USEDEP}]
	>=dev-python/cryptography-1.6.0[${PYTHON_USEDEP}]
	!~dev-python/cryptography-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/webob-1.7.1[${PYTHON_USEDEP}]
	>=dev-python/greenlet-0.3.2[${PYTHON_USEDEP}]
	>=dev-python/pastedeploy-1.5.0-r1[${PYTHON_USEDEP}]
	dev-python/paste[${PYTHON_USEDEP}]
	>=dev-python/prettytable-0.7.1[${PYTHON_USEDEP}]
	<dev-python/prettytable-0.8[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-migrate-0.11.0[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.13[${PYTHON_USEDEP}]
	!~dev-python/netaddr-0.7.16[${PYTHON_USEDEP}]
	>=dev-python/netifaces-0.10.4[${PYTHON_USEDEP}]
	>=dev-python/paramiko-2.0[${PYTHON_USEDEP}]
	>=dev-python/Babel-2.3.4[${PYTHON_USEDEP}]
	!~dev-python/Babel-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.11[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/jsonschema-2.5.0[${PYTHON_USEDEP}]
	<dev-python/jsonschema-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-cinderclient-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/python-neutronclient-6.3.0[${PYTHON_USEDEP}]
	>=dev-python/python-glanceclient-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.14.2[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]
	>=dev-python/websockify-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-cache-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-3.8.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-4.0.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-config-4.3.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-config-4.4.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-2.14.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-3.22.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-reports-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.10.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-serialization-2.19.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.20.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-db-4.24.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-rootwrap-5.0.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-messaging-5.24.2[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-5.25.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-policy-1.23.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-privsep-1.9.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-privsep-1.17.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-2.1.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-i18n-3.15.2[${PYTHON_USEDEP}]
	>=dev-python/oslo-service-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/rfc3986-0.3.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-middleware-3.27.0[${PYTHON_USEDEP}]
	>=dev-python/psutil-3.2.2[${PYTHON_USEDEP}]
	>=dev-python/oslo-versionedobjects-1.17.0[${PYTHON_USEDEP}]
	>=dev-python/os-brick-1.15.2[${PYTHON_USEDEP}]
	>=dev-python/os-traits-0.3.1[${PYTHON_USEDEP}]
	>=dev-python/os-vif-1.7.0[${PYTHON_USEDEP}]
	>=dev-python/os-win-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/castellan-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/microversion-parse-0.1.2[${PYTHON_USEDEP}]
	>=dev-python/os-xenapi-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/tooz-1.47.0[${PYTHON_USEDEP}]
	>=dev-python/cursive-0.1.2[${PYTHON_USEDEP}]
	>=dev-python/pypowervm-1.1.6[${PYTHON_USEDEP}]
	dev-python/libvirt-python[${PYTHON_USEDEP}]
	app-emulation/libvirt[iscsi?]
	novncproxy? ( www-apps/novnc )
	sys-apps/iproute2
	openvswitch? ( net-misc/openvswitch )
	rabbitmq? ( net-misc/rabbitmq-server )
	memcached? (
		net-misc/memcached
		>=dev-python/python-memcached-1.58
	)
	sys-fs/sysfsutils
	sys-fs/multipath-tools
	net-misc/bridge-utils
	compute? (
		app-cdr/cdrtools
		sys-fs/dosfstools
		app-emulation/qemu
	)
	iscsi? (
		sys-fs/lsscsi
		>=sys-block/open-iscsi-2.0.873-r1
	)"

#PATCHES=(
#)

pkg_setup() {
	linux-info_pkg_setup
	CONFIG_CHECK_MODULES="BLK_DEV_NBD VHOST_NET IP6_NF_FILTER IP6_NF_IPTABLES IP_NF_TARGET_REJECT \
	IP_NF_MANGLE IP_NF_TARGET_MASQUERADE NF_NAT_IPV4 IP_NF_FILTER IP_NF_IPTABLES \
	NF_CONNTRACK_IPV4 NF_DEFRAG_IPV4 NF_NAT_IPV4 NF_NAT NF_CONNTRACK NETFILTER_XTABLES \
	ISCSI_TCP SCSI_DH DM_MULTIPATH DM_SNAPSHOT"
	if linux_config_exists; then
		for module in ${CONFIG_CHECK_MODULES}; do
			linux_chkconfig_present ${module} || ewarn "${module} needs to be enabled in kernel"
		done
	fi
	enewgroup nova
	enewuser nova -1 -1 /var/lib/nova nova
}

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	if use !compute-only; then
		for svc in api conductor consoleauth network scheduler spicehtml5proxy xvpvncproxy; do
			newinitd "${FILESDIR}/nova.initd" "nova-${svc}"
		done
	fi
	use compute && newinitd "${FILESDIR}/nova.initd" "nova-compute"
	use novncproxy && newinitd "${FILESDIR}/nova.initd" "nova-novncproxy"

	diropts -m 0750 -o nova -g qemu
	dodir /var/log/nova /var/lib/nova/instances
	diropts -m 0750 -o nova -g nova

	insinto /etc/nova
	insopts -m 0640 -o nova -g nova
	newins "${DISTDIR}/nova.conf.sample-${PV}" "nova.conf.sample"
	doins "${FILESDIR}/nova-compute.conf"
	doins "${S}/etc/nova/"*
	# rootwrap filters
	insopts -m 0644
	insinto /etc/nova/rootwrap.d
	doins "etc/nova/rootwrap.d/api-metadata.filters"
	doins "etc/nova/rootwrap.d/compute.filters"
	doins "etc/nova/rootwrap.d/network.filters"

	# add sudoers definitions for user nova
	insinto /etc/sudoers.d/
	insopts -m 0600 -o root -g root
	doins "${FILESDIR}/nova-sudoers"

	if use iscsi ; then
		# Install udev rules for handle iscsi disk with right links under /dev
		udev_newrules "${FILESDIR}/openstack-scsi-disk.rules" 60-openstack-scsi-disk.rules

		insinto /etc/nova/
		doins "${FILESDIR}/scsi-openscsi-link.sh"
	fi
}

python_install() {
	distutils-r1_python_install
	# copy migration conf file (not coppied on install via setup.py script)
	insinto "$(python_get_sitedir)/db/sqlalchemy/migrate_repo/"
	doins "nova/db/sqlalchemy/migrate_repo/migrate.cfg"
	# copy the CA cert dir (not coppied on install via setup.py script)
	cp -R "${S}/nova/CA" "${D}/$(python_get_sitedir)/nova/" || die "installing CA files failed"
}

pkg_postinst() {
	if use iscsi ; then
		elog "iscsid needs to be running if you want cinder to connect"
	fi
}
