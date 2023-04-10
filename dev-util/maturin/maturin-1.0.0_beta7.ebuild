# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler-1.0.2
	ahash-0.7.6
	aho-corasick-0.7.20
	anyhow-1.0.70
	autocfg-1.1.0
	base64-0.13.1
	base64-0.21.0
	bitflags-1.3.2
	block-buffer-0.10.4
	bstr-1.4.0
	bumpalo-3.12.0
	byteorder-1.4.3
	bytes-1.4.0
	bytesize-1.2.0
	bzip2-0.4.4
	bzip2-sys-0.1.11+1.0.8
	cab-0.4.1
	camino-1.1.4
	cargo-config2-0.1.6
	cargo-options-0.6.0
	cargo-platform-0.1.2
	cargo-xwin-0.14.2
	cargo-zigbuild-0.16.5
	cargo_metadata-0.15.3
	cbindgen-0.24.3
	cc-1.0.79
	cfb-0.7.3
	cfg-expr-0.14.0
	cfg-if-1.0.0
	charset-0.1.3
	chumsky-0.9.2
	clap-4.1.10
	clap_complete-4.1.6
	clap_complete_command-0.5.1
	clap_complete_fig-4.1.2
	clap_complete_nushell-0.1.10
	clap_derive-4.1.9
	clap_lex-0.3.3
	cli-table-0.4.7
	concolor-0.0.11
	concolor-query-0.1.0
	configparser-3.0.2
	console-0.15.5
	content_inspector-0.2.4
	core-foundation-0.9.3
	core-foundation-sys-0.8.3
	cpufeatures-0.2.5
	crc32fast-1.3.2
	crossbeam-channel-0.5.7
	crossbeam-deque-0.8.3
	crossbeam-epoch-0.9.14
	crossbeam-utils-0.8.15
	crypto-common-0.1.6
	ctor-0.1.26
	data-encoding-2.3.3
	dialoguer-0.10.3
	diff-0.1.13
	digest-0.10.6
	dirs-4.0.0
	dirs-sys-0.3.7
	dunce-1.0.3
	either-1.8.1
	encode_unicode-0.3.6
	encoding_rs-0.8.32
	errno-0.2.8
	errno-dragonfly-0.1.2
	fastrand-1.9.0
	fat-macho-0.4.6
	filetime-0.2.19
	flate2-1.0.25
	fnv-1.0.7
	foreign-types-0.3.2
	foreign-types-shared-0.1.1
	form_urlencoded-1.1.0
	fs-err-2.9.0
	generic-array-0.14.7
	getrandom-0.2.8
	glob-0.3.1
	globset-0.4.10
	goblin-0.6.1
	hashbrown-0.12.3
	heck-0.4.1
	hermit-abi-0.2.6
	home-0.5.4
	humantime-2.1.0
	humantime-serde-1.1.1
	idna-0.3.0
	ignore-0.4.20
	indexmap-1.9.3
	indicatif-0.17.3
	indoc-2.0.1
	instant-0.1.12
	io-lifetimes-1.0.4
	is-terminal-0.4.2
	itertools-0.10.5
	itoa-1.0.6
	js-sys-0.3.61
	keyring-2.0.1
	lazy_static-1.4.0
	lddtree-0.3.2
	libc-0.2.140
	linux-keyutils-0.2.3
	linux-raw-sys-0.1.4
	lock_api-0.4.9
	log-0.4.17
	lzxd-0.1.4
	mailparse-0.13.8
	matchers-0.1.0
	memchr-2.5.0
	memoffset-0.8.0
	mime-0.3.17
	mime_guess-2.0.4
	minijinja-0.31.0
	minimal-lexical-0.2.1
	miniz_oxide-0.6.2
	msi-0.5.1
	multipart-0.18.0
	native-tls-0.2.11
	nom-7.1.3
	normalize-line-endings-0.3.0
	normpath-1.0.1
	nu-ansi-term-0.46.0
	num_cpus-1.15.0
	number_prefix-0.4.0
	once_cell-1.17.1
	openssl-0.10.48
	openssl-macros-0.1.0
	openssl-probe-0.1.5
	openssl-src-111.25.1+1.1.1t
	openssl-sys-0.9.83
	os_pipe-1.1.2
	os_str_bytes-6.5.0
	output_vt100-0.1.3
	overload-0.1.1
	parking_lot-0.12.1
	parking_lot_core-0.9.6
	path-slash-0.2.1
	pep440_rs-0.3.3
	pep508_rs-0.1.1
	percent-encoding-2.2.0
	pin-project-lite-0.2.9
	pkg-config-0.3.26
	plain-0.2.3
	platform-info-1.0.2
	portable-atomic-0.3.19
	ppv-lite86-0.2.17
	pretty_assertions-1.3.0
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.54
	psm-0.1.21
	pyproject-toml-0.5.1
	python-pkginfo-0.5.5
	quote-1.0.26
	quoted_printable-0.4.7
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.4
	rayon-1.7.0
	rayon-core-1.11.0
	redox_syscall-0.2.16
	redox_users-0.4.3
	regex-1.7.3
	regex-automata-0.1.10
	regex-syntax-0.6.29
	rfc2047-decoder-0.2.2
	ring-0.16.20
	rustc_version-0.4.0
	rustix-0.36.7
	rustls-0.20.8
	rustls-pemfile-1.0.2
	rustversion-1.0.12
	ryu-1.0.13
	same-file-1.0.6
	schannel-0.1.21
	scopeguard-1.1.0
	scroll-0.11.0
	scroll_derive-0.11.0
	sct-0.7.0
	security-framework-2.8.2
	security-framework-sys-2.8.0
	semver-1.0.17
	serde-1.0.155
	serde_derive-1.0.155
	serde_json-1.0.95
	serde_spanned-0.6.1
	sha2-0.10.6
	sharded-slab-0.1.4
	shell-escape-0.1.5
	shell-words-1.1.0
	shlex-1.1.0
	similar-2.2.1
	smallvec-1.10.0
	smawk-0.3.1
	snapbox-0.4.4
	snapbox-macros-0.3.1
	socks-0.3.4
	spin-0.5.2
	stacker-0.1.15
	static_assertions-1.1.0
	strsim-0.10.0
	syn-1.0.109
	tar-0.4.38
	target-lexicon-0.12.6
	tempfile-3.4.0
	termcolor-1.2.0
	terminal_size-0.2.3
	textwrap-0.16.0
	thiserror-1.0.39
	thiserror-impl-1.0.39
	thread_local-1.1.7
	time-0.3.20
	time-core-0.1.0
	time-macros-0.2.8
	tinyvec-1.6.0
	tinyvec_macros-0.1.1
	toml-0.5.11
	toml-0.7.3
	toml_datetime-0.6.1
	toml_edit-0.19.8
	tracing-0.1.37
	tracing-attributes-0.1.23
	tracing-core-0.1.30
	tracing-log-0.1.3
	tracing-serde-0.1.3
	tracing-subscriber-0.3.16
	trycmd-0.14.11
	twox-hash-1.6.3
	typenum-1.16.0
	unicase-2.6.0
	unicode-bidi-0.3.13
	unicode-ident-1.0.8
	unicode-linebreak-0.1.4
	unicode-normalization-0.1.22
	unicode-width-0.1.10
	untrusted-0.7.1
	ureq-2.6.2
	url-2.3.1
	uuid-1.3.0
	valuable-0.1.0
	vcpkg-0.2.15
	version_check-0.9.4
	versions-4.1.0
	wait-timeout-0.2.0
	walkdir-2.3.3
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.84
	wasm-bindgen-backend-0.2.84
	wasm-bindgen-macro-0.2.84
	wasm-bindgen-macro-support-0.2.84
	wasm-bindgen-shared-0.2.84
	web-sys-0.3.61
	webpki-0.22.0
	webpki-roots-0.22.6
	which-4.4.0
	wild-2.1.0
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.42.0
	windows_aarch64_gnullvm-0.42.2
	windows_aarch64_msvc-0.42.2
	windows_i686_gnu-0.42.2
	windows_i686_msvc-0.42.2
	windows_x86_64_gnu-0.42.2
	windows_x86_64_gnullvm-0.42.2
	windows_x86_64_msvc-0.42.2
	winnow-0.4.1
	xattr-0.2.3
	xwin-0.2.12
	yansi-0.5.1
	zeroize-1.5.7
	zip-0.6.4"
# additional crates used by test-crates/* test packages,
# `grep test-crates tests/run.rs` to see which are needed
CRATES_TEST="
	anyhow-1.0.69
	askama-0.11.1
	askama_derive-0.11.2
	askama_escape-0.10.3
	askama_shared-0.12.2
	bincode-1.3.3
	camino-1.1.2
	cc-1.0.73
	cc-1.0.74
	goblin-0.6.0
	indoc-1.0.7
	itoa-1.0.5
	libc-0.2.134
	libc-0.2.137
	mime-0.3.16
	once_cell-1.15.0
	once_cell-1.16.0
	once_cell-1.17.0
	parking_lot_core-0.9.3
	parking_lot_core-0.9.4
	paste-1.0.11
	proc-macro2-1.0.46
	proc-macro2-1.0.47
	proc-macro2-1.0.51
	pyo3-0.18.1
	pyo3-build-config-0.18.1
	pyo3-ffi-0.18.1
	pyo3-macros-0.18.1
	pyo3-macros-backend-0.18.1
	python3-dll-a-0.2.6
	quote-1.0.21
	quote-1.0.23
	ryu-1.0.12
	semver-1.0.16
	serde-1.0.152
	serde_derive-1.0.152
	serde_json-1.0.93
	siphasher-0.3.10
	syn-1.0.102
	syn-1.0.103
	syn-1.0.107
	target-lexicon-0.12.4
	thiserror-1.0.38
	thiserror-impl-1.0.38
	unicode-ident-1.0.5
	unicode-ident-1.0.6
	uniffi-0.23.0
	uniffi_bindgen-0.23.0
	uniffi_build-0.23.0
	uniffi_checksum_derive-0.23.0
	uniffi_core-0.23.0
	uniffi_macros-0.23.0
	uniffi_meta-0.23.0
	uniffi_testing-0.23.0
	unindent-0.1.10
	weedle2-4.0.0
	windows-sys-0.36.1
	windows_aarch64_gnullvm-0.42.0
	windows_aarch64_msvc-0.36.1
	windows_aarch64_msvc-0.42.0
	windows_i686_gnu-0.36.1
	windows_i686_gnu-0.42.0
	windows_i686_msvc-0.36.1
	windows_i686_msvc-0.42.0
	windows_x86_64_gnu-0.36.1
	windows_x86_64_gnu-0.42.0
	windows_x86_64_gnullvm-0.42.0
	windows_x86_64_msvc-0.36.1
	windows_x86_64_msvc-0.42.0"
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )
inherit bash-completion-r1 cargo distutils-r1 edo flag-o-matic toolchain-funcs

DESCRIPTION="Build and publish crates with pyo3, rust-cpython and cffi bindings"
HOMEPAGE="https://www.maturin.rs/"
SRC_URI="
	https://github.com/PyO3/maturin/archive/refs/tags/v${PV/_beta/-beta.}.tar.gz
		-> ${P}.gh.tar.gz
	$(cargo_crate_uris)
	test? ( $(cargo_crate_uris ${CRATES_TEST}) )"
S="${WORKDIR}/${P/_beta/-beta.}"

# note: ring is unused, so SSLeay+openssl licenses can be skipped
LICENSE="
	0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD CC0-1.0 ISC
	MIT MPL-2.0 Unicode-DFS-2016 doc? ( CC-BY-4.0 OFL-1.1 )"
SLOT="0"
# unkeyworded beta for testing
#KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="doc +ssl test"
RESTRICT="!test? ( test )"

RDEPEND="$(python_gen_cond_dep 'dev-python/tomli[${PYTHON_USEDEP}]' 3.{9..10})"
DEPEND="ssl? ( dev-libs/openssl:= )"
BDEPEND="
	dev-python/setuptools-rust[${PYTHON_USEDEP}]
	doc? ( app-text/mdbook )
	test? (
		${RDEPEND}
		$(python_gen_cond_dep 'dev-python/cffi[${PYTHON_USEDEP}]' 'python*')
		dev-python/boltons[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
	)"
RDEPEND+=" ${DEPEND}"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_prepare() {
	distutils-r1_src_prepare

	# used to prevent use of network during tests
	cat > "${T}"/pip.conf <<-EOF || die
		[install]
		no-index = yes
		no-dependencies = yes
	EOF
}

src_configure() {
	filter-lto # TODO: cleanup after bug #893658

	local cargoargs=(
		# TODO: try switching to `--profile gentoo` then should be able to
		# remove all `use debug` checks and --release in tests, but needs:
		# https://github.com/gentoo/gentoo/pull/29510
		$(usev debug '--profile dev')
		--no-default-features
		# like release.yml + native-tls for better platform support than rustls
		--features full,password-storage$(usev ssl ,native-tls)
	)

	export MATURIN_SETUP_ARGS=${cargoargs[*]} # --no-default-features if empty
	export OPENSSL_NO_VENDOR=1
}

python_compile_all() {
	use !doc || mdbook build -d html guide || die

	if ! tc-is-cross-compiler; then
		local maturin=target/$(usex debug{,} release)/maturin
		${maturin} completions bash > "${T}"/${PN} || die
		${maturin} completions fish > "${T}"/${PN}.fish || die
		${maturin} completions zsh > "${T}"/_${PN} || die
	else
		ewarn "shell completion files were skipped due to cross-compilation"
	fi
}

python_test() {
	local -x COLUMNS=100 # what tests/cmd was generated for
	local -x MATURIN_TEST_PYTHON=${EPYTHON}
	local -x PIP_CONFIG_FILE=${T}/pip.conf
	local -x VIRTUALENV_SYSTEM_SITE_PACKAGES=1

	local skip=(
		# avoid need for wasm over a single hello world test
		--skip integration_wasm_hello_world
		# fragile depending on rust version, also wants libpypy*-c.so for pypy
		--skip pyo3_no_extension_module
	)

	edo cargo test $(usev !debug --release) ${MATURIN_SETUP_ARGS} -- "${skip[@]}"
}

python_install_all() {
	dodoc Changelog.md README.md
	use doc && dodoc -r guide/html

	if ! tc-is-cross-compiler; then
		dobashcomp "${T}"/${PN}

		insinto /usr/share/fish/vendor_completions.d
		doins "${T}"/${PN}.fish

		insinto /usr/share/zsh/site-functions
		doins "${T}"/_${PN}
	fi
}
