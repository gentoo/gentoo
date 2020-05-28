# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs linux-info cmake-utils

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

COMMON_DEPEND="dev-util/systemtap
	sys-devel/clang:=
	dev-libs/libbpf:=
	>=sys-devel/llvm-3.7.1:=[llvm_targets_BPF(+)]
	<sys-devel/clang-10:=
	<sys-devel/llvm-10:=[llvm_targets_BPF(+)]
	>=dev-util/bcc-0.12.0:=
	virtual/libelf"
DEPEND="${COMMON_DEPEND}
	test? ( dev-cpp/gtest )"
RDEPEND="${COMMON_DEPEND}"
BDEPEND+="dev-util/cmake
	sys-devel/flex
	sys-devel/bison"

S="${WORKDIR}/${PN}-${MY_PV}"
QA_DT_NEEDED="/usr/lib.*/libbpftraceresources.so"

PATCHES=(
	"${FILESDIR}/bpftrace-0.10.0-install-libs.patch"
	"${FILESDIR}/bpftrace-0.10.0-dont-compress-man.patch"
	"${FILESDIR}/bpftrace-0.10.0-llvm-multi.patch"
)

# lots of fixing needed
RESTRICT="test"

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

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local -a mycmakeargs
	mycmakeargs=(
		"-DSTATIC_LINKING:BOOL=OFF"
		"-DBUILD_TESTING:BOOL=OFF"
	)

	cmake-utils_src_configure
}
