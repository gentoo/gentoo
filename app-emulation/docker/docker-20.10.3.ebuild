# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGO_PN=github.com/docker/docker
GIT_COMMIT=46229ca1d8
inherit bash-completion-r1 linux-info systemd udev golang-vcs-snapshot

DESCRIPTION="The core functions you need to create Docker images and run Docker containers"
HOMEPAGE="https://www.docker.com/"
MY_PV=${PV/_/-}
SRC_URI="https://github.com/moby/moby/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="apparmor aufs btrfs +cli +container-init device-mapper hardened overlay seccomp"

DEPEND="
	acct-group/docker
	>=dev-db/sqlite-3.7.9:3
	apparmor? ( sys-libs/libapparmor )
	btrfs? ( >=sys-fs/btrfs-progs-3.16.1 )
	device-mapper? ( >=sys-fs/lvm2-2.02.89[thin] )
	seccomp? ( >=sys-libs/libseccomp-2.2.1 )
"

# https://github.com/moby/moby/blob/master/project/PACKAGERS.md#runtime-dependencies
# https://github.com/moby/moby/blob/master/project/PACKAGERS.md#optional-dependencies
# https://github.com/moby/moby/tree/master//hack/dockerfile/install
# make sure containerd, docker-proxy, runc and tini pinned to exact versions from ^,
# for appropriate branchch/version of course
RDEPEND="
	${DEPEND}
	>=net-firewall/iptables-1.4
	sys-process/procps
	>=dev-vcs/git-1.7
	>=app-arch/xz-utils-4.9
	dev-libs/libltdl
	~app-emulation/containerd-1.4.3[apparmor?,btrfs?,device-mapper?,seccomp?]
	~app-emulation/runc-1.0.0_rc92[apparmor?,seccomp?]
	~app-emulation/docker-proxy-0.8.0_p20201215
	cli? ( app-emulation/docker-cli )
	container-init? ( >=sys-process/tini-0.19.0[static] )
"

# https://github.com/docker/docker/blob/master/project/PACKAGERS.md#build-dependencies
BDEPEND="
	>=dev-lang/go-1.13.12
	dev-go/go-md2man
	virtual/pkgconfig
"

RESTRICT="installsources strip"

S="${WORKDIR}/${P}/src/${EGO_PN}"

# see "contrib/check-config.sh" from upstream's sources
CONFIG_CHECK="
	~NAMESPACES ~NET_NS ~PID_NS ~IPC_NS ~UTS_NS
	~CGROUPS ~CGROUP_CPUACCT ~CGROUP_DEVICE ~CGROUP_FREEZER ~CGROUP_SCHED ~CPUSETS ~MEMCG
	~KEYS
	~VETH ~BRIDGE ~BRIDGE_NETFILTER
	~IP_NF_FILTER ~IP_NF_TARGET_MASQUERADE ~NETFILTER_XT_MARK
	~NETFILTER_NETLINK ~NETFILTER_XT_MATCH_ADDRTYPE ~NETFILTER_XT_MATCH_CONNTRACK ~NETFILTER_XT_MATCH_IPVS
	~IP_NF_NAT ~NF_NAT
	~POSIX_MQUEUE

	~USER_NS
	~SECCOMP
	~CGROUP_PIDS
	~MEMCG_SWAP

	~BLK_CGROUP ~BLK_DEV_THROTTLING
	~CGROUP_PERF
	~CGROUP_HUGETLB
	~NET_CLS_CGROUP
	~CFS_BANDWIDTH ~FAIR_GROUP_SCHED ~RT_GROUP_SCHED
	~IP_VS ~IP_VS_PROTO_TCP ~IP_VS_PROTO_UDP ~IP_VS_NFCT ~IP_VS_RR

	~VXLAN
	~CRYPTO ~CRYPTO_AEAD ~CRYPTO_GCM ~CRYPTO_SEQIV ~CRYPTO_GHASH ~XFRM_ALGO ~XFRM_USER
	~IPVLAN
	~MACVLAN ~DUMMY

	~OVERLAY_FS ~!OVERLAY_FS_REDIRECT_DIR
	~EXT4_FS_SECURITY
	~EXT4_FS_POSIX_ACL
"

ERROR_KEYS="CONFIG_KEYS: is mandatory"
ERROR_MEMCG_SWAP="CONFIG_MEMCG_SWAP: is required if you wish to limit swap usage of containers"
ERROR_RESOURCE_COUNTERS="CONFIG_RESOURCE_COUNTERS: is optional for container statistics gathering"

ERROR_BLK_CGROUP="CONFIG_BLK_CGROUP: is optional for container statistics gathering"
ERROR_IOSCHED_CFQ="CONFIG_IOSCHED_CFQ: is optional for container statistics gathering"
ERROR_CGROUP_PERF="CONFIG_CGROUP_PERF: is optional for container statistics gathering"
ERROR_CFS_BANDWIDTH="CONFIG_CFS_BANDWIDTH: is optional for container statistics gathering"
ERROR_XFRM_ALGO="CONFIG_XFRM_ALGO: is optional for secure networks"
ERROR_XFRM_USER="CONFIG_XFRM_USER: is optional for secure networks"

pkg_setup() {
	if kernel_is lt 3 10; then
		ewarn ""
		ewarn "Using Docker with kernels older than 3.10 is unstable and unsupported."
		ewarn " - http://docs.docker.com/engine/installation/binaries/#check-kernel-dependencies"
	fi

	if kernel_is le 3 18; then
		CONFIG_CHECK+="
			~RESOURCE_COUNTERS
		"
	fi

	if kernel_is le 3 13; then
		CONFIG_CHECK+="
			~NETPRIO_CGROUP
		"
	else
		CONFIG_CHECK+="
			~CGROUP_NET_PRIO
		"
	fi

	if kernel_is lt 4 5; then
		CONFIG_CHECK+="
			~MEMCG_KMEM
		"
		ERROR_MEMCG_KMEM="CONFIG_MEMCG_KMEM: is optional"
	fi

	if kernel_is lt 4 7; then
		CONFIG_CHECK+="
			~DEVPTS_MULTIPLE_INSTANCES
		"
	fi

	if kernel_is lt 5 1; then
		CONFIG_CHECK+="
			~NF_NAT_IPV4
			~IOSCHED_CFQ
			~CFQ_GROUP_IOSCHED
		"
	fi

	if kernel_is lt 5 2; then
		CONFIG_CHECK+="
			~NF_NAT_NEEDED
		"
	fi

	if kernel_is lt 5 8; then
		CONFIG_CHECK+="
			~MEMCG_SWAP_ENABLED
		"
	fi

	if use aufs; then
		CONFIG_CHECK+="
			~AUFS_FS
			~EXT4_FS_POSIX_ACL ~EXT4_FS_SECURITY
		"
		ERROR_AUFS_FS="CONFIG_AUFS_FS: is required to be set if and only if aufs is patched to kernel instead of using standalone"
	fi

	if use btrfs; then
		CONFIG_CHECK+="
			~BTRFS_FS
			~BTRFS_FS_POSIX_ACL
		"
	fi

	if use device-mapper; then
		CONFIG_CHECK+="
			~BLK_DEV_DM ~DM_THIN_PROVISIONING ~EXT4_FS ~EXT4_FS_POSIX_ACL ~EXT4_FS_SECURITY
		"
	fi

	linux-info_pkg_setup
}

src_compile() {
	export DOCKER_GITCOMMIT="${GIT_COMMIT}"
	export GOPATH="${WORKDIR}/${P}"

	# setup CFLAGS and LDFLAGS for separate build target
	# see https://github.com/tianon/docker-overlay/pull/10
	export CGO_CFLAGS="-I${ROOT}/usr/include"
	export CGO_LDFLAGS="-L${ROOT}/usr/$(get_libdir)"

	# let's set up some optional features :)
	export DOCKER_BUILDTAGS=''
	for gd in aufs btrfs device-mapper overlay; do
		if ! use $gd; then
			DOCKER_BUILDTAGS+=" exclude_graphdriver_${gd//-/}"
		fi
	done

	for tag in apparmor seccomp; do
		if use $tag; then
			DOCKER_BUILDTAGS+=" $tag"
		fi
	done

	if use hardened; then
		sed -i "s/EXTLDFLAGS_STATIC='/&-fno-PIC /" hack/make.sh || die
		grep -q -- '-fno-PIC' hack/make.sh || die 'hardened sed failed'
		sed  "s/LDFLAGS_STATIC_DOCKER='/&-extldflags -fno-PIC /" \
			-i hack/make/dynbinary-daemon || die
		grep -q -- '-fno-PIC' hack/make/dynbinary-daemon || die 'hardened sed failed'
	fi

	# build daemon
	./hack/make.sh dynbinary || die 'dynbinary failed'
}

src_install() {
	dosym containerd /usr/bin/docker-containerd
	dosym containerd-shim /usr/bin/docker-containerd-shim
	dosym runc /usr/bin/docker-runc
	use container-init && dosym tini /usr/bin/docker-init
	newbin bundles/dynbinary-daemon/dockerd dockerd

	newinitd contrib/init/openrc/docker.initd docker
	newconfd contrib/init/openrc/docker.confd docker

	systemd_dounit contrib/init/systemd/docker.{service,socket}

	udev_dorules contrib/udev/*.rules

	dodoc AUTHORS CONTRIBUTING.md CHANGELOG.md NOTICE README.md
	dodoc -r docs/*

	# note: intentionally not using "doins" so that we preserve +x bits
	dodir /usr/share/${PN}/contrib
	cp -R contrib/* "${ED}/usr/share/${PN}/contrib"
}

pkg_postinst() {
	udev_reload

	elog
	elog "To use Docker, the Docker daemon must be running as root. To automatically"
	elog "start the Docker daemon at boot:"
	if systemd_is_booted || has_version sys-apps/systemd; then
		elog "  systemctl enable docker.service"
	else
		elog "  rc-update add docker default"
	fi
	elog
	elog "To use Docker as a non-root user, add yourself to the 'docker' group:"
	elog '  usermod -aG docker <youruser>'
	elog

	if use device-mapper; then
		elog " Devicemapper storage driver has been deprecated"
		elog " It will be removed in a future release"
		elog
	fi

	if use overlay; then
		elog " Overlay storage driver/USEflag has been deprecated"
		elog " in favor of overlay2 (enabled unconditionally)"
		elog
	fi

	if has_version sys-fs/zfs; then
		elog " ZFS storage driver is available"
		elog " Check https://docs.docker.com/storage/storagedriver/zfs-driver for more info"
		elog
	fi

	if use cli; then
		ewarn "Starting with docker 20.10.2, docker has been split into"
		ewarn "two packages upstream, so Gentoo has followed suit."
		ewarn
		ewarn "app-emulation/docker contains the daemon and"
		ewarn "app-emulation/docker-cli contains the docker command."
		ewarn
		ewarn "docker currently installs docker-cli using the cli use flag."
		ewarn
		ewarn "This use flag is temporary, so you need to take the"
		ewarn "following actions:"
		ewarn
		ewarn "First, disable the cli use flag for app-emulation/docker"
		ewarn
		ewarn "Then, if you need docker-cli and docker on the same machine,"
		ewarn "run the following command:"
		ewarn
		ewarn "# emerge --noreplace docker-cli"
		ewarn
	fi
}
