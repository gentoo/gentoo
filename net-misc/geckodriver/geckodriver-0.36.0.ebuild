# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.24.2
	adler2@2.0.0
	ahash@0.7.8
	aho-corasick@1.1.3
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstyle@1.0.10
	anyhow@1.0.96
	arbitrary@1.4.1
	autocfg@1.4.0
	backtrace@0.3.74
	base64@0.21.7
	base64@0.22.1
	bitflags@2.8.0
	block-buffer@0.10.4
	bumpalo@3.17.0
	bytes@1.10.0
	cc@1.2.15
	cfg-if@1.0.0
	chrono@0.4.39
	clap@4.5.31
	clap_builder@4.5.31
	clap_lex@0.7.4
	cookie@0.16.2
	core-foundation-sys@0.8.7
	core_maths@0.1.1
	cpufeatures@0.2.17
	crc32fast@1.4.2
	crossbeam-utils@0.8.21
	crypto-common@0.1.6
	deranged@0.3.11
	derive_arbitrary@1.4.1
	digest@0.10.7
	dirs-sys@0.3.7
	dirs@4.0.0
	displaydoc@0.2.5
	equivalent@1.0.2
	errno@0.3.10
	fastrand@2.3.0
	flate2@1.1.0
	fnv@1.0.7
	form_urlencoded@1.2.1
	futures-channel@0.3.31
	futures-core@0.3.31
	futures-io@0.3.31
	futures-macro@0.3.31
	futures-sink@0.3.31
	futures-task@0.3.31
	futures-util@0.3.31
	generic-array@0.14.7
	getrandom@0.2.15
	getrandom@0.3.1
	gimli@0.31.1
	h2@0.3.26
	hashbrown@0.12.3
	hashbrown@0.15.2
	headers-core@0.2.0
	headers@0.3.9
	hermit-abi@0.3.9
	http-body@0.4.6
	http@0.2.12
	httparse@1.10.0
	httpdate@1.0.3
	hyper@0.14.32
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
	icu_segmenter@1.5.0
	icu_segmenter_data@1.5.0
	idna@1.0.3
	idna_adapter@1.2.0
	indexmap@1.9.3
	indexmap@2.7.1
	itoa@1.0.14
	js-sys@0.3.77
	lazy_static@1.5.0
	libc@0.2.170
	libm@0.2.11
	libredox@0.1.3
	linked-hash-map@0.5.6
	linux-raw-sys@0.4.15
	litemap@0.7.4
	log@0.4.26
	marionette@0.7.0
	memchr@2.7.4
	mime@0.3.17
	mime_guess@2.0.5
	miniz_oxide@0.8.5
	mio@0.8.11
	mozdevice@0.5.4
	mozilla-central-workspace-hack@0.1.0
	mozprofile@0.9.4
	mozrunner@0.15.4
	mozversion@0.5.3
	num-conv@0.1.0
	num-integer@0.1.46
	num-traits@0.2.19
	num_cpus@1.16.0
	object@0.36.7
	once_cell@1.20.3
	percent-encoding@2.3.1
	pin-project-internal@1.1.9
	pin-project-lite@0.2.16
	pin-project@1.1.9
	pin-utils@0.1.0
	plist@1.7.0
	powerfmt@0.2.0
	proc-macro2@1.0.93
	quick-xml@0.32.0
	quote@1.0.38
	redox_users@0.4.6
	regex-automata@0.4.9
	regex-syntax@0.8.5
	regex@1.11.1
	rust-ini@0.10.3
	rustc-demangle@0.1.24
	rustix@0.38.44
	rustversion@1.0.19
	ryu@1.0.19
	same-file@1.0.6
	scoped-tls@1.0.1
	semver@1.0.25
	serde@1.0.218
	serde_derive@1.0.218
	serde_json@1.0.139
	serde_repr@0.1.19
	serde_urlencoded@0.7.1
	sha1@0.10.6
	shlex@1.3.0
	slab@0.4.9
	smallvec@1.14.0
	socket2@0.5.8
	stable_deref_trait@1.2.0
	strsim@0.11.1
	syn@2.0.98
	synstructure@0.13.1
	tempfile@3.17.1
	terminal_size@0.4.1
	thiserror-impl@1.0.69
	thiserror-impl@2.0.11
	thiserror@1.0.69
	thiserror@2.0.11
	time-core@0.1.2
	time-macros@0.2.19
	time@0.3.37
	tinystr@0.7.6
	tokio-stream@0.1.17
	tokio-util@0.7.13
	tokio@1.38.1
	tower-service@0.3.3
	tracing-attributes@0.1.28
	tracing-core@0.1.33
	tracing@0.1.41
	try-lock@0.2.5
	typenum@1.18.0
	unicase@2.8.1
	unicode-ident@1.0.17
	unix_path@1.0.1
	unix_str@1.0.0
	url@2.5.4
	utf16_iter@1.0.5
	utf8_iter@1.0.4
	uuid@1.14.0
	version_check@0.9.5
	walkdir@2.5.0
	want@0.3.1
	warp@0.3.7
	wasi@0.11.0+wasi-snapshot-preview1
	wasi@0.13.3+wasi-0.2.2
	wasm-bindgen-backend@0.2.100
	wasm-bindgen-macro-support@0.2.100
	wasm-bindgen-macro@0.2.100
	wasm-bindgen-shared@0.2.100
	wasm-bindgen@0.2.100
	webdriver@0.52.0
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
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.6
	winreg@0.10.1
	wit-bindgen-rt@0.33.0
	write16@1.0.0
	writeable@0.5.5
	yaml-rust@0.4.5
	yoke-derive@0.7.5
	yoke@0.7.5
	zerofrom-derive@0.1.5
	zerofrom@0.1.5
	zerovec-derive@0.10.3
	zerovec@0.10.4
	zip@2.2.2
"

inherit cargo

DESCRIPTION="Proxy for using WebDriver clients to interact with Gecko-based browsers"
HOMEPAGE="https://firefox-source-docs.mozilla.org/testing/geckodriver/ https://github.com/mozilla/geckodriver"
SRC_URI="https://github.com/mozilla/geckodriver/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}"

LICENSE="MPL-2.0"
# Dependent crate licenses
LICENSE+="
	MIT MPL-2.0 Unicode-3.0
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc64 ~riscv x86"

IUSE="unchained"

RDEPEND="!www-client/firefox[geckodriver(-)]"

pkg_setup() {
	QA_FLAGS_IGNORED="/usr/$(get_libdir)/firefox/geckodriver"
	rust_pkg_setup
}

src_prepare() {
	# Apply the unchained patch from https://github.com/rafiibrahim8/geckodriver-unchained -
	# makes geckodriver available on Gecko-based non-Firefox browsers, e.g. Librewolf.
	# bgo#930568
	use unchained && eapply "${FILESDIR}"/geckodriver-0.34.0-firefox-125.0-unchained.patch

	default
}

src_install() {
	einstalldocs

	mkdir -p "${D}"/usr/$(get_libdir)/firefox || die "Failed to create /usr/lib*/firefox directory."
	exeinto /usr/$(get_libdir)/firefox
	doexe "$(cargo_target_dir)"/geckodriver
	dosym -r /usr/$(get_libdir)/firefox/geckodriver /usr/bin/geckodriver
}
