# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs llvm linux-info cmake

DESCRIPTION="High-level tracing language for eBPF"
HOMEPAGE="https://github.com/iovisor/bpftrace"

if [[ ${PV} =~ 9{4,} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/iovisor/${PN}"
	BDEPEND=""
else
	MY_PV="${PV//_/}"
	SRC_URI="https://github.com/iovisor/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
	BDEPEND="app-arch/xz-utils "
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

COMMON_DEPEND="
	dev-util/systemtap
	dev-libs/libbpf:=
	>=sys-devel/llvm-3.7.1:=[llvm_targets_BPF(+)]
	<=sys-devel/llvm-12:=[llvm_targets_BPF(+)]
	<=sys-devel/clang-12:=
	>=dev-util/bcc-0.13.0:=
	virtual/libelf
"
DEPEND="${COMMON_DEPEND}
	test? ( dev-cpp/gtest )
"
RDEPEND="${COMMON_DEPEND}"
BDEPEND+="
	>=dev-util/cmake-3.8
	sys-devel/flex
	sys-devel/bison
"

S="${WORKDIR}/${PN}-${MY_PV:-${PV}}"
QA_DT_NEEDED="/usr/lib.*/libbpftraceresources.so"

PATCHES=(
	"${FILESDIR}/bpftrace-0.11.0-install-libs.patch"
	"${FILESDIR}/bpftrace-0.10.0-dont-compress-man.patch"
	"${FILESDIR}/bpftrace-0.11.4-old-kernels.patch"
)

# lots of fixing needed
RESTRICT="test"

# https://bugs.gentoo.org/754648
RESTRICT+=" strip"

pkg_pretend() {
	local CONFIG_CHECK="
		~BPF
		~BPF_EVENTS
		~BPF_JIT
		~BPF_SYSCALL
		~FTRACE_SYSCALLS
		~HAVE_EBPF_JIT
	"

	check_extra_config
}

pkg_setup() {
	LLVM_MAX_SLOT=11 llvm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local -a mycmakeargs
	mycmakeargs=(
		"-DSTATIC_LINKING:BOOL=OFF"
		"-DBUILD_TESTING:BOOL=OFF"
	)

	cmake_src_configure
}
