# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.25.1
	adler2@2.0.1
	aho-corasick@1.1.4
	alloca@0.4.0
	android_system_properties@0.1.5
	anes@0.1.6
	ansi-width@0.1.0
	anstream@0.6.21
	anstyle-parse@0.2.7
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.13
	anyhow@1.0.101
	approx@0.5.1
	autocfg@1.5.0
	automod@1.0.16
	backtrace@0.3.76
	base64@0.22.1
	bitflags@2.11.0
	bumpalo@3.19.1
	by_address@1.2.1
	cast@0.3.0
	cc@1.2.56
	cfg-if@1.0.4
	chrono@0.4.43
	ciborium-io@0.2.2
	ciborium-ll@0.2.2
	ciborium@0.2.2
	clap@4.5.59
	clap_builder@4.5.59
	clap_derive@4.5.55
	clap_lex@1.0.0
	colorchoice@1.0.4
	content_inspector@0.2.4
	core-foundation-sys@0.8.7
	criterion-plot@0.8.2
	criterion@0.8.2
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.20
	crossbeam-utils@0.8.21
	crunchy@0.2.4
	deranged@0.5.6
	dirs-sys@0.5.0
	dirs@6.0.0
	dunce@1.0.5
	either@1.15.0
	equivalent@1.0.2
	errno@0.3.14
	fast-srgb8@1.0.0
	fastrand@2.3.0
	filetime@0.2.27
	find-msvc-tools@0.1.9
	foldhash@0.1.5
	getrandom@0.2.17
	getrandom@0.3.4
	getrandom@0.4.1
	gimli@0.32.3
	git2@0.21.0
	glob@0.3.3
	half@2.7.1
	hashbrown@0.15.5
	hashbrown@0.16.1
	heck@0.5.0
	humantime-serde@1.1.1
	humantime@2.3.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.65
	id-arena@2.3.0
	indexmap@2.13.0
	is_terminal_polyfill@1.70.2
	itertools@0.13.0
	itoa@1.0.17
	jobserver@0.1.34
	js-sys@0.3.85
	leb128fmt@0.1.0
	libc@0.2.182
	libgit2-sys@0.18.5+1.9.4
	libredox@0.1.12
	libz-sys@1.1.23
	linux-raw-sys@0.11.0
	locale@0.2.2
	log@0.4.29
	memchr@2.8.0
	miniz_oxide@0.8.9
	natord-plus-plus@2.0.0
	normalize-line-endings@0.3.0
	nu-ansi-term@0.50.3
	num-conv@0.2.0
	num-traits@0.2.19
	object@0.37.3
	once_cell@1.21.3
	once_cell_polyfill@1.70.2
	oorandom@11.1.5
	openssl-src@300.5.5+3.5.5
	openssl-sys@0.9.111
	option-ext@0.2.0
	os_pipe@1.2.3
	page_size@0.6.0
	palette@0.7.5
	palette_derive@0.7.6
	partition-identity@0.3.0
	path-clean@1.0.1
	percent-encoding@2.3.2
	phf@0.13.1
	phf_generator@0.13.1
	phf_macros@0.13.1
	phf_shared@0.13.1
	pkg-config@0.3.32
	plist@1.10.0
	plotters-backend@0.3.7
	plotters-svg@0.3.7
	plotters@0.3.7
	powerfmt@0.2.0
	prettyplease@0.2.37
	proc-macro2@1.0.106
	proc-mounts@0.3.0
	quick-xml@0.41.0
	quote@1.0.44
	r-efi@5.3.0
	rayon-core@1.13.0
	rayon@1.11.0
	redox_syscall@0.7.1
	redox_users@0.5.2
	regex-automata@0.4.14
	regex-syntax@0.8.9
	regex@1.12.3
	rustc-demangle@0.1.27
	rustix@1.1.3
	rustversion@1.0.22
	ryu@1.0.23
	same-file@1.0.6
	semver@1.0.27
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.149
	serde_norway@0.9.42
	serde_spanned@1.0.4
	shlex@1.3.0
	similar@2.7.0
	siphasher@1.0.2
	snapbox-macros@1.0.0
	snapbox@1.0.0
	strsim@0.11.1
	syn@2.0.116
	tempfile@3.25.0
	terminal_size@0.4.3
	thiserror-impl@1.0.69
	thiserror-impl@2.0.18
	thiserror@1.0.69
	thiserror@2.0.18
	time-core@0.1.8
	time-macros@0.2.27
	time@0.3.47
	timeago@0.6.0
	tinytemplate@1.2.1
	toml_datetime@0.7.5+spec-1.1.0
	toml_edit@0.23.10+spec-1.0.0
	toml_parser@1.0.9+spec-1.1.0
	toml_writer@1.0.6+spec-1.1.0
	trycmd@1.0.0
	unicode-ident@1.0.24
	unicode-width@0.1.14
	unicode-width@0.2.2
	unicode-xid@0.2.6
	unit-prefix@0.5.2
	unsafe-libyaml-norway@0.2.15
	utf8parse@0.2.2
	uutils_term_grid@0.7.0
	uzers@0.12.2
	vcpkg@0.2.15
	wait-timeout@0.2.1
	walkdir@2.5.0
	wasi@0.11.1+wasi-snapshot-preview1
	wasip2@1.0.2+wasi-0.2.9
	wasip3@0.4.0+wasi-0.3.0-rc-2026-01-06
	wasm-bindgen-macro-support@0.2.108
	wasm-bindgen-macro@0.2.108
	wasm-bindgen-shared@0.2.108
	wasm-bindgen@0.2.108
	wasm-encoder@0.244.0
	wasm-metadata@0.244.0
	wasmparser@0.244.0
	web-sys@0.3.85
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.11
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.62.2
	windows-implement@0.60.2
	windows-interface@0.59.3
	windows-link@0.2.1
	windows-result@0.4.1
	windows-strings@0.5.1
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
	winnow@0.7.14
	wit-bindgen-core@0.51.0
	wit-bindgen-rust-macro@0.51.0
	wit-bindgen-rust@0.51.0
	wit-bindgen@0.51.0
	wit-component@0.244.0
	wit-parser@0.244.0
	zerocopy-derive@0.8.39
	zerocopy@0.8.39
	zmij@1.0.21
"

RUST_MIN_VER="1.90.0"

inherit cargo shell-completion

DESCRIPTION="A modern, maintained replacement for ls"
HOMEPAGE="
	https://eza.rocks
	https://github.com/eza-community/eza
"
SRC_URI="
	https://github.com/eza-community/eza/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/eza-community/eza/releases/download/v${PV}/man-${PV}.tar.gz -> ${P}-manpages.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="EUPL-1.2"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT MPL-2.0 Unicode-3.0 ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="+git"

BDEPEND="virtual/pkgconfig"
DEPEND="
	git? (
		=dev-libs/libgit2-1.9*:=
		dev-libs/openssl
	)
	virtual/zlib:=
"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="usr/bin/${PN}"

pkg_setup() {
	export LIBGIT2_NO_VENDOR=1
	export OPENSSL_NO_VENDOR=1
	export PKG_CONFIG_ALLOW_CROSS=1
	rust_pkg_setup
}

src_prepare() {
	default

	# Known failing tests, upstream says they could potentially be ignored for now.
	# bug #914214
	# https://github.com/eza-community/eza/issues/393
	rm tests/cmd/{icons,basic}_all.toml || die
	rm tests/cmd/absolute{,_recurse}_unix.toml || die

	sed -i -e 's/^strip = true$/strip = false/g' Cargo.toml || die "failed to disable stripping"
}

src_configure() {
	local myfeatures=(
		$(usev git)
	)
	cargo_src_configure --no-default-features
}

src_install() {
	cargo_src_install

	dobashcomp "completions/bash/${PN}"
	dozshcomp "completions/zsh/_${PN}"
	dofishcomp "completions/fish/${PN}.fish"

	doman "${WORKDIR}"/target/man-${PV}/*
}
