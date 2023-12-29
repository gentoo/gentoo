# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )

inherit autotools linux-info python-single-r1 systemd tmpfiles

DESCRIPTION="Production quality, multilayer virtual switch"
HOMEPAGE="https://www.openvswitch.org"
SRC_URI="https://www.openvswitch.org/releases/${P}.tar.gz"

LICENSE="Apache-2.0 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="debug monitor +ssl unwind valgrind xdp"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Check python/ovs/version.py in tarball for dev-python/ovs dep
RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		~dev-python/ovs-2.17.7[${PYTHON_USEDEP}]
		dev-python/twisted[${PYTHON_USEDEP}]
		dev-python/zope-interface[${PYTHON_USEDEP}]
	')
	debug? ( dev-lang/perl )
	unwind? ( sys-libs/libunwind:= )
	ssl? ( dev-libs/openssl:= )"
DEPEND="${RDEPEND}
	sys-apps/lsb-release
	sys-apps/util-linux[caps]
	valgrind? ( dev-util/valgrind )
	xdp? ( net-libs/xdp-tools )"
BDEPEND="virtual/pkgconfig
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/sphinx[${PYTHON_USEDEP}]
	')"
PATCHES=(
	"${FILESDIR}/xcp-interface-reconfigure-2.3.2.patch"
)

CONFIG_CHECK="~IPV6 ~NET_ACT_POLICE ~NET_CLS_ACT ~NET_CLS_U32 ~NET_SCH_INGRESS ~OPENVSWITCH ~TUN"

pkg_setup() {
	if use xdp ; then
		CONFIG_CHECK+=" ~BPF ~BPF_JIT ~BPF_SYSCALL ~HAVE_BPF_JIT ~XDP_SOCKETS"
	fi

	linux-info_pkg_setup
}

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	python_setup

	# monitor is statically enabled for bug #596206
	# use monitor || export ovs_cv_python="no"
	# pyside is statically disabled
	export ovs_cv_pyuic4="no"

	# flake8 is primarily a style guide tool, running it as part of the tests
	# in Gentoo does not make much sense, only breaks them: bug #607280
	export ovs_cv_flake8="no"

	# Only adds a diagram to the man page, just skip it as we don't
	# want to add a BDEPEND on graphviz right now. bug #856286
	export ovs_cv_dot="no"

	export ac_cv_header_valgrind_valgrind_h=$(usex valgrind)

	export ac_cv_lib_unwind_unw_backtrace="$(usex unwind)"

	# Need PYTHON3 variable for bug #860240
	PYTHON3="${PYTHON}" CONFIG_SHELL="${BROOT}"/bin/bash SHELL="${BROOT}"/bin/bash econf \
		--with-rundir=/run/openvswitch \
		--with-logdir=/var/log/openvswitch \
		--with-pkidir=/etc/ssl/openvswitch \
		--with-dbdir=/var/lib/openvswitch \
		$(use_enable ssl) \
		$(use_enable !debug ndebug) \
		$(use_enable xdp afxdp)
}

src_install() {
	default

	find "${ED}/usr" -name '*.la' -delete || die

	local SCRIPT
	if use monitor; then
		# ovs-bugtool is installed to sbin by the build system, but we
		# install it to bin below, and these clash in merged-usr
		# https://bugs.gentoo.org/889846
		rm "${ED}"/usr/sbin/ovs-bugtool || die

		for SCRIPT in ovs-{pcap,parse-backtrace,dpctl-top,l3ping,tcpdump,tcpundump,test,vlan-test} bugtool/ovs-bugtool; do
			python_doscript utilities/"${SCRIPT}"
		done
		rm -r "${ED}"/usr/share/openvswitch/python || die
	fi

	keepdir /var/{lib,log}/openvswitch
	keepdir /etc/openvswitch
	keepdir /etc/ssl/openvswitch
	fperms 0750 /etc/ssl/openvswitch

	rm -rf "${ED}"/var/run || die

	newconfd "${FILESDIR}/ovsdb-server_conf2" ovsdb-server
	newconfd "${FILESDIR}/ovs-vswitchd.confd-r2" ovs-vswitchd
	newinitd "${FILESDIR}/ovsdb-server-r1" ovsdb-server
	newinitd "${FILESDIR}/ovs-vswitchd-r1" ovs-vswitchd

	systemd_newunit "${FILESDIR}/ovsdb-server-r3.service" ovsdb-server.service
	systemd_newunit "${FILESDIR}/ovs-vswitchd-r3.service" ovs-vswitchd.service
	systemd_newunit rhel/usr_lib_systemd_system_ovs-delete-transient-ports.service ovs-delete-transient-ports.service
	newtmpfiles "${FILESDIR}/openvswitch.tmpfiles" openvswitch.conf

	insinto /etc/logrotate.d
	newins rhel/etc_logrotate.d_openvswitch openvswitch
}

pkg_postinst() {
	tmpfiles_process openvswitch.conf

	# Only needed on non-systemd, but helps anyway
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
			"${EROOT}"/usr/share/openvswitch/vswitch.ovsschema || die "converting database failed"
	else
		einfo "Creating new database '${db}'..."
		ovsdb-tool create "${db}" \
			"${EROOT}"/usr/share/openvswitch/vswitch.ovsschema || die "creating database failed"
	fi
}
