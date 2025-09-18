# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {17..21} )
RUST_MIN_VER=1.85.1
RUST_OPTIONAL=1

inherit cmake flag-o-matic linux-info llvm-r1 rust

DESCRIPTION="High-level tracing language for eBPF"
HOMEPAGE="https://github.com/bpftrace/bpftrace"
MY_PV="${PV//_/}"
# the man page version may trail the release
#MAN_V="0.24.0"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/bpftrace/bpftrace"
	EGIT_BRANCH="release/0.24.x"
	inherit git-r3
else
	SRC_URI="https://github.com/bpftrace/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64"
fi

SRC_URI+=" https://github.com/bpftrace/${PN}/releases/download/v${MAN_V:-${PV}}/man.tar.xz -> ${PN}-${MAN_V:-${PV}}-man.tar.xz"

S="${WORKDIR}/${PN}-${MY_PV:-${PV}}"

LICENSE="Apache-2.0"
SLOT="0"

IUSE="pcap test systemd"

RESTRICT="!test? ( test )"

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
	app-editors/vim-core
	dev-libs/cereal
	dev-util/bpftool
	test? (
		${RUST_DEPEND}
		dev-lang/go
		dev-util/pahole
	)
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/bpftrace-0.11.4-old-kernels.patch"
	"${FILESDIR}/bpftrace-0.21.0-dont-compress-man.patch"
	"${FILESDIR}/bpftrace-0.24.0-gcc16.patch"
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
	llvm-r1_pkg_setup
	use test && rust_pkg_setup
}

src_prepare() {
	# create a usable version from git
	if [[ ${PV} == *9999* ]] ; then
		local rev=$(git branch --show-current | sed -e 's/* //g' -e 's/release\///g')-$(git rev-parse --short HEAD)
		sed -i "/configure_file/i set (BPFTRACE_VERSION \"v${rev}\")" cmake/Version.cmake || die
	fi

	# unpack prepackaged man tarball for bpftrace.8
	pushd "${WORKDIR}" && unpack ${PN}-${MAN_V:-${PV}}-man.tar.xz && popd

	cmake_src_prepare
}

src_configure() {
	# suppress one remaining and benign ODR violation warning due to
	# a generated libbpf header used by the tests, see:
	# https://github.com/bpftrace/bpftrace/issues/4591
	use test && append-flags -Wno-odr

	local mycmakeargs=(
		# DO NOT build the internal libs as shared
		-DBUILD_SHARED_LIBS=OFF
		# DO dynamically link the bpftrace executable
		-DSTATIC_LINKING:BOOL=OFF
		-DBUILD_TESTING:BOOL=$(usex test)
		# we use the pregenerated man page
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
