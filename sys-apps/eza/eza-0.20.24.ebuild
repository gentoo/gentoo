# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.24.2
	adler2@2.0.0
	aho-corasick@1.1.3
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anes@0.1.6
	ansi-width@0.1.0
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.7
	anstyle@1.0.10
	approx@0.5.1
	autocfg@1.4.0
	automod@1.0.14
	backtrace@0.3.74
	base64@0.22.1
	bitflags@2.8.0
	bumpalo@3.17.0
	by_address@1.2.1
	byteorder@1.5.0
	cast@0.3.0
	cc@1.2.10
	cfg-if@1.0.0
	chrono@0.4.40
	ciborium-io@0.2.2
	ciborium-ll@0.2.2
	ciborium@0.2.2
	clap@4.5.27
	clap_builder@4.5.27
	clap_lex@0.7.4
	colorchoice@1.0.3
	content_inspector@0.2.4
	core-foundation-sys@0.8.7
	criterion-plot@0.5.0
	criterion@0.5.1
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	crunchy@0.2.3
	datetime@0.5.2
	deranged@0.3.11
	dirs-sys@0.5.0
	dirs@6.0.0
	displaydoc@0.2.5
	dunce@1.0.5
	either@1.13.0
	equivalent@1.0.1
	errno@0.3.10
	fast-srgb8@1.0.0
	fastrand@2.3.0
	filetime@0.2.25
	form_urlencoded@1.2.1
	getrandom@0.2.15
	getrandom@0.3.1
	gimli@0.31.1
	git2@0.20.0
	glob@0.3.2
	half@2.4.1
	hashbrown@0.15.2
	hermit-abi@0.4.0
	humantime-serde@1.1.1
	humantime@2.1.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.61
	icu_collections@1.5.0
	icu_locid@1.5.0
	icu_locid_transform@1.5.0
	icu_locid_transform_data@1.5.0
	icu_normalizer@1.5.0
	icu_normalizer_data@1.5.0
	icu_properties@1.5.1
	icu_properties_data@1.5.0
	icu_provider@1.5.0
	icu_provider_macros@1.5.0
	idna@1.0.3
	idna_adapter@1.2.0
	indexmap@2.7.1
	is-terminal@0.4.15
	is_terminal_polyfill@1.70.1
	itertools@0.10.5
	itoa@1.0.14
	jobserver@0.1.32
	js-sys@0.3.77
	libc@0.2.170
	libgit2-sys@0.18.0+1.9.0
	libredox@0.1.3
	libz-sys@1.1.21
	linux-raw-sys@0.4.15
	linux-raw-sys@0.9.2
	litemap@0.7.4
	locale@0.2.2
	log@0.4.26
	memchr@2.7.4
	miniz_oxide@0.8.3
	natord-plus-plus@2.0.0
	normalize-line-endings@0.3.0
	nu-ansi-term@0.50.1
	num-conv@0.1.0
	num-traits@0.2.19
	number_prefix@0.4.0
	object@0.36.7
	once_cell@1.21.0
	oorandom@11.1.4
	openssl-src@300.4.1+3.4.0
	openssl-sys@0.9.104
	option-ext@0.2.0
	os_pipe@1.2.1
	palette@0.7.6
	palette_derive@0.7.6
	partition-identity@0.3.0
	path-clean@1.0.1
	percent-encoding@2.3.1
	phf@0.11.3
	phf_generator@0.11.3
	phf_macros@0.11.3
	phf_shared@0.11.3
	pkg-config@0.3.31
	plist@1.7.0
	plotters-backend@0.3.7
	plotters-svg@0.3.7
	plotters@0.3.7
	powerfmt@0.2.0
	proc-macro2@1.0.93
	proc-mounts@0.3.0
	quick-xml@0.32.0
	quote@1.0.38
	rand@0.8.5
	rand_core@0.6.4
	rayon-core@1.12.1
	rayon@1.10.0
	redox_syscall@0.1.57
	redox_syscall@0.5.8
	redox_users@0.5.0
	regex-automata@0.4.9
	regex-syntax@0.8.5
	regex@1.11.1
	rustc-demangle@0.1.24
	rustix@0.38.44
	rustix@1.0.2
	rustversion@1.0.19
	ryu@1.0.19
	same-file@1.0.6
	serde@1.0.219
	serde_derive@1.0.219
	serde_json@1.0.138
	serde_norway@0.9.42
	serde_spanned@0.6.8
	shlex@1.3.0
	similar@2.7.0
	siphasher@1.0.1
	smallvec@1.13.2
	snapbox-macros@0.3.10
	snapbox@0.6.21
	stable_deref_trait@1.2.0
	syn@2.0.96
	synstructure@0.13.1
	tempfile@3.16.0
	terminal_size@0.4.2
	thiserror-impl@1.0.69
	thiserror-impl@2.0.11
	thiserror@1.0.69
	thiserror@2.0.11
	time-core@0.1.2
	time-macros@0.2.19
	time@0.3.37
	timeago@0.4.2
	tinystr@0.7.6
	tinytemplate@1.2.1
	toml_datetime@0.6.8
	toml_edit@0.22.22
	trycmd@0.15.9
	unicode-ident@1.0.16
	unicode-width@0.1.14
	unicode-width@0.2.0
	unsafe-libyaml-norway@0.2.15
	url@2.5.4
	utf16_iter@1.0.5
	utf8_iter@1.0.4
	utf8parse@0.2.2
	uutils_term_grid@0.6.0
	uzers@0.12.1
	vcpkg@0.2.15
	wait-timeout@0.2.0
	walkdir@2.5.0
	wasi@0.11.0+wasi-snapshot-preview1
	wasi@0.13.3+wasi-0.2.2
	wasm-bindgen-backend@0.2.100
	wasm-bindgen-macro-support@0.2.100
	wasm-bindgen-macro@0.2.100
	wasm-bindgen-shared@0.2.100
	wasm-bindgen@0.2.100
	web-sys@0.3.77
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.9
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-link@0.1.0
	windows-sys@0.52.0
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
	winnow@0.6.25
	wit-bindgen-rt@0.33.0
	write16@1.0.0
	writeable@0.5.5
	yoke-derive@0.7.5
	yoke@0.7.5
	zerofrom-derive@0.1.5
	zerofrom@0.1.5
	zerovec-derive@0.10.3
	zerovec@0.10.4
	zoneinfo_compiled@0.5.1
"

inherit cargo shell-completion

# script to generate the tarball: https://raw.githubusercontent.com/sevz17/eza-manpages/main/generate-eza-manpages
# MANPAGES_BASE_URI="https://github.com/sevz17/eza-manpages/releases/download/${PV}"
MANPAGES_BASE_URI="https://github.com/idealseal/eza-manpages/releases/download/${PV}"

DESCRIPTION="A modern, maintained replacement for ls"
HOMEPAGE="
	https://eza.rocks
	https://github.com/eza-community/eza
"
SRC_URI="
	https://github.com/eza-community/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${MANPAGES_BASE_URI}/${P}-manpages.tar.xz
	${CARGO_CRATE_URIS}
"

LICENSE="EUPL-1.2"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT MPL-2.0 Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="+git"

BDEPEND="virtual/pkgconfig"
DEPEND="
	git? ( =dev-libs/libgit2-1.9*:= )
	dev-libs/openssl
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="usr/bin/${PN}"

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
	export LIBGIT2_NO_VENDOR=1
	export OPENSSL_NO_VENDOR=1
	export PKG_CONFIG_ALLOW_CROSS=1
	cargo_src_configure --no-default-features
}

src_install() {
	cargo_src_install

	dobashcomp "completions/bash/${PN}"
	dozshcomp "completions/zsh/_${PN}"
	dofishcomp "completions/fish/${PN}.fish"

	doman "${WORKDIR}"/manpages/*
}
