# Copyright 2017-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.2
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.3.2
	anstyle-parse@0.2.3
	anstyle-query@1.0.2
	anstyle-wincon@1.0.2
	anstyle@1.0.6
	assert_cmd@2.0.14
	assert_fs@1.1.1
	autocfg@1.1.0
	bitflags@1.3.2
	bitflags@2.4.2
	bstr@1.9.1
	bumpalo@3.15.4
	cc@1.0.90
	cfg-if@1.0.0
	chrono-humanize@0.2.3
	chrono@0.4.35
	clap@4.3.24
	clap_builder@4.3.24
	clap_complete@4.5.1
	clap_derive@4.3.12
	clap_lex@0.5.1
	colorchoice@1.0.0
	core-foundation-sys@0.8.6
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.19
	crossterm@0.27.0
	crossterm_winapi@0.9.1
	dashmap@5.5.3
	difflib@0.4.0
	dirs-sys@0.4.1
	dirs@5.0.1
	doc-comment@0.3.3
	equivalent@1.0.1
	errno@0.3.8
	fastrand@2.0.1
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
	git2@0.18.2
	glob@0.3.1
	globset@0.4.14
	globwalk@0.9.1
	hashbrown@0.14.3
	heck@0.4.1
	hermit-abi@0.3.9
	human-sort@0.2.2
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.60
	idna@0.5.0
	ignore@0.4.22
	indexmap@2.2.5
	io-lifetimes@1.0.11
	is-terminal@0.4.12
	itoa@1.0.10
	jobserver@0.1.28
	js-sys@0.3.69
	lazy_static@1.4.0
	libc@0.2.153
	libgit2-sys@0.16.2+1.7.2
	libredox@0.0.1
	libz-sys@1.1.15
	linked-hash-map@0.5.6
	linux-raw-sys@0.3.8
	linux-raw-sys@0.4.13
	lock_api@0.4.11
	log@0.4.21
	lscolors@0.16.0
	memchr@2.7.1
	mio@0.8.11
	normalize-line-endings@0.3.0
	nu-ansi-term@0.49.0
	num-traits@0.2.18
	once_cell@1.19.0
	option-ext@0.2.0
	parking_lot@0.12.1
	parking_lot_core@0.9.9
	percent-encoding@2.3.1
	pin-project-lite@0.2.13
	pin-utils@0.1.0
	pkg-config@0.3.30
	predicates-core@1.0.6
	predicates-tree@1.0.9
	predicates@3.1.0
	proc-macro2@1.0.78
	pure-rust-locales@0.8.1
	quote@1.0.35
	redox_syscall@0.4.1
	redox_users@0.4.4
	regex-automata@0.4.6
	regex-syntax@0.8.2
	regex@1.10.3
	rustix@0.37.27
	rustix@0.38.31
	ryu@1.0.17
	same-file@1.0.6
	scopeguard@1.2.0
	serde@1.0.197
	serde_derive@1.0.197
	serde_yaml@0.9.32
	serial_test@2.0.0
	serial_test_derive@2.0.0
	signal-hook-mio@0.2.3
	signal-hook-registry@1.4.1
	signal-hook@0.3.17
	slab@0.4.9
	smallvec@1.13.1
	strsim@0.10.0
	syn@2.0.52
	sys-locale@0.3.1
	tempfile@3.10.1
	term_grid@0.1.7
	terminal_size@0.2.6
	terminal_size@0.3.0
	termtree@0.4.1
	thiserror-impl@1.0.57
	thiserror@1.0.57
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	unicode-bidi@0.3.15
	unicode-ident@1.0.12
	unicode-normalization@0.1.23
	unicode-width@0.1.11
	unsafe-libyaml@0.2.10
	url@2.5.0
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
	windows-core@0.52.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.48.5
	windows-targets@0.52.4
	windows@0.43.0
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.4
	windows_aarch64_msvc@0.42.2
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.4
	windows_i686_gnu@0.42.2
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.4
	windows_i686_msvc@0.42.2
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.4
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.4
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.4
	windows_x86_64_msvc@0.42.2
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.4
	xattr@1.3.1
	xdg@2.5.2
	yaml-rust@0.4.5
"

inherit bash-completion-r1 cargo

DESCRIPTION="An ls command with a lot of pretty colors and some other stuff."
HOMEPAGE="https://github.com/lsd-rs/lsd/"
SRC_URI="
	https://github.com/lsd-rs/lsd/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT MPL-2.0 Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

QA_FLAGS_IGNORED="usr/bin/lsd"

src_prepare() {
	sed -i -e '/strip/s:true:false:' Cargo.toml || die
	default
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

	insinto /usr/share/fish/vendor_completions.d
	doins "${T}"/shell_completions/lsd.fish

	insinto /usr/share/zsh/site-functions
	doins "${T}"/shell_completions/_lsd
}
