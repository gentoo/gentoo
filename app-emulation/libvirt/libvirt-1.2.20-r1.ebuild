# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils user autotools-utils linux-info systemd readme.gentoo

BACKPORTS=""

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://libvirt.org/libvirt.git"
	SRC_URI=""
	KEYWORDS=""
	SLOT="0"
else
	# Versions with 4 numbers are stable updates:
	if [[ ${PV} =~ ^[0-9]+(\.[0-9]+){3} ]]; then
		SRC_URI="http://libvirt.org/sources/stable_updates/${P}.tar.gz"
	else
		SRC_URI="http://libvirt.org/sources/${P}.tar.gz"
	fi
	SRC_URI+=" ${BACKPORTS:+
		https://dev.gentoo.org/~cardoe/distfiles/${P}-${BACKPORTS}.tar.xz
		https://dev.gentoo.org/~tamiko/distfiles/${P}-${BACKPORTS}.tar.xz}"
	KEYWORDS="~amd64 ~x86"
	SLOT="0/${PV}"
fi

DESCRIPTION="C toolkit to manipulate virtual machines"
HOMEPAGE="http://www.libvirt.org/"
LICENSE="LGPL-2.1"
IUSE="apparmor audit avahi +caps firewalld fuse glusterfs iscsi +libvirtd lvm \
	lxc +macvtap nfs nls numa openvz parted pcap phyp policykit +qemu rbd sasl \
	selinux systemd +udev uml +vepa virtualbox virt-network wireshark-plugins \
	xen"

REQUIRED_USE="
	firewalld? ( virt-network )
	libvirtd? ( || ( lxc openvz qemu uml virtualbox xen ) )
	lxc? ( caps libvirtd )
	openvz? ( libvirtd )
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
	>=net-analyzer/netcat6-1.0-r2
	>=net-libs/gnutls-1.0.25
	net-libs/libssh2
	>=net-misc/curl-7.18.0
	sys-apps/dmidecode
	>=sys-apps/util-linux-2.17
	sys-devel/gettext
	sys-libs/ncurses:0=
	sys-libs/readline:=
	apparmor? ( sys-libs/libapparmor )
	audit? ( sys-process/audit )
	avahi? ( >=net-dns/avahi-0.6[dbus] )
	caps? ( sys-libs/libcap-ng )
	firewalld? ( net-firewall/firewalld )
	fuse? ( >=sys-fs/fuse-2.8.6 )
	glusterfs? ( >=sys-cluster/glusterfs-3.4.1 )
	iscsi? ( sys-block/open-iscsi )
	lvm? ( >=sys-fs/lvm2-2.02.48-r2 )
	lxc? ( !systemd? ( sys-power/pm-utils ) )
	nfs? ( net-fs/nfs-utils )
	numa? (
		>sys-process/numactl-2.0.2
		sys-process/numad
	)
	openvz? ( sys-kernel/openvz-sources:* )
	parted? (
		>=sys-block/parted-1.8[device-mapper]
		sys-fs/lvm2
	)
	pcap? ( >=net-libs/libpcap-1.0.0 )
	policykit? ( >=sys-auth/polkit-0.9 )
	qemu? (
		>=app-emulation/qemu-0.13.0
		dev-libs/yajl
		!systemd? ( sys-power/pm-utils )
	)
	rbd? ( sys-cluster/ceph )
	sasl? ( dev-libs/cyrus-sasl )
	selinux? ( >=sys-libs/libselinux-2.0.85 )
	systemd? ( sys-apps/systemd )
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
		app-emulation/xen-tools
	)
	udev? (
		virtual/udev
		>=x11-libs/libpciaccess-0.10.9
	)"

DEPEND="${RDEPEND}
	app-text/xhtml1
	dev-lang/perl
	dev-libs/libxslt
	dev-perl/XML-XPath
	virtual/pkgconfig"

pkg_setup() {
	enewgroup qemu 77
	enewuser qemu 77 -1 -1 qemu kvm

	# Some people used the masked ebuild which was not adding the qemu
	# user to the kvm group originally. This results in VMs failing to
	# start for some users. bug #430808
	egetent group kvm | grep -q qemu
	if [[ $? -ne 0 ]]; then
		gpasswd -a qemu kvm
	fi

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
		~DEVPTS_MULTIPLE_INSTANCES
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
	# Handle specific kernel versions for different features
	kernel_is lt 3 6 && CONFIG_CHECK+=" ~CGROUP_MEM_RES_CTLR"
	kernel_is ge 3 6 && CONFIG_CHECK+=" ~MEMCG ~MEMCG_SWAP ~MEMCG_KMEM"

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

	ERROR_USER_NS="Optional depending on LXC configuration."

	if [[ -n ${CONFIG_CHECK} ]]; then
		linux-info_pkg_setup
	fi
}

src_prepare() {
	touch "${S}/.mailmap"

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

	epatch \
		"${FILESDIR}"/${PN}-1.2.9-do_not_use_sysconf.patch \
		"${FILESDIR}"/${PN}-1.2.16-fix_paths_in_libvirt-guests_sh.patch \
		"${FILESDIR}"/${PN}-1.2.17-fix_paths_for_apparmor.patch

	[[ -n ${BACKPORTS} ]] &&
		EPATCH_FORCE=yes EPATCH_SUFFIX="patch" \
			EPATCH_SOURCE="${WORKDIR}/patches" epatch

	epatch_user

	# Tweak the init script:
	cp "${FILESDIR}/libvirtd.init-r15" "${S}/libvirtd.init" || die
	sed -e "s/USE_FLAG_FIREWALLD/$(usex firewalld 'need firewalld' '')/" \
		-e "s/USE_FLAG_AVAHI/$(usex avahi avahi-daemon '')/" \
		-e "s/USE_FLAG_ISCSI/$(usex iscsi iscsid '')/" \
		-e "s/USE_FLAG_RBD/$(usex rbd  ceph '')/" \
		-i "${S}/libvirtd.init" || die "sed failed"

	AUTOTOOLS_AUTORECONF=true
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_with apparmor)
		$(use_with apparmor apparmor-profiles)
		$(use_with audit)
		$(use_with avahi)
		$(use_with caps capng)
		$(use_with firewalld)
		$(use_with fuse)
		$(use_with glusterfs)
		$(use_with glusterfs storage-gluster)
		$(use_with iscsi storage-iscsi)
		$(use_with libvirtd)
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
		$(use_with systemd systemd-daemon)
		$(usex systemd --with-init-script=systemd '')
		$(use_with udev)
		$(use_with uml)
		$(use_with vepa virtualport)
		$(use_with virt-network network)
		$(use_with wireshark-plugins wireshark-dissector)
		$(use_with xen)
		$(use_with xen xen-inotify)
		$(usex xen --with-libxl '')

		--without-hal
		--without-netcf
		--without-sanlock
		--without-xenapi
		--with-esx
		--with-qemu-group=$(usex caps qemu root)
		--with-qemu-user=$(usex caps qemu root)
		--with-remote
		--with-storage-fs
		--with-vmware

		--disable-static
		--disable-werror

		--docdir=/usr/share/doc/${PF}
		--htmldir=/usr/share/doc/${PF}/html
		--localstatedir=/var
	)

	if use virtualbox && has_version app-emulation/virtualbox-ose; then
		myeconfargs+=( --with-vbox=/usr/lib/virtualbox-ose/ )
	else
		myeconfargs+=( $(use_with virtualbox vbox) )
	fi

	autotools-utils_src_configure

	if [[ ${PV} = *9999* ]]; then
		# Restore gnulib's config.sub and config.guess
		# bug #377279
		(cd .gnulib && git reset --hard > /dev/null)
	fi
}

src_test() {
	# Explicitly allow parallel build of tests
	export VIR_TEST_DEBUG=1
	HOME="${T}" emake check || die "tests failed"
}

src_install() {
	autotools-utils_src_compile install \
		DESTDIR="${D}" \
		SYSTEMD_UNIT_DIR="$(systemd_get_unitdir)"

	find "${D}" -name '*.la' -delete || die

	# Remove bogus, empty directories. They are either not used, or
	# libvirtd is able to create them on demand
	rm -rf "${D}"/etc/sysconfig
	rm -rf "${D}"/var/cache
	rm -rf "${D}"/var/run
	rm -rf "${D}"/var/log

	use libvirtd || return 0
	# From here, only libvirtd-related instructions, be warned!

	use systemd && systemd_install_serviced \
		"${FILESDIR}"/libvirtd.service.conf libvirtd.service

	systemd_newtmpfilesd "${FILESDIR}"/libvirtd.tmpfiles.conf libvirtd.conf

	newinitd "${S}/libvirtd.init" libvirtd || die
	newinitd "${FILESDIR}/libvirt-guests.init-r1" libvirt-guests || die
	newinitd "${FILESDIR}/virtlockd.init-r1" virtlockd || die

	newconfd "${FILESDIR}/libvirtd.confd-r5" libvirtd || die
	newconfd "${FILESDIR}/libvirt-guests.confd" libvirt-guests || die

	DOC_CONTENTS=$(<"${FILESDIR}/README.gentoo-r1")
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

	if [[ -n ${REPLACING_VERSIONS} ]] && ! version_is_at_least 1.2.18-r2 ${REPLACING_VERSIONS} ]]; then
		FORCE_PRINT_ELOG=true
	fi

	DOC_CONTENTS=$(<"${FILESDIR}/README.gentoo-r1")
	DISABLE_AUTOFORMATTING=true
	readme.gentoo_print_elog
}
