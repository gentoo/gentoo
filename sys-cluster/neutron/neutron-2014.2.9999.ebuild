# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/neutron/neutron-2014.2.9999.ebuild,v 1.13 2015/04/13 03:27:20 prometheanfire Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-2 linux-info user

DESCRIPTION="A virtual network service for Openstack"
HOMEPAGE="https://launchpad.net/neutron"
EGIT_REPO_URI="https://github.com/openstack/neutron.git"
EGIT_BRANCH="stable/juno"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="dhcp doc l3 metadata openvswitch linuxbridge server test sqlite mysql postgres"
REQUIRED_USE="|| ( mysql postgres sqlite )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pbr-0.8[${PYTHON_USEDEP}]
	<dev-python/pbr-1.0[${PYTHON_USEDEP}]
	app-admin/sudo
	test? (
		${RDEPEND}
		>=dev-python/hacking-0.9.2[${PYTHON_USEDEP}]
		<dev-python/hacking-0.10[${PYTHON_USEDEP}]
		>=dev-python/cliff-1.7.0[${PYTHON_USEDEP}]
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		>=dev-python/fixtures-0.3.14[${PYTHON_USEDEP}]
		>=dev-python/mock-1.0[${PYTHON_USEDEP}]
		>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
		dev-python/ordereddict[${PYTHON_USEDEP}]
		>=dev-python/requests-mock-0.4.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testtools-0.9.34[${PYTHON_USEDEP}]
		!~dev-python/testtools-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/webtest-2.0[${PYTHON_USEDEP}]
		dev-python/configobj[${PYTHON_USEDEP}]
	)"

RDEPEND="
	dev-python/paste[${PYTHON_USEDEP}]
	>=dev-python/pastedeploy-1.5.0-r1[${PYTHON_USEDEP}]
	>=dev-python/routes-1.12.3[${PYTHON_USEDEP}]
	!~dev-python/routes-2.0[${PYTHON_USEDEP}]
	>=dev-python/anyjson-0.3.3[${PYTHON_USEDEP}]
	>=dev-python/Babel-1.3[${PYTHON_USEDEP}]
	>=dev-python/eventlet-0.15.1[${PYTHON_USEDEP}]
	<dev-python/eventlet-0.16.0[${PYTHON_USEDEP}]
	>=dev-python/greenlet-0.3.2[${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.7.5[${PYTHON_USEDEP}]
	>=dev-python/requests-2.1.0[${PYTHON_USEDEP}]
	!~dev-python/requests-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.9[${PYTHON_USEDEP}]
	dev-python/jsonrpclib[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	>=dev-python/keystonemiddleware-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.12[${PYTHON_USEDEP}]
	>=dev-python/python-neutronclient-2.3.6[${PYTHON_USEDEP}]
	<=dev-python/python-neutronclient-3.0.0[${PYTHON_USEDEP}]
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
	>=dev-python/webob-1.2.3[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-0.10.0[${PYTHON_USEDEP}]
	>=dev-python/alembic-0.6.4[${PYTHON_USEDEP}]
	>=dev-python/six-1.7.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-db-1.0.0[${PYTHON_USEDEP}]
	<dev-python/oslo-db-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-messaging-1.4.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-1.5.0[${PYTHON_USEDEP}]
	<dev-python/oslo-messaging-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-rootwrap-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/python-novaclient-2.18.0[${PYTHON_USEDEP}]
	dev-python/pyudev[${PYTHON_USEDEP}]
	sys-apps/iproute2
	net-misc/bridge-utils
	net-firewall/ipset
	openvswitch? ( net-misc/openvswitch )
	dhcp? ( net-dns/dnsmasq[dhcp-tools] )"

PATCHES=(
	"${FILESDIR}/0001-Fixes-bug-in-interface-handling-of-ip_lib.py.patch"
	"${FILESDIR}/0002-moving-vxlan-module-check-to-sanity-checks-and-makin.patch"
	"${FILESDIR}/0003-fixes-error-logging-to-use-the-right-exception-paren.patch"
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
	#it's /bin/ip not /sbin/ip
	sed -i 's/sbin\/ip\,/bin\/ip\,/g' etc/neutron/rootwrap.d/*
	distutils-r1_src_prepare
}

python_compile_all() {
	use doc && make -C doc html
}

python_test() {
	# https://bugs.launchpad.net/neutron/+bug/1234857
	# https://bugs.launchpad.net/swift/+bug/1249727
	# https://bugs.launchpad.net/neutron/+bug/1251657
	# turn multiprocessing off, testr will use it --parallel
	local DISTUTILS_NO_PARALLEL_BUILD=1
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
		newconfd "${FILESDIR}/neutron-linuxbridge-agent.confd" "neutron-linuxbridge-agent"
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
