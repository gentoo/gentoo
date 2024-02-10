# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick-0.7.18
	anyhow-1.0.63
	atty-0.2.14
	autocfg-1.1.0
	bitflags-1.3.2
	bstr-0.2.17
	cfg-if-1.0.0
	clap-3.2.20
	clap_derive-3.2.18
	clap_lex-0.2.4
	cpp_demangle-0.3.5
	csv-1.1.6
	csv-core-0.1.10
	dirs-next-2.0.0
	dirs-sys-next-0.1.2
	encode_unicode-1.0.0
	env_logger-0.9.0
	fuchsia-cprng-0.1.1
	getrandom-0.2.7
	goblin-0.5.4
	hashbrown-0.12.3
	heck-0.4.0
	hermit-abi-0.1.19
	hexplay-0.2.1
	humantime-2.1.0
	indexmap-1.9.1
	itoa-0.4.8
	lazy_static-1.4.0
	libc-0.2.132
	log-0.4.17
	memchr-2.5.0
	memrange-0.1.3
	metagoblin-0.6.0
	once_cell-1.14.0
	os_str_bytes-6.3.0
	plain-0.2.3
	prettytable-rs-0.9.0
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.43
	quote-1.0.21
	rand-0.3.23
	rand-0.4.6
	rand_core-0.3.1
	rand_core-0.4.2
	rdrand-0.4.0
	redox_syscall-0.2.16
	redox_users-0.4.3
	regex-1.6.0
	regex-automata-0.1.10
	regex-syntax-0.6.27
	rustc-demangle-0.1.21
	rustc-serialize-0.3.24
	rustversion-1.0.9
	ryu-1.0.11
	scroll-0.11.0
	scroll_derive-0.11.0
	serde-1.0.144
	strsim-0.10.0
	syn-1.0.99
	term-0.7.0
	termcolor-0.3.6
	termcolor-1.1.3
	terminal_size-0.1.17
	textwrap-0.15.0
	theban_interval_tree-0.7.1
	thiserror-1.0.33
	thiserror-impl-1.0.33
	time-0.1.44
	unicode-ident-1.0.3
	unicode-width-0.1.9
	version_check-0.9.4
	wasi-0.10.0+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	wincolor-0.1.6
"

inherit cargo

DESCRIPTION="Binary file analysis tool"
HOMEPAGE="https://github.com/m4b/bingrep"
SRC_URI="https://github.com/m4b/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)"

LICENSE="MIT Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 ISC MIT Unicode-DFS-2016 Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

QA_FLAGS_IGNORED="usr/bin/bingrep"

src_install() {
	cargo_src_install
	einstalldocs
}
