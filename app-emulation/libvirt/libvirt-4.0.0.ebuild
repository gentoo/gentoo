# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils user linux-info systemd readme.gentoo-r1 bash-completion-r1

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://libvirt.org/libvirt.git"
	SRC_URI=""
	KEYWORDS="amd64"
	SLOT="0"
else
	# Versions with 4 numbers are stable updates:
	if [[ ${PV} =~ ^[0-9]+(\.[0-9]+){3} ]]; then
		SRC_URI="http://libvirt.org/sources/stable_updates/${P}.tar.xz"
	else
		SRC_URI="http://libvirt.org/sources/${P}.tar.xz"
	fi
	KEYWORDS="amd64 ~arm64 ~x86"
	SLOT="0/${PV}"
fi

DESCRIPTION="C toolkit to manipulate virtual machines"
HOMEPAGE="http://www.libvirt.org/"
LICENSE="LGPL-2.1"
IUSE="
	apparmor audit +caps +dbus firewalld fuse glusterfs iscsi +libvirtd lvm
	libssh lxc +macvtap nfs nls numa openvz parted pcap phyp policykit
	+qemu rbd sasl selinux +udev uml +vepa virtualbox virt-network
	wireshark-plugins xen zeroconf zfs
"

REQUIRED_USE="
	firewalld? ( virt-network )
	libvirtd? ( || ( lxc openvz qemu uml virtualbox xen ) )
	lxc? ( caps libvirtd )
	openvz? ( libvirtd )
	policykit? ( dbus )
	qemu? ( libvirtd )
	uml? ( libvirtd )
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
	app-misc/scrub
	dev-libs/libgcrypt:0
	dev-libs/libnl:3
	>=dev-libs/libxml2-2.7.6
	|| ( >=net-analyzer/netcat6-1.0-r2 >=net-analyzer/openbsd-netcat-1.105-r1 )
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
	firewalld? ( net-firewall/firewalld )
	fuse? ( >=sys-fs/fuse-2.8.6:= )
	glusterfs? ( >=sys-cluster/glusterfs-3.4.1 )
	iscsi? ( sys-block/open-iscsi )
	libssh? ( net-libs/libssh )
	lvm? ( >=sys-fs/lvm2-2.02.48-r2[-device-mapper-only(-)] )
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
		>=app-emulation/qemu-0.13.0
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
		app-emulation/xen
		app-emulation/xen-tools:=
	)
	udev? (
		virtual/udev
		>=x11-libs/libpciaccess-0.10.9
	)
	zeroconf? ( >=net-dns/avahi-0.6[dbus] )
	zfs? ( sys-fs/zfs )"

DEPEND="${RDEPEND}
	app-text/xhtml1
	dev-lang/perl
	dev-libs/libxslt
	dev-perl/XML-XPath
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.0-do_not_use_sysconf.patch
	"${FILESDIR}"/${PN}-1.2.16-fix_paths_in_libvirt-guests_sh.patch
	"${FILESDIR}"/${PN}-3.10.0-r2-fix_paths_for_apparmor.patch
	"${FILESDIR}"/${PN}-1.3.4-glibc-2.23.patch
	"${FILESDIR}"/${PN}-3.1.0-musl-fix-includes.patch          # bug #609488
	"${FILESDIR}"/${PN}-4.0.0-bash_completion_bugfixes.patch   # bug #644632
)

pkg_setup() {
	if use qemu; then
		enewgroup qemu 77
		enewuser qemu 77 -1 -1 "qemu,kvm"
	fi

	use policykit && enewgroup libvirt

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
		~NETFILTER_XT_TARGET_CHECKSUM"
	# Bandwidth Limiting Support
	use virt-network && CONFIG_CHECK+="
		~BRIDGE_EBT_T_NAT
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
		# git checkouts require bootstrapping to create the configure script.
		# Additionally the submodules must be cloned to the right locations
		# bug #377279
		./bootstrap || die "bootstrap failed"
		(
			git submodule status | sed 's/^[ +-]//;s/ .*//'
			git hash-object bootstrap.conf
		) >.git-module-status
	fi

	# Tweak the init script:
	cp "${FILESDIR}/libvirtd.init-r16" "${S}/libvirtd.init" || die
	sed -e "s/USE_FLAG_FIREWALLD/$(usex firewalld 'need firewalld' '')/" \
		-e "s/USE_FLAG_AVAHI/$(usex zeroconf 'use avahi-daemon' '')/" \
		-e "s/USE_FLAG_ISCSI/$(usex iscsi 'use iscsid' '')/" \
		-e "s/USE_FLAG_RBD/$(usex rbd 'use ceph' '')/" \
		-i "${S}/libvirtd.init" || die "sed failed"

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with apparmor)
		$(use_with apparmor apparmor-profiles)
		$(use_with audit)
		$(use_with caps capng)
		$(use_with dbus)
		$(use_with firewalld)
		$(use_with fuse)
		$(use_with glusterfs)
		$(use_with glusterfs storage-gluster)
		$(use_with iscsi storage-iscsi)
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
		$(use_with uml)
		$(use_with vepa virtualport)
		$(use_with virt-network network)
		$(use_with wireshark-plugins wireshark-dissector)
		$(use_with xen)
		$(use_with xen xen-inotify)
		$(use_with xen libxl)
		$(use_with zeroconf avahi)
		$(use_with zfs storage-zfs)

		--without-hal
		--without-netcf
		--without-sanlock
		--without-xenapi

		--with-esx
		--with-init-script=systemd
		--with-qemu-group=$(usex caps qemu root)
		--with-qemu-user=$(usex caps qemu root)
		--with-remote
		--with-storage-fs
		--with-vmware

		--disable-static
		--disable-werror

		--with-html-subdir=${PF}/html
		--localstatedir=/var
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
		(cd .gnulib && git reset --hard > /dev/null)
	fi
}

src_test() {
	cd "${BUILD_DIR}"

	# remove problematic tests, bug #591416, bug #591418
	sed -i -e 's#commandtest$(EXEEXT) # #' \
		-e 's#virfirewalltest$(EXEEXT) # #' \
		-e 's#nwfilterebiptablestest$(EXEEXT) # #' \
		-e 's#nwfilterxml2firewalltest$(EXEEXT)$##' \
		tests/Makefile

	export VIR_TEST_DEBUG=1
	HOME="${T}" emake check || die "tests failed"
}

src_install() {
	emake DESTDIR="${D}" \
		SYSTEMD_UNIT_DIR="$(systemd_get_systemunitdir)" install

	find "${D}" -name '*.la' -delete || die

	# Remove bogus, empty directories. They are either not used, or
	# libvirtd is able to create them on demand
	rm -rf "${D}"/etc/sysconfig
	rm -rf "${D}"/var/cache
	rm -rf "${D}"/var/run
	rm -rf "${D}"/var/log

	use libvirtd || return 0
	# From here, only libvirtd-related instructions, be warned!

	systemd_install_serviced \
		"${FILESDIR}"/libvirtd.service.conf libvirtd.service

	systemd_newtmpfilesd "${FILESDIR}"/libvirtd.tmpfiles.conf libvirtd.conf

	newinitd "${S}/libvirtd.init" libvirtd || die
	newinitd "${FILESDIR}/libvirt-guests.init-r2" libvirt-guests || die
	newinitd "${FILESDIR}/virtlockd.init-r1" virtlockd || die
	newinitd "${FILESDIR}/virtlogd.init-r1" virtlogd || die

	newconfd "${FILESDIR}/libvirtd.confd-r5" libvirtd || die
	newconfd "${FILESDIR}/libvirt-guests.confd" libvirt-guests || die

	newbashcomp "${S}/tools/bash-completion/vsh" vsh
	bashcomp_alias vsh virsh virt-admin

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
