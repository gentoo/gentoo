# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LLVM_MAX_SLOT=15

inherit llvm linux-info cmake toolchain-funcs

DESCRIPTION="High-level tracing language for eBPF"
HOMEPAGE="https://github.com/iovisor/bpftrace"
MY_PV="${PV//_/}"
SRC_URI="
	https://github.com/iovisor/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~chutzpah/dist/bpftrace/bpftrace-0.14.1-llvm14.patch.gz
"
S="${WORKDIR}/${PN}-${MY_PV:-${PV}}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="fuzzing test"
# lots of fixing needed
RESTRICT="test"

RDEPEND="
	>=dev-libs/libbpf-0.8:=
	<dev-libs/libbpf-1.0:=
	>=dev-util/bcc-0.13.0:=
	dev-util/systemtap
	<sys-devel/clang-$((${LLVM_MAX_SLOT} + 1)):=
	<sys-devel/llvm-$((${LLVM_MAX_SLOT} + 1)):=[llvm_targets_BPF(+)]
	sys-libs/binutils-libs:=
	virtual/libelf:=
"
DEPEND="
	${COMMON_DEPEND}
	dev-libs/cereal:=
	test? ( dev-cpp/gtest )
"
BDEPEND="
	sys-apps/sed
	app-arch/xz-utils
	sys-devel/flex
	sys-devel/bison
	virtual/pkgconfig
"

QA_DT_NEEDED="/usr/lib.*/libbpftraceresources.so"

PATCHES=(
	"${FILESDIR}/bpftrace-0.15.0-install-libs.patch"
	"${FILESDIR}/bpftrace-0.15.0-dont-compress-man.patch"
	"${FILESDIR}/bpftrace-0.11.4-old-kernels.patch"
	"${FILESDIR}/bpftrace-0.15.0-bcc-025.patch"
	"${FILESDIR}/bpftrace-0.15.0-binutils-2.39.patch"
	"${FILESDIR}/bpftrace-0.15.0-llvm-15-pointers.patch"
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
	llvm_pkg_setup
}

src_configure() {
	local -a mycmakeargs=(
		-DSTATIC_LINKING:BOOL=OFF
		# bug 809362, 754648
		-DBUILD_SHARED_LIBS:=OFF
		-DBUILD_TESTING:BOOL=OFF
		-DBUILD_FUZZ:BOOL=$(usex fuzzing)
		-DENABLE_MAN:BOOL=OFF
		-DLIBBPF_INCLUDE_DIRS="$($(tc-getPKG_CONFIG) --cflags-only-I libbpf | sed 's:-I::g')"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	# bug 809362
	dostrip -x /usr/bin/bpftrace
	doman man/man8/*.?
}
