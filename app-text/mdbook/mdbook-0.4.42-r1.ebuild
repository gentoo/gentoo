# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.24.2
	adler2@2.0.0
	aho-corasick@1.1.3
	ammonia@4.0.0
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.6
	anstyle@1.0.10
	anyhow@1.0.93
	assert_cmd@2.0.16
	autocfg@1.4.0
	backtrace@0.3.74
	base64@0.21.7
	bitflags@1.3.2
	bitflags@2.6.0
	bit-set@0.5.3
	bit-vec@0.6.3
	block-buffer@0.10.4
	bstr@1.10.0
	bumpalo@3.16.0
	byteorder@1.5.0
	bytes@1.8.0
	cc@1.1.36
	cfg-if@1.0.0
	chrono@0.4.38
	clap@4.5.20
	clap_builder@4.5.20
	clap_complete@4.5.37
	clap_lex@0.7.2
	colorchoice@1.0.3
	core-foundation-sys@0.8.7
	cpufeatures@0.2.14
	crossbeam-channel@0.5.13
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.20
	crypto-common@0.1.6
	data-encoding@2.6.0
	dbus@0.9.7
	difflib@0.4.0
	diff@0.1.13
	digest@0.10.7
	displaydoc@0.2.5
	doc-comment@0.3.3
	elasticlunr-rs@3.0.2
	env_filter@0.1.2
	env_logger@0.11.5
	equivalent@1.0.1
	errno@0.3.9
	fastrand@2.1.1
	filetime@0.2.25
	float-cmp@0.9.0
	fnv@1.0.7
	form_urlencoded@1.2.1
	fsevent-sys@4.1.0
	futf@0.1.5
	futures-channel@0.3.31
	futures-core@0.3.31
	futures-macro@0.3.31
	futures-sink@0.3.31
	futures-task@0.3.31
	futures-util@0.3.31
	generic-array@0.14.7
	getrandom@0.2.15
	gimli@0.31.1
	globset@0.4.15
	h2@0.3.26
	handlebars@6.2.0
	hashbrown@0.15.1
	headers-core@0.2.0
	headers@0.3.9
	hermit-abi@0.3.9
	html5ever@0.26.0
	html5ever@0.27.0
	httparse@1.9.5
	httpdate@1.0.3
	http-body@0.4.6
	http@0.2.12
	http@1.1.0
	humantime@2.1.0
	hyper@0.14.31
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
	ignore@0.4.23
	indexmap@2.6.0
	inotify-sys@0.1.5
	inotify@0.9.6
	is_terminal_polyfill@1.70.1
	itoa@1.0.11
	js-sys@0.3.72
	kqueue-sys@1.0.4
	kqueue@1.0.8
	libc@0.2.161
	libdbus-sys@0.2.5
	libredox@0.1.3
	linux-raw-sys@0.4.14
	litemap@0.7.3
	lock_api@0.4.12
	log@0.4.22
	mac@0.1.1
	maplit@1.0.2
	markup5ever@0.11.0
	markup5ever@0.12.1
	markup5ever_rcdom@0.2.0
	memchr@2.7.4
	mime@0.3.17
	mime_guess@2.0.5
	miniz_oxide@0.8.0
	mio@0.8.11
	mio@1.0.2
	new_debug_unreachable@1.0.6
	normalize-line-endings@0.3.0
	normpath@1.3.0
	notify-debouncer-mini@0.4.1
	notify@6.1.1
	num-modular@0.6.1
	num-order@1.2.0
	num-traits@0.2.19
	object@0.36.5
	once_cell@1.20.2
	opener@0.7.2
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	pathdiff@0.2.2
	percent-encoding@2.3.1
	pest@2.7.14
	pest_derive@2.7.14
	pest_generator@2.7.14
	pest_meta@2.7.14
	phf@0.10.1
	phf@0.11.2
	phf_codegen@0.10.0
	phf_codegen@0.11.2
	phf_generator@0.10.0
	phf_generator@0.11.2
	phf_shared@0.10.0
	phf_shared@0.11.2
	pin-project-internal@1.1.7
	pin-project-lite@0.2.15
	pin-project@1.1.7
	pin-utils@0.1.0
	pkg-config@0.3.31
	ppv-lite86@0.2.20
	precomputed-hash@0.1.1
	predicates-core@1.0.8
	predicates-tree@1.0.11
	predicates@3.1.2
	pretty_assertions@1.4.1
	proc-macro2@1.0.89
	pulldown-cmark-escape@0.10.1
	pulldown-cmark-to-cmark@18.0.0
	pulldown-cmark@0.10.3
	pulldown-cmark@0.12.2
	quote@1.0.37
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	redox_syscall@0.5.7
	regex-automata@0.4.8
	regex-syntax@0.8.5
	regex@1.11.1
	rustc-demangle@0.1.24
	rustix@0.38.39
	ryu@1.0.18
	same-file@1.0.6
	scoped-tls@1.0.1
	scopeguard@1.2.0
	select@0.6.0
	semver@1.0.23
	serde@1.0.214
	serde_derive@1.0.214
	serde_json@1.0.132
	serde_urlencoded@0.7.1
	sha1@0.10.6
	sha2@0.10.8
	shlex@1.3.0
	siphasher@0.3.11
	slab@0.4.9
	smallvec@1.13.2
	socket2@0.5.7
	stable_deref_trait@1.2.0
	string_cache@0.8.7
	string_cache_codegen@0.5.2
	strsim@0.11.1
	synstructure@0.13.1
	syn@1.0.109
	syn@2.0.87
	tempfile@3.13.0
	tendril@0.4.3
	terminal_size@0.4.0
	termtree@0.4.1
	thiserror-impl@1.0.68
	thiserror@1.0.68
	tinystr@0.7.6
	tokio-macros@2.4.0
	tokio-tungstenite@0.21.0
	tokio-util@0.7.12
	tokio@1.41.0
	toml@0.5.11
	topological-sort@0.2.2
	tower-service@0.3.3
	tracing-core@0.1.32
	tracing@0.1.40
	try-lock@0.2.5
	tungstenite@0.21.0
	typenum@1.17.0
	ucd-trie@0.1.7
	unicase@2.8.0
	unicode-ident@1.0.13
	url@2.5.3
	utf8parse@0.2.2
	utf8_iter@1.0.4
	utf16_iter@1.0.5
	utf-8@0.7.6
	version_check@0.9.5
	wait-timeout@0.2.0
	walkdir@2.5.0
	want@0.3.1
	warp@0.3.7
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.95
	wasm-bindgen-macro-support@0.2.95
	wasm-bindgen-macro@0.2.95
	wasm-bindgen-shared@0.2.95
	wasm-bindgen@0.2.95
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.9
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.48.5
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.6
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.6
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.6
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.6
	write16@1.0.0
	writeable@0.5.5
	xml5ever@0.17.0
	yansi@1.0.1
	yoke-derive@0.7.4
	yoke@0.7.4
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
	zerofrom-derive@0.1.4
	zerofrom@0.1.4
	zerovec-derive@0.10.3
	zerovec@0.10.4
"
inherit cargo toolchain-funcs

DESCRIPTION="Create a book from markdown files"
HOMEPAGE="https://rust-lang.github.io/mdBook/"
SRC_URI="
	https://github.com/rust-lang/mdBook/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"
S="${WORKDIR}/${P/b/B}"

# CC-BY-4.0/OFL-1.1: embeds fonts inside the executable
LICENSE="MPL-2.0 CC-BY-4.0 OFL-1.1"
LICENSE+=" Apache-2.0 CC0-1.0 ISC MIT Unicode-3.0 Unicode-DFS-2016" # crates
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="doc"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_compile() {
	cargo_src_compile

	if use doc; then
		if tc-is-cross-compiler; then
			ewarn "html docs were skipped due to cross-compilation"
		else
			"$(cargo_target_dir)"/${PN} build -d html guide || die
		fi
	fi
}

src_test() {
	local skip=(
		# fails with usersandbox
		--skip test_ignore_canonical
	)

	cargo_src_test -- "${skip[@]}"
}

src_install() {
	cargo_src_install

	dodoc CHANGELOG.md README.md
	use doc && ! tc-is-cross-compiler && dodoc -r guide/html
}
