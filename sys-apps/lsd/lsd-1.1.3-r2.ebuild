# Copyright 2017-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.82.0"
CRATES="
	aho-corasick@1.1.3
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.3.2
	anstyle-parse@0.2.7
	anstyle-query@1.1.4
	anstyle-wincon@1.0.2
	anstyle@1.0.11
	assert_cmd@2.0.17
	assert_fs@1.1.3
	autocfg@1.5.0
	bitflags@1.3.2
	bitflags@2.9.3
	bstr@1.12.0
	bumpalo@3.19.0
	cc@1.2.34
	cfg-if@1.0.3
	chrono-humanize@0.2.3
	chrono@0.4.41
	clap@4.3.24
	clap_builder@4.3.24
	clap_complete@4.5.3
	clap_derive@4.3.12
	clap_lex@0.5.1
	colorchoice@1.0.4
	core-foundation-sys@0.8.7
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	crossterm@0.27.0
	crossterm_winapi@0.9.1
	dashmap@5.5.3
	difflib@0.4.0
	dirs-sys@0.4.1
	dirs@5.0.1
	displaydoc@0.2.5
	doc-comment@0.3.3
	equivalent@1.0.2
	errno@0.3.13
	fastrand@2.3.0
	float-cmp@0.10.0
	form_urlencoded@1.2.2
	futures-channel@0.3.31
	futures-core@0.3.31
	futures-executor@0.3.31
	futures-io@0.3.31
	futures-sink@0.3.31
	futures-task@0.3.31
	futures-util@0.3.31
	futures@0.3.31
	getrandom@0.2.16
	getrandom@0.3.3
	git2@0.20.2
	glob@0.3.3
	globset@0.4.16
	globwalk@0.9.1
	hashbrown@0.14.5
	hashbrown@0.15.5
	heck@0.4.1
	hermit-abi@0.3.9
	hermit-abi@0.5.2
	human-sort@0.2.2
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.63
	icu_collections@2.0.0
	icu_locale_core@2.0.0
	icu_normalizer@2.0.0
	icu_normalizer_data@2.0.0
	icu_properties@2.0.1
	icu_properties_data@2.0.1
	icu_provider@2.0.0
	idna@1.1.0
	idna_adapter@1.2.1
	ignore@0.4.23
	indexmap@2.11.0
	io-lifetimes@1.0.11
	is-terminal@0.4.16
	itoa@1.0.15
	jobserver@0.1.34
	js-sys@0.3.77
	lazy_static@1.5.0
	libc@0.2.175
	libgit2-sys@0.18.2+1.9.1
	libredox@0.1.9
	libz-sys@1.1.22
	linked-hash-map@0.5.6
	linux-raw-sys@0.3.8
	linux-raw-sys@0.4.15
	linux-raw-sys@0.9.4
	litemap@0.8.0
	lock_api@0.4.13
	log@0.4.27
	lscolors@0.16.0
	memchr@2.7.5
	mio@0.8.11
	normalize-line-endings@0.3.0
	nu-ansi-term@0.49.0
	num-traits@0.2.19
	once_cell@1.21.3
	option-ext@0.2.0
	parking_lot@0.12.4
	parking_lot_core@0.9.11
	percent-encoding@2.3.2
	pin-project-lite@0.2.16
	pin-utils@0.1.0
	pkg-config@0.3.32
	potential_utf@0.1.3
	predicates-core@1.0.9
	predicates-tree@1.0.12
	predicates@3.1.3
	proc-macro2@1.0.101
	pure-rust-locales@0.8.1
	quote@1.0.40
	r-efi@5.3.0
	redox_syscall@0.5.17
	redox_users@0.4.6
	regex-automata@0.4.10
	regex-syntax@0.8.6
	regex@1.11.2
	rustix@0.37.28
	rustix@0.38.44
	rustix@1.0.8
	rustversion@1.0.22
	ryu@1.0.20
	same-file@1.0.6
	scopeguard@1.2.0
	serde@1.0.219
	serde_derive@1.0.219
	serde_yaml@0.9.34+deprecated
	serial_test@2.0.0
	serial_test_derive@2.0.0
	shlex@1.3.0
	signal-hook-mio@0.2.4
	signal-hook-registry@1.4.6
	signal-hook@0.3.18
	slab@0.4.11
	smallvec@1.15.1
	stable_deref_trait@1.2.0
	strsim@0.10.0
	syn@2.0.106
	synstructure@0.13.2
	sys-locale@0.3.2
	tempfile@3.21.0
	term_grid@0.1.7
	terminal_size@0.2.6
	terminal_size@0.3.0
	termtree@0.5.1
	thiserror-impl@1.0.69
	thiserror@1.0.69
	tinystr@0.8.1
	unicode-ident@1.0.18
	unicode-width@0.1.11
	unsafe-libyaml@0.2.11
	url@2.5.7
	utf8_iter@1.0.4
	utf8parse@0.2.2
	uzers@0.11.3
	vcpkg@0.2.15
	version_check@0.9.5
	vsort@0.2.0
	wait-timeout@0.2.1
	walkdir@2.5.0
	wasi@0.11.1+wasi-snapshot-preview1
	wasi@0.14.3+wasi-0.2.4
	wasm-bindgen-backend@0.2.100
	wasm-bindgen-macro-support@0.2.100
	wasm-bindgen-macro@0.2.100
	wasm-bindgen-shared@0.2.100
	wasm-bindgen@0.2.100
	wild@2.2.1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.10
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.61.2
	windows-implement@0.60.0
	windows-interface@0.59.1
	windows-link@0.1.3
	windows-result@0.3.4
	windows-strings@0.4.2
	windows-sys@0.48.0
	windows-sys@0.59.0
	windows-sys@0.60.2
	windows-targets@0.48.5
	windows-targets@0.52.6
	windows-targets@0.53.3
	windows@0.43.0
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_gnullvm@0.53.0
	windows_aarch64_msvc@0.42.2
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.6
	windows_aarch64_msvc@0.53.0
	windows_i686_gnu@0.42.2
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.6
	windows_i686_gnu@0.53.0
	windows_i686_gnullvm@0.52.6
	windows_i686_gnullvm@0.53.0
	windows_i686_msvc@0.42.2
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.6
	windows_i686_msvc@0.53.0
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnu@0.53.0
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_gnullvm@0.53.0
	windows_x86_64_msvc@0.42.2
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.6
	windows_x86_64_msvc@0.53.0
	wit-bindgen@0.45.0
	writeable@0.6.1
	xattr@1.5.1
	xdg@2.5.2
	yaml-rust@0.4.5
	yoke-derive@0.8.0
	yoke@0.8.0
	zerofrom-derive@0.1.6
	zerofrom@0.1.6
	zerotrie@0.2.2
	zerovec-derive@0.11.1
	zerovec@0.11.4
"

inherit cargo shell-completion

DESCRIPTION="An ls command with a lot of pretty colors and some other stuff."
HOMEPAGE="https://github.com/lsd-rs/lsd/"
SRC_URI="
	https://github.com/lsd-rs/lsd/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT MPL-2.0 Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

DEPEND="
	=dev-libs/libgit2-1.9*:=
"
RDEPEND="
	${DEPEND}
"

QA_FLAGS_IGNORED="usr/bin/lsd"

src_prepare() {
	local PATCHES=(
		# https://github.com/lsd-rs/lsd/pull/1161
		"${FILESDIR}/${P}-no-color-test.patch"
	)
	default

	sed -i -e '/strip/s:true:false:' Cargo.toml || die
	# unpin libgit2
	sed -i -e '/git2/s:0.18:*:' Cargo.toml || die
	rm Cargo.lock || die
}

src_compile() {
	export SHELL_COMPLETIONS_DIR="${T}/shell_completions"
	cargo_src_compile
}

src_install() {
	cargo_src_install

	local DOCS=( README.md doc/lsd.md )
	einstalldocs

	newbashcomp "${T}"/shell_completions/lsd.bash lsd
	dofishcomp "${T}"/shell_completions/lsd.fish
	dozshcomp "${T}"/shell_completions/_lsd
}
