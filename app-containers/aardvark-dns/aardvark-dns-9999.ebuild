# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.21.0
	adler@1.0.2
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.3.2
	anstyle-parse@0.2.1
	anstyle-query@1.0.0
	anstyle-wincon@1.0.2
	anstyle@1.0.2
	anyhow@1.0.75
	async-broadcast@0.5.1
	async-trait@0.1.73
	autocfg@1.1.0
	backtrace@0.3.69
	bitflags@2.4.0
	bumpalo@3.14.0
	bytes@1.5.0
	cc@1.0.83
	cfg-if@1.0.0
	chrono@0.4.31
	clap@4.3.24
	clap_builder@4.3.24
	clap_derive@4.3.12
	clap_lex@0.5.0
	colorchoice@1.0.0
	core-foundation-sys@0.8.4
	data-encoding@2.4.0
	drain@0.1.1
	endian-type@0.1.2
	enum-as-inner@0.6.0
	equivalent@1.0.1
	errno-dragonfly@0.1.2
	errno@0.3.3
	error-chain@0.12.4
	event-listener@2.5.3
	form_urlencoded@1.2.0
	futures-channel@0.3.28
	futures-core@0.3.28
	futures-executor@0.3.28
	futures-io@0.3.28
	futures-task@0.3.28
	futures-util@0.3.28
	getrandom@0.2.10
	gimli@0.28.0
	hashbrown@0.14.0
	heck@0.4.1
	hermit-abi@0.3.3
	hostname@0.3.1
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.57
	idna@0.4.0
	indexmap@2.0.0
	ipnet@2.8.0
	is-terminal@0.4.9
	itoa@1.0.9
	js-sys@0.3.64
	libc@0.2.148
	linux-raw-sys@0.4.7
	log@0.4.20
	match_cfg@0.1.0
	memchr@2.6.3
	miniz_oxide@0.7.1
	mio@0.8.8
	nibble_vec@0.1.0
	nix@0.27.1
	num-traits@0.2.16
	num_cpus@1.16.0
	num_threads@0.1.6
	object@0.32.1
	once_cell@1.18.0
	percent-encoding@2.3.0
	pin-project-lite@0.2.13
	pin-utils@0.1.0
	ppv-lite86@0.2.17
	proc-macro2@1.0.67
	quick-error@1.2.3
	quote@1.0.33
	radix_trie@0.2.1
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	resolv-conf@0.7.0
	rustc-demangle@0.1.23
	rustix@0.38.14
	serde@1.0.188
	serde_derive@1.0.188
	serde_spanned@0.6.3
	signal-hook-registry@1.4.1
	signal-hook@0.3.17
	slab@0.4.9
	smallvec@1.11.1
	socket2@0.5.4
	strsim@0.10.0
	syn@2.0.37
	syslog@6.1.0
	thiserror-impl@1.0.48
	thiserror@1.0.48
	time-core@0.1.1
	time-macros@0.2.10
	time@0.3.23
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	tokio-macros@2.1.0
	tokio@1.32.0
	toml@0.7.8
	toml_datetime@0.6.3
	toml_edit@0.19.15
	tracing-attributes@0.1.26
	tracing-core@0.1.31
	tracing@0.1.37
	trust-dns-client@0.23.0
	trust-dns-proto@0.23.0
	trust-dns-server@0.23.0
	unicode-bidi@0.3.13
	unicode-ident@1.0.12
	unicode-normalization@0.1.22
	url@2.4.1
	utf8parse@0.2.1
	version_check@0.9.4
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.87
	wasm-bindgen-macro-support@0.2.87
	wasm-bindgen-macro@0.2.87
	wasm-bindgen-shared@0.2.87
	wasm-bindgen@0.2.87
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.48.0
	windows-targets@0.48.5
	windows@0.48.0
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.48.5
	winnow@0.5.15
"
CRATES+="${PN}@1.8.0"
inherit cargo

DESCRIPTION="A container-focused DNS server"
HOMEPAGE="https://github.com/containers/aardvark-dns"
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/containers/aardvark-dns.git"
else
	SRC_URI="${CARGO_CRATE_URIS}"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv"
fi
LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT Unlicense Unicode-DFS-2016 ZLIB"
SLOT="0"
QA_FLAGS_IGNORED="usr/bin/${PN}"

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_install() {
	cargo_src_install
	dodir /usr/libexec/podman
	dosym -r /usr/bin/"${PN}" /usr/libexec/podman/"${PN}"
}
