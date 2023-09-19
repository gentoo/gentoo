# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler@1.0.2
	ahash@0.7.6
	aho-corasick@0.7.20
	anstream@0.3.2
	anstyle-parse@0.2.1
	anstyle-query@1.0.0
	anstyle-wincon@1.0.2
	anstyle@1.0.1
	anyhow@1.0.73
	autocfg@1.1.0
	base64@0.13.1
	base64@0.21.2
	bitflags@1.3.2
	block-buffer@0.10.4
	bstr@1.6.0
	bumpalo@3.13.0
	byteorder@1.4.3
	bytesize@1.2.0
	bytes@1.4.0
	bzip2-sys@0.1.11+1.0.8
	bzip2@0.4.4
	cab@0.4.1
	camino@1.1.6
	cargo-config2@0.1.8
	cargo-options@0.6.0
	cargo-platform@0.1.3
	cargo-xwin@0.14.6
	cargo-zigbuild@0.17.0
	cargo_metadata@0.17.0
	cbindgen@0.24.5
	cc@1.0.82
	cfb@0.7.3
	cfg-expr@0.15.4
	cfg-if@1.0.0
	charset@0.1.3
	chumsky@0.9.2
	clap@4.1.14
	clap_builder@4.1.14
	clap_complete@4.2.3
	clap_complete_command@0.5.1
	clap_complete_fig@4.2.0
	clap_complete_nushell@0.1.11
	clap_derive@4.1.14
	clap_lex@0.4.1
	cli-table@0.4.7
	colorchoice@1.0.0
	configparser@3.0.2
	console@0.15.7
	content_inspector@0.2.4
	core-foundation-sys@0.8.4
	core-foundation@0.9.3
	cpufeatures@0.2.9
	crc32fast@1.3.2
	crossbeam-channel@0.5.8
	crossbeam-deque@0.8.3
	crossbeam-epoch@0.9.15
	crossbeam-utils@0.8.16
	crypto-common@0.1.6
	data-encoding@2.4.0
	dialoguer@0.10.4
	diff@0.1.13
	digest@0.10.7
	dirs-sys@0.4.1
	dirs@5.0.1
	dunce@1.0.4
	either@1.9.0
	encode_unicode@0.3.6
	encoding_rs@0.8.32
	errno-dragonfly@0.1.2
	errno@0.3.2
	fastrand@1.9.0
	fat-macho@0.4.7
	filetime@0.2.22
	flate2@1.0.27
	fnv@1.0.7
	foreign-types-shared@0.1.1
	foreign-types@0.3.2
	form_urlencoded@1.2.0
	fs-err@2.9.0
	generic-array@0.14.7
	getrandom@0.2.10
	globset@0.4.10
	glob@0.3.1
	goblin@0.7.1
	hashbrown@0.12.3
	heck@0.4.1
	hermit-abi@0.3.2
	home@0.5.5
	humantime-serde@1.1.1
	humantime@2.1.0
	idna@0.4.0
	ignore@0.4.20
	indexmap@1.9.3
	indicatif@0.17.6
	indoc@2.0.3
	instant@0.1.12
	io-lifetimes@1.0.11
	is-terminal@0.4.7
	itertools@0.11.0
	itoa@1.0.9
	js-sys@0.3.64
	keyring@2.0.5
	lazy_static@1.4.0
	lddtree@0.3.3
	libc@0.2.147
	linux-keyutils@0.2.3
	linux-raw-sys@0.3.8
	lock_api@0.4.10
	log@0.4.20
	lzxd@0.1.4
	mailparse@0.14.0
	matchers@0.1.0
	memchr@2.5.0
	memoffset@0.9.0
	mime@0.3.17
	mime_guess@2.0.4
	minijinja@1.0.6
	minimal-lexical@0.2.1
	miniz_oxide@0.7.1
	msi@0.5.1
	multipart@0.18.0
	native-tls@0.2.11
	nom@7.1.3
	normalize-line-endings@0.3.0
	normpath@1.1.1
	number_prefix@0.4.0
	num_cpus@1.16.0
	nu-ansi-term@0.46.0
	once_cell@1.18.0
	openssl-macros@0.1.1
	openssl-probe@0.1.5
	openssl-src@111.27.0+1.1.1v
	openssl-sys@0.9.91
	openssl@0.10.56
	option-ext@0.2.0
	os_pipe@1.1.4
	overload@0.1.1
	parking_lot@0.12.1
	parking_lot_core@0.9.8
	paste@1.0.14
	path-slash@0.2.1
	pep440_rs@0.3.6
	pep508_rs@0.2.1
	percent-encoding@2.3.0
	pin-project-lite@0.2.12
	pkg-config@0.3.27
	plain@0.2.3
	platform-info@2.0.2
	portable-atomic@1.4.2
	ppv-lite86@0.2.17
	pretty_assertions@1.4.0
	proc-macro2@1.0.66
	psm@0.1.21
	pyproject-toml@0.6.1
	python-pkginfo@0.6.0
	quoted_printable@0.4.8
	quote@1.0.32
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rayon-core@1.11.0
	rayon@1.7.0
	redox_syscall@0.2.16
	redox_syscall@0.3.5
	redox_users@0.4.3
	regex-automata@0.1.10
	regex-syntax@0.6.29
	regex@1.7.3
	rfc2047-decoder@0.2.2
	ring@0.16.20
	rustc_version@0.4.0
	rustix@0.37.23
	rustls-pemfile@1.0.3
	rustls-webpki@0.100.1
	rustls@0.21.2
	rustversion@1.0.14
	ryu@1.0.15
	same-file@1.0.6
	schannel@0.1.22
	scopeguard@1.2.0
	scroll@0.11.0
	scroll_derive@0.11.1
	sct@0.7.0
	security-framework-sys@2.9.1
	security-framework@2.9.2
	semver@1.0.18
	serde@1.0.183
	serde_derive@1.0.183
	serde_json@1.0.104
	serde_spanned@0.6.3
	sha2@0.10.7
	sharded-slab@0.1.4
	shell-escape@0.1.5
	shell-words@1.1.0
	shlex@1.1.0
	similar@2.2.1
	smallvec@1.11.0
	smawk@0.3.1
	snapbox-macros@0.3.4
	snapbox@0.4.11
	socks@0.3.4
	spin@0.5.2
	stacker@0.1.15
	static_assertions@1.1.0
	strsim@0.10.0
	syn@1.0.109
	syn@2.0.28
	target-lexicon@0.12.11
	tar@0.4.40
	tempfile@3.6.0
	termcolor@1.2.0
	terminal_size@0.2.6
	textwrap@0.16.0
	thiserror-impl@1.0.45
	thiserror@1.0.45
	thread_local@1.1.7
	time-core@0.1.0
	time-macros@0.2.8
	time@0.3.20
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	toml@0.5.11
	toml@0.7.4
	toml_datetime@0.6.2
	toml_edit@0.19.10
	tracing-attributes@0.1.26
	tracing-core@0.1.31
	tracing-log@0.1.3
	tracing-serde@0.1.3
	tracing-subscriber@0.3.17
	tracing@0.1.37
	trycmd@0.14.16
	twox-hash@1.6.3
	typenum@1.16.0
	unicase@2.6.0
	unicode-bidi@0.3.13
	unicode-ident@1.0.11
	unicode-linebreak@0.1.5
	unicode-normalization@0.1.22
	unicode-width@0.1.10
	untrusted@0.7.1
	ureq@2.7.1
	url@2.4.0
	utf8parse@0.2.1
	uuid@1.4.1
	valuable@0.1.0
	vcpkg@0.2.15
	versions@5.0.1
	version_check@0.9.4
	wait-timeout@0.2.0
	walkdir@2.3.3
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.87
	wasm-bindgen-macro-support@0.2.87
	wasm-bindgen-macro@0.2.87
	wasm-bindgen-shared@0.2.87
	wasm-bindgen@0.2.87
	webpki-roots@0.23.1
	web-sys@0.3.64
	which@4.4.0
	wild@2.1.0
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.5
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.45.0
	windows-sys@0.48.0
	windows-targets@0.42.2
	windows-targets@0.48.2
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_gnullvm@0.48.2
	windows_aarch64_msvc@0.42.2
	windows_aarch64_msvc@0.48.2
	windows_i686_gnu@0.42.2
	windows_i686_gnu@0.48.2
	windows_i686_msvc@0.42.2
	windows_i686_msvc@0.48.2
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_gnullvm@0.48.2
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnu@0.48.2
	windows_x86_64_msvc@0.42.2
	windows_x86_64_msvc@0.48.2
	winnow@0.4.7
	xattr@1.0.1
	xwin@0.2.14
	yansi@0.5.1
	zeroize@1.6.0
	zip@0.6.6
"
# additional crates used by test-crates/* test packages,
# `grep test-crates tests/run.rs` to see which are needed
CRATES_TEST="
	anyhow@1.0.72
	askama@0.12.0
	askama_derive@0.12.1
	askama_escape@0.10.3
	basic-toml@0.1.4
	bincode@1.3.3
	cargo_metadata@0.15.4
	cc@1.0.73
	cc@1.0.81
	goblin@0.6.1
	indoc@1.0.7
	indoc@1.0.9
	libc@0.2.134
	lock_api@0.4.9
	log@0.4.19
	once_cell@1.15.0
	parking_lot_core@0.9.3
	proc-macro2@1.0.46
	pyo3-build-config@0.18.3
	pyo3-build-config@0.19.0
	pyo3-build-config@0.19.2
	pyo3-ffi@0.18.3
	pyo3-ffi@0.19.0
	pyo3-ffi@0.19.2
	pyo3-macros-backend@0.19.0
	pyo3-macros-backend@0.19.2
	pyo3-macros@0.19.0
	pyo3-macros@0.19.2
	pyo3@0.19.0
	pyo3@0.19.2
	python3-dll-a@0.2.6
	python3-dll-a@0.2.9
	quote@1.0.21
	scopeguard@1.1.0
	serde@1.0.182
	serde_derive@1.0.182
	siphasher@0.3.10
	smallvec@1.10.0
	syn@1.0.102
	target-lexicon@0.12.7
	thiserror-impl@1.0.44
	thiserror@1.0.44
	unicode-ident@1.0.5
	uniffi@0.24.3
	uniffi_bindgen@0.24.3
	uniffi_build@0.24.3
	uniffi_checksum_derive@0.24.3
	uniffi_core@0.24.3
	uniffi_macros@0.24.3
	uniffi_meta@0.24.3
	uniffi_testing@0.24.3
	unindent@0.1.10
	unindent@0.1.11
	weedle2@4.0.0
	windows-sys@0.36.1
	windows-targets@0.48.1
	windows_aarch64_gnullvm@0.48.0
	windows_aarch64_msvc@0.36.1
	windows_aarch64_msvc@0.48.0
	windows_i686_gnu@0.36.1
	windows_i686_gnu@0.48.0
	windows_i686_msvc@0.36.1
	windows_i686_msvc@0.48.0
	windows_x86_64_gnullvm@0.48.0
	windows_x86_64_gnu@0.36.1
	windows_x86_64_gnu@0.48.0
	windows_x86_64_msvc@0.36.1
	windows_x86_64_msvc@0.48.0
"
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )
inherit cargo distutils-r1 edo flag-o-matic shell-completion toolchain-funcs

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
KEYWORDS="amd64 arm arm64 ~loong ~ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="doc +ssl test"
RESTRICT="!test? ( test )"

RDEPEND="$(python_gen_cond_dep 'dev-python/tomli[${PYTHON_USEDEP}]' 3.10)"
DEPEND="ssl? ( dev-libs/openssl:= )"
BDEPEND="
	dev-python/setuptools-rust[${PYTHON_USEDEP}]
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

	export MATURIN_SETUP_ARGS=${cargoargs[*]}
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
		dofishcomp "${T}"/${PN}.fish
		dozshcomp "${T}"/_${PN}
	fi
}
