# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Extra crates required at runtime via rustc-build-sysroot crate.
# Note: versions are locked in /usr/lib/rust/*/lib/rustlib/src/rust/library/Cargo.lock.
CRATES="
	compiler_builtins@0.1.146
	compiler_builtins@0.1.152
	compiler_builtins@0.1.158
	compiler_builtins@0.1.160
"

# Implied by crates above.
RUST_MIN_VER=1.86.0
RUST_MAX_VER=1.89.0

declare -A GIT_CRATES=(
	[compiletest_rs]='https://github.com/Manishearth/compiletest-rs;0c1418d5cd5177ee9d863a5c2f300c0973cfc4f1;compiletest-rs-%commit%'
)

# LLVM 19 fails on assertions
LLVM_COMPAT=( {20..21} )
RUST_REQ_USE="llvm_targets_BPF(+),rust-src"

inherit cargo llvm-r2

DESCRIPTION="Simple BPF static linker"
HOMEPAGE="https://github.com/aya-rs/bpf-linker/"
SRC_URI="
	https://github.com/aya-rs/bpf-linker/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	https://github.com/gentoo-crate-dist/bpf-linker/releases/download/v${PV}/${P}-crates.tar.xz
	${CARGO_CRATE_URIS}
"

LICENSE="|| ( MIT Apache-2.0 )"
# Dependent crate licenses
LICENSE+="
	ISC MIT Unicode-3.0 Unicode-DFS-2016
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	$(llvm_gen_dep '
		llvm-core/llvm:${LLVM_SLOT}=[llvm_targets_BPF]
	')
"
RDEPEND="
	${DEPEND}
	${RUST_DEPEND}
"
BDEPEND="
	test? (
		dev-util/btfdump
	)
"

QA_FLAGS_IGNORED=/usr/bin/bpf-linker

pkg_setup() {
	rust_pkg_setup
}

src_prepare() {
	default

	# replace upstream crate substitution with our crate substitution, sigh
	local ct_dep=$(grep ^compiletest_rs "${ECARGO_HOME}"/config.toml || die)
	sed -i -e "/compiletest_rs/s;^.*$;${ct_dep};" Cargo.toml || die
}

src_configure() {
	local myfeatures=(
		"llvm-${LLVM_SLOT}"
		rustc-build-sysroot
	)
	cargo_src_configure --no-default-features

	export "LLVM_SYS_${LLVM_SLOT}1_PREFIX"="$(get_llvm_prefix -d)"
	# the package requires BPF target that is only available in nightly
	export RUSTC_BOOTSTRAP=1
}
