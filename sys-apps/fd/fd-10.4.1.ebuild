# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.90.0"
CRATES="
	aho-corasick@1.1.4
	anstream@0.6.21
	anstyle-parse@0.2.7
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.13
	anyhow@1.0.102
	argmax@0.4.0
	bitflags@1.3.2
	bitflags@2.11.0
	block2@0.6.2
	bstr@1.12.1
	cc@1.2.56
	cfg-if@1.0.4
	cfg_aliases@0.2.1
	clap@4.5.60
	clap_builder@4.5.60
	clap_complete@4.5.66
	clap_derive@4.5.55
	clap_lex@1.0.0
	colorchoice@1.0.4
	crossbeam-channel@0.5.15
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	ctrlc@3.5.2
	diff@0.1.13
	dispatch2@0.3.1
	equivalent@1.0.2
	errno@0.3.14
	etcetera@0.11.0
	faccess@0.2.4
	fastrand@2.3.0
	filetime@0.2.27
	find-msvc-tools@0.1.9
	foldhash@0.1.5
	getrandom@0.4.2
	globset@0.4.18
	hashbrown@0.15.5
	hashbrown@0.16.1
	heck@0.5.0
	id-arena@2.3.0
	ignore@0.4.25
	indexmap@2.13.0
	is_terminal_polyfill@1.70.2
	itoa@1.0.17
	jiff-static@0.2.23
	jiff-tzdb-platform@0.1.3
	jiff-tzdb@0.1.6
	jiff@0.2.23
	leb128fmt@0.1.0
	libc@0.2.183
	libredox@0.1.14
	linux-raw-sys@0.12.1
	log@0.4.29
	lscolors@0.21.0
	memchr@2.8.0
	nix@0.30.1
	nix@0.31.2
	normpath@1.5.0
	nu-ansi-term@0.50.3
	objc2-encode@4.1.0
	objc2@0.6.4
	once_cell@1.21.3
	once_cell_polyfill@1.70.2
	plain@0.2.3
	portable-atomic-util@0.2.5
	portable-atomic@1.13.1
	prettyplease@0.2.37
	proc-macro2@1.0.106
	quote@1.0.45
	r-efi@6.0.0
	redox_syscall@0.7.3
	regex-automata@0.4.14
	regex-syntax@0.8.10
	regex@1.12.3
	rustix@1.1.4
	same-file@1.0.6
	semver@1.0.27
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.149
	shlex@1.3.0
	strsim@0.11.1
	syn@2.0.117
	tempfile@3.26.0
	terminal_size@0.4.3
	test-case-core@3.3.1
	test-case-macros@3.3.1
	test-case@3.3.1
	tikv-jemalloc-sys@0.6.1+5.3.0-1-ge13ca993e8ccb9ba9847cc330696e02839f328f7
	tikv-jemallocator@0.6.1
	unicode-ident@1.0.24
	unicode-xid@0.2.6
	utf8parse@0.2.2
	walkdir@2.5.0
	wasip2@1.0.2+wasi-0.2.9
	wasip3@0.4.0+wasi-0.3.0-rc-2026-01-06
	wasm-encoder@0.244.0
	wasm-metadata@0.244.0
	wasmparser@0.244.0
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.11
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-link@0.2.1
	windows-sys@0.60.2
	windows-sys@0.61.2
	windows-targets@0.53.5
	windows_aarch64_gnullvm@0.53.1
	windows_aarch64_msvc@0.53.1
	windows_i686_gnu@0.53.1
	windows_i686_gnullvm@0.53.1
	windows_i686_msvc@0.53.1
	windows_x86_64_gnu@0.53.1
	windows_x86_64_gnullvm@0.53.1
	windows_x86_64_msvc@0.53.1
	wit-bindgen-core@0.51.0
	wit-bindgen-rust-macro@0.51.0
	wit-bindgen-rust@0.51.0
	wit-bindgen@0.51.0
	wit-component@0.244.0
	wit-parser@0.244.0
	zmij@1.0.21
"

inherit cargo shell-completion

DESCRIPTION="Alternative to find that provides sensible defaults for 80% of the use cases"
HOMEPAGE="https://github.com/sharkdp/fd"
SRC_URI="
	https://github.com/sharkdp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/sharkdp/${PN}/releases/download/v${PV}/${PN}-v${PV}-i686-unknown-linux-gnu.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="|| ( Apache-2.0 MIT )"
# Dependent crate licenses
LICENSE+=" MIT Unicode-3.0 ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

DEPEND="
	!elibc_musl? ( >=dev-libs/jemalloc-5.1.0:= )
"
RDEPEND="
	${DEPEND}
"

QA_FLAGS_IGNORED="/usr/bin/fd"

src_compile() {
	sed -i -e '/strip/d' Cargo.toml || die

	# this enables to build with system jemallloc, but musl targets do not use it at all
	if ! use elibc_musl; then
		export JEMALLOC_OVERRIDE="${ESYSROOT}/usr/$(get_libdir)/libjemalloc.so"
		# https://github.com/tikv/jemallocator/issues/19
		export CARGO_FEATURE_UNPREFIXED_MALLOC_ON_SUPPORTED_PLATFORMS=1
	fi
	cargo_src_compile
}

src_test() {
	unset CLICOLOR_FORCE
	cargo_src_test
}

src_install() {
	cargo_src_install

	# pre-downloaded to avoid generation via running itself.
	local compdir="${WORKDIR}/${PN}-v${PV}-i686-unknown-linux-gnu"

	newbashcomp "${compdir}"/autocomplete/fd.bash fd
	dofishcomp "${compdir}"/autocomplete/fd.fish
	# zsh completion is in contrib
	dozshcomp contrib/completion/_fd

	dodoc README.md
	doman doc/*.1
}
