# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.95"
CRATES="
	anstream@1.0.0
	anstyle-parse@1.0.0
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.14
	anyhow@1.0.103
	async-broadcast@0.7.2
	async-channel@2.5.0
	async-executor@1.14.0
	async-io@2.6.0
	async-lock@3.4.2
	async-process@2.5.0
	async-recursion@1.1.1
	async-signal@0.2.14
	async-task@4.7.1
	async-trait@0.1.89
	atomic-waker@1.1.2
	autocfg@1.5.1
	bitflags@2.13.0
	block2@0.6.2
	blocking@1.6.2
	bumpalo@3.20.3
	bytes@1.12.0
	cfg-if@1.0.4
	cfg_aliases@0.2.1
	clap@4.6.1
	clap_builder@4.6.0
	clap_derive@4.6.1
	clap_lex@1.1.0
	colorchoice@1.0.5
	colored@3.1.1
	concurrent-queue@2.5.0
	crossbeam-utils@0.8.21
	ctrlc@3.5.2
	dispatch2@0.3.1
	endi@1.1.1
	enumflags2@0.7.12
	enumflags2_derive@0.7.12
	equivalent@1.0.2
	errno@0.3.14
	event-listener-strategy@0.5.4
	event-listener@5.4.1
	fastrand@2.4.1
	futures-core@0.3.32
	futures-io@0.3.32
	futures-lite@2.6.1
	futures-sink@0.3.32
	futures-task@0.3.32
	futures-util@0.3.32
	getrandom@0.4.3
	hashbrown@0.17.1
	heck@0.5.0
	hermit-abi@0.5.2
	hex@0.4.3
	indexmap@2.14.0
	is_terminal_polyfill@1.70.2
	js-sys@0.3.103
	libc@0.2.186
	linux-raw-sys@0.12.1
	log@0.4.33
	memchr@2.8.2
	memoffset@0.9.1
	mio@1.2.1
	nix@0.31.3
	ntapi@0.4.3
	objc2-core-foundation@0.3.2
	objc2-encode@4.1.0
	objc2-foundation@0.3.2
	objc2-io-kit@0.3.2
	objc2-open-directory@0.3.2
	objc2@0.6.4
	once_cell@1.21.4
	once_cell_polyfill@1.70.2
	ordered-stream@0.2.0
	parking@2.2.1
	pin-project-lite@0.2.17
	piper@0.2.5
	polling@3.11.0
	proc-macro-crate@3.5.0
	proc-macro2@1.0.106
	quote@1.0.46
	r-efi@6.0.0
	rustix@1.1.4
	rustversion@1.0.22
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_repr@0.1.20
	serde_spanned@1.1.1
	signal-hook-registry@1.4.8
	slab@0.4.12
	socket2@0.6.4
	static_assertions@1.1.0
	strsim@0.11.1
	syn@2.0.118
	sysinfo@0.39.5
	tempfile@3.27.0
	terminal_size@0.4.4
	tokio-macros@2.7.0
	tokio-util@0.7.18
	tokio@1.52.3
	toml@1.1.2+spec-1.1.0
	toml_datetime@1.1.1+spec-1.1.0
	toml_edit@0.25.12+spec-1.1.0
	toml_parser@1.1.2+spec-1.1.0
	toml_writer@1.1.1+spec-1.1.0
	tracing-attributes@0.1.31
	tracing-core@0.1.36
	tracing@0.1.44
	uds_windows@1.2.1
	unicase@2.9.0
	unicode-ident@1.0.24
	unicode-width@0.2.2
	utf8parse@0.2.2
	uuid@1.23.4
	wasi@0.11.1+wasi-snapshot-preview1
	wasm-bindgen-macro-support@0.2.126
	wasm-bindgen-macro@0.2.126
	wasm-bindgen-shared@0.2.126
	wasm-bindgen@0.2.126
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-collections@0.3.2
	windows-core@0.62.2
	windows-future@0.3.2
	windows-implement@0.60.2
	windows-interface@0.59.3
	windows-link@0.2.1
	windows-numerics@0.3.1
	windows-result@0.4.1
	windows-strings@0.5.1
	windows-sys@0.61.2
	windows-threading@0.2.1
	windows@0.62.2
	winnow@1.0.3
	zbus@5.16.0
	zbus_macros@5.16.0
	zbus_names@4.3.2
	zbus_polkit@5.0.0
	zvariant@5.12.0
	zvariant_derive@5.12.0
	zvariant_utils@3.4.0
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
