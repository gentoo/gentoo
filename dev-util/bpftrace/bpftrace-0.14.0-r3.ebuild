# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs llvm linux-info cmake

DESCRIPTION="High-level tracing language for eBPF"
HOMEPAGE="https://github.com/iovisor/bpftrace"
MY_PV="${PV//_/}"
SRC_URI="https://github.com/iovisor/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV:-${PV}}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fuzzing test"
# lots of fixing needed
RESTRICT="test"

RDEPEND="
	dev-libs/libbpf:=
	>=dev-util/bcc-0.13.0:=
	dev-util/systemtap
	<=sys-devel/clang-14:=
	<=sys-devel/llvm-14:=[llvm_targets_BPF(+)]
	sys-libs/binutils-libs:=
	virtual/libelf
"
DEPEND="
	${COMMON_DEPEND}
	dev-libs/cereal:=
	test? ( dev-cpp/gtest )
"
BDEPEND="
	app-arch/xz-utils
	sys-devel/flex
	sys-devel/bison
"

QA_DT_NEEDED="/usr/lib.*/libbpftraceresources.so"

PATCHES=(
	"${FILESDIR}/bpftrace-0.14.0-install-libs.patch"
	"${FILESDIR}/bpftrace-0.14.0-dont-compress-man.patch"
	"${FILESDIR}/bpftrace-0.11.4-old-kernels.patch"
	"${FILESDIR}/bpftrace-0.12.0-fuzzing-build.patch"
)

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
	LLVM_MAX_SLOT=13 llvm_pkg_setup
}

src_configure() {
	local -a mycmakeargs=(
		-DSTATIC_LINKING:BOOL=OFF
		-DBUILD_TESTING:BOOL=OFF
		-DBUILD_FUZZ:BOOL=$(usex fuzzing)
		-DENABLE_MAN:BOOL=OFF
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	doman man/man8/*.?
}
