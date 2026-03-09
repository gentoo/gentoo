# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {16..21} )

RUST_MIN_VER="1.88.0"

inherit cargo llvm-r2 linux-info

DESCRIPTION="sched_ext schedulers and tools"
HOMEPAGE="https://github.com/sched-ext/scx"
SRC_URI="
	https://github.com/sched-ext/scx/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"
if [[ ${PKGBUMPING} != ${PVR} ]]; then
	SRC_URI+="
		https://github.com/gentoo-crate-dist/scx/releases/download/v${PV}/scx-${PV}-crates.tar.xz
	"
fi

LICENSE="GPL-2"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD-2 BSD CC0-1.0 ISC MIT MPL-2.0 Unicode-3.0 ZLIB
"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/libbpf-1.6:=
	sys-libs/libseccomp
	virtual/libelf:=
	virtual/zlib:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	app-misc/jq
	dev-libs/protobuf[protoc(+)]
	>=dev-util/bpftool-7.5.0
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}=[llvm_targets_BPF(-)]
	')
"
PDEPEND="~sys-kernel/scx-loader-${PV}"

CONFIG_CHECK="
	~BPF
	~BPF_EVENTS
	~BPF_JIT
	~BPF_JIT_ALWAYS_ON
	~BPF_JIT_DEFAULT_ON
	~BPF_SYSCALL
	~DEBUG_INFO_BTF
	~FTRACE
	~SCHED_CLASS_EXT
"

QA_PREBUILT="/usr/bin/vmlinux_docify"

PATCHES=(
	# Made obsolete by rebasing upstream, can be dropped in 1.1.1
	"${FILESDIR}/${P}-scx_cake-musl-fix.patch"
)

pkg_setup() {
	linux-info_pkg_setup
	llvm-r2_pkg_setup
	rust_pkg_setup
}

src_compile() {
	local -x BPF_CLANG=clang-${LLVM_SLOT}
	cargo_src_compile
}

src_test() {
	# Skip broken tests in scx_mitosis and scx_utils
	# Upstream: https://github.com/sched-ext/scx/issues/3418
	cargo_src_test -- \
		--skip cell_manager::tests::test_borrowable_cpumasks_respects_cpuset \
		--skip cell_manager::tests::test_cpuset_parsing_from_file \
		--skip cell_manager::tests::test_deficit_all_cells_exceed_target \
		--skip cell_manager::tests::test_symmetric_pairwise_overlap_produces_equal_cells \
		--skip cpumask::tests::test_to_cpulist_roundtrip
}

src_install() {
	einfo "Installing schedulers"
	local sched
	for sched in scheds/rust/scx_*; do
		einfo "Installing ${sched#scheds/rust/}"
		dobin "target/$(usex debug debug release)/${sched#scheds/rust}"
	done

	einfo "Installing tools"
	dobin target/$(usex debug debug release)/{scx{cash,top},vmlinux_docify}

	dodoc README.md

	local readme readme_name
	for readme in scheds/rust/*/README.md ./rust/*/README.md; do
		[[ -e ${readme} ]] || continue
		readme_name="${readme#*/rust/}"
		readme_name="${readme_name%/README.md}"
		newdoc "${readme}" "${readme_name}.md"
	done
}
