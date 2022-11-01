# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick-0.7.18
	ansi_term-0.12.1
	assert_cmd-1.0.8
	assert_fs-1.0.7
	atty-0.2.14
	autocfg-1.1.0
	bitflags-1.3.2
	bstr-0.2.17
	cfg-if-1.0.0
	chrono-0.4.19
	chrono-humanize-0.1.2
	clap-3.2.17
	clap_complete-3.2.4
	clap_lex-0.2.4
	crossbeam-utils-0.8.8
	crossterm-0.24.0
	crossterm_winapi-0.9.0
	difference-2.0.0
	difflib-0.4.0
	dirs-3.0.2
	dirs-sys-0.3.7
	doc-comment-0.3.3
	either-1.6.1
	fastrand-1.7.0
	float-cmp-0.8.0
	fnv-1.0.7
	getrandom-0.2.5
	glob-0.3.0
	globset-0.4.8
	globwalk-0.8.1
	hashbrown-0.11.2
	hermit-abi-0.1.19
	human-sort-0.2.2
	idna-0.2.3
	ignore-0.4.18
	indexmap-1.8.0
	instant-0.1.12
	itertools-0.10.3
	lazy_static-1.4.0
	libc-0.2.121
	linked-hash-map-0.5.4
	lock_api-0.4.6
	log-0.4.16
	lscolors-0.9.0
	matches-0.1.9
	memchr-2.4.1
	mio-0.8.4
	normalize-line-endings-0.3.0
	num-integer-0.1.44
	num-traits-0.2.14
	once_cell-1.10.0
	os_str_bytes-6.3.0
	parking_lot-0.11.2
	parking_lot-0.12.1
	parking_lot_core-0.8.5
	parking_lot_core-0.9.3
	percent-encoding-2.1.0
	predicates-1.0.8
	predicates-2.1.1
	predicates-core-1.0.3
	predicates-tree-1.0.5
	proc-macro2-1.0.36
	quote-1.0.17
	redox_syscall-0.2.12
	redox_users-0.4.2
	regex-1.5.5
	regex-automata-0.1.10
	regex-syntax-0.6.25
	remove_dir_all-0.5.3
	ryu-1.0.9
	same-file-1.0.6
	scopeguard-1.1.0
	serde-1.0.136
	serde_derive-1.0.136
	serde_yaml-0.8.23
	serial_test-0.5.1
	serial_test_derive-0.5.1
	signal-hook-0.3.14
	signal-hook-mio-0.2.3
	signal-hook-registry-1.4.0
	smallvec-1.8.0
	strsim-0.10.0
	syn-1.0.89
	tempfile-3.3.0
	term_grid-0.1.7
	termcolor-1.1.3
	terminal_size-0.1.17
	termtree-0.2.4
	textwrap-0.15.0
	thiserror-1.0.30
	thiserror-impl-1.0.30
	thread_local-1.1.4
	time-0.1.43
	tinyvec-1.6.0
	tinyvec_macros-0.1.0
	unicode-bidi-0.3.8
	unicode-normalization-0.1.19
	unicode-width-0.1.9
	unicode-xid-0.2.2
	url-2.1.1
	users-0.11.0
	version_check-0.9.4
	wait-timeout-0.2.0
	walkdir-2.3.2
	wasi-0.10.2+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
	wild-2.0.4
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.36.1
	windows_aarch64_msvc-0.36.1
	windows_i686_gnu-0.36.1
	windows_i686_msvc-0.36.1
	windows_x86_64_gnu-0.36.1
	windows_x86_64_msvc-0.36.1
	xattr-0.2.2
	xdg-2.1.0
	yaml-rust-0.4.5
"

inherit bash-completion-r1 cargo

DESCRIPTION="An ls command with a lot of pretty colors and some other stuff."
HOMEPAGE="https://github.com/Peltoche/lsd"
SRC_URI="https://github.com/Peltoche/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 MIT Unlicense ZLIB"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 ~riscv ~x86"

QA_FLAGS_IGNORED="usr/bin/lsd"

src_prepare() {
	sed -i 's/strip = true/strip = false/' Cargo.toml || die
	default
}

src_compile() {
	export SHELL_COMPLETIONS_DIR="${T}/shell_completions"
	cargo_src_compile
}

src_install() {
	cargo_src_install

	local DOCS=( CHANGELOG.md README.md doc/lsd.md )
	einstalldocs

	newbashcomp "${T}"/shell_completions/lsd.bash lsd

	insinto /usr/share/fish/vendor_completions.d
	doins "${T}"/shell_completions/lsd.fish

	insinto /usr/share/zsh/site-functions
	doins "${T}"/shell_completions/_lsd
}
