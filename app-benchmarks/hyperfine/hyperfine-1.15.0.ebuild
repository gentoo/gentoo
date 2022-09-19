# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick-0.7.19
	anyhow-1.0.64
	approx-0.5.1
	arrayvec-0.7.2
	assert_cmd-2.0.4
	atty-0.2.14
	autocfg-0.1.8
	autocfg-1.1.0
	bitflags-1.3.2
	bstr-0.2.17
	cfg-if-1.0.0
	clap-3.2.20
	clap_complete-3.2.4
	clap_lex-0.2.4
	cloudabi-0.0.3
	colored-2.0.0
	console-0.15.1
	csv-1.1.6
	csv-core-0.1.10
	difflib-0.4.0
	doc-comment-0.3.3
	either-1.8.0
	encode_unicode-0.3.6
	fastrand-1.8.0
	float-cmp-0.9.0
	fuchsia-cprng-0.1.1
	getrandom-0.2.7
	hashbrown-0.12.3
	hermit-abi-0.1.19
	indexmap-1.9.1
	indicatif-0.16.2
	instant-0.1.12
	itertools-0.10.3
	itoa-0.4.8
	itoa-1.0.3
	lazy_static-1.4.0
	libc-0.2.132
	memchr-2.5.0
	memoffset-0.6.5
	nix-0.25.0
	normalize-line-endings-0.3.0
	num-0.2.1
	num-bigint-0.2.6
	num-complex-0.2.4
	num-integer-0.1.45
	num-iter-0.1.43
	num-rational-0.2.4
	num-traits-0.2.15
	number_prefix-0.4.0
	once_cell-1.14.0
	os_str_bytes-6.3.0
	pin-utils-0.1.0
	ppv-lite86-0.2.16
	predicates-2.1.1
	predicates-core-1.0.3
	predicates-tree-1.0.5
	proc-macro2-1.0.43
	quote-1.0.21
	rand-0.6.5
	rand-0.8.5
	rand_chacha-0.1.1
	rand_chacha-0.3.1
	rand_core-0.3.1
	rand_core-0.4.2
	rand_core-0.6.3
	rand_hc-0.1.0
	rand_isaac-0.1.1
	rand_jitter-0.1.4
	rand_os-0.1.3
	rand_pcg-0.1.2
	rand_xorshift-0.1.1
	rdrand-0.4.0
	redox_syscall-0.2.16
	regex-1.6.0
	regex-automata-0.1.10
	regex-syntax-0.6.27
	remove_dir_all-0.5.3
	rust_decimal-1.26.1
	ryu-1.0.11
	serde-1.0.144
	serde_derive-1.0.144
	serde_json-1.0.85
	shell-words-1.1.0
	statistical-1.0.0
	strsim-0.10.0
	syn-1.0.99
	tempfile-3.3.0
	termcolor-1.1.3
	terminal_size-0.1.17
	termtree-0.2.4
	textwrap-0.15.0
	thiserror-1.0.34
	thiserror-impl-1.0.34
	unicode-ident-1.0.3
	wait-timeout-0.2.0
	wasi-0.11.0+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit bash-completion-r1 cargo

DESCRIPTION="A command-line benchmarking tool (runs other benchmarks)"
HOMEPAGE="https://github.com/sharkdp/hyperfine"
SRC_URI="https://github.com/sharkdp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 Boost-1.0 ISC MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_install() {
	local build_dir="$(dirname $(find target/ -name ${PN}.bash -print -quit))"

	newbashcomp "${build_dir}/${PN}.bash" "${PN}"

	insinto /usr/share/zsh/site-functions
	doins "${build_dir}/_${PN}"

	insinto /usr/share/fish/vendor_completions.d
	doins "${build_dir}/${PN}.fish"

	cargo_src_install
	doman doc/hyperfine.1
	einstalldocs
}
