# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@0.7.20
	anyhow@1.0.69
	atty@0.2.14
	bitflags@1.3.2
	bstr@0.2.17
	cc@1.0.79
	cfg-if@1.0.0
	clap@4.1.4
	clap_derive@4.1.0
	clap_lex@0.3.1
	cpp_demangle@0.4.0
	csv@1.1.6
	csv-core@0.1.10
	dirs-next@2.0.0
	dirs-sys-next@0.1.2
	encode_unicode@1.0.0
	env_logger@0.10.0
	errno@0.2.8
	errno-dragonfly@0.1.2
	getrandom@0.2.8
	goblin@0.6.0
	heck@0.4.1
	hermit-abi@0.1.19
	hermit-abi@0.3.0
	hexplay@0.2.1
	humantime@2.1.0
	io-lifetimes@1.0.5
	is-terminal@0.4.3
	itoa@0.4.8
	lazy_static@1.4.0
	libc@0.2.139
	linux-raw-sys@0.1.4
	log@0.4.17
	memchr@2.5.0
	metagoblin@0.8.0
	once_cell@1.17.0
	os_str_bytes@6.4.1
	plain@0.2.3
	prettytable-rs@0.10.0
	proc-macro-error@1.0.4
	proc-macro-error-attr@1.0.4
	proc-macro2@1.0.93
	quote@1.0.23
	redox_syscall@0.2.16
	redox_users@0.4.3
	regex@1.7.1
	regex-automata@0.1.10
	regex-syntax@0.6.28
	rustc-demangle@0.1.21
	rustix@0.36.8
	rustversion@1.0.11
	ryu@1.0.12
	scroll@0.11.0
	scroll_derive@0.11.0
	serde@1.0.152
	strsim@0.10.0
	syn@1.0.107
	term@0.7.0
	termcolor@0.3.6
	termcolor@1.2.0
	terminal_size@0.2.3
	thiserror@1.0.38
	thiserror-impl@1.0.38
	unicode-ident@1.0.6
	unicode-width@0.1.10
	version_check@0.9.4
	wasi@0.11.0+wasi-snapshot-preview1
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.5
	winapi-x86_64-pc-windows-gnu@0.4.0
	wincolor@0.1.6
	windows-sys@0.42.0
	windows-sys@0.45.0
	windows-targets@0.42.1
	windows_aarch64_gnullvm@0.42.1
	windows_aarch64_msvc@0.42.1
	windows_i686_gnu@0.42.1
	windows_i686_msvc@0.42.1
	windows_x86_64_gnu@0.42.1
	windows_x86_64_gnullvm@0.42.1
	windows_x86_64_msvc@0.42.1
"

inherit cargo

DESCRIPTION="Binary file analysis tool"
HOMEPAGE="https://github.com/m4b/bingrep"
SRC_URI="https://github.com/m4b/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}"

LICENSE="Apache-2.0 BSD Boost-1.0 MIT Unicode-DFS-2016"

SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-update-crates.patch
)

QA_FLAGS_IGNORED="usr/bin/${PN}"

pkg_setup() {
	rust_pkg_setup
	# Requires nightly feature proc-macro2
	export RUSTC_BOOTSTRAP=1
}

src_install() {
	cargo_src_install
	einstalldocs
}
