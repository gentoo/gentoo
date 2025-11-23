# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.3
	annotate-snippets@0.11.4
	anstyle@1.0.10
	autocfg@1.4.0
	bitflags@1.3.2
	bitflags@2.2.1
	block@0.1.6
	cc@1.2.2
	cexpr@0.6.0
	cfg-if@1.0.0
	clang-sys@1.8.1
	clap@4.1.4
	clap_complete@4.2.0
	clap_derive@4.1.0
	clap_lex@0.3.1
	either@1.13.0
	env_logger@0.10.0
	env_logger@0.8.4
	errno@0.3.10
	fastrand@1.9.0
	getrandom@0.2.15
	glob@0.3.1
	heck@0.4.1
	hermit-abi@0.3.9
	hermit-abi@0.4.0
	humantime@2.1.0
	instant@0.1.12
	io-lifetimes@1.0.11
	is-terminal@0.4.13
	itertools@0.13.0
	libc@0.2.167
	libloading@0.8.6
	linux-raw-sys@0.3.8
	log@0.4.22
	malloc_buf@0.0.6
	memchr@2.7.4
	minimal-lexical@0.2.1
	nom@7.1.3
	objc@0.2.7
	once_cell@1.20.2
	os_str_bytes@6.4.1
	owo-colors@4.1.0
	prettyplease@0.2.25
	proc-macro-error-attr@1.0.4
	proc-macro-error@1.0.4
	proc-macro2@1.0.92
	quickcheck@1.0.3
	quote@1.0.37
	rand@0.8.5
	rand_core@0.6.4
	redox_syscall@0.3.5
	regex-automata@0.4.9
	regex-syntax@0.8.5
	regex@1.11.1
	rustc-hash@2.1.0
	rustix@0.37.27
	shlex@1.3.0
	similar@2.6.0
	strsim@0.10.0
	syn@1.0.109
	syn@2.0.90
	tempfile@3.6.0
	termcolor@1.2.0
	unicode-ident@1.0.14
	unicode-width@0.1.14
	version_check@0.9.4
	wasi@0.11.0+wasi-snapshot-preview1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.5
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.48.5
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.6
"

inherit rust-toolchain cargo

DESCRIPTION="Automatically generates Rust FFI bindings to C and C++ libraries."
HOMEPAGE="https://rust-lang.github.io/rust-bindgen/"
SRC_URI="https://github.com/rust-lang/rust-${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"
S=${WORKDIR}/rust-${P}

LICENSE="BSD"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD ISC MIT Unicode-3.0"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv"

DEPEND="${RUST_DEPEND}"
RDEPEND="${DEPEND}
	llvm-core/clang:*"

QA_FLAGS_IGNORED="usr/bin/bindgen"

src_test () {
	# required by clang during tests
	local -x TARGET=$(rust_abi)

	cargo_src_test --bins --lib
}

src_install () {
	cargo_src_install --path "${S}/bindgen-cli"

	einstalldocs
}
