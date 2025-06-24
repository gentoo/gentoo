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
	anstyle-wincon@3.0.8
	anstyle@1.0.10
	approx@0.5.1
	autocfg@1.4.0
	automod@1.0.15
	backtrace@0.3.75
	base64@0.22.1
	bitflags@2.9.1
	bumpalo@3.17.0
	by_address@1.2.1
	byteorder@1.5.0
	cast@0.3.0
	cc@1.2.24
	cfg-if@1.0.0
	chrono@0.4.41
	ciborium-io@0.2.2
	ciborium-ll@0.2.2
	ciborium@0.2.2
	clap@4.5.39
	clap_builder@4.5.39
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
	deranged@0.4.0
	dirs-sys@0.5.0
	dirs@6.0.0
	displaydoc@0.2.5
	dunce@1.0.5
	either@1.15.0
	equivalent@1.0.2
	errno@0.3.12
	fast-srgb8@1.0.0
	fastrand@2.3.0
	filetime@0.2.25
	form_urlencoded@1.2.1
	getrandom@0.2.16
	getrandom@0.3.3
	gimli@0.31.1
	git2@0.20.2
	glob@0.3.2
	half@2.6.0
	hashbrown@0.15.3
	hermit-abi@0.5.1
	humantime-serde@1.1.1
	humantime@2.2.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.63
	icu_collections@2.0.0
	icu_locale_core@2.0.0
	icu_normalizer@2.0.0
	icu_normalizer_data@2.0.0
	icu_properties@2.0.1
	icu_properties_data@2.0.1
	icu_provider@2.0.0
	idna@1.0.3
	idna_adapter@1.2.1
	indexmap@2.9.0
	is-terminal@0.4.16
	is_terminal_polyfill@1.70.1
	itertools@0.10.5
	itoa@1.0.15
	jobserver@0.1.33
	js-sys@0.3.77
	libc@0.2.172
	libgit2-sys@0.18.1+1.9.0
	libredox@0.1.3
	libz-sys@1.1.22
	linux-raw-sys@0.9.4
	litemap@0.8.0
	locale@0.2.2
	log@0.4.27
	memchr@2.7.4
	miniz_oxide@0.8.8
	natord-plus-plus@2.0.0
	normalize-line-endings@0.3.0
	nu-ansi-term@0.50.1
	num-conv@0.1.0
	num-traits@0.2.19
	number_prefix@0.4.0
	object@0.36.7
	once_cell@1.21.3
	once_cell_polyfill@1.70.1
	oorandom@11.1.5
	openssl-src@300.5.0+3.5.0
	openssl-sys@0.9.109
	option-ext@0.2.0
	os_pipe@1.2.2
	palette@0.7.6
	palette_derive@0.7.6
	partition-identity@0.3.0
	path-clean@1.0.1
	percent-encoding@2.3.1
	phf@0.11.3
	phf_generator@0.11.3
	phf_macros@0.11.3
	phf_shared@0.11.3
	pkg-config@0.3.32
	plist@1.7.1
	plotters-backend@0.3.7
	plotters-svg@0.3.7
	plotters@0.3.7
	potential_utf@0.1.2
	powerfmt@0.2.0
	proc-macro2@1.0.95
	proc-mounts@0.3.0
	quick-xml@0.32.0
	quote@1.0.40
	r-efi@5.2.0
	rand@0.8.5
	rand_core@0.6.4
	rayon-core@1.12.1
	rayon@1.10.0
	redox_syscall@0.1.57
	redox_syscall@0.5.12
	redox_users@0.5.0
	regex-automata@0.4.9
	regex-syntax@0.8.5
	regex@1.11.1
	rustc-demangle@0.1.24
	rustix@1.0.7
	rustversion@1.0.21
	ryu@1.0.20
	same-file@1.0.6
	serde@1.0.219
	serde_derive@1.0.219
	serde_json@1.0.140
	serde_norway@0.9.42
	serde_spanned@0.6.8
	shlex@1.3.0
	similar@2.7.0
	siphasher@1.0.1
	smallvec@1.15.0
	snapbox-macros@0.3.10
	snapbox@0.6.21
	stable_deref_trait@1.2.0
	syn@2.0.101
	synstructure@0.13.2
	tempfile@3.20.0
	terminal_size@0.4.2
	thiserror-impl@1.0.69
	thiserror-impl@2.0.12
	thiserror@1.0.69
	thiserror@2.0.12
	time-core@0.1.4
	time-macros@0.2.22
	time@0.3.41
	timeago@0.4.2
	tinystr@0.8.1
	tinytemplate@1.2.1
	toml_datetime@0.6.9
	toml_edit@0.22.26
	toml_write@0.1.1
	trycmd@0.15.9
	unicode-ident@1.0.18
	unicode-width@0.1.14
	unicode-width@0.2.0
	unsafe-libyaml-norway@0.2.15
	url@2.5.4
	utf8_iter@1.0.4
	utf8parse@0.2.2
	uutils_term_grid@0.7.0
	uzers@0.12.1
	vcpkg@0.2.15
	wait-timeout@0.2.1
	walkdir@2.5.0
	wasi@0.11.0+wasi-snapshot-preview1
	wasi@0.14.2+wasi-0.2.4
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
	windows-core@0.61.2
	windows-implement@0.60.0
	windows-interface@0.59.1
	windows-link@0.1.1
	windows-result@0.3.4
	windows-strings@0.4.2
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
	winnow@0.7.10
	wit-bindgen-rt@0.39.0
	writeable@0.6.1
	yoke-derive@0.8.0
	yoke@0.8.0
	zerofrom-derive@0.1.6
	zerofrom@0.1.6
	zerotrie@0.2.2
	zerovec-derive@0.11.1
	zerovec@0.11.2
	zoneinfo_compiled@0.5.1
"

inherit cargo shell-completion

DESCRIPTION="A modern, maintained replacement for ls"
HOMEPAGE="
	https://eza.rocks
	https://github.com/eza-community/eza
"
SRC_URI="
	https://github.com/eza-community/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="EUPL-1.2"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT MPL-2.0 Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="+git man"

BDEPEND="
	man? ( dev-go/go-md2man )
	virtual/pkgconfig
"
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

	if use man; then
		mkdir "${WORKDIR}"/manpages || die
		for f in $(ls "${S}"/man || die); do
			go-md2man \
				-in "${S}"/man/${f} \
				-out "${WORKDIR}"/manpages/${f/.md/} \
				|| die "go-md2man failed for ${f}"
		done
		doman "${WORKDIR}"/manpages/*
	fi
}
