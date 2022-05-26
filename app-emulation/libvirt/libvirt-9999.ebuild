# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Please bump with dev-python/libvirt-python!

PYTHON_COMPAT=( python3_{8..10} )
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/libvirt.org.asc
inherit meson bash-completion-r1 linux-info python-any-r1 readme.gentoo-r1 tmpfiles verify-sig

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/libvirt/libvirt.git"
	EGIT_BRANCH="master"
else
	SRC_URI="https://libvirt.org/sources/${P}.tar.xz
		verify-sig? ( https://libvirt.org/sources/${P}.tar.xz.asc )"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
fi

DESCRIPTION="C toolkit to manipulate virtual machines"
HOMEPAGE="https://www.libvirt.org/ https://gitlab.com/libvirt/libvirt/"
LICENSE="LGPL-2.1"
SLOT="0/${PV}"
IUSE="
	apparmor audit bash-completion +caps dtrace firewalld fuse glusterfs
	iscsi iscsi-direct +libvirtd lvm libssh libssh2 lxc nfs nls numa openvz
	parted pcap policykit +qemu rbd sasl selinux +udev
	virtualbox +virt-network wireshark-plugins xen zfs
"

REQUIRED_USE="
	firewalld? ( virt-network )
	libvirtd? ( || ( lxc openvz qemu virtualbox xen ) )
	lxc? ( caps libvirtd )
	openvz? ( libvirtd )
	qemu? ( libvirtd )
	virt-network? ( libvirtd )
	virtualbox? ( libvirtd )
	xen? ( libvirtd )"

BDEPEND="
	app-text/xhtml1
	dev-lang/perl
	dev-libs/libxslt
	dev-perl/XML-XPath
	dev-python/docutils
	virtual/pkgconfig
	net-libs/rpcsvc-proto
	bash-completion? ( >=app-shells/bash-completion-2.0 )
	verify-sig? ( sec-keys/openpgp-keys-libvirt )"

# gettext.sh command is used by the libvirt command wrappers, and it's
# non-optional, so put it into RDEPEND.
# We can use both libnl:1.1 and libnl:3, but if you have both installed, the
# package will use 3 by default. Since we don't have slot pinning in an API,
# we must go with the most recent
RDEPEND="
	acct-user/qemu
	app-misc/scrub
	>=dev-libs/glib-2.56.0
	dev-libs/libgcrypt
	dev-libs/libnl:3
	>=dev-libs/libxml2-2.9.1
	>=net-analyzer/openbsd-netcat-1.105-r1
	>=net-libs/gnutls-3.2.0:=
	net-libs/libtirpc:=
	>=net-misc/curl-7.18.0
	sys-apps/dbus
	sys-apps/dmidecode
	sys-devel/gettext
	>=sys-libs/readline-7.0:=
	virtual/acl
	apparmor? ( sys-libs/libapparmor )
	audit? ( sys-process/audit )
	caps? ( sys-libs/libcap-ng )
	dtrace? ( dev-util/systemtap )
	firewalld? ( >=net-firewall/firewalld-0.6.3 )
	fuse? ( sys-fs/fuse:= )
	glusterfs? ( >=sys-cluster/glusterfs-3.4.1 )
	iscsi? ( >=sys-block/open-iscsi-1.18.0 )
	iscsi-direct? ( >=net-libs/libiscsi-1.18.0 )
	libssh? ( >=net-libs/libssh-0.7:= )
	libssh2? ( >=net-libs/libssh2-1.3 )
	lvm? ( >=sys-fs/lvm2-2.02.48-r2[-device-mapper-only(-)] )
	lxc? ( !sys-apps/systemd[cgroup-hybrid(-)] )
	nfs? ( net-fs/nfs-utils )
	numa? (
		>sys-process/numactl-2.0.2
		sys-process/numad
	)
	parted? (
		>=sys-block/parted-1.8[device-mapper]
		sys-fs/lvm2[-device-mapper-only(-)]
	)
	pcap? ( >=net-libs/libpcap-1.8.0 )
	policykit? (
		acct-group/libvirt
		>=sys-auth/polkit-0.9
	)
	qemu? (
		>=app-emulation/qemu-2.11
		>=dev-libs/yajl-2.0.3:=
	)
	rbd? ( sys-cluster/ceph )
	sasl? ( >=dev-libs/cyrus-sasl-2.1.26 )
	selinux? ( >=sys-libs/libselinux-2.0.85 )
	virt-network? (
		net-dns/dnsmasq[dhcp,ipv6(+),script]
		net-firewall/ebtables
		>=net-firewall/iptables-1.4.10[ipv6(+)]
		net-misc/radvd
		sys-apps/iproute2[-minimal]
	)
	wireshark-plugins? ( >=net-analyzer/wireshark-2.6.0:= )
	xen? (
		>=app-emulation/xen-4.9.0
		app-emulation/xen-tools:=
	)
	udev? (
		virtual/libudev:=
		>=x11-libs/libpciaccess-0.10.9
	)
	zfs? ( sys-fs/zfs )
	kernel_linux? ( sys-apps/util-linux )"
DEPEND="${BDEPEND}
	${RDEPEND}
	${PYTHON_DEPS}"

PATCHES=(
	"${FILESDIR}"/${PN}-6.0.0-fix_paths_in_libvirt-guests_sh.patch
	"${FILESDIR}"/${PN}-8.2.0-do-not-use-sysconfig.patch
	"${FILESDIR}"/${PN}-8.2.0-fix-paths-for-apparmor.patch
)

pkg_setup() {
	# Check kernel configuration:
	CONFIG_CHECK=""
	use fuse && CONFIG_CHECK+="
		~FUSE_FS"

	use lvm && CONFIG_CHECK+="
		~BLK_DEV_DM
		~DM_MULTIPATH
		~DM_SNAPSHOT"

	use lxc && CONFIG_CHECK+="
		~BLK_CGROUP
		~CGROUP_CPUACCT
		~CGROUP_DEVICE
		~CGROUP_FREEZER
		~CGROUP_NET_PRIO
		~CGROUP_PERF
		~CGROUPS
		~CGROUP_SCHED
		~CPUSETS
		~IPC_NS
		~MACVLAN
		~NAMESPACES
		~NET_CLS_CGROUP
		~NET_NS
		~PID_NS
		~POSIX_MQUEUE
		~SECURITYFS
		~USER_NS
		~UTS_NS
		~VETH
		~!GRKERNSEC_CHROOT_MOUNT
		~!GRKERNSEC_CHROOT_DOUBLE
		~!GRKERNSEC_CHROOT_PIVOT
		~!GRKERNSEC_CHROOT_CHMOD
		~!GRKERNSEC_CHROOT_CAPS"

	kernel_is lt 4 7 && use lxc && CONFIG_CHECK+="
		~DEVPTS_MULTIPLE_INSTANCES"

	use virt-network && CONFIG_CHECK+="
		~BRIDGE_EBT_MARK_T
		~BRIDGE_NF_EBTABLES
		~NETFILTER_ADVANCED
		~NETFILTER_XT_CONNMARK
		~NETFILTER_XT_MARK
		~NETFILTER_XT_TARGET_CHECKSUM
		~IP_NF_FILTER
		~IP_NF_MANGLE
		~IP_NF_NAT
		~IP_NF_TARGET_MASQUERADE
		~IP6_NF_FILTER
		~IP6_NF_MANGLE
		~IP6_NF_NAT"
	# Bandwidth Limiting Support
	use virt-network && CONFIG_CHECK+="
		~BRIDGE_EBT_T_NAT
		~IP_NF_TARGET_REJECT
		~NET_ACT_POLICE
		~NET_CLS_FW
		~NET_CLS_U32
		~NET_SCH_HTB
		~NET_SCH_INGRESS
		~NET_SCH_SFQ"

	ERROR_USER_NS="Optional depending on LXC configuration."

	if [[ -n ${CONFIG_CHECK} ]]; then
		linux-info_pkg_setup
	fi

	python-any-r1_pkg_setup
}

src_prepare() {
	touch "${S}/.mailmap" || die

	default
	python_fix_shebang .

	# Skip fragile tests which relies on pristine environment
	# (Breaks because of sandbox environment variables)
	# bug #802876
	sed -i -e "/commandtest/d" tests/meson.build || die

	# Tweak the init script:
	cp "${FILESDIR}/libvirtd.init-r19" "${S}/libvirtd.init" || die
	sed -e "s/USE_FLAG_FIREWALLD/$(usex firewalld 'need firewalld' '')/" \
		-i "${S}/libvirtd.init" || die "sed failed"
}

src_configure() {
	local emesonargs=(
		$(meson_feature apparmor)
		$(meson_feature apparmor apparmor_profiles)
		$(meson_feature audit)
		$(meson_feature caps capng)
		$(meson_feature dtrace)
		$(meson_feature firewalld)
		$(meson_feature fuse)
		$(meson_feature glusterfs)
		$(meson_feature glusterfs storage_gluster)
		$(meson_feature iscsi storage_iscsi)
		$(meson_feature iscsi-direct storage_iscsi_direct)
		$(meson_feature libvirtd driver_libvirtd)
		$(meson_feature libssh)
		$(meson_feature libssh2)
		$(meson_feature lvm storage_lvm)
		$(meson_feature lvm storage_mpath)
		$(meson_feature lxc driver_lxc)
		$(meson_feature nls)
		$(meson_feature numa numactl)
		$(meson_feature numa numad)
		$(meson_feature openvz driver_openvz)
		$(meson_feature parted storage_disk)
		$(meson_feature pcap libpcap)
		$(meson_feature policykit polkit)
		$(meson_feature qemu driver_qemu)
		$(meson_feature qemu yajl)
		$(meson_feature rbd storage_rbd)
		$(meson_feature sasl)
		$(meson_feature selinux)
		$(meson_feature udev)
		$(meson_feature virt-network driver_network)
		$(meson_feature virtualbox driver_vbox)
		$(meson_feature wireshark-plugins wireshark_dissector)
		$(meson_feature xen driver_libxl)
		$(meson_feature zfs storage_zfs)

		-Dnetcf=disabled
		-Dsanlock=disabled

		-Ddriver_esx=enabled
		-Dinit_script=systemd
		-Dqemu_user=$(usex caps qemu root)
		-Dqemu_group=$(usex caps qemu root)
		-Ddriver_remote=enabled
		-Dstorage_fs=enabled
		-Ddriver_vmware=enabled

		--localstatedir="${EPREFIX}/var"
		-Drunstatedir="${EPREFIX}/run"
		-Ddocdir="${EPREFIX}/usr/share/doc/${PF}"
	)

	meson_src_configure
}

src_test() {
	export VIR_TEST_DEBUG=1
	# Don't run the syntax check tests, they're fragile and not relevant
	# to us downstream anyway.
	# We also crank up the timeout (as Fedora does) just to preempt failures
	# on slower arches.
	meson_src_test --no-suite syntax-check --timeout-multiplier 10
}

src_install() {
	meson_src_install

	# Depending on configuration option, libvirt will create some bogus
	# directoreis. They are either not used, or libvirtd is able to create
	# them on demand, so let's remove them.
	#
	# Note, we are using -f here so that rm does not fail or warn if the
	# directory is nonexistent.
	rm -rf "${D}"/etc/sysconfig
	rm -rf "${D}"/var
	rm -rf "${D}"/run

	use libvirtd || return 0
	# From here, only libvirtd-related instructions, be warned!

	newtmpfiles "${FILESDIR}"/libvirtd.tmpfiles.conf libvirtd.conf

	newinitd "${S}/libvirtd.init" libvirtd
	newinitd "${FILESDIR}/libvirt-guests.init-r4" libvirt-guests
	newinitd "${FILESDIR}/virtlockd.init-r2" virtlockd
	newinitd "${FILESDIR}/virtlogd.init-r2" virtlogd

	newconfd "${FILESDIR}/libvirtd.confd-r5" libvirtd
	newconfd "${FILESDIR}/libvirt-guests.confd" libvirt-guests

	DOC_CONTENTS=$(<"${FILESDIR}/README.gentoo-r3")
	DISABLE_AUTOFORMATTING=true
	readme.gentoo_create_doc
}

pkg_postinst() {
	if [[ -e "${ROOT}"/etc/libvirt/qemu/networks/default.xml ]]; then
		touch "${ROOT}"/etc/libvirt/qemu/networks/default.xml || die
	fi

	use libvirtd || return 0
	# From here, only libvirtd-related instructions, be warned!
	tmpfiles_process libvirtd.conf
	readme.gentoo_print_elog
}
