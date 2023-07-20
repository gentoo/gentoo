# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick-1.0.2
	anstream-0.3.2
	anstyle-1.0.1
	anstyle-parse-0.2.1
	anstyle-query-1.0.0
	anstyle-wincon-1.0.1
	approx-0.5.1
	assert_cmd-2.0.12
	autocfg-1.1.0
	bitflags-1.3.2
	bitflags-2.3.3
	bstr-1.6.0
	bytemuck-1.13.1
	cc-1.0.79
	cfg-if-1.0.0
	clap-4.3.12
	clap_builder-4.3.12
	clap_derive-4.3.12
	clap_lex-0.5.0
	colorchoice-1.0.0
	csv-1.2.2
	csv-core-0.1.10
	difflib-0.4.0
	dirs-next-2.0.0
	dirs-sys-next-0.1.2
	doc-comment-0.3.3
	downcast-0.11.0
	either-1.8.1
	encode_unicode-1.0.0
	equivalent-1.0.1
	errno-0.3.1
	errno-dragonfly-0.1.2
	fastrand-1.9.0
	float-cmp-0.9.0
	fragile-2.0.0
	getrandom-0.2.10
	hashbrown-0.14.0
	heck-0.4.1
	hermit-abi-0.3.2
	indexmap-2.0.0
	instant-0.1.12
	io-lifetimes-1.0.11
	is-terminal-0.4.9
	itertools-0.10.5
	itoa-1.0.9
	lazy_static-1.4.0
	libc-0.2.147
	libm-0.2.7
	linux-raw-sys-0.3.8
	linux-raw-sys-0.4.3
	matrixmultiply-0.3.7
	memchr-2.5.0
	mockall-0.11.4
	mockall_derive-0.11.4
	nalgebra-0.29.0
	nalgebra-macros-0.1.0
	normalize-line-endings-0.3.0
	num-complex-0.4.3
	num-integer-0.1.45
	num-rational-0.4.1
	num-traits-0.2.15
	once_cell-1.18.0
	paste-1.0.14
	ppv-lite86-0.2.17
	predicates-2.1.5
	predicates-3.0.3
	predicates-core-1.0.6
	predicates-tree-1.0.9
	prettytable-rs-0.10.0
	proc-macro2-1.0.66
	quote-1.0.31
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.4
	rand_distr-0.4.3
	rawpointer-0.2.1
	redox_syscall-0.2.16
	redox_syscall-0.3.5
	redox_users-0.4.3
	regex-1.9.1
	regex-automata-0.3.3
	regex-syntax-0.7.4
	rpick-0.9.0
	rustix-0.37.23
	rustix-0.38.4
	rustversion-1.0.14
	ryu-1.0.15
	safe_arch-0.7.0
	serde-1.0.171
	serde_derive-1.0.171
	serde_yaml-0.9.23
	simba-0.6.0
	statrs-0.16.0
	strsim-0.10.0
	syn-1.0.109
	syn-2.0.26
	tempfile-3.6.0
	term-0.7.0
	termtree-0.4.1
	thiserror-1.0.43
	thiserror-impl-1.0.43
	typenum-1.16.0
	unicode-ident-1.0.11
	unicode-width-0.1.10
	unsafe-libyaml-0.2.9
	utf8parse-0.2.1
	wait-timeout-0.2.0
	wasi-0.11.0+wasi-snapshot-preview1
	wide-0.7.11
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.48.0
	windows-targets-0.48.1
	windows_aarch64_gnullvm-0.48.0
	windows_aarch64_msvc-0.48.0
	windows_i686_gnu-0.48.0
	windows_i686_msvc-0.48.0
	windows_x86_64_gnu-0.48.0
	windows_x86_64_gnullvm-0.48.0
	windows_x86_64_msvc-0.48.0
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
