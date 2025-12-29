# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.88"
CRATES="
	anstream@0.6.21
	anstyle-parse@0.2.7
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.13
	anyhow@1.0.100
	async-broadcast@0.7.2
	async-channel@2.5.0
	async-executor@1.13.3
	async-io@2.6.0
	async-lock@3.4.1
	async-process@2.5.0
	async-recursion@1.1.1
	async-signal@0.2.13
	async-task@4.7.1
	async-trait@0.1.89
	atomic-waker@1.1.2
	autocfg@1.5.0
	bitflags@2.10.0
	block2@0.6.2
	blocking@1.6.2
	bumpalo@3.19.0
	bytes@1.11.0
	cfg-if@1.0.4
	cfg_aliases@0.2.1
	clap@4.5.53
	clap_builder@4.5.53
	clap_derive@4.5.49
	clap_lex@0.7.6
	colorchoice@1.0.4
	colored@3.0.0
	concurrent-queue@2.5.0
	crossbeam-utils@0.8.21
	ctrlc@3.5.1
	dispatch2@0.3.0
	endi@1.1.1
	enumflags2@0.7.12
	enumflags2_derive@0.7.12
	equivalent@1.0.2
	errno@0.3.14
	event-listener-strategy@0.5.4
	event-listener@5.4.1
	fastrand@2.3.0
	futures-core@0.3.31
	futures-io@0.3.31
	futures-lite@2.6.1
	futures-sink@0.3.31
	getrandom@0.3.4
	hashbrown@0.16.1
	heck@0.5.0
	hermit-abi@0.5.2
	hex@0.4.3
	indexmap@2.12.1
	is_terminal_polyfill@1.70.2
	js-sys@0.3.83
	libc@0.2.178
	linux-raw-sys@0.11.0
	log@0.4.29
	memchr@2.7.6
	memoffset@0.9.1
	mio@1.1.0
	nix@0.30.1
	ntapi@0.4.1
	objc2-core-foundation@0.3.2
	objc2-encode@4.1.0
	objc2-io-kit@0.3.2
	objc2@0.6.3
	once_cell@1.21.3
	once_cell_polyfill@1.70.2
	ordered-stream@0.2.0
	parking@2.2.1
	pin-project-lite@0.2.16
	piper@0.2.4
	polling@3.11.0
	proc-macro-crate@3.4.0
	proc-macro2@1.0.103
	quote@1.0.42
	r-efi@5.3.0
	rustix@1.1.2
	rustversion@1.0.22
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_repr@0.1.20
	serde_spanned@1.0.3
	signal-hook-registry@1.4.7
	slab@0.4.11
	socket2@0.6.1
	static_assertions@1.1.0
	strsim@0.11.1
	syn@2.0.111
	sysinfo@0.37.2
	tempfile@3.23.0
	terminal_size@0.4.3
	tokio-macros@2.6.0
	tokio-util@0.7.17
	tokio@1.48.0
	toml@0.9.8
	toml_datetime@0.7.3
	toml_edit@0.23.7
	toml_parser@1.0.4
	toml_writer@1.0.4
	tracing-attributes@0.1.31
	tracing-core@0.1.35
	tracing@0.1.43
	uds_windows@1.1.0
	unicase@2.8.1
	unicode-ident@1.0.22
	unicode-width@0.2.2
	utf8parse@0.2.2
	uuid@1.19.0
	wasi@0.11.1+wasi-snapshot-preview1
	wasip2@1.0.1+wasi-0.2.4
	wasm-bindgen-macro-support@0.2.106
	wasm-bindgen-macro@0.2.106
	wasm-bindgen-shared@0.2.106
	wasm-bindgen@0.2.106
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-collections@0.2.0
	windows-core@0.61.2
	windows-future@0.2.1
	windows-implement@0.60.2
	windows-interface@0.59.3
	windows-link@0.1.3
	windows-link@0.2.1
	windows-numerics@0.2.0
	windows-result@0.3.4
	windows-strings@0.4.2
	windows-sys@0.59.0
	windows-sys@0.60.2
	windows-sys@0.61.2
	windows-targets@0.52.6
	windows-targets@0.53.5
	windows-threading@0.1.0
	windows@0.61.3
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
	winnow@0.7.14
	wit-bindgen@0.46.0
	zbus@5.12.0
	zbus_macros@5.12.0
	zbus_names@4.2.0
	zbus_polkit@5.0.0
	zvariant@5.8.0
	zvariant_derive@5.8.0
	zvariant_utils@3.2.1
"

inherit cargo systemd

DESCRIPTION="DBUS on-demand loader of sched-ext schedulers"
HOMEPAGE="https://github.com/sched-ext/scx-loader"
SRC_URI="
	https://github.com/sched-ext/scx-loader/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="GPL-2"
# Dependent crate licenses
LICENSE+=" MIT MPL-2.0 Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="~sys-kernel/scx-${PV}"

QA_PREBUILT="
	usr/bin/scx_loader
	usr/bin/scxctl
"

src_install() {
	einstalldocs
	newdoc crates/scx_loader/README.md scx_loader.md
	newdoc crates/scxctl/README.md scxctl.md

	cargo_src_install --path crates/scx_loader
	cargo_src_install --path crates/scxctl

	newinitd "${FILESDIR}"/scx_loader.initd scx_loader
	systemd_dounit services/scx_loader.service

	insinto /usr/share/dbus-1/system/
	doins services/org.scx.Loader.service

	insinto /usr/share/dbus-1/system.d/
	doins configs/org.scx.Loader.conf

	insinto /usr/share/dbus-1/interfaces/
	doins configs/org.scx.Loader.xml

	insinto /usr/share/polkit-1/actions/
	doins configs/org.scx.Loader.policy

	insinto /etc/scx_loader/
	newins configs/scx_loader.toml config.toml
}
