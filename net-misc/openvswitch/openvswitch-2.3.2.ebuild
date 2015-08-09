# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils linux-info linux-mod python-single-r1 systemd autotools

DESCRIPTION="Production quality, multilayer virtual switch"
HOMEPAGE="http://openvswitch.org"
SRC_URI="http://openvswitch.org/releases/${P}.tar.gz"

LICENSE="Apache-2.0 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug modules monitor +ssl"

RDEPEND=">=sys-apps/openrc-0.10.5
	ssl? ( dev-libs/openssl:= )
	monitor? (
		${PYTHON_DEPS}
		dev-python/twisted-core
		dev-python/twisted-conch
		dev-python/twisted-web
		dev-python/PyQt4[${PYTHON_USEDEP}]
		dev-python/zope-interface[${PYTHON_USEDEP}] )
	debug? ( dev-lang/perl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

CONFIG_CHECK="~NET_CLS_ACT ~NET_CLS_U32 ~NET_SCH_INGRESS ~NET_ACT_POLICE ~IPV6 ~TUN"
MODULE_NAMES="openvswitch(net:${S}/datapath/linux)"
BUILD_TARGETS="all"

pkg_setup() {
	if use modules ; then
		CONFIG_CHECK+=" ~!OPENVSWITCH"
		kernel_is ge 2 6 32 || die "Linux >= 2.6.32 and <= 3.14 required for userspace modules"
		kernel_is le 3 14 || die "Linux >= 2.6.32 and <= 3.14 required for userspace modules"
		linux-mod_pkg_setup
	else
		CONFIG_CHECK+=" ~OPENVSWITCH"
		linux-info_pkg_setup
	fi
	use monitor && python-single-r1_pkg_setup
}

src_prepare() {
	# Never build kernelmodules, doing this manually
	sed -i \
		-e '/^SUBDIRS/d' \
		datapath/Makefile.in || die "sed failed"
	epatch "${FILESDIR}/xcp-interface-reconfigure-2.3.2.patch"
	eautoreconf
}
src_configure() {
	set_arch_to_kernel
	use monitor || export ovs_cv_python="no"
	#pyside is staticly disabled
	export ovs_cv_pyuic4="no"

	local linux_config
	use modules && linux_config="--with-linux=${KV_OUT_DIR}"

	PYTHON=python2.7 econf ${linux_config} \
		--with-rundir=/var/run/openvswitch \
		--with-logdir=/var/log/openvswitch \
		--with-pkidir=/etc/ssl/openvswitch \
		--with-dbdir=/var/lib/openvswitch \
		$(use_enable ssl) \
		$(use_enable !debug ndebug)
}

src_compile() {
	default

#	use monitor && python_fix_shebang \
#		utilities/ovs-{pcap,tcpundump,test,vlan-test} \
#		utilities/bugtool/ovs-bugtool
	if use monitor; then
		sed -i \
			's/^#\!\ python2\.7/#\!\/usr\/bin\/env\ python2\.7/' \
			utilities/ovs-{pcap,parse-backtrace,dpctl-top,l3ping,tcpundump,test,vlan-test} \
			utilities/bugtool/ovs-bugtool || die "sed died :("
	fi

	use modules && linux-mod_src_compile
}

src_install() {
	default

	if use monitor ; then
		python_domodule "${ED}"/usr/share/openvswitch/python/*
		rm -r "${ED}/usr/share/openvswitch/python"
		python_optimize "${ED}/usr/share/ovsdbmonitor"
	fi
	# not working without the brcompat_mod kernel module which did not get
	# included in the kernel and we can't build it anymore
	rm "${D}/usr/sbin/ovs-brcompatd" "${D}/usr/share/man/man8/ovs-brcompatd.8"

	keepdir /var/{lib,log}/openvswitch
	keepdir /etc/ssl/openvswitch
	fperms 0750 /etc/ssl/openvswitch

	rm -rf "${ED}/var/run"
	use monitor || rmdir "${ED}/usr/share/ovsdbmonitor"
	use debug || rm "${ED}/usr/bin/ovs-parse-leaks"

	newconfd "${FILESDIR}/ovsdb-server_conf2" ovsdb-server
	newconfd "${FILESDIR}/ovs-vswitchd_conf" ovs-vswitchd
	newinitd "${FILESDIR}/ovsdb-server-r1" ovsdb-server
	newinitd "${FILESDIR}/ovs-vswitchd-r1" ovs-vswitchd

	systemd_dounit "${FILESDIR}/ovsdb-server.service"
	systemd_dounit "${FILESDIR}/ovs-vswitchd.service"
	systemd_newtmpfilesd "${FILESDIR}/openvswitch.tmpfiles" openvswitch.conf

	insinto /etc/logrotate.d
	newins rhel/etc_logrotate.d_openvswitch openvswitch

	use modules && linux-mod_src_install
}

pkg_postinst() {
	use modules && linux-mod_pkg_postinst

	for pv in ${REPLACING_VERSIONS}; do
		if ! version_is_at_least 1.9.0 ${pv} ; then
			ewarn "The configuration database for Open vSwitch got moved in version 1.9.0 from"
			ewarn "    /etc/openvswitch"
			ewarn "to"
			ewarn "    /var/lib/openvswitch"
			ewarn "Please copy/move the database manually before running the schema upgrade."
			ewarn "The PKI files are now supposed to go to /etc/ssl/openvswitch"
		fi
	done

	elog "Use the following command to create an initial database for ovsdb-server:"
	elog "   emerge --config =${CATEGORY}/${PF}"
	elog "(will create a database in /var/lib/openvswitch/conf.db)"
	elog "or to convert the database to the current schema after upgrading."
}

pkg_config() {
	local db="${EPREFIX}/var/lib/openvswitch/conf.db"
	if [ -e "${db}" ] ; then
		einfo "Database '${db}' already exists, doing schema migration..."
		einfo "(if the migration fails, make sure that ovsdb-server is not running)"
		"${EPREFIX}/usr/bin/ovsdb-tool" convert "${db}" "${EPREFIX}/usr/share/openvswitch/vswitch.ovsschema" || die "converting database failed"
	else
		einfo "Creating new database '${db}'..."
		"${EPREFIX}/usr/bin/ovsdb-tool" create "${db}" "${EPREFIX}/usr/share/openvswitch/vswitch.ovsschema" || die "creating database failed"
	fi
}
