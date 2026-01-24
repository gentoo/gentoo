# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_PV=${PV/_/-}

inherit go-module linux-info optfeature systemd toolchain-funcs udev

GIT_COMMIT=fbf3ed25f893e6ce21336f1101590e40a13934f4

DESCRIPTION="The core functions you need to create Docker images and run Docker containers"
HOMEPAGE="https://www.docker.com/"
SRC_URI="https://github.com/moby/moby/archive/${PN}-v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/moby-${PN}-v${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="apparmor btrfs +container-init cuda +overlay2 seccomp selinux systemd"

DEPEND="
	acct-group/docker
	>=dev-db/sqlite-3.7.9:3
	net-firewall/nftables:=
	apparmor? ( sys-libs/libapparmor )
	btrfs? ( >=sys-fs/btrfs-progs-3.16.1 )
	seccomp? ( >=sys-libs/libseccomp-2.2.1 )
	systemd? ( sys-apps/systemd )
"

# https://github.com/moby/moby/blob/master/project/PACKAGERS.md#runtime-dependencies
# https://github.com/moby/moby/blob/master/project/PACKAGERS.md#optional-dependencies
RDEPEND="
	${DEPEND}
	sys-process/procps
	>=dev-vcs/git-1.7
	>=app-arch/xz-utils-4.9
	>=app-containers/containerd-2.2.0[apparmor?,btrfs?,seccomp?]
	>=app-containers/runc-1.2.6[apparmor?,seccomp?]
	!app-containers/docker-proxy
	!<app-containers/docker-cli-${PV}
	container-init? ( >=sys-process/tini-0.19.0[static] )
	cuda? ( app-containers/nvidia-container-toolkit )
	selinux? ( sec-policy/selinux-docker )
"

# https://github.com/docker/docker/blob/master/project/PACKAGERS.md#build-dependencies
BDEPEND="
	dev-go/go-md2man
	virtual/pkgconfig
"
# tests require running dockerd as root and downloading containers
RESTRICT="installsources strip test"

# https://bugs.gentoo.org/748984 https://github.com/etcd-io/etcd/pull/12552
pkg_setup() {
	# this is based on "contrib/check-config.sh" from upstream's sources
	# required features.
	CONFIG_CHECK="
		~NAMESPACES ~NET_NS ~PID_NS ~IPC_NS ~UTS_NS
		~CGROUPS ~CGROUP_CPUACCT ~CGROUP_DEVICE ~CGROUP_FREEZER ~CGROUP_SCHED ~CPUSETS ~MEMCG
		~KEYS
		~VETH ~BRIDGE ~BRIDGE_NETFILTER
		~IP_NF_FILTER ~IP_NF_RAW ~IP_NF_TARGET_MASQUERADE
		~NETFILTER_XT_MATCH_ADDRTYPE
		~NETFILTER_XT_MATCH_CONNTRACK
		~NETFILTER_XT_MATCH_IPVS
		~NETFILTER_XT_MARK
		~IP_NF_NAT ~NF_NAT
		~POSIX_MQUEUE
	"
	WARNING_POSIX_MQUEUE="CONFIG_POSIX_MQUEUE: is required for bind-mounting /dev/mqueue into containers"

	if kernel_is ge 6 17; then
		CONFIG_CHECK+="
			~IP_NF_IPTABLES_LEGACY
			~NETFILTER_XTABLES_LEGACY
		"
	fi

	if kernel_is lt 4 8; then
		CONFIG_CHECK+="
			~DEVPTS_MULTIPLE_INSTANCES
		"
	fi

	if kernel_is le 5 1; then
		CONFIG_CHECK+="
			~NF_NAT_IPV4
		"
	fi

	if kernel_is le 5 2; then
		CONFIG_CHECK+="
			~NF_NAT_NEEDED
		"
	fi

	if kernel_is ge 4 15; then
		CONFIG_CHECK+="
			~CGROUP_BPF
		"
	fi

	# optional features
	CONFIG_CHECK+="
		~USER_NS
	"

	if use seccomp; then
		CONFIG_CHECK+="
			~SECCOMP ~SECCOMP_FILTER
		"
	fi

	CONFIG_CHECK+="
		~CGROUP_PIDS
	"

	if kernel_is lt 6 1; then
		CONFIG_CHECK+="
			~MEMCG_SWAP
			"
	fi

	if kernel_is le 5 8; then
		CONFIG_CHECK+="
			~MEMCG_SWAP_ENABLED
		"
	fi

	CONFIG_CHECK+="
		~!LEGACY_VSYSCALL_NATIVE
		"
	if kernel_is lt 5 19; then
		CONFIG_CHECK+="
			~LEGACY_VSYSCALL_EMULATE
			"
	fi
	CONFIG_CHECK+="
		~!LEGACY_VSYSCALL_NONE
		"
	WARNING_LEGACY_VSYSCALL_NONE="CONFIG_LEGACY_VSYSCALL_NONE enabled: \
		Containers with <=glibc-2.13 will not work"

	if kernel_is le 4 5; then
		CONFIG_CHECK+="
			~MEMCG_KMEM
		"
	fi

	if kernel_is lt 5; then
		CONFIG_CHECK+="
			~IOSCHED_CFQ ~CFQ_GROUP_IOSCHED
		"
	fi

	CONFIG_CHECK+="
		~BLK_CGROUP ~BLK_DEV_THROTTLING
		~CGROUP_PERF
		~CGROUP_HUGETLB
		~NET_CLS_CGROUP ~CGROUP_NET_PRIO
		~CFS_BANDWIDTH ~FAIR_GROUP_SCHED
		~IP_NF_TARGET_REDIRECT
		~IP_VS
		~IP_VS_NFCT
		~IP_VS_PROTO_TCP
		~IP_VS_PROTO_UDP
		~IP_VS_RR
		"

	if use selinux; then
		CONFIG_CHECK+="
			~SECURITY_SELINUX
			"
	fi

	if use apparmor; then
		CONFIG_CHECK+="
			~SECURITY_APPARMOR
			"
	fi

	# if ! is_set EXT4_USE_FOR_EXT2; then
	#	check_flags EXT3_FS EXT3_FS_XATTR EXT3_FS_POSIX_ACL EXT3_FS_SECURITY
	#	if ! is_set EXT3_FS || ! is_set EXT3_FS_XATTR || ! is_set EXT3_FS_POSIX_ACL || ! is_set EXT3_FS_SECURITY; then
	#		echo "    $(wrap_color '(enable these ext3 configs if you are using ext3 as backing filesystem)' bold black)"
	#	fi
	# fi

	CONFIG_CHECK+="
		~EXT4_FS ~EXT4_FS_POSIX_ACL ~EXT4_FS_SECURITY
	"

	# if ! is_set EXT4_FS || ! is_set EXT4_FS_POSIX_ACL || ! is_set EXT4_FS_SECURITY; then
	#	if is_set EXT4_USE_FOR_EXT2; then
	#		echo "    $(wrap_color 'enable these ext4 configs if you are using ext3 or ext4 as backing filesystem' bold black)"
	#	else
	#		echo "    $(wrap_color 'enable these ext4 configs if you are using ext4 as backing filesystem' bold black)"
	#	fi
	# fi

	# network drivers
	CONFIG_CHECK+="
		~VXLAN ~BRIDGE_VLAN_FILTERING
		~CRYPTO ~CRYPTO_AEAD ~CRYPTO_GCM ~CRYPTO_SEQIV ~CRYPTO_GHASH
		~XFRM ~XFRM_USER ~XFRM_ALGO ~INET_ESP
	"
	if kernel_is le 5 3; then
		CONFIG_CHECK+="
			~INET_XFRM_MODE_TRANSPORT
		"
	fi

	CONFIG_CHECK+="
		~IPVLAN
		"
	CONFIG_CHECK+="
		~MACVLAN ~DUMMY
		"
	CONFIG_CHECK+="
		~NF_NAT_FTP ~NF_CONNTRACK_FTP ~NF_NAT_TFTP ~NF_CONNTRACK_TFTP
	"

	# storage drivers
	if use btrfs; then
		CONFIG_CHECK+="
			~BTRFS_FS
			~BTRFS_FS_POSIX_ACL
		"
	fi

	CONFIG_CHECK+="
		~OVERLAY_FS
	"

	linux-info_pkg_setup
}

src_unpack() {
	default
	go-module_src_unpack
	cd "${S}"
	[[ -f go.mod ]] || ln -s vendor.mod go.mod || die
	[[ -f go.sum ]] || ln -s vendor.sum go.sum || die
}

src_compile() {
	export DOCKER_GITCOMMIT="${GIT_COMMIT}"
	export VERSION=${PV}
	tc-export PKG_CONFIG

	# setup CFLAGS and LDFLAGS for separate build target
	# see https://github.com/tianon/docker-overlay/pull/10
	CGO_CFLAGS+=" -I${ESYSROOT}/usr/include"
	CGO_LDFLAGS+=" -L${ESYSROOT}/usr/$(get_libdir)"

	# let's set up some optional features :)
	export DOCKER_BUILDTAGS=''
	for gd in btrfs overlay2; do
		if ! use $gd; then
			DOCKER_BUILDTAGS+=" exclude_graphdriver_${gd//-/}"
		fi
	done

	for tag in apparmor seccomp; do
		if use $tag; then
			DOCKER_BUILDTAGS+=" $tag"
		fi
	done

	export AUTO_GOPATH=1
	export EXCLUDE_AUTO_BUILDTAG_JOURNALD=$(usex systemd '' 'y')
	export GO_MD2MAN=/usr/bin/go-md2man

	# build binaries
	./hack/make.sh dynbinary || die 'dynbinary failed'

	# build man page
	cd man || die
	emake || die
}

src_install() {
	dosym containerd /usr/bin/docker-containerd
	dosym containerd-shim-runc-v2 /usr/bin/docker-containerd-shim
	dosym runc /usr/bin/docker-runc
	use container-init && dosym tini /usr/bin/docker-init
	dobin bundles/dynbinary-daemon/dockerd
	dobin bundles/dynbinary-daemon/docker-proxy
	for f in dockerd-rootless-setuptool.sh dockerd-rootless.sh; do
		dosym ../share/docker/contrib/${f} /usr/bin/${f}
	done

	newinitd contrib/init/openrc/docker.initd docker
	newconfd contrib/init/openrc/docker.confd docker

	systemd_dounit contrib/init/systemd/docker.{service,socket}

	dodoc AUTHORS CONTRIBUTING.md NOTICE README.md
	dodoc -r docs/*
	doman man/man8/dockerd.8

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

	if has_version sys-fs/zfs; then
		elog " ZFS storage driver is available"
		elog " Check https://docs.docker.com/storage/storagedriver/zfs-driver for more info"
		elog
	fi

	optfeature "rootless mode support" sys-apps/shadow
	optfeature "rootless mode support" sys-apps/rootlesskit
	optfeature_header "for rootless mode you also need a network stack"
	optfeature "rootless mode network stack" app-containers/slirp4netns
}
