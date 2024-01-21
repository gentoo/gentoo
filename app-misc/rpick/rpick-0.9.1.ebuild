# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.2
	anstream@0.6.8
	anstyle@1.0.4
	anstyle-parse@0.2.3
	anstyle-query@1.0.2
	anstyle-wincon@3.0.2
	approx@0.5.1
	assert_cmd@2.0.13
	autocfg@1.1.0
	bitflags@1.3.2
	bitflags@2.4.2
	bstr@1.9.0
	bytemuck@1.14.0
	cfg-if@1.0.0
	clap@4.4.18
	clap_builder@4.4.18
	clap_derive@4.4.7
	clap_lex@0.6.0
	colorchoice@1.0.0
	csv@1.3.0
	csv-core@0.1.11
	difflib@0.4.0
	dirs-next@2.0.0
	dirs-sys-next@0.1.2
	doc-comment@0.3.3
	downcast@0.11.0
	either@1.9.0
	encode_unicode@1.0.0
	equivalent@1.0.1
	errno@0.3.8
	fastrand@2.0.1
	float-cmp@0.9.0
	fragile@2.0.0
	getrandom@0.2.12
	hashbrown@0.14.3
	heck@0.4.1
	hermit-abi@0.3.3
	indexmap@2.1.0
	is-terminal@0.4.10
	itertools@0.10.5
	itoa@1.0.10
	lazy_static@1.4.0
	libc@0.2.152
	libm@0.2.8
	libredox@0.0.1
	linux-raw-sys@0.4.13
	matrixmultiply@0.3.8
	memchr@2.7.1
	mockall@0.11.4
	mockall_derive@0.11.4
	nalgebra@0.29.0
	nalgebra-macros@0.1.0
	normalize-line-endings@0.3.0
	num-complex@0.4.4
	num-integer@0.1.45
	num-rational@0.4.1
	num-traits@0.2.17
	paste@1.0.14
	ppv-lite86@0.2.17
	predicates@2.1.5
	predicates@3.1.0
	predicates-core@1.0.6
	predicates-tree@1.0.9
	prettytable-rs@0.10.0
	proc-macro2@1.0.76
	quote@1.0.35
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rand_distr@0.4.3
	rawpointer@0.2.1
	redox_syscall@0.4.1
	redox_users@0.4.4
	regex@1.10.2
	regex-automata@0.4.3
	regex-syntax@0.8.2
	rpick@0.9.1
	rustix@0.38.30
	rustversion@1.0.14
	ryu@1.0.16
	safe_arch@0.7.1
	serde@1.0.195
	serde_derive@1.0.195
	serde_yaml@0.9.30
	simba@0.6.0
	statrs@0.16.0
	strsim@0.10.0
	syn@1.0.109
	syn@2.0.48
	tempfile@3.9.0
	term@0.7.0
	termtree@0.4.1
	thiserror@1.0.56
	thiserror-impl@1.0.56
	typenum@1.17.0
	unicode-ident@1.0.12
	unicode-width@0.1.11
	unsafe-libyaml@0.2.10
	utf8parse@0.2.1
	wait-timeout@0.2.0
	wasi@0.11.0+wasi-snapshot-preview1
	wide@0.7.13
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	windows-sys@0.52.0
	windows-targets@0.52.0
	windows_aarch64_gnullvm@0.52.0
	windows_aarch64_msvc@0.52.0
	windows_i686_gnu@0.52.0
	windows_i686_msvc@0.52.0
	windows_x86_64_gnu@0.52.0
	windows_x86_64_gnullvm@0.52.0
	windows_x86_64_msvc@0.52.0
"

inherit cargo

DESCRIPTION="Helps you pick items from a list by various algorithms"
HOMEPAGE="https://github.com/bowlofeggs/rpick"
SRC_URI="${CARGO_CRATE_URIS}"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 GPL-3 MIT Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

QA_FLAGS_IGNORED="usr/bin/rpick"

src_install() {
	cargo_src_install

	dodoc CHANGELOG.md README.md
}
