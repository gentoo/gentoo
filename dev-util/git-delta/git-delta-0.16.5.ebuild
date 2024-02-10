# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler@1.0.2
	aho-corasick@0.7.20
	android_system_properties@0.1.5
	ansi_colours@1.2.1
	ansi_term@0.12.1
	anyhow@1.0.70
	approx@0.5.1
	arrayvec@0.7.2
	atty@0.2.14
	autocfg@1.1.0
	base64@0.21.0
	bat@0.22.1
	bincode@1.3.3
	bitflags@1.3.2
	bitflags@2.2.1
	box_drawing@0.1.2
	bstr@1.3.0
	bumpalo@3.12.0
	bytelines@2.2.2
	bytemuck@1.13.1
	bytesize@1.2.0
	cc@1.0.79
	cfg-if@1.0.0
	chrono-humanize@0.2.2
	chrono@0.4.23
	clap@4.1.8
	clap_derive@4.1.8
	clap_lex@0.3.2
	clircle@0.3.0
	codespan-reporting@0.11.1
	console@0.15.5
	content_inspector@0.2.4
	core-foundation-sys@0.8.3
	crc32fast@1.3.2
	ctrlc@3.2.5
	cxx-build@1.0.91
	cxx@1.0.91
	cxxbridge-flags@1.0.91
	cxxbridge-macro@1.0.91
	dirs-sys@0.3.7
	dirs@4.0.0
	either@1.8.1
	encode_unicode@0.3.6
	encoding-index-japanese@1.20141219.5
	encoding-index-korean@1.20141219.5
	encoding-index-simpchinese@1.20141219.5
	encoding-index-singlebyte@1.20141219.5
	encoding-index-tradchinese@1.20141219.5
	encoding@0.2.33
	encoding_index_tests@0.1.4
	errno-dragonfly@0.1.2
	errno@0.2.8
	find-crate@0.6.3
	flate2@1.0.25
	fnv@1.0.7
	form_urlencoded@1.1.0
	getrandom@0.2.8
	git2@0.16.1
	globset@0.4.10
	grep-cli@0.1.7
	hashbrown@0.12.3
	heck@0.4.1
	hermit-abi@0.1.19
	hermit-abi@0.3.1
	iana-time-zone-haiku@0.1.1
	iana-time-zone@0.1.53
	idna@0.3.0
	indexmap@1.9.2
	io-lifetimes@1.0.5
	is-terminal@0.4.4
	itertools@0.10.5
	itoa@1.0.6
	jobserver@0.1.26
	js-sys@0.3.61
	lazy_static@1.4.0
	libc@0.2.139
	libgit2-sys@0.14.2+1.5.1
	libz-sys@1.1.8
	line-wrap@0.1.1
	link-cplusplus@1.0.8
	linked-hash-map@0.5.6
	linux-raw-sys@0.1.4
	log@0.4.17
	memchr@2.5.0
	miniz_oxide@0.6.2
	nix@0.26.2
	ntapi@0.4.0
	num-integer@0.1.45
	num-traits@0.2.15
	once_cell@1.17.1
	onig@6.4.0
	onig_sys@69.8.1
	os_str_bytes@6.4.1
	palette@0.6.1
	palette_derive@0.6.1
	path_abs@0.5.1
	pathdiff@0.2.1
	percent-encoding@2.2.0
	phf@0.11.1
	phf_generator@0.11.1
	phf_macros@0.11.1
	phf_shared@0.11.1
	pkg-config@0.3.26
	plist@1.4.1
	proc-macro-error-attr@1.0.4
	proc-macro-error@1.0.4
	proc-macro2@1.0.51
	quick-xml@0.26.0
	quote@1.0.23
	rand@0.8.5
	rand_core@0.6.4
	redox_syscall@0.2.16
	redox_users@0.4.3
	regex-automata@0.1.10
	regex-syntax@0.6.28
	regex@1.7.1
	rgb@0.8.36
	rustix@0.36.9
	ryu@1.0.13
	safemem@0.3.3
	same-file@1.0.6
	scratch@1.0.4
	semver@1.0.16
	serde@1.0.152
	serde_derive@1.0.152
	serde_json@1.0.93
	serde_yaml@0.8.26
	shell-words@1.1.0
	siphasher@0.3.10
	smol_str@0.1.24
	static_assertions@1.1.0
	std_prelude@0.2.12
	strsim@0.10.0
	syn@1.0.109
	syntect@5.0.0
	sysinfo@0.28.2
	termcolor@1.2.0
	terminal_size@0.2.5
	thiserror-impl@1.0.38
	thiserror@1.0.38
	time-core@0.1.0
	time-macros@0.2.8
	time@0.1.45
	time@0.3.20
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	toml@0.5.11
	unicode-bidi@0.3.10
	unicode-ident@1.0.7
	unicode-normalization@0.1.22
	unicode-segmentation@1.10.1
	unicode-width@0.1.10
	url@2.3.1
	utf8parse@0.2.0
	vcpkg@0.2.15
	version_check@0.9.4
	vte@0.11.0
	vte_generate_state_changes@0.1.1
	walkdir@2.3.2
	wasi@0.10.0+wasi-snapshot-preview1
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.84
	wasm-bindgen-macro-support@0.2.84
	wasm-bindgen-macro@0.2.84
	wasm-bindgen-shared@0.2.84
	wasm-bindgen@0.2.84
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.5
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.42.0
	windows-sys@0.45.0
	windows-targets@0.42.1
	windows_aarch64_gnullvm@0.42.1
	windows_aarch64_msvc@0.42.1
	windows_i686_gnu@0.42.1
	windows_i686_msvc@0.42.1
	windows_x86_64_gnu@0.42.1
	windows_x86_64_gnullvm@0.42.1
	windows_x86_64_msvc@0.42.1
	xdg@2.4.1
	yaml-rust@0.4.5
"

inherit bash-completion-r1 cargo

DESCRIPTION="A syntax-highlighting pager for git"
HOMEPAGE="https://github.com/dandavison/delta"
SRC_URI="https://github.com/dandavison/delta/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" ${CARGO_CRATE_URIS}"
S="${WORKDIR}/${P/git-/}"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 CC0-1.0 LGPL-3+ MIT Unicode-DFS-2016"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv"

BDEPEND="virtual/pkgconfig"
DEPEND="
	dev-libs/libgit2:=
	dev-libs/oniguruma:=
"
RDEPEND="
	${DEPEND}
	!app-text/delta
"

QA_FLAGS_IGNORED="usr/bin/delta"

src_configure() {
	# Some crates will auto-build and statically link C libraries(!)
	# Tracker bug #709568
	export RUSTONIG_SYSTEM_LIBONIG=1
	export LIBGIT2_SYS_USE_PKG_CONFIG=1
	export PKG_CONFIG_ALLOW_CROSS=1
}

src_install() {
	cargo_src_install

	# No man page (yet?)

	# Completions
	newbashcomp "${S}"/etc/completion/completion.bash delta

	insinto /usr/share/zsh/site-functions
	newins "${S}"/etc/completion/completion.zsh _delta

	insinto /usr/share/fish/vendor_completions.d
	doins "${S}"/etc/completion/completion.fish
}
