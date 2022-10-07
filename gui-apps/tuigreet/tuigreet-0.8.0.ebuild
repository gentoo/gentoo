# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ahash-0.7.6
	aho-corasick-0.7.18
	async-trait-0.1.53
	autocfg-1.1.0
	bitflags-1.3.2
	block-0.1.6
	block-buffer-0.9.0
	bytes-1.1.0
	cassowary-0.3.0
	cfg-if-1.0.0
	chrono-0.4.19
	cpufeatures-0.2.2
	crossterm-0.23.2
	crossterm_winapi-0.9.0
	dashmap-5.3.3
	digest-0.9.0
	dlv-list-0.3.0
	find-crate-0.6.3
	fluent-0.16.0
	fluent-bundle-0.15.2
	fluent-langneg-0.13.0
	fluent-syntax-0.11.0
	futures-0.3.21
	futures-channel-0.3.21
	futures-core-0.3.21
	futures-executor-0.3.21
	futures-io-0.3.21
	futures-macro-0.3.21
	futures-sink-0.3.21
	futures-task-0.3.21
	futures-util-0.3.21
	generic-array-0.14.5
	getopts-0.2.21
	getrandom-0.2.6
	greetd_ipc-0.8.0
	hashbrown-0.12.1
	hermit-abi-0.1.19
	i18n-config-0.4.2
	i18n-embed-0.13.4
	i18n-embed-fl-0.6.4
	i18n-embed-impl-0.8.0
	intl-memoizer-0.5.1
	intl_pluralrules-7.0.1
	itoa-1.0.1
	lazy_static-1.4.0
	libc-0.2.125
	locale_config-0.3.0
	lock_api-0.4.7
	log-0.4.17
	malloc_buf-0.0.6
	memchr-2.5.0
	memoffset-0.6.5
	mio-0.8.3
	nix-0.24.1
	num-integer-0.1.45
	num-traits-0.2.15
	num_cpus-1.13.1
	objc-0.2.7
	objc-foundation-0.1.1
	objc_id-0.1.1
	once_cell-1.10.0
	opaque-debug-0.3.0
	ordered-multimap-0.4.3
	parking_lot-0.12.0
	parking_lot_core-0.9.3
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.38
	pure-rust-locales-0.5.6
	quote-1.0.18
	redox_syscall-0.2.13
	regex-1.5.5
	regex-syntax-0.6.25
	rust-embed-6.4.0
	rust-embed-impl-6.2.0
	rust-embed-utils-7.2.0
	rust-ini-0.18.0
	rustc-hash-1.1.0
	ryu-1.0.9
	same-file-1.0.6
	scopeguard-1.1.0
	self_cell-0.10.2
	serde-1.0.137
	serde_derive-1.0.137
	serde_json-1.0.81
	sha2-0.9.9
	signal-hook-0.3.13
	signal-hook-mio-0.2.3
	signal-hook-registry-1.4.0
	slab-0.4.6
	smallvec-1.8.0
	smart-default-0.6.0
	smawk-0.3.1
	socket2-0.4.5
	strsim-0.10.0
	syn-1.0.92
	textwrap-0.15.0
	thiserror-1.0.31
	thiserror-impl-1.0.31
	time-0.1.43
	tinystr-0.3.4
	tokio-1.18.2
	tokio-macros-1.7.0
	toml-0.5.9
	tui-0.18.0
	type-map-0.4.0
	typenum-1.15.0
	unic-langid-0.9.0
	unic-langid-impl-0.9.0
	unicode-linebreak-0.1.2
	unicode-segmentation-1.9.0
	unicode-width-0.1.9
	unicode-xid-0.2.3
	version_check-0.9.4
	walkdir-2.3.2
	wasi-0.10.2+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
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
	zeroize-1.5.5
"

inherit cargo

DESCRIPTION="TUI greeter for greetd login manager"
HOMEPAGE="https://github.com/apognu/tuigreet"

SRC_URI="https://github.com/apognu/tuigreet/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)"

QA_FLAGS_IGNORED="usr/bin/tuigreet"

LICENSE="Apache-2.0 Boost-1.0 GPL-3 MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~riscv"

RDEPEND="acct-group/greetd
	acct-user/greetd
	gui-libs/greetd"
DEPEND="${RDEPEND}"

src_install() {
	dodir /var/cache/${PN}
	fowners greetd:greetd /var/cache/${PN}

	cargo_src_install
}
