# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )
# still no 34 :( https://bugs.launchpad.net/neutron/+bug/1630439

inherit distutils-r1 linux-info user

DESCRIPTION="A virtual network service for Openstack"
HOMEPAGE="https://launchpad.net/neutron"
if [[ ${PV} == *9999 ]];then
	inherit git-r3
	SRC_URI="https://dev.gentoo.org/~prometheanfire/dist/openstack/neutron/train/configs.tar.gz -> neutron-configs-${PV}.tar.gz
	https://dev.gentoo.org/~prometheanfire/dist/openstack/neutron/train/ml2_plugins.tar.gz -> neutron-ml2-plugins-${PV}.tar.gz"
	EGIT_REPO_URI="https://github.com/openstack/neutron.git"
	EGIT_BRANCH="stable/train"
else
	SRC_URI="https://dev.gentoo.org/~prometheanfire/dist/openstack/neutron/train/configs.tar.gz -> neutron-configs-${PV}.tar.gz
	https://dev.gentoo.org/~prometheanfire/dist/openstack/neutron/train/ml2_plugins.tar.gz -> neutron-ml2-plugins-${PV}.tar.gz
	https://tarballs.openstack.org/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="compute-only dhcp haproxy ipv6 l3 metadata openvswitch linuxbridge server sqlite +mysql postgres"
REQUIRED_USE="!compute-only? ( || ( mysql postgres sqlite ) )
						compute-only? ( !mysql !postgres !sqlite !dhcp !l3 !metadata !server
						|| ( openvswitch linuxbridge ) )"

CDEPEND=">=dev-python/pbr-4.0.0[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	app-admin/sudo"

RDEPEND="
	${CDEPEND}
	>=dev-python/paste-2.0.2[${PYTHON_USEDEP}]
	>=dev-python/pastedeploy-1.5.0-r1[${PYTHON_USEDEP}]
	>=dev-python/routes-2.3.1[${PYTHON_USEDEP}]
	>=dev-python/debtcollector-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/decorator-3.4.0[${PYTHON_USEDEP}]
	>=dev-python/eventlet-0.18.4[${PYTHON_USEDEP}]
	!~dev-python/eventlet-0.20.1[${PYTHON_USEDEP}]
	>=dev-python/pecan-1.3.2[${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.9.1[${PYTHON_USEDEP}]
	>=dev-python/requests-2.14.2[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.10[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.18[${PYTHON_USEDEP}]
	>=dev-python/netifaces-0.10.4[${PYTHON_USEDEP}]
	>=dev-python/neutron-lib-1.29.1[${PYTHON_USEDEP}]
	>=dev-python/python-neutronclient-6.3.0[${PYTHON_USEDEP}]
	>=dev-python/tenacity-3.2.1[${PYTHON_USEDEP}]
	compute-only? (
		>=dev-python/sqlalchemy-1.2.0[${PYTHON_USEDEP}]
	)
	sqlite? (
		>=dev-python/sqlalchemy-1.2.0[sqlite,${PYTHON_USEDEP}]
	)
	mysql? (
		>=dev-python/pymysql-0.7.6[${PYTHON_USEDEP}]
		!~dev-python/pymysql-0.7.7[${PYTHON_USEDEP}]
		>=dev-python/sqlalchemy-1.2.0[${PYTHON_USEDEP}]
	)
	postgres? (
		>=dev-python/psycopg-2.5.0[${PYTHON_USEDEP}]
		>=dev-python/sqlalchemy-1.2.0[${PYTHON_USEDEP}]
	)
	>=dev-python/webob-1.8.2[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth-3.4.0[${PYTHON_USEDEP}]
	>=dev-python/alembic-0.8.10[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-cache-1.26.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-3.26.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-5.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-2.19.2[${PYTHON_USEDEP}]
	>=dev-python/oslo-db-4.37.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.15.3[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-3.36.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-messaging-5.29.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-middleware-3.31.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-policy-1.30.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-privsep-1.32.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-reports-1.18.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-rootwrap-5.8.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.18.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-serialization-2.19.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-service-1.24.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-service-1.28.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-upgradecheck-0.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.33.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-versionedobjects-1.35.1[${PYTHON_USEDEP}]
	>=dev-python/osprofiler-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/os-ken-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/ovs-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/ovsdbapp-0.9.1[${PYTHON_USEDEP}]
	>=dev-python/psutil-3.2.2[${PYTHON_USEDEP}]
	>=dev-python/pyroute2-0.5.3[${PYTHON_USEDEP}]
	>=dev-python/python-novaclient-9.1.0[${PYTHON_USEDEP}]
	>=dev-python/openstacksdk-0.31.2[${PYTHON_USEDEP}]
	>=dev-python/python-designateclient-2.7.0[${PYTHON_USEDEP}]
	>=dev-python/os-xenapi-0.3.1[${PYTHON_USEDEP}]
	>=dev-python/os-vif-1.15.1[${PYTHON_USEDEP}]
	dev-python/pyudev[${PYTHON_USEDEP}]
	sys-apps/iproute2
	net-misc/iputils[arping]
	net-misc/bridge-utils
	net-firewall/ipset
	net-firewall/iptables
	net-firewall/ebtables
	net-firewall/conntrack-tools
	haproxy? ( net-proxy/haproxy )
	openvswitch? ( net-misc/openvswitch )
	ipv6? (
		net-misc/radvd
		>=net-misc/dibbler-1.0.1
	)
	dhcp? ( net-dns/dnsmasq[dhcp-tools] )"

#PATCHES=(
#)

pkg_pretend() {
	linux-info_pkg_setup
	CONFIG_CHECK_MODULES="VLAN_8021Q IP6_NF_FILTER IP6_NF_IPTABLES IP_NF_TARGET_REJECT \
	IP_NF_MANGLE IP_NF_TARGET_MASQUERADE NF_NAT_IPV4 NF_CONNTRACK_IPV4 NF_DEFRAG_IPV4 \
	NF_NAT_IPV4 NF_NAT NF_CONNTRACK IP_NF_FILTER IP_NF_IPTABLES NETFILTER_XTABLES"
	if linux_config_exists; then
		for module in ${CONFIG_CHECK_MODULES}; do
			linux_chkconfig_present ${module} || ewarn "${module} needs to be enabled in kernel"
		done
	fi
}

pkg_setup() {
	enewgroup neutron
	enewuser neutron -1 -1 /var/lib/neutron neutron
}

pkg_config() {
	fperms 0700 /var/log/neutron
	fowners neutron:neutron /var/log neutron
}

src_prepare() {
	sed -i '/^hacking/d' test-requirements.txt || die
	# it's /bin/ip not /sbin/ip
	sed -i 's/sbin\/ip\,/bin\/ip\,/g' etc/neutron/rootwrap.d/* || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
	if use server; then
		newinitd "${FILESDIR}/neutron.initd" "neutron-server"
		newconfd "${FILESDIR}/neutron-server.confd" "neutron-server"
		dosym /etc/neutron/plugin.ini /etc/neutron/plugins/ml2/ml2_conf.ini
	fi
	if use dhcp; then
		newinitd "${FILESDIR}/neutron.initd" "neutron-dhcp-agent"
		newconfd "${FILESDIR}/neutron-dhcp-agent.confd" "neutron-dhcp-agent"
	fi
	if use l3; then
		newinitd "${FILESDIR}/neutron.initd" "neutron-l3-agent"
		newconfd "${FILESDIR}/neutron-l3-agent.confd" "neutron-l3-agent"
	fi
	if use metadata; then
		newinitd "${FILESDIR}/neutron.initd" "neutron-metadata-agent"
		newconfd "${FILESDIR}/neutron-metadata-agent.confd" "neutron-metadata-agent"
	fi
	if use openvswitch; then
		newinitd "${FILESDIR}/neutron.initd" "neutron-openvswitch-agent"
		newconfd "${FILESDIR}/neutron-openvswitch-agent.confd" "neutron-openvswitch-agent"
		newinitd "${FILESDIR}/neutron.initd" "neutron-ovs-cleanup"
		newconfd "${FILESDIR}/neutron-openvswitch-agent.confd" "neutron-ovs-cleanup"
	fi
	if use linuxbridge; then
		newinitd "${FILESDIR}/neutron.initd" "neutron-linuxbridge-agent"
		newconfd "${FILESDIR}/neutron-linuxbridge-agent.confd" "neutron-linuxbridge-agent"
	fi
	diropts -m 755 -o neutron -g neutron
	dodir /var/log/neutron /var/lib/neutron
	keepdir /etc/neutron
	insinto /etc/neutron
	insopts -m 0640 -o neutron -g neutron

	doins etc/*
	# stupid renames
	insinto /etc/neutron
	doins -r "etc/neutron/plugins"
	insopts -m 0640 -o root -g root
	doins "etc/rootwrap.conf"
	doins -r "etc/neutron/rootwrap.d"

	#add sudoers definitions for user neutron
	insinto /etc/sudoers.d/
	insopts -m 0440 -o root -g root
	newins "${FILESDIR}/neutron.sudoersd" neutron

	# add generated configs
	cd "${D}/etc/neutron" || die
	unpack "neutron-configs-${PV}.tar.gz"
	cd "${D}/etc/neutron/plugins/ml2" || die
	unpack "neutron-ml2-plugins-${PV}.tar.gz"

	# correcting perms
	fowners neutron:neutron -R "/etc/neutron"
	fperms o-rwx -R "/etc/neutron/"

	#remove superfluous stuff
	rm -R "${D}/usr/etc/"
}

python_install() {
	distutils-r1_python_install
	# copy migration conf file (not coppied on install via setup.py script)
	python_moduleinto neutron/db/migration/alembic_migrations
	python_domodule "neutron/db/migration/alembic_migrations/versions"
}

pkg_postinst() {
	elog
	elog "neutron-server's conf.d file may need updating to include additional ini files"
	elog "We currently assume the ml2 plugin will be used but do not make assumptions"
	elog "on if you will use openvswitch or linuxbridge (or something else)"
	elog
	elog "Other conf.d files may need updating too, but should be good for the default use case"
	elog
}
