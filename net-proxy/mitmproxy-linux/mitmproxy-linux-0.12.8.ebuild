# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Extra crates required at runtime via rustc-build-sysroot crate.
# Note: versions are locked in /usr/lib/rust/*/lib/rustlib/src/rust/library/Cargo.lock.
CRATES="
	addr2line@0.25.0
	adler2@2.0.1
	cfg-if@1.0.1
	compiler_builtins@0.1.160
	dlmalloc@0.2.9
	dlmalloc@0.2.10
	fortanix-sgx-abi@0.5.0
	fortanix-sgx-abi@0.6.1
	getopts@0.2.23
	gimli@0.32.0
	hashbrown@0.15.4
	hermit-abi@0.5.2
	libc@0.2.174
	memchr@2.7.5
	miniz_oxide@0.8.9
	object@0.37.1
	r-efi-alloc@2.1.0
	r-efi@5.3.0
	rustc-demangle@0.1.25
	rustc-literal-escaper@0.0.2
	rustc-literal-escaper@0.0.5
	unwinding@0.2.7
	unicode-width@0.2.1
	wasi@0.11.1+wasi-snapshot-preview1
"

# Implied by crates above.
RUST_MIN_VER=1.89.0
RUST_MAX_VER=1.90.0

declare -A GIT_CRATES=(
	[boringtun]='https://github.com/cloudflare/boringtun;2f3c85f5c4a601018c10b464b1ca890d9504bf6e;boringtun-%commit%/boringtun'
)

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{12..14} )
RUST_REQ_USE="llvm_targets_BPF(+),rust-src"

inherit cargo distutils-r1 pypi

DESCRIPTION="mitmproxy's Rust bits"
HOMEPAGE="
	https://github.com/mitmproxy/mitmproxy_rs/
	https://pypi.org/project/mitmproxy-rs/
"
SRC_URI+="
	${CARGO_CRATE_URIS}
	https://github.com/gentoo-crate-dist/mitmproxy_rs/releases/download/v${PV}/mitmproxy_rs-${PV}-crates.tar.xz
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD ISC
	LGPL-3+ MIT Unicode-3.0 WTFPL-2 ZLIB
"
SLOT="0"
KEYWORDS="amd64 ~arm64"

BDEPEND="
	dev-util/bpf-linker
"

src_prepare() {
	local PATCHES=(
		# aya-ebpf overwrites libc functions with incompatible
		# implementations that break everything, and therefore
		# can only be used for bpf* targets
		# https://github.com/aya-rs/aya/issues/1254
		"${FILESDIR}/${PN}-0.11.5-no-host-aya-ebpf.patch"
	)

	distutils-r1_src_prepare

	# replace upstream crate substitution with our crate substitution, sigh
	local bor_dep=$(grep ^boringtun "${ECARGO_HOME}"/config.toml || die)
	sed -i -e "/boringtun/s;^.*$;${bor_dep};" Cargo.toml || die

	# this only implicitly builds mitmproxy-linux-ebpf, and is broken
	# https://github.com/mitmproxy/mitmproxy/issues/7663
	rm mitmproxy-linux/build.rs || die
}

src_configure() {
	# first, we must build mitmproxy-linux-ebpf for the bpf target
	# bpf-linker requires BPF target that is only available in nightly
	local -x RUSTC_BOOTSTRAP=1
	# no clue why this needs to be explicit
	local -x RUSTFLAGS="-C linker=bpf-linker"

	local cmd=(
		"${CARGO}" build
		-Z build-std=core
		--bins
		--release
		--target=bpfel-unknown-none
	)

	pushd mitmproxy-linux-ebpf >/dev/null || die
	echo "${cmd[*]}" >&2
	"${cmd[@]}" || die "${cmd[*]} failed"
	popd >/dev/null || die

	export OUT_DIR="${S}/target/bpfel-unknown-none/release"
}

python_test() {
	cargo_src_test --manifest-path mitmproxy-linux/Cargo.toml
}
