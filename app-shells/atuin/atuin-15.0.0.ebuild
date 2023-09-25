# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aead-0.5.2
	ahash-0.7.6
	aho-corasick-0.7.19
	android_system_properties-0.1.5
	anyhow-1.0.64
	argon2-0.5.0
	async-trait-0.1.58
	atoi-1.0.0
	atty-0.2.14
	autocfg-1.1.0
	axum-0.6.4
	axum-core-0.3.2
	base64-0.13.1
	base64-0.21.0
	base64ct-1.6.0
	beef-0.5.2
	bitflags-1.3.2
	blake2-0.10.6
	block-buffer-0.10.3
	bumpalo-3.12.0
	byteorder-1.4.3
	bytes-1.2.1
	cassowary-0.3.0
	cc-1.0.73
	cfg-if-1.0.0
	chrono-0.4.22
	chronoutil-0.2.3
	cipher-0.4.4
	clap-4.1.14
	clap_builder-4.1.14
	clap_complete-4.2.0
	clap_derive-4.1.14
	clap_lex-0.4.1
	colored-2.0.0
	config-0.13.2
	console-0.15.5
	core-foundation-0.9.3
	core-foundation-sys-0.8.3
	cpufeatures-0.2.5
	crc-3.0.0
	crc-catalog-2.1.0
	crossbeam-channel-0.5.8
	crossbeam-queue-0.3.6
	crossbeam-utils-0.8.11
	crossterm-0.26.1
	crossterm_winapi-0.9.0
	crypto-common-0.1.6
	digest-0.10.5
	directories-4.0.1
	dirs-4.0.0
	dirs-sys-0.3.7
	dotenvy-0.15.3
	ed25519-1.5.2
	either-1.8.0
	encode_unicode-0.3.6
	encoding_rs-0.8.31
	env_logger-0.10.0
	errno-0.3.1
	errno-dragonfly-0.1.2
	event-listener-2.5.3
	eyre-0.6.8
	filedescriptor-0.8.2
	flume-0.10.14
	fnv-1.0.7
	form_urlencoded-1.1.0
	fs-err-2.9.0
	futures-channel-0.3.24
	futures-core-0.3.24
	futures-executor-0.3.24
	futures-intrusive-0.4.0
	futures-macro-0.3.24
	futures-sink-0.3.24
	futures-task-0.3.24
	futures-util-0.3.24
	fuzzy-matcher-0.3.7
	generic-array-0.14.6
	getrandom-0.2.7
	h2-0.3.14
	hashbrown-0.12.3
	hashlink-0.8.0
	heck-0.4.0
	hermit-abi-0.1.19
	hermit-abi-0.3.1
	hex-0.4.3
	hkdf-0.12.3
	hmac-0.12.1
	http-0.2.8
	http-body-0.4.5
	http-range-header-0.3.0
	httparse-1.8.0
	httpdate-1.0.2
	humantime-2.1.0
	hyper-0.14.20
	hyper-rustls-0.23.0
	iana-time-zone-0.1.48
	idna-0.3.0
	indenter-0.3.3
	indexmap-1.9.1
	indicatif-0.17.3
	inout-0.1.3
	instant-0.1.12
	interim-0.1.0
	io-lifetimes-1.0.10
	ipnet-2.5.0
	is-terminal-0.4.7
	itertools-0.10.5
	itoa-1.0.3
	js-sys-0.3.60
	lazy_static-1.4.0
	libc-0.2.141
	libsodium-sys-0.2.7
	libsqlite3-sys-0.24.2
	linux-raw-sys-0.3.1
	lock_api-0.4.8
	log-0.4.17
	logos-0.12.1
	logos-derive-0.12.1
	matchers-0.1.0
	matchit-0.7.0
	md-5-0.10.4
	memchr-2.5.0
	mime-0.3.16
	minimal-lexical-0.2.1
	minspan-0.1.1
	mio-0.8.4
	nom-7.1.1
	nu-ansi-term-0.46.0
	num-0.2.1
	num-bigint-0.2.6
	num-complex-0.2.4
	num-integer-0.1.45
	num-iter-0.1.43
	num-rational-0.2.4
	num-traits-0.2.15
	num_cpus-1.13.1
	number_prefix-0.4.0
	once_cell-1.17.1
	opaque-debug-0.3.0
	openssl-probe-0.1.5
	overload-0.1.1
	parking_lot-0.11.2
	parking_lot-0.12.1
	parking_lot_core-0.8.5
	parking_lot_core-0.9.3
	parse_duration-2.1.1
	password-hash-0.5.0
	paste-1.0.9
	pathdiff-0.2.1
	pbkdf2-0.11.0
	percent-encoding-2.2.0
	pin-project-1.0.12
	pin-project-internal-1.0.12
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	pkg-config-0.3.25
	poly1305-0.8.0
	portable-atomic-0.3.19
	ppv-lite86-0.2.16
	proc-macro2-1.0.56
	quote-1.0.26
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.4
	redox_syscall-0.2.16
	redox_users-0.4.3
	regex-1.7.2
	regex-automata-0.1.10
	regex-syntax-0.6.29
	reqwest-0.11.12
	ring-0.16.20
	rmp-0.8.11
	rmp-serde-1.1.1
	rpassword-7.2.0
	rtoolbox-0.0.1
	runtime-format-0.1.3
	rustc-hash-1.1.0
	rustix-0.37.11
	rustls-0.20.6
	rustls-native-certs-0.6.2
	rustls-pemfile-1.0.1
	rustversion-1.0.11
	ryu-1.0.11
	salsa20-0.10.2
	same-file-1.0.6
	schannel-0.1.20
	scopeguard-1.1.0
	sct-0.7.0
	security-framework-2.7.0
	security-framework-sys-2.6.1
	semver-1.0.14
	serde-1.0.145
	serde_derive-1.0.145
	serde_json-1.0.86
	serde_path_to_error-0.1.9
	serde_regex-1.1.0
	serde_urlencoded-0.7.1
	sha1-0.10.4
	sha2-0.10.6
	sharded-slab-0.1.4
	shellexpand-2.1.2
	signal-hook-0.3.15
	signal-hook-mio-0.2.3
	signal-hook-registry-1.4.0
	signature-1.6.1
	slab-0.4.7
	smallvec-1.9.0
	socket2-0.4.7
	sodiumoxide-0.2.7
	spin-0.5.2
	spin-0.9.8
	sql-builder-3.1.1
	sqlformat-0.2.0
	sqlx-0.6.2
	sqlx-core-0.6.2
	sqlx-macros-0.6.2
	sqlx-rt-0.6.2
	stringprep-0.1.2
	strsim-0.10.0
	subtle-2.4.1
	syn-1.0.99
	syn-2.0.14
	sync_wrapper-0.1.1
	termcolor-1.1.3
	thiserror-1.0.38
	thiserror-impl-1.0.38
	thread_local-1.1.7
	time-0.1.44
	tiny-bip39-1.0.0
	tinyvec-1.6.0
	tinyvec_macros-0.1.0
	tokio-1.25.0
	tokio-macros-1.8.0
	tokio-rustls-0.23.4
	tokio-stream-0.1.9
	tokio-util-0.7.4
	toml-0.5.9
	tower-0.4.13
	tower-http-0.3.4
	tower-layer-0.3.2
	tower-service-0.3.2
	tracing-0.1.37
	tracing-attributes-0.1.23
	tracing-core-0.1.30
	tracing-subscriber-0.3.16
	try-lock-0.2.3
	typenum-1.15.0
	unicode-bidi-0.3.8
	unicode-ident-1.0.3
	unicode-normalization-0.1.21
	unicode-segmentation-1.10.1
	unicode-width-0.1.10
	unicode_categories-0.1.1
	universal-hash-0.5.0
	untrusted-0.7.1
	url-2.3.1
	urlencoding-2.1.2
	uuid-1.2.1
	vcpkg-0.2.15
	version_check-0.9.4
	walkdir-2.3.2
	want-0.3.0
	wasi-0.10.0+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.83
	wasm-bindgen-backend-0.2.83
	wasm-bindgen-futures-0.4.33
	wasm-bindgen-macro-0.2.83
	wasm-bindgen-macro-support-0.2.83
	wasm-bindgen-shared-0.2.83
	web-sys-0.3.60
	webpki-0.22.0
	webpki-roots-0.22.4
	whoami-1.2.3
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.36.1
	windows-sys-0.42.0
	windows-sys-0.48.0
	windows-targets-0.48.0
	windows_aarch64_gnullvm-0.42.0
	windows_aarch64_gnullvm-0.48.0
	windows_aarch64_msvc-0.36.1
	windows_aarch64_msvc-0.42.0
	windows_aarch64_msvc-0.48.0
	windows_i686_gnu-0.36.1
	windows_i686_gnu-0.42.0
	windows_i686_gnu-0.48.0
	windows_i686_msvc-0.36.1
	windows_i686_msvc-0.42.0
	windows_i686_msvc-0.48.0
	windows_x86_64_gnu-0.36.1
	windows_x86_64_gnu-0.42.0
	windows_x86_64_gnu-0.48.0
	windows_x86_64_gnullvm-0.42.0
	windows_x86_64_gnullvm-0.48.0
	windows_x86_64_msvc-0.36.1
	windows_x86_64_msvc-0.42.0
	windows_x86_64_msvc-0.48.0
	winreg-0.10.1
	xsalsa20poly1305-0.9.0
	zeroize-1.6.0
	zeroize_derive-1.4.2
"

inherit cargo shell-completion

DESCRIPTION="Shell history manager supporting encrypted synchronisation"
HOMEPAGE="https://github.com/ellie/atuin"
SRC_URI="
	https://github.com/ellie/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)
"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 ISC MIT MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND=">=virtual/rust-1.67.1"

QA_FLAGS_IGNORED="usr/bin/${PN}"

DOCS=(
	README.md
	CHANGELOG.md
	docs/docs
)

src_compile() {
	cargo_src_compile

	ATUIN_BIN="target/$(usex debug debug release)/${PN}"

	# Prepare shell completion generation
	mkdir completions || die
	local shell
	for shell in bash fish zsh; do
		"${ATUIN_BIN}" gen-completions \
					 -s ${shell} \
					 -o completions \
			|| die
	done
}

src_install() {
	cargo install --path "${PN}"

	exeinto "/usr/bin"
	doexe "${ATUIN_BIN}"

	dodoc -r "${DOCS[@]}"

	newbashcomp "completions/${PN}.bash" "${PN}"
	dozshcomp "completions/_${PN}"
	dofishcomp "completions/${PN}.fish"
}
