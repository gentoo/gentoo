# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/nova/nova-2015.1.9999.ebuild,v 1.13 2015/06/17 21:10:37 prometheanfire Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils git-2 linux-info multilib udev user

DESCRIPTION="A cloud computing fabric controller (main part of an IaaS system) written in Python"
HOMEPAGE="https://launchpad.net/nova"
EGIT_REPO_URI="https://github.com/openstack/nova.git"
EGIT_BRANCH="stable/kilo"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="+compute compute-only +kvm +memcached +novncproxy openvswitch +rabbitmq sqlite mysql postgres xen iscsi"
REQUIRED_USE="!compute-only? ( || ( mysql postgres sqlite ) )
						compute-only? ( compute !rabbitmq !memcached !mysql !postgres !sqlite )
						compute? ( ^^ ( kvm xen ) )"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/pbr-0.8[${PYTHON_USEDEP}]
		<dev-python/pbr-1.0[${PYTHON_USEDEP}]
		app-admin/sudo"

# barbicanclient is in here for doc generation
RDEPEND="
	compute-only? (
		>=dev-python/sqlalchemy-0.9.7[${PYTHON_USEDEP}]
		<=dev-python/sqlalchemy-0.9.99[${PYTHON_USEDEP}]
	)
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
	>=dev-python/boto-2.32.1[${PYTHON_USEDEP}]
	>=dev-python/decorator-3.4.0[${PYTHON_USEDEP}]
	>=dev-python/eventlet-0.16.1[${PYTHON_USEDEP}]
	!~dev-python/eventlet-0.17.0[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.6[${PYTHON_USEDEP}]
	>=dev-python/keystonemiddleware-1.5.0[${PYTHON_USEDEP}]
	<dev-python/keystonemiddleware-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/lxml-2.3[${PYTHON_USEDEP}]
	>=dev-python/routes-1.12.3-r1[${PYTHON_USEDEP}]
	!~dev-python/routes-2.0[${PYTHON_USEDEP}]
	>=dev-python/webob-1.2.3[${PYTHON_USEDEP}]
	>=dev-python/greenlet-0.3.2[${PYTHON_USEDEP}]
	>=dev-python/pastedeploy-1.5.0-r1[${PYTHON_USEDEP}]
	dev-python/paste[${PYTHON_USEDEP}]
	~dev-python/sqlalchemy-migrate-0.9.5[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.12[${PYTHON_USEDEP}]
	>=dev-python/paramiko-1.13.0[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
	>=dev-python/Babel-1.3[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.9[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.0.0[${PYTHON_USEDEP}]
	<dev-python/jsonschema-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-cinderclient-1.1.0[${PYTHON_USEDEP}]
	<dev-python/python-cinderclient-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/python-neutronclient-2.3.11[${PYTHON_USEDEP}]
	<dev-python/python-neutronclient-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/python-glanceclient-0.15.0[${PYTHON_USEDEP}]
	<dev-python/python-glanceclient-0.18.0[${PYTHON_USEDEP}]
	>=dev-python/python-barbicanclient-3.0.1[${PYTHON_USEDEP}]
	<dev-python/python-barbicanclient-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.3.0[${PYTHON_USEDEP}]
	<dev-python/stevedore-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/websockify-0.6.0[${PYTHON_USEDEP}]
	<dev-python/websockify-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-1.8.0[${PYTHON_USEDEP}]
	<dev-python/oslo-concurrency-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-1.9.3[${PYTHON_USEDEP}]
	<dev-python/oslo-config-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-0.2.0[${PYTHON_USEDEP}]
	<dev-python/oslo-context-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-1.0.0[${PYTHON_USEDEP}]
	<dev-python/oslo-log-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.4.0[${PYTHON_USEDEP}]
	<dev-python/oslo-serialization-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-1.4.0[${PYTHON_USEDEP}]
	<dev-python/oslo-utils-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-db-1.7.0[${PYTHON_USEDEP}]
	<dev-python/oslo-db-1.8.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-rootwrap-1.6.0[${PYTHON_USEDEP}]
	<dev-python/oslo-rootwrap-1.7.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-messaging-1.8.0[${PYTHON_USEDEP}]
	<dev-python/oslo-messaging-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-1.5.0[${PYTHON_USEDEP}]
	<dev-python/oslo-i18n-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/rfc3986-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-middleware-1.0.0[${PYTHON_USEDEP}]
	<dev-python/oslo-middleware-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/psutil-1.1.1[${PYTHON_USEDEP}]
	<dev-python/psutil-2.0.0[${PYTHON_USEDEP}]
	dev-python/libvirt-python[${PYTHON_USEDEP}]
	novncproxy? ( www-apps/novnc )
	sys-apps/iproute2
	openvswitch? ( net-misc/openvswitch )
	rabbitmq? ( net-misc/rabbitmq-server )
	memcached? ( net-misc/memcached )
	sys-fs/sysfsutils
	sys-fs/multipath-tools
	net-misc/bridge-utils
	compute? (
		app-cdr/cdrkit
		kvm? ( app-emulation/qemu )
		xen? ( app-emulation/xen
			   app-emulation/xen-tools )
	)
	iscsi? (
		sys-fs/lsscsi
	)"

PATCHES=(
)

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

python_prepare() {
	distutils-r1_python_prepare
	sed -i 's/python/python2\.7/g' tools/config/generate_sample.sh || die
}

python_compile() {
	distutils-r1_python_compile
	./tools/config/generate_sample.sh -b ./ -p nova -o etc/nova || die
}

python_install() {
	distutils-r1_python_install

	if use !compute-only; then
		for svc in api cert conductor consoleauth network scheduler spicehtml5proxy xvpvncproxy; do
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
	newins "etc/nova/nova.conf.sample" "nova.conf"
	doins "etc/nova/api-paste.ini"
	doins "etc/nova/logging_sample.conf"
	doins "etc/nova/policy.json"
	doins "etc/nova/rootwrap.conf"
	#rootwrap filters
	insinto /etc/nova/rootwrap.d
	doins "etc/nova/rootwrap.d/api-metadata.filters"
	doins "etc/nova/rootwrap.d/compute.filters"
	doins "etc/nova/rootwrap.d/network.filters"
	#copy migration conf file (not coppied on install via setup.py script)
	insopts -m 0644
	insinto /usr/$(get_libdir)/python2.7/site-packages/nova/db/sqlalchemy/migrate_repo/
	doins "nova/db/sqlalchemy/migrate_repo/migrate.cfg"
	#copy the CA cert dir (not coppied on install via setup.py script)
	cp -R "${S}/nova/CA" "${D}/usr/$(get_libdir)/python2.7/site-packages/nova/" || die "installing CA files failed"

	#add sudoers definitions for user nova
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
