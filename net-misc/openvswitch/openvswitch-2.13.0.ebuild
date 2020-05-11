# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 python3_7 )

inherit autotools eutils linux-info linux-mod python-r1 systemd

DESCRIPTION="Production quality, multilayer virtual switch"
HOMEPAGE="https://www.openvswitch.org"
SRC_URI="https://www.openvswitch.org/releases/${P}.tar.gz"

LICENSE="Apache-2.0 GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"
IUSE="debug modules monitor +ssl"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	ssl? ( dev-libs/openssl:0= )
	${PYTHON_DEPS}
	~dev-python/ovs-2.13.0[${PYTHON_USEDEP}]
	dev-python/twisted[conch,${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
	debug? ( dev-lang/perl )"
DEPEND="${RDEPEND}
	sys-apps/util-linux[caps]
	virtual/pkgconfig"

PATCHES="
	"${FILESDIR}/xcp-interface-reconfigure-2.3.2.patch"
"

CONFIG_CHECK="~NET_CLS_ACT ~NET_CLS_U32 ~NET_SCH_INGRESS ~NET_ACT_POLICE ~IPV6 ~TUN"
MODULE_NAMES="openvswitch(net:${S}/datapath/linux)"
BUILD_TARGETS="all"

pkg_setup() {
	if use modules ; then
		CONFIG_CHECK+=" ~!OPENVSWITCH"
		kernel_is ge 3 10 0 || die "Linux >= 3.10.0 and <= 4.8 required for userspace modules"
		# docs state 4.17.x code states 4.15.x
		kernel_is le 5 5 999 || die "Linux >= 3.10.0 and <= 4.18 required for userspace modules"
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
	# monitor is statically enabled for bug 596206
	# use monitor || export ovs_cv_python="no"
	# pyside is staticly disabled
	export ovs_cv_pyuic4="no"

	# flake8 is primarily a style guide tool, running it as part of the tests
	# in Gentoo does not make much sense, only breaks them: bug 607280
	export ovs_cv_flake8="no"

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
	if use monitor; then
		for SCRIPT in ovs-{pcap,parse-backtrace,dpctl-top,l3ping,tcpdump,tcpundump,test,vlan-test} bugtool/ovs-bugtool; do
			sed -e '1s|^.*$|#!/usr/bin/python|' -i utilities/"${SCRIPT}"
			python_foreach_impl python_doscript utilities/"${SCRIPT}"
		done
		rm -r "${ED%}"/usr/share/openvswitch/python || die
	fi

	keepdir /var/{lib,log}/openvswitch
	keepdir /etc/ssl/openvswitch
	fperms 0750 /etc/ssl/openvswitch

	rm -rf "${ED%}"/var/run || die

	newconfd "${FILESDIR}/ovsdb-server_conf2" ovsdb-server
	newconfd "${FILESDIR}/ovs-vswitchd.confd-r2" ovs-vswitchd
	newinitd "${FILESDIR}/ovsdb-server-r1" ovsdb-server
	newinitd "${FILESDIR}/ovs-vswitchd-r1" ovs-vswitchd

	systemd_newunit "${FILESDIR}/ovsdb-server-r3.service" ovsdb-server.service
	systemd_newunit "${FILESDIR}/ovs-vswitchd-r3.service" ovs-vswitchd.service
	systemd_newunit rhel/usr_lib_systemd_system_ovs-delete-transient-ports.service ovs-delete-transient-ports.service
	systemd_newtmpfilesd "${FILESDIR}/openvswitch.tmpfiles" openvswitch.conf

	insinto /etc/logrotate.d
	newins rhel/etc_logrotate.d_openvswitch openvswitch

	use modules && linux-mod_src_install
}

pkg_postinst() {
	use modules && linux-mod_pkg_postinst

	# only needed on non-systemd, but helps anyway
	elog "Use the following command to create an initial database for ovsdb-server:"
	elog "   emerge --config =${CATEGORY}/${PF}"
	elog "(will create a database in /var/lib/openvswitch/conf.db)"
	elog "or to convert the database to the current schema after upgrading."
}

pkg_config() {
	local db="${EROOT%}"/var/lib/openvswitch/conf.db
	if [[ -e "${db}" ]] ; then
		einfo "Database '${db}' already exists, doing schema migration..."
		einfo "(if the migration fails, make sure that ovsdb-server is not running)"
		ovsdb-tool convert "${db}" \
			"${EROOT%}"/usr/share/openvswitch/vswitch.ovsschema || die "converting database failed"
	else
		einfo "Creating new database '${db}'..."
		ovsdb-tool create "${db}" \
			"${EROOT%}"/usr/share/openvswitch/vswitch.ovsschema || die "creating database failed"
	fi
}
