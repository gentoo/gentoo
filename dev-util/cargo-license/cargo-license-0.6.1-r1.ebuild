# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ansi_term@0.12.1
	anstream@0.6.11
	anstyle@1.0.4
	anstyle-parse@0.2.3
	anstyle-query@1.0.2
	anstyle-wincon@3.0.2
	anyhow@1.0.79
	camino@1.1.6
	cargo-platform@0.1.6
	cargo_metadata@0.18.1
	clap@4.4.18
	clap_builder@4.4.18
	clap_derive@4.4.7
	clap_lex@0.6.0
	colorchoice@1.0.0
	csv@1.3.0
	csv-core@0.1.11
	either@1.9.0
	equivalent@1.0.1
	getopts@0.2.21
	hashbrown@0.14.3
	heck@0.4.1
	indexmap@2.1.0
	itertools@0.12.0
	itoa@1.0.10
	memchr@2.7.1
	proc-macro2@1.0.78
	quote@1.0.35
	ryu@1.0.16
	semver@1.0.21
	serde@1.0.195
	serde_derive@1.0.195
	serde_json@1.0.111
	serde_spanned@0.6.5
	smallvec@1.13.1
	spdx@0.10.3
	strsim@0.10.0
	syn@2.0.48
	thiserror@1.0.56
	thiserror-impl@1.0.56
	toml@0.8.8
	toml_datetime@0.6.5
	toml_edit@0.21.0
	unicode-ident@1.0.12
	unicode-width@0.1.11
	utf8parse@0.2.1
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
	winnow@0.5.34
"

inherit cargo

DESCRIPTION="Cargo subcommand to see license of dependencies"
HOMEPAGE="https://github.com/onur/cargo-license"
SRC_URI="
	https://github.com/onur/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="Apache-2.0 Boost-1.0 MIT Unicode-DFS-2016 Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

QA_FLAGS_IGNORED="/usr/bin/${PN}"

src_install() {
	cargo_src_install
	einstalldocs
}
