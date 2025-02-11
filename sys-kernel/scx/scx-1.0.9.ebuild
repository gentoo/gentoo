# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {16..19} )

# List of crates for pycargoebuild:
# rust/scx_{loader,rustland_core,stats,utils}
# scheds/rust/scx_{bpfland,lavd,layered,rlfifo,rustland,rusty}
CRATES="
"

RUST_MIN_VER="1.74.1"

inherit llvm-r1 linux-info cargo rust-toolchain meson

DESCRIPTION="sched_ext schedulers and tools"
HOMEPAGE="https://github.com/sched-ext/scx"
SRC_URI="
	https://github.com/sched-ext/scx/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"
if [[ ${PKGBUMPING} != ${PVR} ]]; then
	SRC_URI+="
		https://github.com/gentoo-crate-dist/scx/releases/download/v${PV}/scx-v${PV}-crates.tar.xz
	"
fi

LICENSE="GPL-2"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD-2 BSD CC0-1.0 ISC MIT MPL-2.0 Unicode-3.0 ZLIB
"
SLOT="0"
KEYWORDS="~amd64"
IUSE="openrc systemd"

DEPEND="
	virtual/libelf:=
	sys-libs/zlib:=
	>=dev-libs/libbpf-1.5:=
	openrc? ( || (
		sys-apps/openrc
		sys-apps/openrc-navi
	) )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	app-misc/jq
	>=dev-util/bpftool-7.5.0
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}=[llvm_targets_BPF(-)]
	')
"

CONFIG_CHECK="
	~BPF
	~BPF_EVENTS
	~BPF_JIT
	~BPF_SYSCALL
	~DEBUG_INFO_BTF
	~FTRACE
	~SCHED_CLASS_EXT
"

QA_PREBUILT="/usr/bin/scx_loader"

pkg_setup() {
	linux-info_pkg_setup
	llvm-r1_pkg_setup
	rust_pkg_setup
}

src_prepare() {
	default

	# Inject the rust_abi value into install_rust_user_scheds
	sed -i "s;\${MESON_BUILD_ROOT};\${MESON_BUILD_ROOT}/$(rust_abi);" \
		meson-scripts/install_rust_user_scheds || die

	# bug #944832
	sed -i 's;^#!/usr/bin/;#!/sbin/;' \
		services/openrc/scx.initrd || die
}

src_configure() {
	BUILD_DIR="${BUILD_DIR:-${WORKDIR}/${P}-build}"

	local emesonargs=(
		-Dbpf_clang="$(get_llvm_prefix)/bin/clang"
		-Dbpftool=disabled
		-Dlibbpf_a=disabled
		-Dcargo="${EPREFIX}/usr/bin/cargo"
		-Dcargo_home="${ECARGO_HOME}"
		-Doffline=true
		-Denable_rust=true
		-Dlibalpm=disabled
		$(meson_feature openrc)
		$(meson_feature systemd)
	)

	cargo_env meson_src_configure
}

src_compile() {
	cargo_env meson_src_compile
}

src_test() {
	cargo_env meson_src_test
}

src_install() {
	cargo_env meson_src_install

	dodoc README.md

	local readme readme_name
	for readme in scheds/{rust,c}/*/README.md ./rust/*/README.md; do
		[[ -e ${readme} ]] || continue
		readme_name="${readme#*/rust/}"
		readme_name="${readme_name#*/c/}"
		readme_name="${readme_name%/README.md}"
		newdoc "${readme}" "${readme_name}.md"
	done
}
