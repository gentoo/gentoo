# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aardvark-dns-1.6.0
	android_system_properties-0.1.5
	anyhow-1.0.70
	async-broadcast-0.5.1
	async-trait-0.1.56
	atty-0.2.14
	autocfg-1.1.0
	bitflags-1.3.2
	bumpalo-3.10.0
	bytes-1.1.0
	cc-1.0.76
	cfg-if-1.0.0
	chrono-0.4.24
	clap-3.2.23
	clap_derive-3.2.18
	clap_lex-0.2.4
	codespan-reporting-0.11.1
	core-foundation-sys-0.8.3
	cxx-1.0.81
	cxx-build-1.0.81
	cxxbridge-flags-1.0.81
	cxxbridge-macro-1.0.81
	data-encoding-2.3.2
	endian-type-0.1.2
	enum-as-inner-0.5.1
	error-chain-0.12.4
	event-listener-2.5.2
	form_urlencoded-1.0.1
	futures-channel-0.3.21
	futures-core-0.3.28
	futures-executor-0.3.21
	futures-io-0.3.21
	futures-task-0.3.28
	futures-util-0.3.28
	getrandom-0.2.7
	hashbrown-0.12.2
	heck-0.4.0
	hermit-abi-0.1.19
	hostname-0.3.1
	iana-time-zone-0.1.53
	iana-time-zone-haiku-0.1.1
	idna-0.2.3
	indexmap-1.9.1
	ipnet-2.5.0
	itoa-1.0.2
	js-sys-0.3.59
	lazy_static-1.4.0
	libc-0.2.140
	link-cplusplus-1.0.7
	log-0.4.17
	match_cfg-0.1.0
	matches-0.1.9
	memoffset-0.7.1
	mio-0.8.4
	nibble_vec-0.1.0
	nix-0.26.2
	num-integer-0.1.45
	num-traits-0.2.15
	num_cpus-1.13.1
	num_threads-0.1.6
	once_cell-1.13.0
	os_str_bytes-6.1.0
	percent-encoding-2.1.0
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	ppv-lite86-0.2.16
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.54
	quick-error-1.2.3
	quote-1.0.26
	radix_trie-0.2.1
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.3
	resolv-conf-0.7.0
	scratch-1.0.2
	serde-1.0.139
	serde_derive-1.0.139
	signal-hook-0.3.15
	signal-hook-registry-1.4.0
	slab-0.4.6
	smallvec-1.9.0
	socket2-0.4.9
	static_assertions-1.1.0
	strsim-0.10.0
	syn-1.0.98
	syn-2.0.12
	syslog-6.0.1
	termcolor-1.1.3
	textwrap-0.16.0
	thiserror-1.0.31
	thiserror-impl-1.0.31
	time-0.1.44
	time-0.3.11
	tinyvec-1.6.0
	tinyvec_macros-0.1.0
	tokio-1.27.0
	tokio-macros-2.0.0
	toml-0.5.9
	tracing-0.1.36
	tracing-attributes-0.1.22
	tracing-core-0.1.29
	trust-dns-client-0.22.0
	trust-dns-proto-0.22.0
	trust-dns-server-0.22.0
	unicode-bidi-0.3.8
	unicode-ident-1.0.1
	unicode-normalization-0.1.21
	unicode-width-0.1.10
	url-2.2.2
	version_check-0.9.4
	wasi-0.10.0+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.82
	wasm-bindgen-backend-0.2.82
	wasm-bindgen-macro-0.2.82
	wasm-bindgen-macro-support-0.2.82
	wasm-bindgen-shared-0.2.82
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.36.1
	windows-sys-0.45.0
	windows-targets-0.42.1
	windows_aarch64_gnullvm-0.42.1
	windows_aarch64_msvc-0.36.1
	windows_aarch64_msvc-0.42.1
	windows_i686_gnu-0.36.1
	windows_i686_gnu-0.42.1
	windows_i686_msvc-0.36.1
	windows_i686_msvc-0.42.1
	windows_x86_64_gnu-0.36.1
	windows_x86_64_gnu-0.42.1
	windows_x86_64_gnullvm-0.42.1
	windows_x86_64_msvc-0.36.1
	windows_x86_64_msvc-0.42.1
"

inherit cargo

DESCRIPTION="A container-focused DNS server"
HOMEPAGE="https://github.com/containers/aardvark-dns"
SRC_URI="$(cargo_crate_uris)"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv"

QA_FLAGS_IGNORED="usr/bin/${PN}
	/usr/libexec/podman/${PN}"

src_install() {
	cargo_src_install
	dodir /usr/libexec/podman
	ln "${ED}/usr/"{bin,libexec/podman}/${PN} || die
}
