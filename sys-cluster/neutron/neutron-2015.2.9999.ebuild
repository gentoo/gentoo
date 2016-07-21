# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-2 linux-info user

DESCRIPTION="A virtual network service for Openstack"
HOMEPAGE="https://launchpad.net/neutron"
EGIT_REPO_URI="https://github.com/openstack/neutron.git"
EGIT_BRANCH="stable/liberty"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="compute-only dhcp doc ipv6 l3 metadata openvswitch linuxbridge server test sqlite mysql postgres"
REQUIRED_USE="!compute-only? ( || ( mysql postgres sqlite ) )
						compute-only? ( !mysql !postgres !sqlite !dhcp !l3 !metadata !server
						|| ( openvswitch linuxbridge ) )"

CDEPEND=">=dev-python/pbr-1.8[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	app-admin/sudo
	test? (
		${RDEPEND}
		>=dev-python/cliff-1.14.0[${PYTHON_USEDEP}]
		<=dev-python/cliff-1.15.0[${PYTHON_USEDEP}]
		>=dev-python/cliff-1.14.0[${PYTHON_USEDEP}]
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		<=dev-python/coverage-4.0.3[${PYTHON_USEDEP}]
		>=dev-python/fixtures-1.3.1[${PYTHON_USEDEP}]
		<=dev-python/fixtures-1.4.0-r9999[${PYTHON_USEDEP}]
		>=dev-python/mock-1.2[${PYTHON_USEDEP}]
		<=dev-python/mock-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
		<=dev-python/subunit-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/requests-mock-0.6.0[${PYTHON_USEDEP}]
		<=dev-python/requests-mock-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
		<=dev-python/oslo-sphinx-4.1.0[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		<=dev-python/testrepository-0.0.20[${PYTHON_USEDEP}]
		>=dev-python/testtools-1.4.0[${PYTHON_USEDEP}]
		<=dev-python/testtools-1.8.1[${PYTHON_USEDEP}]
		>=dev-python/testresources-0.2.4[${PYTHON_USEDEP}]
		<=dev-python/testresources-1.0.0-r9999[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		<=dev-python/testscenarios-0.5[${PYTHON_USEDEP}]
		>=dev-python/webtest-2.0[${PYTHON_USEDEP}]
		<=dev-python/webtest-2.0.20[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.10.0[${PYTHON_USEDEP}]
		<=dev-python/oslotest-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/os-testr-0.1.0[${PYTHON_USEDEP}]
		<=dev-python/os-testr-0.4.2[${PYTHON_USEDEP}]
		>=dev-python/tempest-lib-0.8.0[${PYTHON_USEDEP}]
		<=dev-python/tempest-lib-0.11.0[${PYTHON_USEDEP}]
		>=dev-python/ddt-0.7.0[${PYTHON_USEDEP}]
		<=dev-python/ddt-1.0.1[${PYTHON_USEDEP}]
		~dev-python/pylint-1.4.4[${PYTHON_USEDEP}]
		>=dev-python/reno-0.1.1[${PYTHON_USEDEP}]
	)"

RDEPEND="
	<=dev-python/paste-2.0.2[${PYTHON_USEDEP}]
	>=dev-python/pastedeploy-1.5.0-r1[${PYTHON_USEDEP}]
	<=dev-python/pastedeploy-1.5.2[${PYTHON_USEDEP}]
	>=dev-python/routes-1.12.3[${PYTHON_USEDEP}]
	!~dev-python/routes-2.0[${PYTHON_USEDEP}]
	!~dev-python/routes-2.1[$(python_gen_usedep 'python2_7')]
	<=dev-python/routes-2.2[${PYTHON_USEDEP}]
	>=dev-python/debtcollector-0.3.0[${PYTHON_USEDEP}]
	<=dev-python/debtcollector-1.1.0[${PYTHON_USEDEP}]
	~dev-python/eventlet-0.17.4[${PYTHON_USEDEP}]
	>=dev-python/pecan-1.0.0[${PYTHON_USEDEP}]
	<=dev-python/pecan-1.0.3[${PYTHON_USEDEP}]
	>=dev-python/greenlet-0.3.2[${PYTHON_USEDEP}]
	<=dev-python/greenlet-0.4.9[${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.7.5[${PYTHON_USEDEP}]
	<=dev-python/httplib2-0.9.2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.5.2[${PYTHON_USEDEP}]
	!~dev-python/requests-2.8.0[${PYTHON_USEDEP}]
	!~dev-python/requests-2.9.0[${PYTHON_USEDEP}]
	<=dev-python/requests-2.8.1[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.6[${PYTHON_USEDEP}]
	<=dev-python/jinja-2.8[${PYTHON_USEDEP}]
	>=dev-python/keystonemiddleware-2.0.0[${PYTHON_USEDEP}]
	!=dev-python/keystonemiddleware-2.4.0[${PYTHON_USEDEP}]
	<=dev-python/keystonemiddleware-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.12[${PYTHON_USEDEP}]
	!~dev-python/netaddr-0.7.16[${PYTHON_USEDEP}]
	<=dev-python/netaddr-0.7.18[${PYTHON_USEDEP}]
	>=dev-python/python-neutronclient-2.6.0[${PYTHON_USEDEP}]
	<=dev-python/python-neutronclient-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/retrying-1.2.3[${PYTHON_USEDEP}]
	!~dev-python/retrying-1.3.0[${PYTHON_USEDEP}]
	<=dev-python/retrying-1.3.3[${PYTHON_USEDEP}]
	>=dev-python/ryu-3.23.2[${PYTHON_USEDEP}]
	<=dev-python/ryu-3.26[${PYTHON_USEDEP}]
	compute-only? (
		>=dev-python/sqlalchemy-0.9.9[${PYTHON_USEDEP}]
		<dev-python/sqlalchemy-1.0.10[${PYTHON_USEDEP}]
	)
	sqlite? (
		>=dev-python/sqlalchemy-0.9.9[sqlite,${PYTHON_USEDEP}]
		<dev-python/sqlalchemy-1.0.10[sqlite,${PYTHON_USEDEP}]
	)
	mysql? (
		dev-python/mysql-python
		>=dev-python/sqlalchemy-0.9.9[${PYTHON_USEDEP}]
		<dev-python/sqlalchemy-1.0.10[${PYTHON_USEDEP}]
	)
	postgres? (
		dev-python/psycopg:2
		>=dev-python/sqlalchemy-0.9.9[${PYTHON_USEDEP}]
		<dev-python/sqlalchemy-1.0.10[${PYTHON_USEDEP}]
	)
	>=dev-python/webob-1.2.3[${PYTHON_USEDEP}]
	<=dev-python/webob-1.5.1[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-1.6.0[${PYTHON_USEDEP}]
	!~dev-python/python-keystoneclient-1.8.0[${PYTHON_USEDEP}]
	<=dev-python/python-keystoneclient-2.0.0-r9999[${PYTHON_USEDEP}]
	>=dev-python/alembic-0.8.0[${PYTHON_USEDEP}]
	<=dev-python/alembic-0.8.3[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	<=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.5.0[${PYTHON_USEDEP}]
	<=dev-python/stevedore-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-2.3.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-concurrency-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-2.3.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-config-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-0.2.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-context-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-db-2.4.1[${PYTHON_USEDEP}]
	<=dev-python/oslo-db-4.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-1.5.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-i18n-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-1.8.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-log-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-messaging-1.16.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-1.17.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-1.17.1[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-2.6.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-2.6.1[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-2.7.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-2.8.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-2.8.1[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-2.9.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-3.1.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-messaging-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-middleware-2.8.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-middleware-3.0.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-middleware-3.1.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-middleware-3.2.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-middleware-3.3.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-policy-0.5.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-policy-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-rootwrap-2.0.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-rootwrap-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.4.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-serialization-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-service-0.7.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-service-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-utils-2.6.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-utils-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-versionedobjects-0.9.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-versionedobjects-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/python-novaclient-2.28.1[${PYTHON_USEDEP}]
	!~dev-python/python-novaclient-2.33.0[${PYTHON_USEDEP}]
	<=dev-python/python-novaclient-2.35.0[${PYTHON_USEDEP}]
	<=dev-python/pyudev-0.18[${PYTHON_USEDEP}]
	sys-apps/iproute2
	net-misc/bridge-utils
	net-firewall/ipset
	net-firewall/iptables
	net-firewall/ebtables
	openvswitch? ( <=net-misc/openvswitch-2.5.9999 )
	ipv6? ( net-misc/radvd )
	dhcp? ( net-dns/dnsmasq[dhcp-tools] )"

PATCHES=(
)

pkg_setup() {
	linux-info_pkg_setup
	CONFIG_CHECK_MODULES="VLAN_8021Q IP6_NF_FILTER IP6_NF_IPTABLES IP_NF_TARGET_REJECT \
	IP_NF_MANGLE IP_NF_TARGET_MASQUERADE NF_NAT_IPV4 NF_CONNTRACK_IPV4 NF_DEFRAG_IPV4 \
	NF_NAT_IPV4 NF_NAT NF_CONNTRACK IP_NF_FILTER IP_NF_IPTABLES NETFILTER_XTABLES"
	if linux_config_exists; then
		for module in ${CONFIG_CHECK_MODULES}; do
			linux_chkconfig_present ${module} || ewarn "${module} needs to be enabled in kernel"
		done
	fi
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

python_compile_all() {
	use doc && make -C doc html
}

python_test() {
	# https://bugs.launchpad.net/neutron/+bug/1234857
	# https://bugs.launchpad.net/swift/+bug/1249727
	# https://bugs.launchpad.net/neutron/+bug/1251657
	# Move tests out that attempt net connection, have failures
	mv $(find . -name test_ovs_tunnel.py) . || die
	sed -e 's:test_app_using_ipv6_and_ssl:_&:' \
		-e 's:test_start_random_port_with_ipv6:_&:' \
		-i neutron/tests/unit/test_wsgi.py || die
	testr init
	testr run --parallel || die "failed testsuite under python2.7"
}

python_install() {
	distutils-r1_python_install
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
		newconfd "${FILESDIR}/neutron-linuxbridge-agent.confd.liberty" "neutron-linuxbridge-agent"
	fi
	diropts -m 755 -o neutron -g neutron
	dodir /var/log/neutron /var/lib/neutron
	keepdir /etc/neutron
	insinto /etc/neutron
	insopts -m 0640 -o neutron -g neutron

	doins etc/*
	# stupid renames
	rm "${D}etc/neutron/quantum"
	insinto /etc/neutron
	doins -r "etc/neutron/plugins"
	insopts -m 0640 -o root -g root
	doins "etc/rootwrap.conf"
	doins -r "etc/neutron/rootwrap.d"

	insopts -m 0644
	insinto "/usr/lib64/python2.7/site-packages/neutron/db/migration/alembic_migrations/"
	doins -r "neutron/db/migration/alembic_migrations/versions"

	#add sudoers definitions for user neutron
	insinto /etc/sudoers.d/
	insopts -m 0440 -o root -g root
	newins "${FILESDIR}/neutron.sudoersd" neutron

	#remove superfluous stuff
	rm -R "${D}/usr/etc/"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )
	distutils-r1_python_install_all
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
