# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit autotools out-of-source bash-completion-r1 eutils linux-info python-any-r1 readme.gentoo-r1 systemd

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://libvirt.org/git/libvirt.git"
	SRC_URI=""
	KEYWORDS=""
	SLOT="0"
else
	SRC_URI="https://libvirt.org/sources/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
	SLOT="0/${PV}"
fi

DESCRIPTION="C toolkit to manipulate virtual machines"
HOMEPAGE="http://www.libvirt.org/"
LICENSE="LGPL-2.1"
IUSE="
	apparmor audit +caps +dbus dtrace firewalld fuse glusterfs iscsi
	iscsi-direct +libvirtd lvm libssh lxc +macvtap nfs nls numa openvz
	parted pcap phyp policykit +qemu rbd sasl selinux +udev +vepa
	virtualbox virt-network wireshark-plugins xen zfs
"

REQUIRED_USE="
	firewalld? ( virt-network )
	libvirtd? ( || ( lxc openvz qemu virtualbox xen ) )
	lxc? ( caps libvirtd )
	openvz? ( libvirtd )
	policykit? ( dbus )
	qemu? ( libvirtd )
	vepa? ( macvtap )
	virt-network? ( libvirtd )
	virtualbox? ( libvirtd )
	xen? ( libvirtd )"

# gettext.sh command is used by the libvirt command wrappers, and it's
# non-optional, so put it into RDEPEND.
# We can use both libnl:1.1 and libnl:3, but if you have both installed, the
# package will use 3 by default. Since we don't have slot pinning in an API,
# we must go with the most recent
RDEPEND="
	acct-user/qemu
	policykit? ( acct-group/libvirt )
	app-misc/scrub
	>=dev-libs/glib-2.48.0
	dev-libs/libgcrypt:0
	dev-libs/libnl:3
	>=dev-libs/libxml2-2.7.6
	>=net-analyzer/openbsd-netcat-1.105-r1
	>=net-libs/gnutls-1.0.25:0=
	net-libs/libssh2
	net-libs/libtirpc
	net-libs/rpcsvc-proto
	>=net-misc/curl-7.18.0
	sys-apps/dmidecode
	>=sys-apps/util-linux-2.17
	sys-devel/gettext
	sys-libs/ncurses:0=
	sys-libs/readline:=
	apparmor? ( sys-libs/libapparmor )
	audit? ( sys-process/audit )
	caps? ( sys-libs/libcap-ng )
	dbus? ( sys-apps/dbus )
	dtrace? ( dev-util/systemtap )
	firewalld? ( >=net-firewall/firewalld-0.6.3 )
	fuse? ( >=sys-fs/fuse-2.8.6:= )
	glusterfs? ( >=sys-cluster/glusterfs-3.4.1 )
	iscsi? ( sys-block/open-iscsi )
	iscsi-direct? ( >=net-libs/libiscsi-1.18.0 )
	libssh? ( net-libs/libssh )
	lvm? ( >=sys-fs/lvm2-2.02.48-r2[-device-mapper-only(-)] )
	lxc? ( !sys-apps/systemd[-cgroup-hybrid(+)] )
	nfs? ( net-fs/nfs-utils )
	numa? (
		>sys-process/numactl-2.0.2
		sys-process/numad
	)
	parted? (
		>=sys-block/parted-1.8[device-mapper]
		sys-fs/lvm2[-device-mapper-only(-)]
	)
	pcap? ( >=net-libs/libpcap-1.0.0 )
	policykit? ( >=sys-auth/polkit-0.9 )
	qemu? (
		>=app-emulation/qemu-1.5.0
		dev-libs/yajl
	)
	rbd? ( sys-cluster/ceph )
	sasl? ( dev-libs/cyrus-sasl )
	selinux? ( >=sys-libs/libselinux-2.0.85 )
	virt-network? (
		net-dns/dnsmasq[script]
		net-firewall/ebtables
		>=net-firewall/iptables-1.4.10[ipv6]
		net-misc/radvd
		sys-apps/iproute2[-minimal]
	)
	virtualbox? ( || ( app-emulation/virtualbox >=app-emulation/virtualbox-bin-2.2.0 ) )
	wireshark-plugins? ( net-analyzer/wireshark:= )
	xen? (
		>=app-emulation/xen-4.6.0
		app-emulation/xen-tools:=
	)
	udev? (
		virtual/udev
		>=x11-libs/libpciaccess-0.10.9
	)
	zfs? ( sys-fs/zfs )"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	app-text/xhtml1
	dev-lang/perl
	dev-libs/libxslt
	dev-perl/XML-XPath
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-5.7.0-do-not-use-sysconf.patch
	"${FILESDIR}"/${PN}-1.2.16-fix_paths_in_libvirt-guests_sh.patch
	"${FILESDIR}"/${PN}-5.2.0-fix-paths-for-apparmor.patch
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

	use macvtap && CONFIG_CHECK+="
		~MACVTAP"

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

	# Handle specific kernel versions for different features
	kernel_is lt 3 6 && CONFIG_CHECK+=" ~CGROUP_MEM_RES_CTLR"
	if kernel_is ge 3 6; then
		CONFIG_CHECK+=" ~MEMCG ~MEMCG_SWAP "
		kernel_is lt 4 5 && CONFIG_CHECK+=" ~MEMCG_KMEM "
	fi

	ERROR_USER_NS="Optional depending on LXC configuration."

	if [[ -n ${CONFIG_CHECK} ]]; then
		linux-info_pkg_setup
	fi
}

src_prepare() {
	touch "${S}/.mailmap"

	default

	if [[ ${PV} = *9999* ]]; then
		# Reinitialize submodules as this is required for gnulib's bootstrap
		git submodule init
		# git checkouts require bootstrapping to create the configure script.
		# Additionally the submodules must be cloned to the right locations
		# bug #377279
		./bootstrap || die "bootstrap failed"
		(
		    git submodule status .gnulib | awk '{ print $1 }'
		    git hash-object bootstrap.conf
		    git ls-tree -d HEAD gnulib/local | awk '{ print $3 }'
		) >.git-module-status
	fi

	# Tweak the init script:
	cp "${FILESDIR}/libvirtd.init-r18" "${S}/libvirtd.init" || die
	sed -e "s/USE_FLAG_FIREWALLD/$(usex firewalld 'need firewalld' '')/" \
		-i "${S}/libvirtd.init" || die "sed failed"

	eautoreconf
}

my_src_configure() {
	local myeconfargs=(
		$(use_with apparmor)
		$(use_with apparmor apparmor-profiles)
		$(use_with audit)
		$(use_with caps capng)
		$(use_with dbus)
		$(use_with dtrace)
		$(use_with firewalld)
		$(use_with fuse)
		$(use_with glusterfs)
		$(use_with glusterfs storage-gluster)
		$(use_with iscsi storage-iscsi)
		$(use_with iscsi-direct storage-iscsi-direct)
		$(use_with libvirtd)
		$(use_with libssh)
		$(use_with lvm storage-lvm)
		$(use_with lvm storage-mpath)
		$(use_with lxc)
		$(use_with macvtap)
		$(use_enable nls)
		$(use_with numa numactl)
		$(use_with numa numad)
		$(use_with openvz)
		$(use_with parted storage-disk)
		$(use_with pcap libpcap)
		$(use_with phyp)
		$(use_with policykit polkit)
		$(use_with qemu)
		$(use_with qemu yajl)
		$(use_with rbd storage-rbd)
		$(use_with sasl)
		$(use_with selinux)
		$(use_with udev)
		$(use_with vepa virtualport)
		$(use_with virt-network network)
		$(use_with wireshark-plugins wireshark-dissector)
		$(use_with xen libxl)
		$(use_with zfs storage-zfs)

		--without-hal
		--without-netcf
		--without-sanlock

		--with-esx
		--with-init-script=systemd
		--with-qemu-group=$(usex caps qemu root)
		--with-qemu-user=$(usex caps qemu root)
		--with-remote
		--with-storage-fs
		--with-vmware

		--disable-static
		--disable-werror

		--localstatedir=/var
		--enable-dependency-tracking
	)

	if use virtualbox && has_version app-emulation/virtualbox-ose; then
		myeconfargs+=( --with-vbox=/usr/lib/virtualbox-ose/ )
	else
		myeconfargs+=( $(use_with virtualbox vbox) )
	fi

	econf "${myeconfargs[@]}"

	if [[ ${PV} = *9999* ]]; then
		# Restore gnulib's config.sub and config.guess
		# bug #377279
		(cd ${S}/.gnulib && git reset --hard > /dev/null)
	fi
}

my_src_test() {
	# remove problematic tests, bug #591416, bug #591418
	sed -i -e 's#commandtest$(EXEEXT) # #' \
		-e 's#virfirewalltest$(EXEEXT) # #' \
		-e 's#nwfilterebiptablestest$(EXEEXT) # #' \
		-e 's#nwfilterxml2firewalltest$(EXEEXT)$##' \
		tests/Makefile

	export VIR_TEST_DEBUG=1
	HOME="${T}" emake check
}

my_src_install() {
	emake DESTDIR="${D}" \
		SYSTEMD_UNIT_DIR="$(systemd_get_systemunitdir)" install

	find "${D}" -name '*.la' -delete || die

	# Remove bogus, empty directories. They are either not used, or
	# libvirtd is able to create them on demand
	rm -rf "${D}"/etc/sysconfig
	rm -rf "${D}"/var

	newbashcomp "${S}/tools/bash-completion/vsh" virsh
	bashcomp_alias virsh virt-admin

	use libvirtd || return 0
	# From here, only libvirtd-related instructions, be warned!

	systemd_install_serviced \
		"${FILESDIR}"/libvirtd.service.conf libvirtd.service

	systemd_newtmpfilesd "${FILESDIR}"/libvirtd.tmpfiles.conf libvirtd.conf

	newinitd "${S}/libvirtd.init" libvirtd
	newinitd "${FILESDIR}/libvirt-guests.init-r4" libvirt-guests
	newinitd "${FILESDIR}/virtlockd.init-r1" virtlockd
	newinitd "${FILESDIR}/virtlogd.init-r1" virtlogd

	newconfd "${FILESDIR}/libvirtd.confd-r5" libvirtd
	newconfd "${FILESDIR}/libvirt-guests.confd" libvirt-guests

	DOC_CONTENTS=$(<"${FILESDIR}/README.gentoo-r2")
	DISABLE_AUTOFORMATTING=true
	readme.gentoo_create_doc
}

pkg_preinst() {
	# we only ever want to generate this once
	if [[ -e "${ROOT}"/etc/libvirt/qemu/networks/default.xml ]]; then
		rm -rf "${D}"/etc/libvirt/qemu/networks/default.xml
	fi
}

pkg_postinst() {
	if [[ -e "${ROOT}"/etc/libvirt/qemu/networks/default.xml ]]; then
		touch "${ROOT}"/etc/libvirt/qemu/networks/default.xml
	fi

	use libvirtd || return 0
	# From here, only libvirtd-related instructions, be warned!

	readme.gentoo_print_elog
}
