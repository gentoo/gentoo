# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {16..20} )

inherit cmake linux-info llvm-r1

DESCRIPTION="High-level tracing language for eBPF"
HOMEPAGE="https://github.com/bpftrace/bpftrace"
MY_PV="${PV//_/}"
# the man page version may trail the release
#MAN_V="0.22.0"
SRC_URI="
	https://github.com/bpftrace/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
	https://github.com/bpftrace/${PN}/releases/download/v${MAN_V:-${PV}}/man.tar.xz -> ${PN}-${MAN_V:-${PV}}-man.tar.xz
"
S="${WORKDIR}/${PN}-${MY_PV:-${PV}}"

LICENSE="Apache-2.0"
SLOT="0"

KEYWORDS="~amd64"
IUSE="pcap test systemd"

# lots of fixing needed
RESTRICT="test"

RDEPEND="
	>=dev-libs/blazesym_c-0.1.1
	>=dev-libs/libbpf-1.5:=
	>=dev-util/bcc-0.25.0:=
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}=
		llvm-core/llvm:${LLVM_SLOT}=[llvm_targets_BPF(+)]
	')
	sys-process/procps
	sys-libs/binutils-libs:=
	virtual/libelf:=
	systemd? ( sys-apps/systemd:= )
	pcap? ( net-libs/libpcap:= )
"
DEPEND="
	${RDEPEND}
	dev-libs/cereal:=
	test? ( dev-cpp/gtest )
"
BDEPEND="
	app-arch/xz-utils
	app-alternatives/lex
	app-alternatives/yacc
	dev-libs/cereal
	test? (
		app-editors/vim-core
		dev-util/pahole
	)
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/bpftrace-0.11.4-old-kernels.patch"
	"${FILESDIR}/bpftrace-0.21.0-dont-compress-man.patch"
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

src_prepare() {
	# 0.23 still has LLDB support, but apparently it's problematic,
	# deprecated and already gone on master.
	# Remove the configuration check.
	sed -i "/find_package(LLDB)/d" CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		# DO NOT build the internal libs as shared
		-DBUILD_SHARED_LIBS=OFF
		# DO dynamically link the bpftrace executable
		-DSTATIC_LINKING:BOOL=OFF
		# bug 809362, 754648
		-DBUILD_TESTING:BOOL=$(usex test)
		-DBUILD_FUZZ:BOOL=OFF
		-DENABLE_MAN:BOOL=OFF
		-DENABLE_SYSTEMD:BOOL=$(usex systemd)
		-DENABLE_SKB_OUTPUT:BOOL=$(usex pcap)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	doman man/man8/*.?
	gunzip "${WORKDIR}/man/man8/bpftrace.8.gz" || die
	doman "${WORKDIR}/man/man8/bpftrace.8"
}
