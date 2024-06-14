# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ahash-0.7.6
	ahash-0.8.3
	aho-corasick-0.7.20
	anyhow-1.0.69
	approx-0.5.1
	arrayvec-0.7.2
	assert_cmd-2.0.8
	atty-0.2.14
	autocfg-0.1.8
	autocfg-1.1.0
	bitflags-1.3.2
	borsh-0.10.2
	borsh-derive-0.10.2
	borsh-derive-internal-0.10.2
	borsh-schema-derive-internal-0.10.2
	bstr-1.3.0
	bytecheck-0.6.10
	bytecheck_derive-0.6.10
	byteorder-1.4.3
	bytes-1.4.0
	cc-1.0.79
	cfg-if-1.0.0
	clap-4.1.8
	clap_complete-4.1.4
	clap_lex-0.3.2
	cloudabi-0.0.3
	colored-2.0.0
	console-0.15.5
	csv-1.2.1
	csv-core-0.1.10
	difflib-0.4.0
	doc-comment-0.3.3
	either-1.8.1
	encode_unicode-0.3.6
	errno-0.2.8
	errno-dragonfly-0.1.2
	fastrand-1.9.0
	float-cmp-0.9.0
	fuchsia-cprng-0.1.1
	getrandom-0.2.8
	hashbrown-0.12.3
	hashbrown-0.13.2
	hermit-abi-0.1.19
	hermit-abi-0.3.1
	indicatif-0.17.3
	instant-0.1.12
	io-lifetimes-1.0.6
	is-terminal-0.4.4
	itertools-0.10.5
	itoa-1.0.6
	lazy_static-1.4.0
	libc-0.2.140
	linux-raw-sys-0.1.4
	memchr-2.5.0
	memoffset-0.7.1
	nix-0.26.2
	normalize-line-endings-0.3.0
	num-0.2.1
	num-bigint-0.2.6
	num-complex-0.2.4
	num-integer-0.1.45
	num-iter-0.1.43
	num-rational-0.2.4
	num-traits-0.2.15
	number_prefix-0.4.0
	once_cell-1.17.1
	os_str_bytes-6.4.1
	pin-utils-0.1.0
	portable-atomic-0.3.19
	ppv-lite86-0.2.17
	predicates-2.1.5
	predicates-core-1.0.5
	predicates-tree-1.0.7
	proc-macro-crate-0.1.5
	proc-macro2-1.0.52
	ptr_meta-0.1.4
	ptr_meta_derive-0.1.4
	quote-1.0.26
	rand-0.6.5
	rand-0.8.5
	rand_chacha-0.1.1
	rand_chacha-0.3.1
	rand_core-0.3.1
	rand_core-0.4.2
	rand_core-0.6.4
	rand_hc-0.1.0
	rand_isaac-0.1.1
	rand_jitter-0.1.4
	rand_os-0.1.3
	rand_pcg-0.1.2
	rand_xorshift-0.1.1
	rdrand-0.4.0
	redox_syscall-0.2.16
	regex-1.7.1
	regex-automata-0.1.10
	regex-syntax-0.6.28
	rend-0.4.0
	rkyv-0.7.40
	rkyv_derive-0.7.40
	rust_decimal-1.29.0
	rustix-0.36.9
	ryu-1.0.13
	seahash-4.1.0
	serde-1.0.156
	serde_derive-1.0.156
	serde_json-1.0.94
	shell-words-1.1.0
	simdutf8-0.1.4
	static_assertions-1.1.0
	statistical-1.0.0
	strsim-0.10.0
	syn-1.0.109
	tempfile-3.4.0
	termcolor-1.2.0
	terminal_size-0.2.5
	termtree-0.4.0
	thiserror-1.0.39
	thiserror-impl-1.0.39
	toml-0.5.11
	unicode-ident-1.0.8
	unicode-width-0.1.10
	version_check-0.9.4
	wait-timeout-0.2.0
	wasi-0.11.0+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.42.0
	windows-sys-0.45.0
	windows-targets-0.42.2
	windows_aarch64_gnullvm-0.42.2
	windows_aarch64_msvc-0.42.2
	windows_i686_gnu-0.42.2
	windows_i686_msvc-0.42.2
	windows_x86_64_gnu-0.42.2
	windows_x86_64_gnullvm-0.42.2
	windows_x86_64_msvc-0.42.2

"

inherit bash-completion-r1 cargo

DESCRIPTION="A command-line benchmarking tool (runs other benchmarks)"
HOMEPAGE="https://github.com/sharkdp/hyperfine"
SRC_URI="https://github.com/sharkdp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0 Unicode-DFS-2016"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_install() {
	local build_dir="$(dirname $(find "$(cargo_target_dir)" -name ${PN}.bash -print -quit))"

	newbashcomp "${build_dir}/${PN}.bash" "${PN}"

	insinto /usr/share/zsh/site-functions
	doins "${build_dir}/_${PN}"

	insinto /usr/share/fish/vendor_completions.d
	doins "${build_dir}/${PN}.fish"

	cargo_src_install
	doman doc/hyperfine.1
	einstalldocs
}
