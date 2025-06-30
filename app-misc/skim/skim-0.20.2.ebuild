# Copyright 2017-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.3
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.6.19
	anstyle-parse@0.2.7
	anstyle-query@1.1.3
	anstyle-wincon@3.0.9
	anstyle@1.0.11
	arrayvec@0.7.6
	autocfg@1.5.0
	beef@0.5.2
	bitflags@1.3.2
	bitflags@2.9.1
	bstr@1.12.0
	bumpalo@3.19.0
	cc@1.2.27
	cfg-if@1.0.1
	cfg_aliases@0.2.1
	chrono@0.4.41
	clap@4.5.40
	clap_builder@4.5.40
	clap_complete@4.5.54
	clap_complete_fig@4.5.2
	clap_complete_nushell@4.5.7
	clap_derive@4.5.40
	clap_lex@0.7.5
	clap_mangen@0.2.27
	colorchoice@1.0.4
	core-foundation-sys@0.8.7
	crossbeam-channel@0.5.15
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-queue@0.3.12
	crossbeam-utils@0.8.21
	crossbeam@0.8.4
	darling@0.20.11
	darling_core@0.20.11
	darling_macro@0.20.11
	defer-drop@1.3.0
	deranged@0.4.0
	derive_builder@0.20.2
	derive_builder_core@0.20.2
	derive_builder_macro@0.20.2
	dirs-next@2.0.0
	dirs-sys-next@0.1.2
	either@1.15.0
	env_filter@0.1.3
	env_home@0.1.0
	env_logger@0.11.8
	equivalent@1.0.2
	errno@0.3.13
	fastrand@2.3.0
	fnv@1.0.7
	fuzzy-matcher@0.3.7
	getrandom@0.2.16
	getrandom@0.3.3
	hashbrown@0.15.4
	heck@0.5.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.63
	ident_case@1.0.1
	indexmap@2.10.0
	is_terminal_polyfill@1.70.1
	jiff-static@0.2.15
	jiff@0.2.15
	js-sys@0.3.77
	lazy_static@1.5.0
	libc@0.2.174
	libredox@0.1.4
	linux-raw-sys@0.9.4
	log@0.4.27
	memchr@2.7.5
	nix@0.29.0
	num-conv@0.1.0
	num-traits@0.2.19
	once_cell@1.21.3
	once_cell_polyfill@1.70.1
	portable-atomic-util@0.2.4
	portable-atomic@1.11.1
	powerfmt@0.2.0
	ppv-lite86@0.2.21
	proc-macro2@1.0.95
	pulldown-cmark@0.13.0
	quote@1.0.40
	r-efi@5.3.0
	rand@0.9.1
	rand_chacha@0.9.0
	rand_core@0.9.3
	rayon-core@1.12.1
	rayon@1.10.0
	redox_users@0.4.6
	regex-automata@0.4.9
	regex-syntax@0.8.5
	regex@1.11.1
	roff@0.2.2
	rustix@1.0.7
	rustversion@1.0.21
	serde@1.0.219
	serde_derive@1.0.219
	shell-quote@0.7.2
	shlex@1.3.0
	strsim@0.11.1
	syn@2.0.104
	tempfile@3.20.0
	term@0.7.0
	thiserror-impl@1.0.69
	thiserror@1.0.69
	thread_local@1.1.9
	time-core@0.1.4
	time@0.3.41
	timer@0.2.0
	unicase@2.8.1
	unicode-ident@1.0.18
	unicode-width@0.2.1
	utf8parse@0.2.2
	vte@0.15.0
	wasi@0.11.1+wasi-snapshot-preview1
	wasi@0.14.2+wasi-0.2.4
	wasm-bindgen-backend@0.2.100
	wasm-bindgen-macro-support@0.2.100
	wasm-bindgen-macro@0.2.100
	wasm-bindgen-shared@0.2.100
	wasm-bindgen@0.2.100
	which@7.0.3
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.61.2
	windows-implement@0.60.0
	windows-interface@0.59.1
	windows-link@0.1.3
	windows-result@0.3.4
	windows-strings@0.4.2
	windows-sys@0.59.0
	windows-sys@0.60.2
	windows-targets@0.52.6
	windows-targets@0.53.2
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_gnullvm@0.53.0
	windows_aarch64_msvc@0.52.6
	windows_aarch64_msvc@0.53.0
	windows_i686_gnu@0.52.6
	windows_i686_gnu@0.53.0
	windows_i686_gnullvm@0.52.6
	windows_i686_gnullvm@0.53.0
	windows_i686_msvc@0.52.6
	windows_i686_msvc@0.53.0
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnu@0.53.0
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_gnullvm@0.53.0
	windows_x86_64_msvc@0.52.6
	windows_x86_64_msvc@0.53.0
	winsafe@0.0.19
	wit-bindgen-rt@0.39.0
	zerocopy-derive@0.8.26
	zerocopy@0.8.26
"

RUST_MIN_VER="1.85.0"

inherit cargo optfeature shell-completion

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
