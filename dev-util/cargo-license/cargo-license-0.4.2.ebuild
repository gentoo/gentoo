# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ansi_term-0.11.0
	ansi_term-0.12.1
	anyhow-1.0.44
	atty-0.2.14
	bitflags-1.3.2
	bstr-0.2.17
	camino-1.0.5
	cargo-platform-0.1.2
	cargo_metadata-0.14.0
	clap-2.33.3
	csv-1.1.6
	csv-core-0.1.10
	getopts-0.2.21
	heck-0.3.3
	hermit-abi-0.1.19
	itoa-0.4.8
	lazy_static-1.4.0
	libc-0.2.103
	memchr-2.4.1
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.29
	quote-1.0.10
	regex-automata-0.1.10
	ryu-1.0.5
	semver-1.0.4
	serde-1.0.130
	serde_derive-1.0.130
	serde_json-1.0.68
	strsim-0.8.0
	structopt-0.3.23
	structopt-derive-0.4.16
	syn-1.0.80
	textwrap-0.11.0
	toml-0.5.8
	unicode-segmentation-1.8.0
	unicode-width-0.1.9
	unicode-xid-0.2.2
	vec_map-0.8.2
	version_check-0.9.3
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="Cargo subcommand to see license of dependencies"
HOMEPAGE="https://github.com/onur/cargo-license"
SRC_URI="https://github.com/onur/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)"

LICENSE="Apache-2.0 Boost-1.0 MIT Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

QA_FLAGS_IGNORED="/usr/bin/cargo-license"

src_install() {
	cargo_src_install
	einstalldocs
}
