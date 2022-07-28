# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This is a beta for additional arch support (ppc, sparc64, mips),
# feel free to keyword as needed if 0.13.1 does not work.

CRATES="
	addr2line-0.17.0
	adler-1.0.2
	aes-0.7.5
	aho-corasick-0.7.18
	anyhow-1.0.58
	async-io-1.7.0
	atty-0.2.14
	autocfg-1.1.0
	backtrace-0.3.66
	base64-0.13.0
	bitflags-1.3.2
	block-buffer-0.10.2
	block-buffer-0.9.0
	block-modes-0.8.1
	block-padding-0.2.1
	bstr-0.2.17
	bumpalo-3.10.0
	byteorder-1.4.3
	bytes-1.2.0
	bytesize-1.1.0
	bzip2-0.4.3
	bzip2-sys-0.1.11+1.0.8
	cab-0.4.1
	cache-padded-1.2.0
	camino-1.0.9
	cargo-options-0.3.1
	cargo-platform-0.1.2
	cargo-xwin-0.10.2
	cargo-zigbuild-0.11.3
	cargo_metadata-0.15.0
	cbindgen-0.24.3
	cc-1.0.73
	cfb-0.7.3
	cfg-if-1.0.0
	charset-0.1.3
	chunked_transfer-1.4.0
	cipher-0.3.0
	clap-3.2.15
	clap_complete-3.2.3
	clap_complete_fig-3.2.4
	clap_derive-3.2.15
	clap_lex-0.2.4
	cli-table-0.4.7
	combine-4.6.4
	concurrent-queue-1.2.4
	configparser-3.0.0
	console-0.15.1
	core-foundation-0.9.3
	core-foundation-sys-0.8.3
	cpufeatures-0.2.2
	crc32fast-1.3.2
	crossbeam-channel-0.5.6
	crossbeam-deque-0.8.2
	crossbeam-epoch-0.9.10
	crossbeam-utils-0.8.11
	crypto-common-0.1.6
	crypto-mac-0.11.1
	data-encoding-2.3.2
	derivative-2.2.0
	dialoguer-0.10.1
	digest-0.10.3
	digest-0.9.0
	dirs-4.0.0
	dirs-sys-0.3.7
	dunce-1.0.2
	either-1.7.0
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
	env_logger-0.7.1
	fastrand-1.8.0
	fat-macho-0.4.5
	filetime-0.2.17
	flate2-1.0.24
	fnv-1.0.7
	foreign-types-0.3.2
	foreign-types-shared-0.1.1
	form_urlencoded-1.0.1
	fs-err-2.7.0
	futures-0.3.21
	futures-channel-0.3.21
	futures-core-0.3.21
	futures-executor-0.3.21
	futures-io-0.3.21
	futures-lite-1.12.0
	futures-macro-0.3.21
	futures-sink-0.3.21
	futures-task-0.3.21
	futures-util-0.3.21
	generic-array-0.14.5
	getrandom-0.2.7
	gimli-0.26.2
	glob-0.3.0
	globset-0.4.9
	goblin-0.5.3
	hashbrown-0.12.3
	heck-0.4.0
	hermit-abi-0.1.19
	hkdf-0.11.0
	hmac-0.11.0
	human-panic-1.0.3
	humantime-1.3.0
	idna-0.2.3
	ignore-0.4.18
	indexmap-1.9.1
	indicatif-0.17.0-rc.6
	indoc-1.0.6
	instant-0.1.12
	itertools-0.10.3
	itoa-1.0.2
	js-sys-0.3.59
	keyring-1.2.0
	lazy_static-1.4.0
	lddtree-0.2.9
	libc-0.2.126
	lock_api-0.4.7
	log-0.4.17
	lzxd-0.1.4
	mailparse-0.13.8
	matchers-0.1.0
	matches-0.1.9
	memchr-2.5.0
	memoffset-0.6.5
	mime-0.3.16
	mime_guess-2.0.4
	minijinja-0.17.0
	miniz_oxide-0.5.3
	msi-0.5.0
	multipart-0.18.0
	native-tls-0.2.10
	nb-connect-1.2.0
	nix-0.22.3
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
	once_cell-1.13.0
	opaque-debug-0.3.0
	openssl-0.10.41
	openssl-macros-0.1.0
	openssl-probe-0.1.5
	openssl-src-111.22.0+1.1.1q
	openssl-sys-0.9.75
	os_str_bytes-6.2.0
	os_type-2.4.0
	parking-2.0.0
	parking_lot-0.12.1
	parking_lot_core-0.9.3
	path-slash-0.2.0
	percent-encoding-2.1.0
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	pkg-config-0.3.25
	plain-0.2.3
	platform-info-0.2.0
	polling-2.2.0
	ppv-lite86-0.2.16
	pretty_env_logger-0.4.0
	proc-macro-crate-0.1.5
	proc-macro-crate-1.1.3
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.42
	pyproject-toml-0.3.1
	python-pkginfo-0.5.4
	quick-error-1.2.3
	quote-1.0.20
	quoted_printable-0.4.5
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.3
	rayon-1.5.3
	rayon-core-1.9.3
	redox_syscall-0.2.16
	redox_users-0.4.3
	regex-1.6.0
	regex-automata-0.1.10
	regex-syntax-0.6.27
	remove_dir_all-0.5.3
	rfc2047-decoder-0.1.2
	ring-0.16.20
	rpassword-7.0.0
	rustc-demangle-0.1.21
	rustc_version-0.4.0
	rustls-0.20.6
	ryu-1.0.10
	same-file-1.0.6
	schannel-0.1.20
	scoped-tls-1.0.0
	scopeguard-1.1.0
	scroll-0.11.0
	scroll_derive-0.11.0
	sct-0.7.0
	secret-service-2.0.2
	security-framework-2.6.1
	security-framework-sys-2.6.1
	semver-1.0.12
	serde-1.0.140
	serde_derive-1.0.140
	serde_json-1.0.82
	serde_repr-0.1.8
	sha2-0.10.2
	sha2-0.9.9
	sharded-slab-0.1.4
	slab-0.4.7
	smallvec-1.9.0
	smawk-0.3.1
	socket2-0.4.4
	socks-0.3.4
	spin-0.5.2
	static_assertions-1.1.0
	strsim-0.10.0
	subtle-2.4.1
	syn-1.0.98
	tar-0.4.38
	target-lexicon-0.12.4
	tempfile-3.3.0
	termcolor-1.1.3
	terminal_size-0.1.17
	textwrap-0.15.0
	thiserror-1.0.31
	thiserror-impl-1.0.31
	thread_local-1.1.4
	time-0.3.11
	time-macros-0.2.4
	tinyvec-1.6.0
	tinyvec_macros-0.1.0
	toml-0.5.9
	toml_edit-0.14.4
	tracing-0.1.35
	tracing-attributes-0.1.22
	tracing-core-0.1.28
	tracing-serde-0.1.3
	tracing-subscriber-0.3.15
	twox-hash-1.6.3
	typenum-1.15.0
	unicase-2.6.0
	unicode-bidi-0.3.8
	unicode-ident-1.0.2
	unicode-linebreak-0.1.2
	unicode-normalization-0.1.21
	unicode-width-0.1.9
	untrusted-0.7.1
	ureq-2.5.0
	url-2.2.2
	uuid-0.8.2
	uuid-1.1.2
	valuable-0.1.0
	vcpkg-0.2.15
	version_check-0.9.4
	waker-fn-1.1.0
	walkdir-2.3.2
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.82
	wasm-bindgen-backend-0.2.82
	wasm-bindgen-macro-0.2.82
	wasm-bindgen-macro-support-0.2.82
	wasm-bindgen-shared-0.2.82
	web-sys-0.3.59
	webpki-0.22.0
	webpki-roots-0.22.4
	wepoll-ffi-0.1.2
	which-4.2.5
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
	zbus-1.9.3
	zbus_macros-1.9.3
	zip-0.6.2
	zvariant-2.10.0
	zvariant_derive-2.10.0"
CRATES_TEST="
	libc-0.2.119
	libc-0.2.125
	once_cell-1.10.0
	once_cell-1.11.0
	once_cell-1.12.0
	once_cell-1.9.0
	parking_lot-0.12.0
	proc-macro2-1.0.38
	proc-macro2-1.0.39
	pyo3-0.16.5
	pyo3-build-config-0.16.0
	pyo3-build-config-0.16.5
	pyo3-ffi-0.16.0
	pyo3-ffi-0.16.5
	pyo3-macros-0.16.5
	pyo3-macros-backend-0.16.5
	python3-dll-a-0.2.3
	quote-1.0.18
	redox_syscall-0.2.13
	smallvec-1.8.0
	syn-1.0.94
	syn-1.0.95
	target-lexicon-0.12.3
	unicode-ident-1.0.0
	unicode-xid-0.2.3
	unindent-0.1.9"
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )
inherit cargo distutils-r1 flag-o-matic

MATURIN_BETA_PV="$(ver_cut 1-3)-beta.$(ver_cut 5)"

DESCRIPTION="Build and publish crates with pyo3, rust-cpython and cffi bindings"
HOMEPAGE="https://maturin.rs/"
SRC_URI="
	https://github.com/PyO3/maturin/archive/refs/tags/v${MATURIN_BETA_PV}.tar.gz -> ${P}.gh.tar.gz
	$(cargo_crate_uris)
	test? ( $(cargo_crate_uris ${CRATES_TEST}) )"
S="${WORKDIR}/${PN}-${MATURIN_BETA_PV}"

LICENSE="
	0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions
	BSD CC0-1.0 ISC MIT MPL-2.0 openssl unicode
	doc? ( CC-BY-4.0 OFL-1.1 )"
SLOT="0"
KEYWORDS=""
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

PATCHES=(
	"${FILESDIR}"/${PN}-0.12.8-zig-tests.patch
)

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

	# setup.py handles most for non-tests, but ensure disabled rustls on arches
	# where ring crate is problematic -- keep in sync below (bug #859577)
	if use mips || use ppc || use ppc64 || use riscv || use s390 || use sparc; then
		sed -i '/^if platform.machine/s/^if/if True or/' setup.py || die
	fi
}

src_configure() {
	filter-lto # undefined references with ring crate

	if use mips || use ppc || use ppc64 || use riscv || use s390 || use sparc; then
		local myfeatures=( upload log human-panic )
		cargo_src_configure --no-default-features
	fi
}

python_compile_all() {
	use !doc || mdbook build -d html guide || die
}

src_test() {
	mv test-crates{,.orig} || die
	distutils-r1_src_test
}

python_test() {
	local -x PIP_CONFIG_FILE=${T}/pip.conf
	local -x VIRTUALENV_SYSTEM_SITE_PACKAGES=1

	local skip=(
		--skip locked_doesnt_build_without_cargo_lock
		# move below when >=rust-1.62 is stable, xfail "pass" with 1.60-1.61
		--skip pyo3_no_extension_module
	)
	[[ ${EPYTHON} == pypy3 ]] && skip+=(
		# test enables pyo3's auto-initialize that is incompatible with pypy
		--skip integration_pyo3_bin
		# wants the missing libpypy*-c.so
#		--skip pyo3_no_extension_module
	)

	cp -r test-crates{.orig,} || die
	cargo_src_test -- "${skip[@]}"
	rm -r test-crates || die
}

python_install_all() {
	dodoc Changelog.md Readme.md
	use doc && dodoc -r guide/html
}
