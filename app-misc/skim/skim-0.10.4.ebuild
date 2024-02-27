# Copyright 2017-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@0.7.19
	android_system_properties@0.1.5
	arrayvec@0.7.2
	atty@0.2.14
	autocfg@1.1.0
	beef@0.5.2
	bitflags@1.3.2
	bumpalo@3.11.1
	cc@1.0.73
	cfg-if@1.0.0
	chrono@0.4.22
	clap@3.2.22
	clap_lex@0.2.4
	codespan-reporting@0.11.1
	core-foundation-sys@0.8.3
	crossbeam-channel@0.5.6
	crossbeam-deque@0.8.2
	crossbeam-epoch@0.9.11
	crossbeam-queue@0.3.6
	crossbeam-utils@0.8.12
	crossbeam@0.8.2
	cxx-build@1.0.80
	cxx@1.0.80
	cxxbridge-flags@1.0.80
	cxxbridge-macro@1.0.80
	darling@0.14.1
	darling_core@0.14.1
	darling_macro@0.14.1
	defer-drop@1.3.0
	derive_builder@0.11.2
	derive_builder_core@0.11.2
	derive_builder_macro@0.11.2
	dirs-next@2.0.0
	dirs-sys-next@0.1.2
	either@1.8.0
	env_logger@0.9.1
	fnv@1.0.7
	fuzzy-matcher@0.3.7
	getrandom@0.2.8
	hashbrown@0.12.3
	hermit-abi@0.1.19
	humantime@2.1.0
	iana-time-zone-haiku@0.1.1
	iana-time-zone@0.1.51
	ident_case@1.0.1
	indexmap@1.9.1
	js-sys@0.3.60
	lazy_static@1.4.0
	libc@0.2.135
	link-cplusplus@1.0.7
	log@0.4.17
	memchr@2.5.0
	memoffset@0.6.5
	nix@0.24.2
	nix@0.25.0
	num-integer@0.1.45
	num-traits@0.2.15
	num_cpus@1.13.1
	num_threads@0.1.6
	once_cell@1.15.0
	os_str_bytes@6.3.0
	pin-utils@0.1.0
	proc-macro2@1.0.47
	quote@1.0.21
	rayon-core@1.9.3
	rayon@1.5.3
	redox_syscall@0.2.16
	redox_users@0.4.3
	regex-syntax@0.6.27
	regex@1.6.0
	rustversion@1.0.9
	scopeguard@1.1.0
	scratch@1.0.2
	shlex@1.1.0
	strsim@0.10.0
	syn@1.0.103
	term@0.7.0
	termcolor@1.1.3
	textwrap@0.15.1
	thiserror-impl@1.0.37
	thiserror@1.0.37
	thread_local@1.1.4
	time@0.1.44
	time@0.3.15
	timer@0.2.0
	tuikit@0.5.0
	unicode-ident@1.0.5
	unicode-width@0.1.10
	utf8parse@0.2.0
	vte@0.11.0
	vte_generate_state_changes@0.1.1
	wasi@0.10.0+wasi-snapshot-preview1
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.83
	wasm-bindgen-macro-support@0.2.83
	wasm-bindgen-macro@0.2.83
	wasm-bindgen-shared@0.2.83
	wasm-bindgen@0.2.83
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.5
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
"

inherit cargo optfeature

DESCRIPTION="Command-line fuzzy finder"
HOMEPAGE="https://github.com/lotabout/skim"
SRC_URI="https://github.com/lotabout/skim/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" ${CARGO_CRATE_URIS}"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT MPL-2.0 Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

QA_FLAGS_IGNORED="usr/bin/sk"

src_install() {
	# prevent cargo_src_install() blowing up on man installation
	mv man manpages || die

	cargo_src_install
	dodoc CHANGELOG.md README.md
	doman manpages/man1/*

	dobin bin/sk-tmux

	insinto /usr/share/vim/vimfiles/plugin
	doins plugin/skim.vim

	# install bash/zsh completion and keybindings
	# since provided completions override a lot of commands, install to /usr/share
	insinto /usr/share/${PN}
	doins shell/{*.bash,*.zsh}
}

pkg_postinst() {
	optfeature "sk-tmux integration" app-misc/tmux
	optfeature "vim plugin integration" app-editors/vim app-editors/gvim
}
