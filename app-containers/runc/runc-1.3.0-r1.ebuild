# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module linux-info

# update on bump, look for commit ID on release tag.
# https://github.com/opencontainers/runc
RUNC_COMMIT=4ca628d1d4c974f92d24daccb901aa078aad748e

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
# https://github.com/opencontainers/runc/blob/b1722d790214952e8a20d4ddd6a83451b9b665a1/script/check-config.sh#L233
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

	if kernel_is ge 4 10; then
		CONFIG_CHECK+="
			~BPF
		"
	fi

	if kernel_is lt 5 1; then
		CONFIG_CHECK+="
			~NF_NAT_IPV4
		"
	fi

	if kernel_is lt 5 2; then
		CONFIG_CHECK+="
			~NF_NAT_NEEDED
		"
	fi

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

	if linux_config_exists && kernel_is lt 5 8; then
		if linux_chkconfig_present MEMCG_SWAP_ENABLED; then
			if linux_chkconfig_present MEMCG_SWAP && ! linux_chkconfig_present MEMCG_SWAP_ENABLED; then
				echo "note that cgroup swap accounting is not enabled in your kernel config, you can enable it by setting boot option \"swapaccount=1\""
			fi
		fi
	fi

	if kernel_is lt 4 5; then
		if linux_config_exists && ! linux_chkconfig_present MEMCG_KMEM; then
			ewarn "CONFIG_MEMCG_KMEM is needed"
		fi
	fi

	if kernel_is lt 3 9; then
		if linux_config_exists && ! linux_chkconfig_present RESOURCE_COUNTERS; then
			ewarn "CONFIG_RESOURCE_COUNTERS is needed"
		fi
	fi

	if kernel_is lt 5 0; then
		if linux_config_exists && ! linux_chkconfig_present IOSCHED_CFQ &&
			! linux_chkconfig_present CFQ_GROUP_IOSCHED; then
			ewarn "CONFIG_IOSCHED_CFQ is needed"
			ewarn "CONFIG_CFQ_GROUP_IOSCHED is needed"
		fi
	fi

	if kernel_is ge 5 4; then
		if linux_config_exists && ! linux_chkconfig_present BLK_CGROUP_IOCOST; then
			ewarn "CONFIG_BLK_CGROUP_IOCOST is needed"
		fi
	fi

	CONFIG_CHECK+="
		~BLK_CGROUP
		~BLK_DEV_THROTTLING
		~CGROUP_PERF
		~CGROUP_HUGETLB
		~NET_CLS_CGROUP
		~CFS_BANDWIDTH FAIR_GROUP_SCHED RT_GROUP_SCHED
		~IP_NF_TARGET_REDIRECT
		~IP_VS
		~IP_VS_NFCT
		~IP_VS_PROTO_TCP
		~IP_VS_PROTO_UDP
		~IP_VS_RR
		~CHECKPOINT_RESTORE
	"

	use selinux && CONFIG_CHECK+="
		~SECURITY_SELINUX"

	use apparmor && CONFIG_CHECK+="
		~SECURITY_APPARMOR"

	if kernel_is lt 3 14; then
		CONFIG_CHECK+="
			~NETPRIO_CGROUP"
	else
		CONFIG_CHECK+="
			~CGROUP_NET_PRIO"
	fi

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
