# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.21.0
	adler@1.0.2
	aho-corasick@1.1.3
	ammonia@4.0.0
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.6.14
	anstyle-parse@0.2.4
	anstyle-query@1.0.3
	anstyle-wincon@3.0.3
	anstyle@1.0.7
	anyhow@1.0.83
	assert_cmd@2.0.14
	autocfg@1.3.0
	backtrace@0.3.71
	base64@0.21.7
	bitflags@1.3.2
	bitflags@2.5.0
	bit-set@0.5.3
	bit-vec@0.6.3
	block-buffer@0.10.4
	bstr@1.9.1
	bumpalo@3.16.0
	byteorder@1.5.0
	bytes@1.6.0
	cc@1.0.97
	cfg-if@1.0.0
	chrono@0.4.38
	clap@4.5.4
	clap_builder@4.5.2
	clap_complete@4.5.2
	clap_lex@0.7.0
	colorchoice@1.0.1
	core-foundation-sys@0.8.6
	cpufeatures@0.2.12
	crossbeam-channel@0.5.12
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.19
	crypto-common@0.1.6
	data-encoding@2.6.0
	dbus@0.9.7
	difflib@0.4.0
	diff@0.1.13
	digest@0.10.7
	doc-comment@0.3.3
	elasticlunr-rs@3.0.2
	env_filter@0.1.0
	env_logger@0.11.3
	equivalent@1.0.1
	errno@0.3.9
	fastrand@2.1.0
	filetime@0.2.23
	float-cmp@0.9.0
	fnv@1.0.7
	form_urlencoded@1.2.1
	fsevent-sys@4.1.0
	futf@0.1.5
	futures-channel@0.3.30
	futures-core@0.3.30
	futures-macro@0.3.30
	futures-sink@0.3.30
	futures-task@0.3.30
	futures-util@0.3.30
	generic-array@0.14.7
	getrandom@0.2.15
	gimli@0.28.1
	globset@0.4.14
	h2@0.3.26
	handlebars@5.1.2
	hashbrown@0.14.5
	headers-core@0.2.0
	headers@0.3.9
	hermit-abi@0.3.9
	html5ever@0.26.0
	html5ever@0.27.0
	httparse@1.8.0
	httpdate@1.0.3
	http-body@0.4.6
	http@0.2.12
	http@1.1.0
	humantime@2.1.0
	hyper@0.14.28
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.60
	idna@0.5.0
	ignore@0.4.22
	indexmap@2.2.6
	inotify-sys@0.1.5
	inotify@0.9.6
	is_terminal_polyfill@1.70.0
	itoa@1.0.11
	js-sys@0.3.69
	kqueue-sys@1.0.4
	kqueue@1.0.8
	libc@0.2.154
	libdbus-sys@0.2.5
	linux-raw-sys@0.4.13
	lock_api@0.4.12
	log@0.4.21
	mac@0.1.1
	maplit@1.0.2
	markup5ever@0.11.0
	markup5ever@0.12.1
	markup5ever_rcdom@0.2.0
	memchr@2.7.2
	mime@0.3.17
	mime_guess@2.0.4
	miniz_oxide@0.7.2
	mio@0.8.11
	new_debug_unreachable@1.0.6
	normalize-line-endings@0.3.0
	normpath@1.2.0
	notify-debouncer-mini@0.4.1
	notify@6.1.1
	num-traits@0.2.19
	num_cpus@1.16.0
	object@0.32.2
	once_cell@1.19.0
	opener@0.7.0
	parking_lot@0.12.2
	parking_lot_core@0.9.10
	pathdiff@0.2.1
	percent-encoding@2.3.1
	pest@2.7.10
	pest_derive@2.7.10
	pest_generator@2.7.10
	pest_meta@2.7.10
	phf@0.10.1
	phf@0.11.2
	phf_codegen@0.10.0
	phf_codegen@0.11.2
	phf_generator@0.10.0
	phf_generator@0.11.2
	phf_shared@0.10.0
	phf_shared@0.11.2
	pin-project-internal@1.1.5
	pin-project-lite@0.2.14
	pin-project@1.1.5
	pin-utils@0.1.0
	pkg-config@0.3.30
	ppv-lite86@0.2.17
	precomputed-hash@0.1.1
	predicates-core@1.0.6
	predicates-tree@1.0.9
	predicates@3.1.0
	pretty_assertions@1.4.0
	proc-macro2@1.0.82
	pulldown-cmark-escape@0.10.1
	pulldown-cmark@0.10.3
	quote@1.0.36
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	redox_syscall@0.4.1
	redox_syscall@0.5.1
	regex-automata@0.4.6
	regex-syntax@0.8.3
	regex@1.10.4
	rustc-demangle@0.1.24
	rustix@0.38.34
	ryu@1.0.18
	same-file@1.0.6
	scoped-tls@1.0.1
	scopeguard@1.2.0
	select@0.6.0
	semver@1.0.23
	serde@1.0.201
	serde_derive@1.0.201
	serde_json@1.0.117
	serde_urlencoded@0.7.1
	sha1@0.10.6
	sha2@0.10.8
	shlex@1.3.0
	siphasher@0.3.11
	slab@0.4.9
	smallvec@1.13.2
	socket2@0.5.7
	string_cache@0.8.7
	string_cache_codegen@0.5.2
	strsim@0.11.1
	syn@1.0.109
	syn@2.0.63
	tempfile@3.10.1
	tendril@0.4.3
	terminal_size@0.3.0
	termtree@0.4.1
	thiserror-impl@1.0.60
	thiserror@1.0.60
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	tokio-macros@2.2.0
	tokio-tungstenite@0.21.0
	tokio-util@0.7.11
	tokio@1.37.0
	toml@0.5.11
	topological-sort@0.2.2
	tower-service@0.3.2
	tracing-core@0.1.32
	tracing@0.1.40
	try-lock@0.2.5
	tungstenite@0.21.0
	typenum@1.17.0
	ucd-trie@0.1.6
	unicase@2.7.0
	unicode-bidi@0.3.15
	unicode-ident@1.0.12
	unicode-normalization@0.1.23
	url@2.5.0
	utf8parse@0.2.1
	utf-8@0.7.6
	version_check@0.9.4
	wait-timeout@0.2.0
	walkdir@2.5.0
	want@0.3.1
	warp@0.3.7
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.92
	wasm-bindgen-macro-support@0.2.92
	wasm-bindgen-macro@0.2.92
	wasm-bindgen-shared@0.2.92
	wasm-bindgen@0.2.92
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.8
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.48.5
	windows-targets@0.52.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.5
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.5
	windows_i686_gnullvm@0.52.5
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.5
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.5
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.5
	xml5ever@0.17.0
	yansi@0.5.1
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
LICENSE+=" Apache-2.0 CC0-1.0 ISC MIT Unicode-DFS-2016" # crates
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv ~s390 sparc x86"
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
