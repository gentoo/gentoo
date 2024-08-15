# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler@1.0.2
	ahash@0.8.11
	aho-corasick@1.1.3
	allocator-api2@0.2.18
	anstream@0.6.14
	anstyle-parse@0.2.4
	anstyle-query@1.1.0
	anstyle-wincon@3.0.3
	anstyle@1.0.7
	anyhow@1.0.86
	arbitrary@1.3.2
	autocfg@1.3.0
	automod@1.0.14
	base64@0.13.1
	base64@0.21.7
	base64@0.22.1
	bitflags@1.3.2
	bitflags@2.5.0
	block-buffer@0.10.4
	bstr@1.9.1
	byteorder@1.5.0
	bytesize@1.3.0
	bytes@1.6.0
	bzip2-sys@0.1.11+1.0.8
	bzip2@0.4.4
	cab@0.5.0
	camino@1.1.7
	cargo-config2@0.1.26
	cargo-options@0.7.4
	cargo-platform@0.1.8
	cargo-xwin@0.16.5
	cargo-zigbuild@0.18.4
	cargo_metadata@0.18.1
	cbindgen@0.26.0
	cc@1.0.104
	cfb@0.9.0
	cfg-if@1.0.0
	charset@0.1.3
	chumsky@0.9.3
	clap@4.5.7
	clap_builder@4.5.7
	clap_complete@4.5.5
	clap_complete_command@0.5.1
	clap_complete_nushell@0.1.11
	clap_derive@4.5.5
	clap_lex@0.7.1
	cli-table@0.4.7
	colorchoice@1.0.1
	configparser@3.1.0
	console@0.15.8
	content_inspector@0.2.4
	core-foundation-sys@0.8.6
	core-foundation@0.9.4
	cpufeatures@0.2.12
	crc32fast@1.4.2
	crossbeam-channel@0.5.13
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.20
	crypto-common@0.1.6
	data-encoding@2.6.0
	deranged@0.3.11
	derivative@2.2.0
	derive_arbitrary@1.3.2
	dialoguer@0.11.0
	diff@0.1.13
	digest@0.10.7
	dirs-sys@0.4.1
	dirs@5.0.1
	displaydoc@0.2.4
	dissimilar@1.0.9
	dunce@1.0.4
	dyn-clone@1.0.17
	either@1.12.0
	encode_unicode@0.3.6
	encoding_rs@0.8.34
	equivalent@1.0.1
	errno@0.3.9
	expect-test@1.5.0
	fastrand@2.1.0
	fat-macho@0.4.8
	filetime@0.2.23
	flate2@1.0.30
	fnv@1.0.7
	foreign-types-shared@0.1.1
	foreign-types@0.3.2
	form_urlencoded@1.2.1
	fs-err@2.11.0
	futures-channel@0.3.30
	futures-core@0.3.30
	futures-executor@0.3.30
	futures-io@0.3.30
	futures-macro@0.3.30
	futures-sink@0.3.30
	futures-task@0.3.30
	futures-timer@3.0.3
	futures-util@0.3.30
	futures@0.3.30
	generic-array@0.14.7
	getrandom@0.2.15
	globset@0.4.14
	glob@0.3.1
	goblin@0.8.2
	hashbrown@0.12.3
	hashbrown@0.14.5
	heck@0.4.1
	heck@0.5.0
	home@0.5.9
	humantime-serde@1.1.1
	humantime@2.1.0
	idna@0.5.0
	ignore@0.4.22
	indexmap@1.9.3
	indexmap@2.2.6
	indicatif@0.17.8
	indoc@2.0.5
	instant@0.1.13
	is_terminal_polyfill@1.70.0
	itertools@0.12.1
	itoa@1.0.11
	keyring@2.3.3
	lazy_static@1.4.0
	lddtree@0.3.5
	libc@0.2.155
	libmimalloc-sys@0.1.38
	libredox@0.1.3
	linux-keyutils@0.2.4
	linux-raw-sys@0.4.14
	lock_api@0.4.12
	log@0.4.21
	lzxd@0.2.5
	mailparse@0.15.0
	matchers@0.1.0
	memchr@2.7.2
	mimalloc@0.1.42
	mime@0.3.17
	mime_guess@2.0.4
	minijinja@1.0.21
	minimal-lexical@0.2.1
	miniz_oxide@0.7.3
	msi@0.7.0
	multipart@0.18.0
	native-tls@0.2.12
	nom@7.1.3
	normalize-line-endings@0.3.0
	normpath@1.2.0
	number_prefix@0.4.0
	num-conv@0.1.0
	num_enum@0.7.2
	num_enum_derive@0.7.2
	nu-ansi-term@0.46.0
	once_cell@1.19.0
	openssl-macros@0.1.1
	openssl-probe@0.1.5
	openssl-sys@0.9.102
	openssl@0.10.64
	option-ext@0.2.0
	os_pipe@1.2.0
	overload@0.1.1
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	paste@1.0.15
	path-slash@0.2.1
	pep440_rs@0.5.0
	pep508_rs@0.4.2
	percent-encoding@2.3.1
	pin-project-lite@0.2.14
	pin-utils@0.1.0
	pkg-config@0.3.30
	plain@0.2.3
	platform-info@2.0.3
	portable-atomic@1.6.0
	powerfmt@0.2.0
	ppv-lite86@0.2.17
	pretty_assertions@1.4.0
	proc-macro2@1.0.85
	proc-macro-crate@3.1.0
	psm@0.1.21
	pyproject-toml@0.10.0
	python-pkginfo@0.6.2
	quoted_printable@0.5.0
	quote@1.0.36
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rayon-core@1.12.1
	rayon@1.10.0
	redox_syscall@0.4.1
	redox_syscall@0.5.1
	redox_users@0.4.5
	regex-automata@0.1.10
	regex-automata@0.4.7
	regex-syntax@0.6.29
	regex-syntax@0.8.4
	regex@1.10.5
	relative-path@1.9.3
	rfc2047-decoder@1.0.5
	ring@0.17.8
	rstest@0.21.0
	rstest_macros@0.21.0
	rustc_version@0.4.0
	rustix@0.38.34
	rustls-pemfile@2.1.2
	rustls-pki-types@1.7.0
	rustls-webpki@0.102.4
	rustls@0.22.4
	rustversion@1.0.17
	ryu@1.0.18
	same-file@1.0.6
	schannel@0.1.23
	schemars@0.8.21
	schemars_derive@0.8.21
	scopeguard@1.2.0
	scroll@0.12.0
	scroll_derive@0.12.0
	security-framework-sys@2.11.0
	security-framework@2.11.0
	semver@1.0.23
	serde@1.0.204
	serde_derive@1.0.204
	serde_derive_internals@0.29.1
	serde_json@1.0.120
	serde_spanned@0.6.6
	sha2@0.10.8
	sharded-slab@0.1.7
	shell-words@1.1.0
	shlex@1.3.0
	similar@2.5.0
	slab@0.4.9
	smallvec@1.13.2
	smawk@0.3.2
	snapbox-macros@0.3.9
	snapbox@0.6.10
	socks@0.3.4
	spin@0.9.8
	stacker@0.1.15
	static_assertions@1.1.0
	strsim@0.11.1
	subtle@2.5.0
	syn@1.0.109
	syn@2.0.66
	target-lexicon@0.12.14
	tar@0.4.41
	tempfile@3.10.1
	termcolor@1.4.1
	terminal_size@0.3.0
	textwrap@0.16.1
	thiserror-impl@1.0.61
	thiserror@1.0.61
	thread_local@1.1.8
	time-core@0.1.2
	time-macros@0.2.18
	time@0.3.36
	tinyvec@1.7.0
	tinyvec_macros@0.1.1
	toml@0.5.11
	toml@0.8.14
	toml_datetime@0.6.6
	toml_edit@0.21.1
	toml_edit@0.22.14
	tracing-attributes@0.1.27
	tracing-core@0.1.32
	tracing-log@0.2.0
	tracing-serde@0.1.3
	tracing-subscriber@0.3.18
	tracing@0.1.40
	trycmd@0.15.4
	twox-hash@1.6.3
	typenum@1.17.0
	unicase@2.7.0
	unicode-bidi@0.3.15
	unicode-ident@1.0.12
	unicode-linebreak@0.1.5
	unicode-normalization@0.1.23
	unicode-width@0.1.13
	unicode-xid@0.2.4
	unscanny@0.1.0
	untrusted@0.9.0
	ureq@2.9.7
	urlencoding@2.1.3
	url@2.5.2
	utf8parse@0.2.2
	uuid@1.8.0
	valuable@0.1.0
	vcpkg@0.2.15
	versions@6.2.0
	version_check@0.9.4
	wait-timeout@0.2.0
	walkdir@2.5.0
	wasi@0.11.0+wasi-snapshot-preview1
	webpki-roots@0.26.2
	which@5.0.0
	which@6.0.1
	wild@2.2.1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.8
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
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
	winnow@0.5.40
	winnow@0.6.13
	winsafe@0.0.19
	xattr@1.3.1
	xwin@0.5.1
	yansi@0.5.1
	zerocopy-derive@0.7.34
	zerocopy@0.7.34
	zeroize@1.8.1
	zip@0.6.6
	zip@1.1.4
"
# additional crates used by test-crates/* test packages,
# `grep test-crates tests/run.rs` to see which are needed
CRATES_TEST="
	askama@0.12.1
	askama_derive@0.12.5
	askama_escape@0.10.3
	askama_parser@0.2.1
	autocfg@1.1.0
	basic-toml@0.1.9
	bincode@1.3.3
	cargo_metadata@0.15.4
	cc@1.0.73
	cc@1.0.81
	cc@1.0.83
	getrandom@0.2.10
	indoc@2.0.4
	libc@0.2.134
	libc@0.2.147
	libc@0.2.149
	memchr@2.7.4
	memoffset@0.9.0
	once_cell@1.15.0
	once_cell@1.18.0
	proc-macro2@1.0.86
	pyo3-build-config@0.18.3
	pyo3-build-config@0.22.0
	pyo3-ffi@0.18.3
	pyo3-ffi@0.22.0
	pyo3-macros-backend@0.22.0
	pyo3-macros@0.22.0
	pyo3@0.22.0
	python3-dll-a@0.2.6
	python3-dll-a@0.2.9
	serde@1.0.203
	serde_derive@1.0.203
	serde_json@1.0.118
	siphasher@0.3.11
	syn@2.0.68
	target-lexicon@0.12.11
	unicode-ident@1.0.5
	unicode-ident@1.0.11
	uniffi@0.28.0
	uniffi_bindgen@0.28.0
	uniffi_build@0.28.0
	uniffi_checksum_derive@0.28.0
	uniffi_core@0.28.0
	uniffi_macros@0.28.0
	uniffi_meta@0.28.0
	uniffi_testing@0.28.0
	uniffi_udl@0.28.0
	unindent@0.2.3
	weedle2@5.0.0
"
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )
inherit cargo distutils-r1 flag-o-matic shell-completion toolchain-funcs

DESCRIPTION="Build and publish crates with pyo3, rust-cpython and cffi bindings"
HOMEPAGE="https://www.maturin.rs/"
SRC_URI="
	https://github.com/PyO3/maturin/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	${CARGO_CRATE_URIS}
	test? ( $(cargo_crate_uris ${CRATES_TEST}) )
"

# note: ring is unused, so openssl license can be skipped
LICENSE="|| ( Apache-2.0 MIT ) doc? ( CC-BY-4.0 OFL-1.1 )"
LICENSE+="
	0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD ISC MIT MPL-2.0
	Unicode-DFS-2016
" # crates
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 sparc x86"
IUSE="doc +ssl test"
RESTRICT="!test? ( test )"

RDEPEND="$(python_gen_cond_dep 'dev-python/tomli[${PYTHON_USEDEP}]' 3.10)"
DEPEND="ssl? ( dev-libs/openssl:= )"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/mdbook )
	test? (
		${RDEPEND}
		$(python_gen_cond_dep 'dev-python/cffi[${PYTHON_USEDEP}]' 'python*')
		dev-python/boltons[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
		dev-vcs/git
	)
"
RDEPEND+=" ${DEPEND}"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_prepare() {
	distutils-r1_src_prepare

	# we build the Rust executable (just once) via cargo_src_compile
	sed -i -e '/setuptools_rust/d' -e '/rust_extensions/d' setup.py || die

	if use test; then
		# used to prevent use of network during tests, and silence pip
		# if it finds unrelated issues with system packages (bug #913613)
		cat > "${T}"/pip.conf <<-EOF || die
			[global]
			quiet = 2

			[install]
			no-index = yes
			no-dependencies = yes
		EOF

		# used by *git_sdist_generator tests
		git init -q || die
		git config --global user.email "larry@gentoo.org" || die
		git config --global user.name "Larry the Cow" || die
		git add . || die
		git commit -qm init || die
	fi
}

src_configure() {
	export OPENSSL_NO_VENDOR=1

	# https://github.com/rust-lang/stacker/issues/79
	use s390 && ! is-flagq '-march=*' &&
		append-cflags $(test-flags-CC -march=z10)

	local myfeatures=(
		# like release.yml + native-tls for better platform support than rustls
		full
		password-storage
		$(usev ssl native-tls)
	)

	cargo_src_configure --no-default-features
}

python_compile_all() {
	cargo_src_compile

	use !doc || mdbook build -d html guide || die

	if ! tc-is-cross-compiler; then
		local maturin=$(cargo_target_dir)/maturin
		"${maturin}" completions bash > "${T}"/${PN} || die
		"${maturin}" completions fish > "${T}"/${PN}.fish || die
		"${maturin}" completions zsh > "${T}"/_${PN} || die
	else
		ewarn "shell completion files were skipped due to cross-compilation"
	fi
}

python_test() {
	local -x MATURIN_TEST_PYTHON=${EPYTHON}
	local -x PIP_CONFIG_FILE=${T}/pip.conf
	local -x VIRTUALENV_SYSTEM_SITE_PACKAGES=1

	# need this for (new) python versions not yet recognized by pyo3
	local -x PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1

	local skip=(
		# picky cli output test that easily benignly fail (bug #937992)
		--skip cli_tests
		# avoid need for wasm over a single hello world test
		--skip integration_wasm_hello_world
		# fragile depending on rust version, also wants libpypy*-c.so for pypy
		--skip pyo3_no_extension_module
		# unimportant tests that use uv, and it does not seem to be able
		# to find the system's dev-python/uv (not worth the trouble)
		--skip develop_hello_world::case_2
		--skip develop_pyo3_ffi_pure::case_2
		# fails on sparc since rust-1.74 (bug #934573), skip for now given
		# should not affect the pep517 backend which is all we need on sparc
		$(usev sparc '--skip build_context::test::test_macosx_deployment_target')
	)

	cargo_src_test -- "${skip[@]}"
}

python_install_all() {
	cargo_src_install

	dodoc Changelog.md README.md
	use doc && dodoc -r guide/html

	if ! tc-is-cross-compiler; then
		dobashcomp "${T}"/${PN}
		dofishcomp "${T}"/${PN}.fish
		dozshcomp "${T}"/_${PN}
	fi
}
