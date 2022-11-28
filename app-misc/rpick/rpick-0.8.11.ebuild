# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick-0.7.18
	approx-0.5.1
	arrayref-0.3.6
	arrayvec-0.5.2
	assert_cmd-2.0.4
	atty-0.2.14
	autocfg-1.1.0
	base64-0.13.0
	bitflags-1.3.2
	blake2b_simd-0.5.11
	bstr-0.2.17
	byteorder-1.4.3
	cfg-if-1.0.0
	clap-3.2.15
	clap_derive-3.2.15
	clap_lex-0.2.4
	constant_time_eq-0.1.5
	crossbeam-utils-0.8.11
	csv-1.1.6
	csv-core-0.1.10
	difflib-0.4.0
	dirs-1.0.5
	dirs-next-2.0.0
	dirs-sys-next-0.1.2
	doc-comment-0.3.3
	downcast-0.11.0
	either-1.7.0
	encode_unicode-0.3.6
	fastrand-1.8.0
	float-cmp-0.9.0
	fragile-1.2.1
	getrandom-0.1.16
	getrandom-0.2.7
	hashbrown-0.12.3
	heck-0.4.0
	hermit-abi-0.1.19
	indexmap-1.9.1
	instant-0.1.12
	itertools-0.10.3
	itoa-0.4.8
	itoa-1.0.2
	lazy_static-1.4.0
	libc-0.2.126
	libm-0.2.3
	matrixmultiply-0.3.2
	memchr-2.5.0
	mockall-0.11.2
	mockall_derive-0.11.2
	nalgebra-0.27.1
	nalgebra-macros-0.1.0
	normalize-line-endings-0.3.0
	num-complex-0.4.2
	num-integer-0.1.45
	num-rational-0.4.1
	num-traits-0.2.15
	once_cell-1.13.0
	os_str_bytes-6.2.0
	paste-1.0.7
	ppv-lite86-0.2.16
	predicates-2.1.1
	predicates-core-1.0.3
	predicates-tree-1.0.5
	prettytable-rs-0.8.0
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.42
	quote-1.0.20
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.3
	rand_distr-0.4.3
	rawpointer-0.2.1
	redox_syscall-0.1.57
	redox_syscall-0.2.16
	redox_users-0.3.5
	redox_users-0.4.3
	regex-1.6.0
	regex-automata-0.1.10
	regex-syntax-0.6.27
	remove_dir_all-0.5.3
	rpick-0.8.11
	rust-argon2-0.8.3
	ryu-1.0.10
	serde-1.0.140
	serde_derive-1.0.140
	serde_yaml-0.9.1
	simba-0.5.1
	statrs-0.15.0
	strsim-0.10.0
	syn-1.0.98
	tempfile-3.3.0
	term-0.5.2
	termcolor-1.1.3
	termtree-0.2.4
	textwrap-0.15.0
	thiserror-1.0.31
	thiserror-impl-1.0.31
	typenum-1.15.0
	unicode-ident-1.0.2
	unicode-width-0.1.9
	unsafe-libyaml-0.2.1
	version_check-0.9.4
	wait-timeout-0.2.0
	wasi-0.9.0+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="Helps you pick items from a list by various algorithms"
HOMEPAGE="https://github.com/bowlofeggs/rpick"
SRC_URI="$(cargo_crate_uris)"

LICENSE="GPL-3 Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 Boost-1.0 CC0-1.0 MIT Unlicense"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

QA_FLAGS_IGNORED="usr/bin/rpick"

src_install() {
	cargo_src_install

	dodoc CHANGELOG.md README.md
}
