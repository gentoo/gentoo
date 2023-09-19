# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick-0.7.20
	approx-0.5.1
	assert_cmd-2.0.8
	autocfg-1.1.0
	bitflags-1.3.2
	bstr-1.3.0
	bytemuck-1.13.1
	cc-1.0.79
	cfg-if-1.0.0
	clap-4.1.8
	clap_derive-4.1.8
	clap_lex-0.3.2
	csv-1.2.1
	csv-core-0.1.10
	difflib-0.4.0
	dirs-next-2.0.0
	dirs-sys-next-0.1.2
	doc-comment-0.3.3
	downcast-0.11.0
	either-1.8.1
	encode_unicode-1.0.0
	errno-0.2.8
	errno-dragonfly-0.1.2
	fastrand-1.9.0
	float-cmp-0.9.0
	fragile-2.0.0
	getrandom-0.2.8
	hashbrown-0.12.3
	heck-0.4.1
	hermit-abi-0.3.1
	indexmap-1.9.2
	instant-0.1.12
	io-lifetimes-1.0.6
	is-terminal-0.4.4
	itertools-0.10.5
	itoa-1.0.6
	lazy_static-1.4.0
	libc-0.2.140
	libm-0.2.6
	linux-raw-sys-0.1.4
	matrixmultiply-0.3.2
	memchr-2.5.0
	mockall-0.11.3
	mockall_derive-0.11.3
	nalgebra-0.29.0
	nalgebra-macros-0.1.0
	normalize-line-endings-0.3.0
	num-complex-0.4.3
	num-integer-0.1.45
	num-rational-0.4.1
	num-traits-0.2.15
	once_cell-1.17.1
	os_str_bytes-6.4.1
	paste-1.0.12
	ppv-lite86-0.2.17
	predicates-2.1.5
	predicates-core-1.0.5
	predicates-tree-1.0.7
	prettytable-rs-0.10.0
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.51
	quote-1.0.23
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.4
	rand_distr-0.4.3
	rawpointer-0.2.1
	redox_syscall-0.2.16
	redox_users-0.4.3
	regex-1.7.1
	regex-automata-0.1.10
	regex-syntax-0.6.28
	rpick-0.8.13
	rustix-0.36.9
	rustversion-1.0.12
	ryu-1.0.13
	safe_arch-0.6.0
	serde-1.0.154
	serde_derive-1.0.154
	serde_yaml-0.9.19
	simba-0.6.0
	statrs-0.16.0
	strsim-0.10.0
	syn-1.0.109
	tempfile-3.4.0
	term-0.7.0
	termcolor-1.2.0
	termtree-0.4.0
	thiserror-1.0.39
	thiserror-impl-1.0.39
	typenum-1.16.0
	unicode-ident-1.0.8
	unicode-width-0.1.10
	unsafe-libyaml-0.2.7
	version_check-0.9.4
	wait-timeout-0.2.0
	wasi-0.11.0+wasi-snapshot-preview1
	wide-0.7.8
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.42.0
	windows-sys-0.45.0
	windows-targets-0.42.1
	windows_aarch64_gnullvm-0.42.1
	windows_aarch64_msvc-0.42.1
	windows_i686_gnu-0.42.1
	windows_i686_msvc-0.42.1
	windows_x86_64_gnu-0.42.1
	windows_x86_64_gnullvm-0.42.1
	windows_x86_64_msvc-0.42.1
"

inherit cargo

DESCRIPTION="Helps you pick items from a list by various algorithms"
HOMEPAGE="https://github.com/bowlofeggs/rpick"
SRC_URI="$(cargo_crate_uris)"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 GPL-3 MIT Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

QA_FLAGS_IGNORED="usr/bin/rpick"

src_install() {
	cargo_src_install

	dodoc CHANGELOG.md README.md
}
