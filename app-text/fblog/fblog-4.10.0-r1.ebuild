# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.3
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.6.14
	anstyle@1.0.7
	anstyle-parse@0.2.4
	anstyle-query@1.1.0
	anstyle-wincon@3.0.3
	autocfg@1.3.0
	bitflags@2.5.0
	block-buffer@0.10.4
	bstr@1.9.1
	bumpalo@3.16.0
	cc@1.0.99
	cfg-if@1.0.0
	chrono@0.4.38
	clap@4.5.6
	clap_builder@4.5.6
	clap_complete@4.5.4
	clap_derive@4.5.5
	clap_lex@0.7.1
	colorchoice@1.0.1
	core-foundation-sys@0.8.6
	cpufeatures@0.2.12
	crypto-common@0.1.6
	digest@0.10.7
	dirs@5.0.1
	dirs-sys@0.4.1
	either@1.12.0
	equivalent@1.0.1
	errno@0.3.9
	generic-array@0.14.7
	getrandom@0.2.15
	handlebars@5.1.2
	hashbrown@0.14.5
	heck@0.5.0
	home@0.5.9
	iana-time-zone@0.1.60
	iana-time-zone-haiku@0.1.2
	indexmap@2.2.6
	is_terminal_polyfill@1.70.0
	itoa@1.0.11
	js-sys@0.3.69
	lazy_static@1.4.0
	libc@0.2.155
	libredox@0.1.3
	linux-raw-sys@0.4.14
	log@0.4.21
	lua-src@546.0.2
	luajit-src@210.5.8+5790d25
	memchr@2.7.2
	mlua@0.9.8
	mlua-sys@0.6.0
	num-traits@0.2.19
	once_cell@1.19.0
	option-ext@0.2.0
	pest@2.7.10
	pest_derive@2.7.10
	pest_generator@2.7.10
	pest_meta@2.7.10
	pkg-config@0.3.30
	proc-macro2@1.0.85
	quote@1.0.36
	redox_users@0.4.5
	regex@1.10.4
	regex-automata@0.4.6
	regex-syntax@0.8.3
	rustc-hash@1.1.0
	rustix@0.38.34
	ryu@1.0.18
	serde@1.0.203
	serde_derive@1.0.203
	serde_json@1.0.117
	serde_spanned@0.6.6
	sha2@0.10.8
	strsim@0.11.1
	syn@2.0.66
	thiserror@1.0.61
	thiserror-impl@1.0.61
	toml@0.8.14
	toml_datetime@0.6.6
	toml_edit@0.22.14
	typenum@1.17.0
	ucd-trie@0.1.6
	unicode-ident@1.0.12
	utf8parse@0.2.1
	version_check@0.9.4
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen@0.2.92
	wasm-bindgen-backend@0.2.92
	wasm-bindgen-macro@0.2.92
	wasm-bindgen-macro-support@0.2.92
	wasm-bindgen-shared@0.2.92
	which@6.0.1
	windows-core@0.52.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.48.5
	windows-targets@0.52.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.5
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.5
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.5
	windows_i686_gnullvm@0.52.5
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.5
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.5
	winnow@0.6.13
	winsafe@0.0.19
	yansi@1.0.1
"

inherit cargo

DESCRIPTION="Small command-line JSON Log viewer"
HOMEPAGE="https://github.com/brocode/fblog"
SRC_URI="
	https://github.com/brocode/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions Boost-1.0 MIT MPL-2.0 unicode Unlicense WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

DOCS=(
	README.md
	default_config.toml
	sample_{context,elastic}.log
	sample{,_nested,_numbered}.json.log
)

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_prepare() {
	default
	rm Cargo.lock || die
}

src_install() {
	cargo_src_install
	einstalldocs
}
