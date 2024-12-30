# Copyright 2017-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.3
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.6
	anstyle@1.0.10
	arrayvec@0.7.6
	autocfg@1.4.0
	beef@0.5.2
	bitflags@1.3.2
	bitflags@2.6.0
	bstr@1.11.0
	bumpalo@3.16.0
	byteorder@1.5.0
	cc@1.2.1
	cfg-if@1.0.0
	cfg_aliases@0.2.1
	chrono@0.4.39
	clap@4.5.27
	clap_builder@4.5.27
	clap_complete@4.5.42
	clap_complete_fig@4.5.2
	clap_complete_nushell@4.5.5
	clap_derive@4.5.24
	clap_lex@0.7.4
	clap_mangen@0.2.26
	colorchoice@1.0.3
	core-foundation-sys@0.8.7
	crossbeam-channel@0.5.13
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-queue@0.3.11
	crossbeam-utils@0.8.20
	crossbeam@0.8.4
	darling@0.20.10
	darling_core@0.20.10
	darling_macro@0.20.10
	defer-drop@1.3.0
	deranged@0.3.11
	derive_builder@0.20.2
	derive_builder_core@0.20.2
	derive_builder_macro@0.20.2
	dirs-next@2.0.0
	dirs-sys-next@0.1.2
	either@1.13.0
	env_filter@0.1.2
	env_home@0.1.0
	env_logger@0.11.6
	equivalent@1.0.1
	errno@0.3.9
	fastrand@2.2.0
	fnv@1.0.7
	fuzzy-matcher@0.3.7
	getrandom@0.2.15
	hashbrown@0.15.2
	heck@0.5.0
	humantime@2.1.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.61
	ident_case@1.0.1
	indexmap@2.7.1
	is_terminal_polyfill@1.70.1
	js-sys@0.3.72
	lazy_static@1.5.0
	libc@0.2.165
	libredox@0.1.3
	linux-raw-sys@0.4.14
	log@0.4.25
	memchr@2.7.4
	nix@0.24.3
	nix@0.29.0
	num-conv@0.1.0
	num-traits@0.2.19
	once_cell@1.20.2
	powerfmt@0.2.0
	ppv-lite86@0.2.20
	proc-macro2@1.0.92
	quote@1.0.37
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rayon-core@1.12.1
	rayon@1.10.0
	redox_users@0.4.6
	regex-automata@0.4.9
	regex-syntax@0.8.5
	regex@1.11.1
	roff@0.2.2
	rustix@0.38.41
	rustversion@1.0.18
	serde@1.0.215
	serde_derive@1.0.215
	shell-quote@0.7.2
	shlex@1.3.0
	strsim@0.11.1
	syn@2.0.89
	tempfile@3.15.0
	term@0.7.0
	thiserror-impl@1.0.69
	thiserror@1.0.69
	thread_local@1.1.8
	time-core@0.1.2
	time@0.3.36
	timer@0.2.0
	tuikit@0.5.0
	unicode-ident@1.0.14
	unicode-width@0.1.14
	unicode-width@0.2.0
	utf8parse@0.2.2
	vte@0.14.1
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.95
	wasm-bindgen-macro-support@0.2.95
	wasm-bindgen-macro@0.2.95
	wasm-bindgen-shared@0.2.95
	wasm-bindgen@0.2.95
	which@7.0.1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	winsafe@0.0.19
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
"

inherit cargo optfeature

DESCRIPTION="Command-line fuzzy finder"
HOMEPAGE="https://github.com/skim-rs/skim"
SRC_URI="
	https://github.com/skim-rs/skim/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT MPL-2.0 Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

QA_FLAGS_IGNORED="usr/bin/sk"

src_compile() {
	cargo_src_compile --bin sk
}

src_install() {
	# prevent cargo_src_install() blowing up on man installation
	mv man manpages || die

	cargo_src_install --path skim
	dodoc CHANGELOG.md README.md
	doman manpages/man1/*

	dobin bin/sk-tmux

	insinto /usr/share/vim/vimfiles/plugin
	doins plugin/skim.vim

	# install bash/zsh completion and keybindings
	# since provided completions override a lot of commands, install to /usr/share
	insinto "/usr/share/${PN}"
	doins shell/{*.bash,*.zsh}
}

pkg_postinst() {
	optfeature "sk-tmux integration" app-misc/tmux
	optfeature "vim plugin integration" app-editors/vim app-editors/gvim
}
