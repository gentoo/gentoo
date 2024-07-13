# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=18

inherit llvm linux-info cmake

DESCRIPTION="High-level tracing language for eBPF"
HOMEPAGE="https://github.com/bpftrace/bpftrace"
MY_PV="${PV//_/}"
SRC_URI="https://github.com/bpftrace/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV:-${PV}}"

LICENSE="Apache-2.0"
SLOT="0"

KEYWORDS="amd64 ~arm64 ~x86"
IUSE="lldb test"

# lots of fixing needed
RESTRICT="test"

RDEPEND="
	>=dev-libs/libbpf-1.1:=
	>=dev-util/bcc-0.25.0:=
	lldb? ( >=dev-debug/lldb-15 )
	>=sys-devel/llvm-15[llvm_targets_BPF(+)]
	>=sys-devel/clang-15
	<sys-devel/clang-$((${LLVM_MAX_SLOT} + 1)):=
	<sys-devel/llvm-$((${LLVM_MAX_SLOT} + 1)):=[llvm_targets_BPF(+)]
	sys-process/procps
	sys-libs/binutils-libs:=
	virtual/libelf:=
"
DEPEND="
	${COMMON_DEPEND}
	dev-libs/cereal:=
	test? ( dev-cpp/gtest )
"
BDEPEND="
	app-arch/xz-utils
	app-alternatives/lex
	app-alternatives/yacc
	test? (
		app-editors/vim-core
		dev-util/pahole
	)
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/bpftrace-0.21.0-dont-compress-man.patch"
	"${FILESDIR}/bpftrace-0.11.4-old-kernels.patch"
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
	local mycmakeargs=(
		# prevent automagic lldb use
		$(cmake_use_find_package lldb LLDB)
		# DO NOT build the internal libs as shared
		-DBUILD_SHARED_LIBS=OFF
		# DO dynamically link the bpftrace executable
		-DSTATIC_LINKING:BOOL=OFF
		# bug 809362, 754648
		-DBUILD_TESTING:BOOL=$(usex test)
		-DBUILD_FUZZ:BOOL=OFF
		-DENABLE_MAN:BOOL=OFF
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	doman man/man8/*.?
}
