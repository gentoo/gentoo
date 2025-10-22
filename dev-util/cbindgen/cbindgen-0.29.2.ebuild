# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	anstream@0.6.19
	anstyle-parse@0.2.7
	anstyle-query@1.1.3
	anstyle-wincon@3.0.9
	anstyle@1.0.11
	autocfg@1.5.0
	bitflags@2.9.1
	cfg-if@1.0.1
	clap@4.5.41
	clap_builder@4.5.41
	clap_lex@0.7.5
	colorchoice@1.0.4
	dashmap@5.5.3
	diff@0.1.13
	equivalent@1.0.2
	errno@0.3.13
	fastrand@2.3.0
	getrandom@0.3.3
	hashbrown@0.14.5
	heck@0.5.0
	indexmap@2.5.0
	is_terminal_polyfill@1.70.1
	itoa@1.0.15
	lazy_static@1.5.0
	libc@0.2.174
	linux-raw-sys@0.9.4
	lock_api@0.4.13
	log@0.4.27
	memchr@2.7.5
	once_cell@1.21.3
	once_cell_polyfill@1.70.1
	parking_lot@0.12.4
	parking_lot_core@0.9.11
	pretty_assertions@1.4.1
	proc-macro2@1.0.95
	quote@1.0.40
	r-efi@5.3.0
	redox_syscall@0.5.13
	rustix@1.0.8
	ryu@1.0.20
	scopeguard@1.2.0
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.140
	serde_spanned@1.0.0
	serial_test@2.0.0
	serial_test_derive@2.0.0
	smallvec@1.15.1
	strsim@0.11.1
	syn@2.0.104
	tempfile@3.20.0
	toml@0.9.2
	toml_datetime@0.7.0
	toml_parser@1.0.1
	toml_writer@1.0.2
	unicode-ident@1.0.18
	utf8parse@0.2.2
	wasi@0.14.2+wasi-0.2.4
	windows-sys@0.59.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	winnow@0.7.12
	wit-bindgen-rt@0.39.0
	yansi@1.0.1
"

inherit cargo

DESCRIPTION="A tool for generating C bindings to Rust code"
HOMEPAGE="https://github.com/mozilla/cbindgen/"
SRC_URI="${CARGO_CRATE_URIS}
	https://github.com/mozilla/cbindgen/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
# Dependent crate licenses
LICENSE+="
	MIT Unicode-3.0
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="test"

# Needs debugging enabled and lots of other problems.
# https://github.com/mozilla/cbindgen/issues?q=is%3Aissue+is%3Aopen+test
RESTRICT="test"

BDEPEND="test? ( dev-build/cmake )"

QA_FLAGS_IGNORED="usr/bin/cbindgen"
