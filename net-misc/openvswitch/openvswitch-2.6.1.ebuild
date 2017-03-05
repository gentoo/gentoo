# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit autotools eutils linux-info linux-mod python-r1 systemd

DESCRIPTION="Production quality, multilayer virtual switch"
HOMEPAGE="http://openvswitch.org"
SRC_URI="http://openvswitch.org/releases/${P}.tar.gz"

LICENSE="Apache-2.0 GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="debug modules monitor +ssl"

RDEPEND="
	|| (
		>=sys-apps/openrc-0.10.5
		sys-apps/systemd
	)
	ssl? ( dev-libs/openssl:0= )
	${PYTHON_DEPS}
	~dev-python/ovs-${PV}
	dev-python/twisted-core
	dev-python/twisted-conch
	dev-python/twisted-web
	dev-python/zope-interface[${PYTHON_USEDEP}]
	debug? ( dev-lang/perl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES="${FILESDIR}/xcp-interface-reconfigure-2.3.2.patch"

CONFIG_CHECK="~NET_CLS_ACT ~NET_CLS_U32 ~NET_SCH_INGRESS ~NET_ACT_POLICE ~IPV6 ~TUN"
MODULE_NAMES="openvswitch(net:${S}/datapath/linux)"
BUILD_TARGETS="all"

pkg_setup() {
	if use modules ; then
		CONFIG_CHECK+=" ~!OPENVSWITCH"
		kernel_is ge 3 10 0 || die "Linux >= 3.10.0 and <= 4.8 required for userspace modules"
		kernel_is le 4 7 999 || die "Linux >= 3.10.0 and <= 4.8 required for userspace modules"
		linux-mod_pkg_setup
	else
		CONFIG_CHECK+=" ~OPENVSWITCH"
		linux-info_pkg_setup
	fi
}

src_prepare() {
	# Never build kernelmodules, doing this manually
	sed -i \
		-e '/^SUBDIRS/d' \
		datapath/Makefile.in || die "sed failed"
	eautoreconf
	default
}

src_configure() {
	set_arch_to_kernel
	#monitor ist statically enabled for bug 596206
	#use monitor || export ovs_cv_python="no"
	#pyside is staticly disabled
	export ovs_cv_pyuic4="no"

	local linux_config
	use modules && linux_config="--with-linux=${KV_OUT_DIR}"

	econf ${linux_config} \
		--with-rundir=/var/run/openvswitch \
		--with-logdir=/var/log/openvswitch \
		--with-pkidir=/etc/ssl/openvswitch \
		--with-dbdir=/var/lib/openvswitch \
		$(use_enable ssl) \
		$(use_enable !debug ndebug)
}

src_compile() {
	default

	use modules && linux-mod_src_compile
}

src_install() {
	default

	local SCRIPT
	for SCRIPT in ovs-{pcap,parse-backtrace,dpctl-top,l3ping,tcpundump,test,vlan-test} bugtool/ovs-bugtool; do
		sed -e '1s|^.*$|#!/usr/bin/python|' -i utilities/"${SCRIPT}" || die
		python_foreach_impl python_doscript utilities/"${SCRIPT}"
	done

	python_foreach_impl python_optimize "${ED%/}"/usr/share/ovsdbmonitor

	rm -r "${ED%/}"/usr/share/openvswitch/python || die

	keepdir /var/{lib,log}/openvswitch
	keepdir /etc/ssl/openvswitch
	fperms 0750 /etc/ssl/openvswitch

	rm -rf "${ED%/}"/var/run || die
	# monitor is statically enabled for bug 596206
	#if ! use monitor ; then
	#	rm -r "${ED%/}"/usr/share/ovsdbmonitor || die
	#fi

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

	local pv
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
	local db="${EROOT%/}"/var/lib/openvswitch/conf.db
	if [[ -e "${db}" ]] ; then
		einfo "Database '${db}' already exists, doing schema migration..."
		einfo "(if the migration fails, make sure that ovsdb-server is not running)"
		ovsdb-tool convert "${db}" \
			"${EROOT%/}"/usr/share/openvswitch/vswitch.ovsschema || die "converting database failed"
	else
		einfo "Creating new database '${db}'..."
		ovsdb-tool create "${db}" \
			"${EROOT%/}"/usr/share/openvswitch/vswitch.ovsschema || die "creating database failed"
	fi
}
