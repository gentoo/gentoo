# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line-0.17.0
	adler-1.0.2
	aes-0.6.0
	aes-soft-0.6.4
	aesni-0.10.0
	aho-corasick-0.7.18
	ansi_term-0.12.1
	anyhow-1.0.52
	async-io-1.6.0
	atty-0.2.14
	autocfg-1.0.1
	backtrace-0.3.63
	base64-0.13.0
	bitflags-1.3.2
	block-buffer-0.10.0
	block-buffer-0.9.0
	block-modes-0.7.0
	block-padding-0.2.1
	bstr-0.2.17
	bumpalo-3.8.0
	byteorder-1.4.3
	bytes-1.1.0
	bytesize-1.1.0
	bzip2-0.4.3
	bzip2-sys-0.1.11+1.0.8
	cache-padded-1.2.0
	camino-1.0.5
	cargo-platform-0.1.2
	cargo_metadata-0.14.1
	cbindgen-0.20.0
	cc-1.0.72
	cfg-if-0.1.10
	cfg-if-1.0.0
	charset-0.1.3
	cipher-0.2.5
	clap-2.34.0
	concurrent-queue-1.2.2
	configparser-3.0.0
	console-0.15.0
	core-foundation-0.9.2
	core-foundation-sys-0.8.3
	cpufeatures-0.2.1
	crc32fast-1.3.0
	crossbeam-utils-0.8.5
	crypto-common-0.1.1
	crypto-mac-0.10.1
	derivative-2.2.0
	dialoguer-0.9.0
	digest-0.10.1
	digest-0.9.0
	dirs-4.0.0
	dirs-sys-0.3.6
	encode_unicode-0.3.6
	encoding_rs-0.8.30
	enumflags2-0.6.4
	enumflags2_derive-0.6.4
	env_logger-0.7.1
	fastrand-1.6.0
	fat-macho-0.4.4
	filetime-0.2.15
	flate2-1.0.22
	fnv-1.0.7
	form_urlencoded-1.0.1
	fs-err-2.6.0
	futures-0.3.19
	futures-channel-0.3.19
	futures-core-0.3.19
	futures-executor-0.3.19
	futures-io-0.3.19
	futures-lite-1.12.0
	futures-macro-0.3.19
	futures-sink-0.3.19
	futures-task-0.3.19
	futures-util-0.3.19
	generic-array-0.14.4
	getrandom-0.2.3
	gimli-0.26.1
	glob-0.3.0
	globset-0.4.8
	goblin-0.4.3
	h2-0.3.9
	hashbrown-0.11.2
	heck-0.3.3
	hermit-abi-0.1.19
	hkdf-0.10.0
	hmac-0.10.1
	http-0.2.6
	http-body-0.4.4
	httparse-1.5.1
	httpdate-1.0.2
	human-panic-1.0.3
	humantime-1.3.0
	hyper-0.14.16
	hyper-rustls-0.23.0
	idna-0.2.3
	ignore-0.4.18
	indexmap-1.7.0
	indoc-1.0.3
	instant-0.1.12
	ipnet-2.3.1
	itoa-0.4.8
	itoa-1.0.1
	js-sys-0.3.55
	keyring-1.0.0
	lazy_static-1.4.0
	lddtree-0.2.4
	libc-0.2.112
	log-0.4.14
	mailparse-0.13.7
	matches-0.1.9
	memchr-2.4.1
	mime-0.3.16
	mime_guess-2.0.3
	minijinja-0.10.0
	miniz_oxide-0.4.4
	mio-0.7.14
	miow-0.3.7
	nb-connect-1.2.0
	nix-0.17.0
	ntapi-0.3.6
	num-0.3.1
	num-bigint-0.3.3
	num-complex-0.3.1
	num-integer-0.1.44
	num-iter-0.1.42
	num-rational-0.3.2
	num-traits-0.2.14
	num_cpus-1.13.1
	object-0.27.1
	once_cell-1.9.0
	opaque-debug-0.3.0
	os_type-2.4.0
	parking-2.0.0
	percent-encoding-2.1.0
	pin-project-lite-0.2.8
	pin-utils-0.1.0
	pkg-config-0.3.24
	plain-0.2.3
	platform-info-0.2.0
	polling-2.2.0
	ppv-lite86-0.2.16
	pretty_env_logger-0.4.0
	proc-macro-crate-0.1.5
	proc-macro-crate-1.1.0
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.36
	pyproject-toml-0.3.1
	python-pkginfo-0.5.0
	quick-error-1.2.3
	quote-1.0.14
	quoted_printable-0.4.5
	rand-0.8.4
	rand_chacha-0.3.1
	rand_core-0.6.3
	rand_hc-0.3.1
	redox_syscall-0.2.10
	redox_users-0.4.0
	regex-1.5.4
	regex-syntax-0.6.25
	remove_dir_all-0.5.3
	reqwest-0.11.8
	rfc2047-decoder-0.1.2
	ring-0.16.20
	rpassword-5.0.1
	rustc-demangle-0.1.21
	rustls-0.20.2
	rustls-pemfile-0.2.1
	ryu-1.0.9
	same-file-1.0.6
	scoped-tls-1.0.0
	scroll-0.10.2
	scroll_derive-0.10.5
	sct-0.7.0
	secret-service-2.0.1
	security-framework-2.4.2
	security-framework-sys-2.4.2
	semver-1.0.4
	serde-1.0.132
	serde_derive-1.0.132
	serde_json-1.0.73
	serde_repr-0.1.7
	serde_urlencoded-0.7.0
	sha2-0.10.0
	sha2-0.9.8
	shlex-1.1.0
	slab-0.4.5
	smawk-0.3.1
	socket2-0.4.2
	spin-0.5.2
	static_assertions-1.1.0
	strsim-0.8.0
	structopt-0.3.25
	structopt-derive-0.4.18
	subtle-2.4.1
	syn-1.0.84
	tar-0.4.38
	target-lexicon-0.12.2
	tempfile-3.2.0
	termcolor-1.1.2
	terminal_size-0.1.17
	textwrap-0.11.0
	textwrap-0.14.2
	thiserror-1.0.30
	thiserror-impl-1.0.30
	thread_local-1.1.3
	time-0.1.43
	tinyvec-1.5.1
	tinyvec_macros-0.1.0
	tokio-1.15.0
	tokio-rustls-0.23.2
	tokio-util-0.6.9
	toml-0.5.8
	tower-service-0.3.1
	tracing-0.1.29
	tracing-core-0.1.21
	try-lock-0.2.3
	typenum-1.15.0
	unicase-2.6.0
	unicode-bidi-0.3.7
	unicode-linebreak-0.1.2
	unicode-normalization-0.1.19
	unicode-segmentation-1.8.0
	unicode-width-0.1.9
	unicode-xid-0.2.2
	unindent-0.1.7
	untrusted-0.7.1
	url-2.2.2
	uuid-0.8.2
	vec_map-0.8.2
	version_check-0.9.4
	void-1.0.2
	waker-fn-1.1.0
	walkdir-2.3.2
	want-0.3.0
	wasi-0.10.2+wasi-snapshot-preview1
	wasm-bindgen-0.2.78
	wasm-bindgen-backend-0.2.78
	wasm-bindgen-futures-0.4.28
	wasm-bindgen-macro-0.2.78
	wasm-bindgen-macro-support-0.2.78
	wasm-bindgen-shared-0.2.78
	web-sys-0.3.55
	webpki-0.22.0
	webpki-roots-0.22.2
	wepoll-ffi-0.1.2
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	winreg-0.7.0
	xattr-0.2.2
	zbus-1.9.1
	zbus_macros-1.9.1
	zeroize-1.4.3
	zip-0.5.13
	zvariant-2.10.0
	zvariant_derive-2.10.0"
CRATES_TEST="
	indoc-0.3.6
	indoc-impl-0.3.6
	libc-0.2.107
	libc-0.2.108
	libc-0.2.110
	lock_api-0.4.5
	once_cell-1.8.0
	parking_lot-0.11.2
	parking_lot_core-0.8.5
	paste-0.1.18
	paste-impl-0.1.18
	proc-macro-hack-0.5.19
	proc-macro2-1.0.32
	pyo3-0.15.1
	pyo3-build-config-0.15.1
	pyo3-macros-0.15.1
	pyo3-macros-backend-0.15.1
	quote-1.0.10
	scopeguard-1.1.0
	smallvec-1.7.0
	syn-1.0.81
	syn-1.0.82"
PYTHON_COMPAT=( python3_{8..10} )
inherit cargo distutils-r1 flag-o-matic

DESCRIPTION="Build and publish crates with pyo3, rust-cpython and cffi bindings"
HOMEPAGE="https://maturin.rs/"
SRC_URI="
	https://github.com/PyO3/maturin/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)
	test? ( $(cargo_crate_uris ${CRATES_TEST}) )"

LICENSE="
	0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD ISC MIT MPL-2.0 openssl
	doc? ( CC-BY-4.0 OFL-1.1 )"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/toml[${PYTHON_USEDEP}]"
BDEPEND="
	doc? ( app-text/mdbook )
	test? (
		dev-python/cffi[${PYTHON_USEDEP}]
		dev-python/boltons[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
	)"

QA_FLAGS_IGNORED="usr/bin/${PN}"

python_prepare_all() {
	distutils-r1_python_prepare_all

	# use setup.py only for pure python and handle cargo manually
	sed -i 's/cmdclass.*/packages=["'${PN}'"],/' setup.py || die

	if use test; then
		# used to prevent use of network during tests
		cat > "${T}"/pip.conf <<-EOF || die
			[install]
			no-index = yes
			no-dependencies = yes
		EOF

		# run plain 'python' from eclass rather than auto-detect 'python3.x'
		sed -i 's/"build",/&"-i","python",/' tests/common/integration.rs || die
	fi
}

python_configure_all() {
	filter-flags '-flto*' # undefined references with ring crate

	cargo_src_configure
}

python_compile_all() {
	cargo_src_compile

	use !doc || mdbook build -d html guide || die
}

python_test() {
	local -x PIP_CONFIG_FILE=${T}/pip.conf
	local -x VIRTUALENV_SYSTEM_SITE_PACKAGES=1

	cargo_src_test -- --skip locked_doesnt_build_without_cargo_lock
}

python_install_all() {
	cargo_src_install

	dodoc Changelog.md Readme.md
	use doc && dodoc -r guide/html
}
