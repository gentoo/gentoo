# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line-0.17.0
	adler-1.0.2
	aes-0.7.5
	ahash-0.3.8
	ahash-0.7.6
	aho-corasick-0.7.19
	anyhow-1.0.66
	async-io-1.10.0
	async-lock-2.6.0
	atty-0.2.14
	autocfg-1.1.0
	backtrace-0.3.66
	base64-0.13.1
	bitflags-1.3.2
	block-buffer-0.10.3
	block-buffer-0.9.0
	block-modes-0.8.1
	block-padding-0.2.1
	bstr-0.2.17
	bumpalo-3.11.1
	byteorder-1.4.3
	bytes-1.2.1
	bytesize-1.1.0
	bzip2-0.4.3
	bzip2-sys-0.1.11+1.0.8
	cab-0.4.1
	cache-padded-1.2.0
	camino-1.1.1
	cargo-options-0.5.2
	cargo-platform-0.1.2
	cargo-xwin-0.12.0
	cargo-zigbuild-0.14.0
	cargo_metadata-0.15.1
	cbindgen-0.24.3
	cc-1.0.73
	cfb-0.7.3
	cfg-if-1.0.0
	charset-0.1.3
	chumsky-0.8.0
	chunked_transfer-1.4.0
	cipher-0.3.0
	clap-3.2.23
	clap-4.0.18
	clap_complete-4.0.3
	clap_complete_fig-4.0.1
	clap_derive-3.2.18
	clap_derive-4.0.18
	clap_lex-0.2.4
	clap_lex-0.3.0
	cli-table-0.4.7
	combine-4.6.6
	concolor-0.0.8
	concolor-query-0.0.5
	concurrent-queue-1.2.4
	configparser-3.0.2
	console-0.15.2
	const-random-0.1.15
	const-random-macro-0.1.15
	content_inspector-0.2.4
	core-foundation-0.9.3
	core-foundation-sys-0.8.3
	cpufeatures-0.2.5
	crc32fast-1.3.2
	crossbeam-channel-0.5.6
	crossbeam-deque-0.8.2
	crossbeam-epoch-0.9.11
	crossbeam-utils-0.8.12
	crunchy-0.2.2
	crypto-common-0.1.6
	crypto-mac-0.11.1
	ctor-0.1.26
	data-encoding-2.3.2
	derivative-2.2.0
	dialoguer-0.10.2
	diff-0.1.13
	digest-0.10.5
	digest-0.9.0
	dirs-4.0.0
	dirs-sys-0.3.7
	dunce-1.0.3
	either-1.8.0
	encode_unicode-0.3.6
	encoding-0.2.33
	encoding-index-japanese-1.20141219.5
	encoding-index-korean-1.20141219.5
	encoding-index-simpchinese-1.20141219.5
	encoding-index-singlebyte-1.20141219.5
	encoding-index-tradchinese-1.20141219.5
	encoding_index_tests-0.1.4
	encoding_rs-0.8.31
	enumflags2-0.6.4
	enumflags2_derive-0.6.4
	errno-0.2.8
	errno-dragonfly-0.1.2
	event-listener-2.5.3
	fastrand-1.8.0
	fat-macho-0.4.6
	filetime-0.2.17
	flate2-1.0.24
	fnv-1.0.7
	foreign-types-0.3.2
	foreign-types-shared-0.1.1
	form_urlencoded-1.1.0
	fs-err-2.8.1
	futures-0.3.25
	futures-channel-0.3.25
	futures-core-0.3.25
	futures-executor-0.3.25
	futures-io-0.3.25
	futures-lite-1.12.0
	futures-macro-0.3.25
	futures-sink-0.3.25
	futures-task-0.3.25
	futures-util-0.3.25
	generic-array-0.14.6
	getrandom-0.2.8
	gimli-0.26.2
	glob-0.3.0
	globset-0.4.9
	goblin-0.6.0
	hashbrown-0.12.3
	heck-0.4.0
	hermit-abi-0.1.19
	hkdf-0.11.0
	hmac-0.11.0
	human-panic-1.0.3
	humantime-2.1.0
	humantime-serde-1.1.1
	idna-0.3.0
	ignore-0.4.18
	indexmap-1.9.1
	indicatif-0.17.0-rc.6
	indoc-1.0.7
	instant-0.1.12
	io-lifetimes-0.7.4
	itertools-0.10.5
	itoa-1.0.4
	js-sys-0.3.60
	keyring-1.2.0
	lazy_static-1.4.0
	lddtree-0.3.2
	libc-0.2.137
	linux-raw-sys-0.0.46
	lock_api-0.4.9
	log-0.4.17
	lzxd-0.1.4
	mailparse-0.13.8
	matchers-0.1.0
	memchr-2.5.0
	memoffset-0.6.5
	mime-0.3.16
	mime_guess-2.0.4
	minijinja-0.24.0
	miniz_oxide-0.5.4
	msi-0.5.0
	multipart-0.18.0
	native-tls-0.2.10
	nb-connect-1.2.0
	nix-0.22.3
	normalize-line-endings-0.3.0
	normpath-0.3.2
	nu-ansi-term-0.46.0
	num-0.4.0
	num-bigint-0.4.3
	num-complex-0.4.2
	num-integer-0.1.45
	num-iter-0.1.43
	num-rational-0.4.1
	num-traits-0.2.15
	num_cpus-1.13.1
	num_threads-0.1.6
	number_prefix-0.4.0
	object-0.29.0
	once_cell-1.15.0
	opaque-debug-0.3.0
	openssl-0.10.42
	openssl-macros-0.1.0
	openssl-probe-0.1.5
	openssl-src-111.22.0+1.1.1q
	openssl-sys-0.9.77
	os_pipe-1.1.1
	os_str_bytes-6.3.1
	os_type-2.6.0
	output_vt100-0.1.3
	overload-0.1.1
	parking-2.0.0
	parking_lot-0.12.1
	parking_lot_core-0.9.3
	path-slash-0.2.1
	pep440-0.2.0
	percent-encoding-2.2.0
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	pkg-config-0.3.26
	plain-0.2.3
	platform-info-1.0.0
	polling-2.4.0
	ppv-lite86-0.2.16
	pretty_assertions-1.3.0
	proc-macro-crate-0.1.5
	proc-macro-crate-1.2.1
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro-hack-0.5.19
	proc-macro2-1.0.47
	pyproject-toml-0.3.1
	python-pkginfo-0.5.5
	quote-1.0.21
	quoted_printable-0.4.5
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.4
	rayon-1.5.3
	rayon-core-1.9.3
	redox_syscall-0.2.16
	redox_users-0.4.3
	regex-1.6.0
	regex-automata-0.1.10
	regex-syntax-0.6.27
	remove_dir_all-0.5.3
	rfc2047-decoder-0.2.0
	ring-0.16.20
	rpassword-7.1.0
	rustc-demangle-0.1.21
	rustc_version-0.4.0
	rustix-0.35.12
	rustls-0.20.7
	rustversion-1.0.9
	ryu-1.0.11
	same-file-1.0.6
	schannel-0.1.20
	scoped-tls-1.0.0
	scopeguard-1.1.0
	scroll-0.11.0
	scroll_derive-0.11.0
	sct-0.7.0
	secret-service-2.0.2
	security-framework-2.7.0
	security-framework-sys-2.6.1
	semver-1.0.14
	serde-1.0.147
	serde_derive-1.0.147
	serde_json-1.0.87
	serde_repr-0.1.9
	sha2-0.10.6
	sha2-0.9.9
	sharded-slab-0.1.4
	shlex-1.1.0
	similar-2.2.0
	slab-0.4.7
	smallvec-1.10.0
	smawk-0.3.1
	snapbox-0.4.0
	snapbox-macros-0.3.1
	socket2-0.4.7
	socks-0.3.4
	spin-0.5.2
	static_assertions-1.1.0
	strsim-0.10.0
	subtle-2.4.1
	syn-1.0.103
	tar-0.4.38
	target-lexicon-0.12.4
	tempfile-3.3.0
	termcolor-1.1.3
	terminal_size-0.1.17
	terminal_size-0.2.1
	textwrap-0.16.0
	thiserror-1.0.37
	thiserror-impl-1.0.37
	thread_local-1.1.4
	time-0.3.16
	time-core-0.1.0
	time-macros-0.2.5
	tiny-keccak-2.0.2
	tinyvec-1.6.0
	tinyvec_macros-0.1.0
	toml-0.5.9
	toml_datetime-0.5.0
	toml_edit-0.15.0
	tracing-0.1.37
	tracing-attributes-0.1.23
	tracing-core-0.1.30
	tracing-log-0.1.3
	tracing-serde-0.1.3
	tracing-subscriber-0.3.16
	trycmd-0.14.1
	twox-hash-1.6.3
	typenum-1.15.0
	unicase-2.6.0
	unicode-bidi-0.3.8
	unicode-ident-1.0.5
	unicode-linebreak-0.1.4
	unicode-normalization-0.1.22
	unicode-width-0.1.10
	untrusted-0.7.1
	ureq-2.5.0
	url-2.3.1
	uuid-0.8.2
	uuid-1.2.1
	valuable-0.1.0
	vcpkg-0.2.15
	version_check-0.9.4
	wait-timeout-0.2.0
	waker-fn-1.1.0
	walkdir-2.3.2
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.83
	wasm-bindgen-backend-0.2.83
	wasm-bindgen-macro-0.2.83
	wasm-bindgen-macro-support-0.2.83
	wasm-bindgen-shared-0.2.83
	web-sys-0.3.60
	webpki-0.22.0
	webpki-roots-0.22.5
	wepoll-ffi-0.1.2
	which-4.3.0
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.36.1
	windows_aarch64_msvc-0.36.1
	windows_i686_gnu-0.36.1
	windows_i686_msvc-0.36.1
	windows_x86_64_gnu-0.36.1
	windows_x86_64_msvc-0.36.1
	xattr-0.2.3
	xwin-0.2.5
	yansi-0.5.1
	zbus-1.9.3
	zbus_macros-1.9.3
	zip-0.6.3
	zvariant-2.10.0
	zvariant_derive-2.10.0"
CRATES_TEST="
	libc-0.2.134
	parking_lot_core-0.9.4
	proc-macro2-1.0.46
	pyo3-0.17.2
	pyo3-build-config-0.17.2
	pyo3-ffi-0.17.2
	pyo3-macros-0.17.2
	pyo3-macros-backend-0.17.2
	python3-dll-a-0.2.6
	syn-1.0.102
	unindent-0.1.10
	windows-sys-0.42.0
	windows_aarch64_gnullvm-0.42.0
	windows_aarch64_msvc-0.42.0
	windows_i686_gnu-0.42.0
	windows_i686_msvc-0.42.0
	windows_x86_64_gnu-0.42.0
	windows_x86_64_gnullvm-0.42.0
	windows_x86_64_msvc-0.42.0"
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )
inherit cargo distutils-r1 flag-o-matic

DESCRIPTION="Build and publish crates with pyo3, rust-cpython and cffi bindings"
HOMEPAGE="https://maturin.rs/"
SRC_URI="
	https://github.com/PyO3/maturin/archive/refs/tags/v${PV/_beta/-beta.}.tar.gz -> ${P}.gh.tar.gz
	$(cargo_crate_uris)
	test? ( $(cargo_crate_uris ${CRATES_TEST}) )"
S="${WORKDIR}/${P/_beta/-beta.}"

LICENSE="
	0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD
	CC0-1.0 ISC MIT MPL-2.0 Unicode-DFS-2016 openssl
	doc? ( CC-BY-4.0 OFL-1.1 )"
SLOT="0"
# unkeyworded beta for testing upcoming 0.14.0
#KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/tomli[${PYTHON_USEDEP}]
	' 3.{8..10} pypy3)"
BDEPEND="
	>=dev-python/setuptools-rust-1.4[${PYTHON_USEDEP}]
	doc? ( app-text/mdbook )
	test? (
		${RDEPEND}
		$(python_gen_cond_dep '
			dev-python/cffi[${PYTHON_USEDEP}]
		' 'python*')
		dev-python/boltons[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
	)"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_prepare() {
	distutils-r1_src_prepare

	# used to prevent use of network during tests
	cat > "${T}"/pip.conf <<-EOF || die
		[install]
		no-index = yes
		no-dependencies = yes
	EOF

	# TODO: package-agnostic way to handle IUSE=debug with setuptools-rust?
	use !debug || sed -i "s/^cargo_args = \[/&'--profile','dev',/" setup.py || die

	# setup.py handles most for non-tests, but ensure rustls is disabled except
	# on arches where ring crate should work (keep in sync below, bug #859577)
	if use !amd64 && use !x86 && use !arm64 && use !arm; then
		sed -i '/^if platform.machine/s/^if/if True or/' setup.py || die
	fi
}

src_configure() {
	filter-lto # undefined references with ring crate

	if use !amd64 && use !x86 && use !arm64 && use !arm; then
		local myfeatures=( upload log human-panic )
		cargo_src_configure --no-default-features
	fi
}

python_compile_all() {
	use !doc || mdbook build -d html guide || die
}

python_test() {
	local -x MATURIN_TEST_PYTHON=${EPYTHON}
	local -x PIP_CONFIG_FILE=${T}/pip.conf
	local -x VIRTUALENV_SYSTEM_SITE_PACKAGES=1

	local skip=(
		--skip locked_doesnt_build_without_cargo_lock
		# relies on 80-chars terminal output but ignores exported COLUMNS=80
		--skip cli_tests
		# avoid need for wasm over a single hello world test
		--skip integration_wasm_hello_world
		# fragile depending on rust version, also wants libpypy*-c.so for pypy
		--skip pyo3_no_extension_module
	)

	cargo_src_test -- "${skip[@]}"
}

python_install_all() {
	dodoc Changelog.md Readme.md
	use doc && dodoc -r guide/html
}
