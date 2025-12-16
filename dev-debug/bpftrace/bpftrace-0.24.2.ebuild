# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {17..21} )
RUST_MIN_VER="1.85.1"
RUST_OPTIONAL=1

inherit cmake flag-o-matic linux-info llvm-r1 rust

DESCRIPTION="High-level tracing language for eBPF"
HOMEPAGE="https://github.com/bpftrace/bpftrace"
MY_PV="${PV//_/}"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/bpftrace/bpftrace"
	EGIT_BRANCH="release/0.24.x"
	inherit git-r3
	# use a released man page for git
	MAN_V="0.24.2"
else
	SRC_URI="https://github.com/bpftrace/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64"
	# the man page version may trail the release
	#MAN_V="0.24.2"
fi

SRC_URI+=" https://github.com/bpftrace/${PN}/releases/download/v${MAN_V:-${PV}}/man.tar.xz -> ${PN}-${MAN_V:-${PV}}-man.tar.xz"

S="${WORKDIR}/${PN}-${MY_PV:-${PV}}"

LICENSE="Apache-2.0"
SLOT="0"

IUSE="pcap systemd test"

RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/blazesym_c-0.1.1
	>=dev-libs/libbpf-1.5:=
	>=dev-util/bcc-0.25.0
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}=
		llvm-core/llvm:${LLVM_SLOT}=[llvm_targets_BPF(+)]
	')
	sys-libs/binutils-libs:=
	virtual/libelf:=
	systemd? ( sys-apps/systemd:= )
	pcap? ( net-libs/libpcap:= )
	virtual/zlib:=
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
	dev-util/bpftool
	|| ( dev-util/xxd app-editors/vim-core )
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
	"${FILESDIR}/bpftrace-0.24.1-enable-ubsan.patch"
)

pkg_pretend() {
	local CONFIG_CHECK="
		~BPF
		~BPF_EVENTS
		~BPF_JIT
		~BPF_SYSCALL
		~DEBUG_INFO_BTF
		~DEBUG_INFO_BTF_MODULES
		~FTRACE_SYSCALLS
		~HAVE_EBPF_JIT
	"

	check_extra_config

	if use test; then
		if ! linux_config_exists ; then
			die "Unable to check your kernel for BTF support: tests cannot run."
		elif ! linux_chkconfig_present DEBUG_INFO_BTF ; then
			die "CONFIG_DEBUG_INFO_BTF is not set: tests cannot run."
		fi
	fi
}

pkg_setup() {
	llvm-r1_pkg_setup
	use test && rust_pkg_setup
}

# git-r3 overrides automatic SRC_URI unpacking
src_unpack() {
	default

	if [[ ${PV} == *9999* ]] ; then
		git-r3_src_unpack
	fi
}

src_prepare() {
	# create a usable version from git
	if [[ ${PV} == *9999* ]] ; then
		local rev=$(git branch --show-current | sed -e 's/* //g' -e 's/release\///g')-$(git rev-parse --short HEAD)
		sed -i "/configure_file/i set (BPFTRACE_VERSION \"${rev}\")" cmake/Version.cmake || die
	fi

	cmake_src_prepare
}

src_configure() {
	# suppress one remaining and benign ODR violation warning due to
	# a generated libbpf header used by the tests, see:
	# https://github.com/bpftrace/bpftrace/issues/4591
	use test && append-flags -Wno-odr

	local mycmakeargs=(
		# DO dynamically link the bpftrace executable
		-DSTATIC_LINKING=OFF
		# DO NOT build the internal libs as shared
		-DBUILD_SHARED_LIBS=OFF
		-DBUILD_TESTING=$(usex test)
		# we use the pregenerated man page
		-DENABLE_MAN=OFF
		-DENABLE_SKB_OUTPUT=$(usex pcap)
		-DENABLE_SYSTEMD=$(usex systemd)
	)

	# enable UBSAN only when enabled in the toolchain
	if is-flagq -fsanitize=undefined; then
		filter-flags -fsanitize=undefined
		mycmakeargs+=( -DBUILD_UBSAN=ON )
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install
	doman man/man8/*.?
	gunzip "${WORKDIR}/man/man8/bpftrace.8.gz" || die
	doman "${WORKDIR}/man/man8/bpftrace.8"
}
