# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler@1.0.2
	ahash@0.8.6
	aho-corasick@1.1.2
	allocator-api2@0.2.16
	anstream@0.3.2
	anstream@0.6.4
	anstyle-parse@0.2.1
	anstyle-query@1.0.0
	anstyle-wincon@1.0.2
	anstyle-wincon@3.0.1
	anstyle@1.0.2
	anyhow@1.0.75
	autocfg@1.1.0
	base64@0.13.1
	base64@0.21.5
	bitflags@1.3.2
	bitflags@2.4.1
	block-buffer@0.10.4
	bstr@1.8.0
	byteorder@1.5.0
	bytesize@1.3.0
	bytes@1.5.0
	bzip2-sys@0.1.11+1.0.8
	bzip2@0.4.4
	cab@0.4.1
	camino@1.1.6
	cargo-config2@0.1.16
	cargo-options@0.7.2
	cargo-platform@0.1.5
	cargo-xwin@0.16.2
	cargo-zigbuild@0.18.0
	cargo_metadata@0.18.1
	cbindgen@0.26.0
	cc@1.0.83
	cfb@0.9.0
	cfg-if@1.0.0
	charset@0.1.3
	chumsky@0.9.3
	clap@4.3.24
	clap_builder@4.3.24
	clap_complete@4.3.2
	clap_complete_command@0.5.1
	clap_complete_fig@4.3.1
	clap_complete_nushell@0.1.11
	clap_derive@4.3.12
	clap_lex@0.5.0
	cli-table@0.4.7
	colorchoice@1.0.0
	configparser@3.0.3
	console@0.15.7
	content_inspector@0.2.4
	core-foundation-sys@0.8.4
	core-foundation@0.9.3
	cpufeatures@0.2.11
	crc32fast@1.3.2
	crossbeam-channel@0.5.8
	crossbeam-deque@0.8.3
	crossbeam-epoch@0.9.15
	crossbeam-utils@0.8.16
	crypto-common@0.1.6
	data-encoding@2.5.0
	deranged@0.3.9
	dialoguer@0.11.0
	diff@0.1.13
	digest@0.10.7
	dirs-sys@0.4.1
	dirs@5.0.1
	dissimilar@1.0.7
	dunce@1.0.4
	either@1.9.0
	encode_unicode@0.3.6
	encoding_rs@0.8.33
	equivalent@1.0.1
	errno@0.3.8
	expect-test@1.4.1
	fastrand@2.0.1
	fat-macho@0.4.7
	filetime@0.2.22
	flate2@1.0.28
	fnv@1.0.7
	foreign-types-shared@0.1.1
	foreign-types@0.3.2
	form_urlencoded@1.2.1
	fs-err@2.11.0
	generic-array@0.14.7
	getrandom@0.2.11
	globset@0.4.14
	glob@0.3.1
	goblin@0.7.1
	hashbrown@0.12.3
	hashbrown@0.14.3
	heck@0.4.1
	hermit-abi@0.3.3
	home@0.5.5
	humantime-serde@1.1.1
	humantime@2.1.0
	idna@0.5.0
	ignore@0.4.20
	indexmap@1.9.3
	indexmap@2.1.0
	indicatif@0.17.7
	indoc@2.0.4
	instant@0.1.12
	io-lifetimes@1.0.11
	is-terminal@0.4.9
	itertools@0.11.0
	itertools@0.12.0
	itoa@1.0.9
	keyring@2.0.5
	lazy_static@1.4.0
	lddtree@0.3.3
	libc@0.2.150
	libredox@0.0.1
	linux-keyutils@0.2.3
	linux-raw-sys@0.3.8
	linux-raw-sys@0.4.11
	lock_api@0.4.11
	log@0.4.20
	lzxd@0.1.4
	mailparse@0.14.0
	matchers@0.1.0
	memchr@2.6.4
	memoffset@0.9.0
	mime@0.3.17
	mime_guess@2.0.4
	minijinja@1.0.10
	minimal-lexical@0.2.1
	miniz_oxide@0.7.1
	msi@0.7.0
	multipart@0.18.0
	native-tls@0.2.11
	nom@7.1.3
	normalize-line-endings@0.3.0
	normpath@1.1.1
	number_prefix@0.4.0
	nu-ansi-term@0.46.0
	once_cell@1.18.0
	openssl-macros@0.1.1
	openssl-probe@0.1.5
	openssl-sys@0.9.96
	openssl@0.10.60
	option-ext@0.2.0
	os_pipe@1.1.4
	overload@0.1.1
	parking_lot@0.12.1
	parking_lot_core@0.9.9
	paste@1.0.14
	path-slash@0.2.1
	pep440_rs@0.3.12
	pep508_rs@0.2.3
	percent-encoding@2.3.1
	pin-project-lite@0.2.13
	pkg-config@0.3.27
	plain@0.2.3
	platform-info@2.0.2
	portable-atomic@1.5.1
	powerfmt@0.2.0
	ppv-lite86@0.2.17
	pretty_assertions@1.4.0
	proc-macro2@1.0.70
	psm@0.1.21
	pyproject-toml@0.8.1
	python-pkginfo@0.6.0
	quoted_printable@0.4.8
	quote@1.0.33
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rayon-core@1.12.0
	rayon@1.8.0
	redox_syscall@0.3.5
	redox_syscall@0.4.1
	redox_users@0.4.4
	regex-automata@0.1.10
	regex-automata@0.4.3
	regex-syntax@0.6.29
	regex-syntax@0.8.2
	regex@1.10.2
	rfc2047-decoder@0.2.2
	ring@0.17.6
	rustc_version@0.4.0
	rustix@0.37.27
	rustix@0.38.21
	rustls-pemfile@2.0.0
	rustls-pki-types@1.0.0
	rustls-webpki@0.101.7
	rustls@0.21.9
	rustversion@1.0.14
	ryu@1.0.15
	same-file@1.0.6
	schannel@0.1.22
	scopeguard@1.2.0
	scroll@0.11.0
	scroll_derive@0.11.1
	sct@0.7.1
	security-framework-sys@2.9.1
	security-framework@2.9.2
	semver@1.0.20
	serde@1.0.193
	serde_derive@1.0.193
	serde_json@1.0.108
	serde_spanned@0.6.4
	sha2@0.10.8
	sharded-slab@0.1.7
	shell-words@1.1.0
	shlex@1.2.0
	similar@2.3.0
	smallvec@1.11.2
	smawk@0.3.2
	snapbox-macros@0.3.6
	snapbox@0.4.14
	socks@0.3.4
	spin@0.9.8
	stacker@0.1.15
	static_assertions@1.1.0
	strsim@0.10.0
	syn@1.0.109
	syn@2.0.39
	target-lexicon@0.12.12
	tar@0.4.40
	tempfile@3.8.1
	termcolor@1.4.0
	terminal_size@0.2.6
	textwrap@0.16.0
	thiserror-impl@1.0.50
	thiserror@1.0.50
	thread_local@1.1.7
	time-core@0.1.2
	time-macros@0.2.15
	time@0.3.30
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	toml@0.5.11
	toml@0.8.8
	toml_datetime@0.6.5
	toml_edit@0.20.7
	toml_edit@0.21.0
	tracing-attributes@0.1.27
	tracing-core@0.1.32
	tracing-log@0.2.0
	tracing-serde@0.1.3
	tracing-subscriber@0.3.18
	tracing@0.1.40
	trycmd@0.14.19
	twox-hash@1.6.3
	typenum@1.17.0
	unicase@2.7.0
	unicode-bidi@0.3.13
	unicode-ident@1.0.12
	unicode-linebreak@0.1.5
	unicode-normalization@0.1.22
	unicode-width@0.1.11
	untrusted@0.9.0
	ureq@2.9.1
	url@2.5.0
	utf8parse@0.2.1
	uuid@1.6.1
	valuable@0.1.0
	vcpkg@0.2.15
	versions@5.0.1
	version_check@0.9.4
	wait-timeout@0.2.0
	walkdir@2.4.0
	wasi@0.11.0+wasi-snapshot-preview1
	webpki-roots@0.25.3
	which@5.0.0
	wild@2.2.0
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.45.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.42.2
	windows-targets@0.48.5
	windows-targets@0.52.0
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.0
	windows_aarch64_msvc@0.42.2
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.0
	windows_i686_gnu@0.42.2
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.0
	windows_i686_msvc@0.42.2
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.0
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.0
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.0
	windows_x86_64_msvc@0.42.2
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.0
	winnow@0.5.19
	xattr@1.0.1
	xwin@0.5.0
	yansi@0.5.1
	zerocopy-derive@0.7.28
	zerocopy@0.7.28
	zeroize@1.7.0
	zip@0.6.6
"
# additional crates used by test-crates/* test packages,
# `grep test-crates tests/run.rs` to see which are needed
CRATES_TEST="
	anstyle@1.0.1
	anyhow@1.0.72
	askama@0.12.0
	askama_derive@0.12.1
	askama_escape@0.10.3
	basic-toml@0.1.4
	bincode@1.3.3
	bitflags@2.4.0
	bytes@1.4.0
	cargo-platform@0.1.3
	cargo_metadata@0.15.4
	cc@1.0.73
	cc@1.0.81
	cc@1.0.82
	clap@4.3.21
	clap_builder@4.3.21
	errno-dragonfly@0.1.2
	errno@0.3.2
	fs-err@2.9.0
	generator@0.7.5
	getrandom@0.2.10
	goblin@0.6.1
	hermit-abi@0.3.2
	indoc@1.0.7
	indoc@1.0.9
	libc@0.2.134
	libc@0.2.147
	libc@0.2.149
	linux-raw-sys@0.4.10
	lock_api@0.4.9
	lock_api@0.4.10
	log@0.4.19
	loom@0.5.6
	memchr@2.5.0
	once_cell@1.15.0
	oneshot@0.1.6
	parking_lot_core@0.9.3
	parking_lot_core@0.9.8
	pin-utils@0.1.0
	proc-macro2@1.0.46
	proc-macro2@1.0.66
	proc-macro2@1.0.69
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
	quote@1.0.32
	redox_syscall@0.2.16
	regex-automata@0.3.7
	regex-syntax@0.7.5
	regex@1.9.4
	scoped-tls@1.0.1
	scopeguard@1.1.0
	semver@1.0.18
	serde@1.0.182
	serde@1.0.183
	serde_derive@1.0.182
	serde_derive@1.0.183
	serde_json@1.0.104
	siphasher@0.3.10
	smallvec@1.10.0
	smallvec@1.11.0
	smallvec@1.11.1
	syn@1.0.102
	syn@2.0.28
	target-lexicon@0.12.7
	target-lexicon@0.12.11
	thiserror-impl@1.0.44
	thiserror@1.0.44
	tracing-log@0.1.4
	tracing-subscriber@0.3.17
	unicase@2.6.0
	unicode-ident@1.0.5
	unicode-ident@1.0.11
	uniffi@0.25.0
	uniffi_bindgen@0.25.0
	uniffi_build@0.25.0
	uniffi_checksum_derive@0.25.0
	uniffi_core@0.25.0
	uniffi_macros@0.25.0
	uniffi_meta@0.25.0
	uniffi_testing@0.25.0
	uniffi_udl@0.25.0
	unindent@0.1.10
	unindent@0.1.11
	weedle2@4.0.0
	windows-sys@0.36.1
	windows-targets@0.48.1
	windows@0.48.0
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
inherit cargo distutils-r1 edo shell-completion toolchain-funcs

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
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="doc +ssl test"
RESTRICT="!test? ( test )"

RDEPEND="$(python_gen_cond_dep 'dev-python/tomli[${PYTHON_USEDEP}]' 3.10)"
DEPEND="ssl? ( dev-libs/openssl:= )"
BDEPEND="
	dev-python/setuptools-rust[${PYTHON_USEDEP}]
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
