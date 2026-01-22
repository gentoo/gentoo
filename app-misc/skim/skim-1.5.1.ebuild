# Copyright 2017-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.25.1
	adler2@2.0.1
	aho-corasick@1.1.4
	allocator-api2@0.2.21
	ansi-to-tui@8.0.1
	anstream@0.6.21
	anstyle-parse@0.2.7
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.13
	anyhow@1.0.100
	arrayvec@0.7.6
	assert_enum_variants@0.1.2
	atomic@0.6.1
	autocfg@1.5.0
	backtrace@0.3.76
	base64@0.22.1
	beef@0.5.2
	bit-set@0.5.3
	bit-vec@0.6.3
	bitflags@1.3.2
	bitflags@2.10.0
	block-buffer@0.10.4
	bstr@1.12.1
	bumpalo@3.19.1
	bytemuck@1.24.0
	bytes@1.11.0
	castaway@0.2.4
	cfg-if@1.0.4
	cfg_aliases@0.2.1
	clap@4.5.54
	clap_builder@4.5.54
	clap_complete@4.5.65
	clap_complete_nushell@4.5.10
	clap_derive@4.5.49
	clap_lex@0.7.7
	clap_mangen@0.2.31
	color-eyre@0.6.5
	color-spantrace@0.3.0
	colorchoice@1.0.4
	compact_str@0.9.0
	console@0.15.11
	convert_case@0.10.0
	cpufeatures@0.2.17
	crossbeam-channel@0.5.15
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	crossterm@0.29.0
	crossterm_winapi@0.9.1
	crypto-common@0.1.7
	csscolorparser@0.6.2
	darling@0.20.11
	darling@0.23.0
	darling_core@0.20.11
	darling_core@0.23.0
	darling_macro@0.20.11
	darling_macro@0.23.0
	defer-drop@1.3.0
	deltae@0.3.2
	deranged@0.5.5
	derive_builder@0.20.2
	derive_builder_core@0.20.2
	derive_builder_macro@0.20.2
	derive_more-impl@2.1.1
	derive_more@2.1.1
	digest@0.10.7
	doctest-file@1.0.0
	document-features@0.2.12
	either@1.15.0
	encode_unicode@1.0.0
	env_filter@0.1.4
	env_home@0.1.0
	env_logger@0.11.8
	equivalent@1.0.2
	errno@0.3.14
	euclid@0.22.13
	eyre@0.6.12
	fancy-regex@0.11.0
	fastrand@2.3.0
	filedescriptor@0.8.3
	finl_unicode@1.4.0
	fixedbitset@0.4.2
	fnv@1.0.7
	foldhash@0.2.0
	frizbee@0.6.0
	futures-channel@0.3.31
	futures-core@0.3.31
	futures-executor@0.3.31
	futures-io@0.3.31
	futures-macro@0.3.31
	futures-sink@0.3.31
	futures-task@0.3.31
	futures-util@0.3.31
	futures@0.3.31
	generic-array@0.14.7
	getrandom@0.3.4
	gimli@0.32.3
	hashbrown@0.16.1
	heck@0.5.0
	hex@0.4.3
	ident_case@1.0.1
	indenter@0.3.4
	indexmap@2.13.0
	indoc@2.0.7
	insta@1.46.1
	instability@0.3.11
	interprocess@2.2.3
	is_terminal_polyfill@1.70.2
	itertools@0.14.0
	itoa@1.0.17
	jiff-static@0.2.18
	jiff@0.2.18
	js-sys@0.3.85
	kasuari@0.4.11
	lab@0.11.0
	lazy_static@1.5.0
	libc@0.2.180
	line-clipping@0.3.5
	linux-raw-sys@0.11.0
	litrs@1.0.0
	lock_api@0.4.14
	log@0.4.29
	lru@0.16.3
	mac_address@1.1.8
	memchr@2.7.6
	memmem@0.1.1
	memoffset@0.9.1
	minimal-lexical@0.2.1
	miniz_oxide@0.8.9
	mio@1.1.1
	multiversion-macros@0.8.0
	multiversion@0.8.0
	nix@0.29.0
	nix@0.30.1
	nom@7.1.3
	nom@8.0.0
	num-conv@0.1.0
	num-derive@0.4.2
	num-traits@0.2.19
	num_threads@0.1.7
	numtoa@0.2.4
	object@0.37.3
	once_cell@1.21.3
	once_cell_polyfill@1.70.2
	ordered-float@4.6.0
	owo-colors@4.2.3
	parking_lot@0.12.5
	parking_lot_core@0.9.12
	pest@2.8.5
	pest_derive@2.8.5
	pest_generator@2.8.5
	pest_meta@2.8.5
	phf@0.11.3
	phf_codegen@0.11.3
	phf_generator@0.11.3
	phf_macros@0.11.3
	phf_shared@0.11.3
	pin-project-lite@0.2.16
	pin-utils@0.1.0
	portable-atomic-util@0.2.4
	portable-atomic@1.13.0
	powerfmt@0.2.0
	ppv-lite86@0.2.21
	proc-macro2@1.0.106
	pulldown-cmark@0.13.0
	quote@1.0.43
	r-efi@5.3.0
	rand@0.8.5
	rand@0.9.2
	rand_chacha@0.9.0
	rand_core@0.6.4
	rand_core@0.9.5
	ratatui-core@0.1.0
	ratatui-crossterm@0.1.0
	ratatui-macros@0.7.0
	ratatui-termwiz@0.1.0
	ratatui-widgets@0.3.0
	ratatui@0.30.0
	rayon-core@1.13.0
	rayon@1.11.0
	recvmsg@1.0.0
	redox_syscall@0.5.18
	regex-automata@0.4.13
	regex-syntax@0.8.8
	regex@1.12.2
	roff@0.2.2
	ron@0.12.0
	rustc-demangle@0.1.27
	rustc_version@0.4.1
	rustix@1.1.3
	rustversion@1.0.22
	ryu@1.0.22
	scopeguard@1.2.0
	semver@1.0.27
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	sha2@0.10.9
	sharded-slab@0.1.7
	shell-quote@0.7.2
	shlex@1.3.0
	signal-hook-mio@0.2.5
	signal-hook-registry@1.4.8
	signal-hook@0.3.18
	simdutf8@0.1.5
	similar@2.7.0
	siphasher@1.0.1
	slab@0.4.11
	smallvec@1.15.1
	socket2@0.6.1
	static_assertions@1.1.0
	strsim@0.11.1
	strum@0.27.2
	strum_macros@0.27.2
	syn@1.0.109
	syn@2.0.114
	target-features@0.1.6
	tempfile@3.24.0
	terminfo@0.9.0
	termion@4.0.6
	termios@0.3.3
	termwiz@0.23.3
	thiserror-impl@1.0.69
	thiserror-impl@2.0.18
	thiserror@1.0.69
	thiserror@2.0.18
	thread_local@1.1.9
	time-core@0.1.7
	time@0.3.45
	tokio-macros@2.6.0
	tokio-util@0.7.18
	tokio@1.49.0
	tracing-core@0.1.36
	tracing-error@0.2.1
	tracing-subscriber@0.3.22
	tracing@0.1.44
	typeid@1.0.3
	typenum@1.19.0
	ucd-trie@0.1.7
	unicase@2.9.0
	unicode-ident@1.0.22
	unicode-segmentation@1.12.0
	unicode-truncate@2.0.1
	unicode-width@0.2.2
	utf8parse@0.2.2
	uuid@1.19.0
	valuable@0.1.1
	version_check@0.9.5
	vte@0.15.0
	vtparse@0.6.2
	wasi@0.11.1+wasi-snapshot-preview1
	wasip2@1.0.2+wasi-0.2.9
	wasm-bindgen-macro-support@0.2.108
	wasm-bindgen-macro@0.2.108
	wasm-bindgen-shared@0.2.108
	wasm-bindgen@0.2.108
	wezterm-bidi@0.2.3
	wezterm-blob-leases@0.1.1
	wezterm-color-types@0.3.0
	wezterm-dynamic-derive@0.1.1
	wezterm-dynamic@0.2.1
	wezterm-input-types@0.1.0
	which@8.0.0
	widestring@1.2.1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-link@0.2.1
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-sys@0.60.2
	windows-sys@0.61.2
	windows-targets@0.52.6
	windows-targets@0.53.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_gnullvm@0.53.1
	windows_aarch64_msvc@0.52.6
	windows_aarch64_msvc@0.53.1
	windows_i686_gnu@0.52.6
	windows_i686_gnu@0.53.1
	windows_i686_gnullvm@0.52.6
	windows_i686_gnullvm@0.53.1
	windows_i686_msvc@0.52.6
	windows_i686_msvc@0.53.1
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnu@0.53.1
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_gnullvm@0.53.1
	windows_x86_64_msvc@0.52.6
	windows_x86_64_msvc@0.53.1
	winsafe@0.0.19
	wit-bindgen@0.51.0
	zerocopy-derive@0.8.33
	zerocopy@0.8.33
"

RUST_MIN_VER="1.88.0"

inherit cargo optfeature shell-completion

DESCRIPTION="Command-line fuzzy finder"
HOMEPAGE="https://github.com/skim-rs/skim"
SRC_URI="
	https://github.com/skim-rs/skim/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	0BSD Apache-2.0 MIT MPL-2.0 Unicode-3.0 Unicode-DFS-2016 WTFPL-2
	ZLIB
"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

BDEPEND="test? ( app-misc/tmux )"

QA_FLAGS_IGNORED="usr/bin/sk"

src_configure() {
	myfeatures=( cli )
	use test && myfeatures+=( test-utils )
	cargo_src_configure --no-default-features
}

src_test() {
	cargo_src_test --bins --lib -- \
		--skip test_ansi_flag_disabled \
		--skip test_ansi_flag_enabled \
		--skip test_ansi_flag_no_strip \
		--skip test_ansi_matching_on_stripped_text
}

src_install() {
	# prevent cargo_src_install() blowing up on man installation
	mv man manpages || die

	cargo_src_install
	dodoc CHANGELOG.md README.md
	doman manpages/man1/*

	dobin bin/sk-tmux

	insinto /usr/share/vim/vimfiles/plugin
	doins plugin/skim.vim

	# install shell keybindings
	insinto "/usr/share/${PN}"
	doins shell/key-bindings.*

	newbashcomp shell/completion.bash sk
	newzshcomp shell/completion.fish sk.fish
	newzshcomp shell/completion.zsh _sk
}

pkg_postinst() {
	optfeature "sk-tmux integration" app-misc/tmux
	optfeature "vim plugin integration" app-editors/vim app-editors/gvim
}
