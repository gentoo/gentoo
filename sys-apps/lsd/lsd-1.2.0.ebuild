# Copyright 2017-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.85.0"
CRATES="
	aho-corasick@1.1.3
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.6.20
	anstyle-parse@0.2.3
	anstyle-query@1.0.2
	anstyle-wincon@3.0.10
	anstyle@1.0.11
	assert_cmd@2.0.14
	assert_fs@1.1.1
	autocfg@1.2.0
	bitflags@1.3.2
	bitflags@2.9.2
	bstr@1.9.1
	bumpalo@3.15.4
	cc@1.0.90
	cfg-if@1.0.0
	chrono-humanize@0.2.3
	chrono@0.4.37
	clap@4.5.45
	clap_builder@4.5.44
	clap_complete@4.5.57
	clap_derive@4.5.45
	clap_lex@0.7.5
	colorchoice@1.0.0
	convert_case@0.7.1
	core-foundation-sys@0.8.6
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.19
	crossterm@0.29.0
	crossterm_winapi@0.9.1
	dashmap@5.5.3
	derive_more-impl@2.0.1
	derive_more@2.0.1
	difflib@0.4.0
	dirs-sys@0.5.0
	dirs@6.0.0
	displaydoc@0.2.5
	doc-comment@0.3.3
	document-features@0.2.11
	equivalent@1.0.1
	errno@0.3.13
	fastrand@2.0.2
	float-cmp@0.9.0
	form_urlencoded@1.2.1
	futures-channel@0.3.30
	futures-core@0.3.30
	futures-executor@0.3.30
	futures-io@0.3.30
	futures-sink@0.3.30
	futures-task@0.3.30
	futures-util@0.3.30
	futures@0.3.30
	getrandom@0.2.12
	git2@0.20.2
	glob@0.3.1
	globset@0.4.14
	globwalk@0.9.1
	hashbrown@0.14.3
	heck@0.5.0
	human-sort@0.2.2
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.60
	icu_collections@1.5.0
	icu_locid@1.5.0
	icu_locid_transform@1.5.0
	icu_locid_transform_data@1.5.0
	icu_normalizer@1.5.0
	icu_normalizer_data@1.5.0
	icu_properties@1.5.1
	icu_properties_data@1.5.0
	icu_provider@1.5.0
	icu_provider_macros@1.5.0
	idna@1.0.3
	idna_adapter@1.2.0
	ignore@0.4.22
	indexmap@2.2.6
	is_terminal_polyfill@1.70.1
	itoa@1.0.11
	jobserver@0.1.28
	js-sys@0.3.69
	lazy_static@1.4.0
	libc@0.2.175
	libgit2-sys@0.18.2+1.9.1
	libredox@0.1.3
	libz-sys@1.1.16
	linked-hash-map@0.5.6
	linux-raw-sys@0.4.13
	linux-raw-sys@0.9.4
	litemap@0.7.4
	litrs@0.4.2
	lock_api@0.4.11
	log@0.4.21
	lscolors@0.20.0
	memchr@2.7.2
	mio@1.0.4
	normalize-line-endings@0.3.0
	nu-ansi-term@0.50.1
	num-traits@0.2.18
	once_cell@1.21.3
	once_cell_polyfill@1.70.1
	option-ext@0.2.0
	parking_lot@0.12.1
	parking_lot_core@0.9.9
	percent-encoding@2.3.1
	pin-project-lite@0.2.14
	pin-utils@0.1.0
	pkg-config@0.3.30
	predicates-core@1.0.6
	predicates-tree@1.0.9
	predicates@3.1.0
	proc-macro2@1.0.98
	pure-rust-locales@0.8.1
	quote@1.0.35
	redox_syscall@0.4.1
	redox_users@0.5.2
	regex-automata@0.4.6
	regex-syntax@0.8.3
	regex@1.10.4
	rustix@0.38.32
	rustix@1.0.8
	ryu@1.0.17
	same-file@1.0.6
	scopeguard@1.2.0
	serde@1.0.197
	serde_derive@1.0.197
	serde_yaml@0.9.34+deprecated
	serial_test@2.0.0
	serial_test_derive@2.0.0
	signal-hook-mio@0.2.4
	signal-hook-registry@1.4.1
	signal-hook@0.3.17
	slab@0.4.9
	smallvec@1.13.2
	stable_deref_trait@1.2.0
	strsim@0.11.1
	syn@2.0.106
	synstructure@0.13.1
	sys-locale@0.3.1
	temp-env@0.3.6
	tempfile@3.10.1
	term_grid@0.1.7
	terminal_size@0.4.3
	termtree@0.4.1
	thiserror-impl@2.0.14
	thiserror@2.0.14
	tinystr@0.7.6
	unicode-ident@1.0.12
	unicode-segmentation@1.12.0
	unicode-width@0.1.13
	unicode-width@0.2.1
	unsafe-libyaml@0.2.11
	url@2.5.4
	utf16_iter@1.0.5
	utf8_iter@1.0.4
	utf8parse@0.2.1
	uzers@0.11.3
	vcpkg@0.2.15
	version_check@0.9.4
	vsort@0.2.0
	wait-timeout@0.2.0
	walkdir@2.5.0
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.92
	wasm-bindgen-macro-support@0.2.92
	wasm-bindgen-macro@0.2.92
	wasm-bindgen-shared@0.2.92
	wasm-bindgen@0.2.92
	wild@2.2.1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-collections@0.2.0
	windows-core@0.52.0
	windows-core@0.61.2
	windows-future@0.2.1
	windows-implement@0.60.0
	windows-interface@0.59.1
	windows-link@0.1.3
	windows-numerics@0.2.0
	windows-result@0.3.4
	windows-strings@0.4.2
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-sys@0.60.2
	windows-targets@0.48.5
	windows-targets@0.52.6
	windows-targets@0.53.3
	windows-threading@0.1.0
	windows@0.61.3
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_gnullvm@0.53.0
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.6
	windows_aarch64_msvc@0.53.0
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.6
	windows_i686_gnu@0.53.0
	windows_i686_gnullvm@0.52.6
	windows_i686_gnullvm@0.53.0
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.6
	windows_i686_msvc@0.53.0
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnu@0.53.0
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_gnullvm@0.53.0
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.6
	windows_x86_64_msvc@0.53.0
	write16@1.0.0
	writeable@0.5.5
	xattr@1.3.1
	xdg@2.5.2
	yaml-rust@0.4.5
	yoke-derive@0.7.5
	yoke@0.7.5
	zerofrom-derive@0.1.5
	zerofrom@0.1.5
	zerovec-derive@0.10.3
	zerovec@0.10.4
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
LICENSE+=" Apache-2.0 MIT MPL-2.0 Unicode-3.0 Unicode-DFS-2016"
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
	default

	sed -i -e '/strip/s:true:false:' Cargo.toml || die
	# unpin libgit2
	sed -i -e '/git2/s:0.[0-9]*:*:' Cargo.toml || die
	rm Cargo.lock || die
}

src_compile() {
	export SHELL_COMPLETIONS_DIR="${T}/shell_completions"
	cargo_src_compile
}

src_test() {
	local -x LC_ALL=C
	cargo_src_test
}

src_install() {
	cargo_src_install

	local DOCS=( README.md doc/lsd.md )
	einstalldocs

	newbashcomp "${T}"/shell_completions/lsd.bash lsd
	dofishcomp "${T}"/shell_completions/lsd.fish
	dozshcomp "${T}"/shell_completions/_lsd
}
