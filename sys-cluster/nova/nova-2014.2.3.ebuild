# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/nova/nova-2014.2.3.ebuild,v 1.1 2015/04/13 03:31:07 prometheanfire Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils linux-info multilib user

DESCRIPTION="A cloud computing fabric controller (main part of an IaaS system) written in Python"
HOMEPAGE="https://launchpad.net/nova"
SRC_URI="http://launchpad.net/${PN}/juno/${PV}/+download/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+compute +kvm +network +novncproxy openvswitch sqlite mysql postgres xen"
REQUIRED_USE="|| ( mysql postgres sqlite )
			  compute? ( || ( kvm xen ) )"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/pbr-0.8[${PYTHON_USEDEP}]
		<dev-python/pbr-1.0[${PYTHON_USEDEP}]
		app-admin/sudo"

RDEPEND="
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
	>=dev-python/anyjson-0.3.3[${PYTHON_USEDEP}]
	>=dev-python/boto-2.32.1[${PYTHON_USEDEP}]
	<dev-python/boto-2.35.0[${PYTHON_USEDEP}]
	>=dev-python/decorator-3.4.0[${PYTHON_USEDEP}]
	>=dev-python/eventlet-0.15.1[${PYTHON_USEDEP}]
	<dev-python/eventlet-0.16.0[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	>=dev-python/keystonemiddleware-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/kombu-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/lxml-2.3[${PYTHON_USEDEP}]
	>=dev-python/routes-1.12.3-r1[${PYTHON_USEDEP}]
	!~dev-python/routes-2.0[${PYTHON_USEDEP}]
	>=dev-python/webob-1.2.3[${PYTHON_USEDEP}]
	>=dev-python/greenlet-0.3.2[${PYTHON_USEDEP}]
	>=dev-python/pastedeploy-1.5.0-r1[${PYTHON_USEDEP}]
	dev-python/paste[${PYTHON_USEDEP}]
	~dev-python/sqlalchemy-migrate-0.9.1[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.12[${PYTHON_USEDEP}]
	>=dev-python/suds-0.4[${PYTHON_USEDEP}]
	>=dev-python/paramiko-1.13.0[${PYTHON_USEDEP}]
	dev-python/posix_ipc[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
	>=dev-python/Babel-1.3[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.9[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.0.0[${PYTHON_USEDEP}]
	<dev-python/jsonschema-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-cinderclient-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/python-neutronclient-2.3.6[${PYTHON_USEDEP}]
	<=dev-python/python-neutronclient-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-glanceclient-0.14.0[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-0.10.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.7.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/websockify-0.6.0[${PYTHON_USEDEP}]
	<dev-python/websockify-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-db-1.0.0[${PYTHON_USEDEP}]
	<dev-python/oslo-db-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-rootwrap-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/pycadf-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-messaging-1.4.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-1.5.0[${PYTHON_USEDEP}]
	<dev-python/oslo-messaging-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/lockfile-0.8[${PYTHON_USEDEP}]
	>=dev-python/simplejson-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/rfc3986-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-vmware-0.6.0[${PYTHON_USEDEP}]
	<dev-python/oslo-vmware-0.9.0[${PYTHON_USEDEP}]
	dev-python/libvirt-python[${PYTHON_USEDEP}]
	novncproxy? ( www-apps/novnc )
	sys-apps/iproute2
	openvswitch? ( net-misc/openvswitch )
	net-misc/rabbitmq-server
	sys-fs/sysfsutils
	sys-fs/multipath-tools
	net-misc/bridge-utils
	kvm? ( app-emulation/qemu )
	xen? ( app-emulation/xen
		   app-emulation/xen-tools )"

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

python_compile() {
	distutils-r1_python_compile
	./tools/config/generate_sample.sh -b ./ -p nova -o etc/nova
}

python_install() {
	distutils-r1_python_install

	for svc in api cert compute conductor consoleauth network scheduler spicehtml5proxy xvpvncproxy; do
		newinitd "${FILESDIR}/nova.initd" "nova-${svc}"
	done
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
	insinto /usr/$(get_libdir)/python2.7/site-packages/nova/db/sqlalchemy/migrate_repo/
	doins "nova/db/sqlalchemy/migrate_repo/migrate.cfg"
	#copy the CA cert dir (not coppied on install via setup.py script)
	cp -R "${S}/nova/CA" "${D}/usr/$(get_libdir)/python2.7/site-packages/nova/" || die "installing CA files failed"

	#add sudoers definitions for user nova
	insinto /etc/sudoers.d/
	insopts -m 0600 -o root -g root
	doins "${FILESDIR}/nova-sudoers"
}
