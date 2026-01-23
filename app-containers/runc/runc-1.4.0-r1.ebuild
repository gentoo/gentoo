# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module linux-info

# update on bump, look for commit ID on release tag.
# https://github.com/opencontainers/runc
RUNC_COMMIT=8bd78a9977e604c4d5f67a7415d7b8b8c109cdc4

CONFIG_CHECK="~USER_NS"

DESCRIPTION="runc container cli tools"
HOMEPAGE="https://github.com/opencontainers/runc/"
MY_PV="${PV/_/-}"
SRC_URI="https://github.com/opencontainers/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="Apache-2.0 BSD-2 BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="apparmor hardened +kmem +seccomp selinux test"

COMMON_DEPEND="
	apparmor? ( sys-libs/libapparmor )
	seccomp? ( sys-libs/libseccomp )"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	!app-emulation/docker-runc
	selinux? ( sec-policy/selinux-container )"
BDEPEND="
	dev-go/go-md2man
	test? ( "${RDEPEND}" )"

# tests need busybox binary, and portage namespace
# sandboxing disabled: mount-sandbox pid-sandbox ipc-sandbox
# majority of tests pass
RESTRICT+=" test"

# Please refer:
# https://github.com/opencontainers/runc/blob/main/script/check-config.sh
pkg_setup() {
	CONFIG_CHECK="
		~NAMESPACES
		~NET_NS
		~PID_NS
		~IPC_NS
		~UTS_NS
		~CGROUPS
		~CGROUP_CPUACCT
		~CGROUP_DEVICE
		~CGROUP_FREEZER
		~CGROUP_SCHED
		~CPUSETS
		~MEMCG
		~KEYS
		~VETH
		~BRIDGE
		~BRIDGE_NETFILTER
		~IP_NF_FILTER
		~IP_NF_TARGET_MASQUERADE
		~NETFILTER_XT_MATCH_ADDRTYPE
		~NETFILTER_XT_MATCH_COMMENT
		~NETFILTER_XT_MATCH_CONNTRACK
		~NETFILTER_XT_MATCH_IPVS
		~IP_NF_NAT
		~NF_NAT
		~POSIX_MQUEUE
		~OVERLAY_FS
	"

	CONFIG_CHECK+="
		~USER_NS
	"

	use seccomp && CONFIG_CHECK+="
		~SECCOMP
		~SECCOMP_FILTER
	"
	WARNING_SECCOMP="CONFIG_SECCOMP is required as optional feature"

	CONFIG_CHECK+="
		~CGROUP_PIDS
	"
	WARNING_CGROUP_PIDS="CONFIG_CGROUP_PIDS is required as optional feature"

	if kernel_is lt 6 1; then
		CONFIG_CHECK+="
			~MEMCG_SWAP
		"
	fi

	CONFIG_CHECK+="
		~BLK_CGROUP
		~BLK_DEV_THROTTLING
		~CGROUP_PERF
		~CGROUP_HUGETLB
		~NET_CLS_CGROUP
		~CFS_BANDWIDTH
		~FAIR_GROUP_SCHED
		~RT_GROUP_SCHED
		~IP_NF_TARGET_REDIRECT
		~IP_VS
		~IP_VS_NFCT
		~IP_VS_PROTO_TCP
		~IP_VS_PROTO_UDP
		~IP_VS_RR
		~CHECKPOINT_RESTORE
		~CGROUP_NET_PRIO
	"

	use selinux && CONFIG_CHECK+="
		~SECURITY_SELINUX"

	use apparmor && CONFIG_CHECK+="
		~SECURITY_APPARMOR"

	if [[ -n ${CONFIG_CHECK} ]]; then
		linux-info_pkg_setup
	fi
}

src_compile() {
	# build up optional flags
	local options=(
		$(usev apparmor)
		$(usev seccomp)
		$(usex kmem '' 'nokmem')
	)

	myemakeargs=(
		BUILDTAGS="${options[*]}"
		COMMIT="${RUNC_COMMIT}"
	)

	emake "${myemakeargs[@]}" runc man
}

src_install() {
	myemakeargs+=(
		PREFIX="${ED}/usr"
		BINDIR="${ED}/usr/bin"
		MANDIR="${ED}/usr/share/man"
	)
	emake "${myemakeargs[@]}" install install-man install-bash

	local DOCS=( README.md PRINCIPLES.md docs/. )
	einstalldocs
}

src_test() {
	emake "${myemakeargs[@]}" localunittest
}
