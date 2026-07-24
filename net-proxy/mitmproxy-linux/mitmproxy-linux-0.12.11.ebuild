# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

# Extra crates required at runtime via rustc-build-sysroot crate.
# Note: versions are locked in /usr/lib/rust/*/lib/rustlib/src/rust/library/Cargo.lock.
CRATES+="
	addr2line@0.25.1
	dlmalloc@0.2.11
	foldhash@0.2.0
	fortanix-sgx-abi@0.6.1
	getopts@0.2.24
	gimli@0.32.3
	hashbrown@0.16.1
	hermit-abi@0.5.2
	libc@0.2.178
	libc@0.2.183
	memchr@2.7.6
	moto-rt@0.16.0
	object@0.37.3
	r-efi-alloc@2.1.0
	r-efi@5.3.0
	rustc-demangle@0.1.27
	rustc-literal-escaper@0.0.7
	unwinding@0.2.8
	vex-sdk@0.27.1
	wasi@0.14.4+wasi-0.2.4
	windows-sys@0.60.2
	windows-targets@0.53.5
	windows_aarch64_gnullvm@0.53.1
	windows_aarch64_msvc@0.53.1
	windows_i686_gnu@0.53.1
	windows_i686_gnullvm@0.53.1
	windows_i686_msvc@0.53.1
	windows_x86_64_gnu@0.53.1
	windows_x86_64_gnullvm@0.53.1
	windows_x86_64_msvc@0.53.1
	wit-bindgen@0.45.1
"

# Implied by crates above.
RUST_MIN_VER=1.95.0
RUST_MAX_VER=1.96.1

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{12..15} )
RUST_REQ_USE="llvm_targets_BPF(+),rust-src"

inherit cargo distutils-r1 pypi

DESCRIPTION="mitmproxy's Rust bits (Linux-specific part)"
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
	:
	# all tests are ignored
	# cargo_src_test --manifest-path mitmproxy-linux/Cargo.toml
}
