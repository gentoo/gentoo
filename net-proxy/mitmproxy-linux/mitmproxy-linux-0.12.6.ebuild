# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Extra crates required at runtime via rustc-build-sysroot crate.
# Note: versions are locked in /usr/lib/rust/*/lib/rustlib/src/rust/library/Cargo.lock.
CRATES="
	compiler_builtins@0.1.146
	compiler_builtins@0.1.152
	dlmalloc@0.2.7
	fortanix-sgx-abi@0.5.0
	getopts@0.2.21
	hermit-abi@0.4.0
	hermit-abi@0.5.0
	libc@0.2.169
	libc@0.2.171
	miniz_oxide@0.8.3
	r-efi-alloc@1.0.0
	r-efi@4.5.0
	unwinding@0.2.5
	unicode-width@0.1.14
"

# Implied by crates above.
RUST_MIN_VER=1.86.0
RUST_MAX_VER=1.87.0

declare -A GIT_CRATES=(
	[boringtun]='https://github.com/cloudflare/boringtun;e3252d9c4f4c8fc628995330f45369effd4660a1;boringtun-%commit%/boringtun'
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
KEYWORDS="~amd64 ~arm64"

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
