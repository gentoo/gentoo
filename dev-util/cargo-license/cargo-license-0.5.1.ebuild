# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ansi_term-0.12.1
	anyhow-1.0.36
	atty-0.2.14
	autocfg-1.1.0
	bitflags-1.2.1
	bstr-0.2.14
	byteorder-1.3.4
	camino-1.1.1
	cargo-platform-0.1.2
	cargo_metadata-0.15.0
	clap-3.2.16
	clap_derive-3.2.15
	clap_lex-0.2.4
	csv-1.1.5
	csv-core-0.1.10
	getopts-0.2.21
	hashbrown-0.12.3
	heck-0.4.0
	hermit-abi-0.1.17
	indexmap-1.9.1
	itoa-0.4.7
	itoa-1.0.3
	lazy_static-1.4.0
	libc-0.2.81
	memchr-2.3.4
	once_cell-1.13.0
	os_str_bytes-6.2.0
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.43
	quote-1.0.21
	regex-automata-0.1.9
	ryu-1.0.5
	semver-1.0.13
	serde-1.0.143
	serde_derive-1.0.143
	serde_json-1.0.83
	strsim-0.10.0
	syn-1.0.99
	termcolor-1.1.3
	textwrap-0.15.0
	toml-0.5.8
	unicode-ident-1.0.3
	unicode-width-0.1.8
	version_check-0.9.2
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	cargo-license-0.5.1
"

inherit cargo

DESCRIPTION="Cargo subcommand to see license of dependencies"
HOMEPAGE="https://github.com/onur/cargo-license"
SRC_URI="$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 Boost-1.0 MIT Unicode-DFS-2016 Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

QA_FLAGS_IGNORED="/usr/bin/cargo-license"

src_install() {
	cargo_src_install
	einstalldocs
}
