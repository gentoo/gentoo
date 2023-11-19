# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line-0.21.0
	adler-1.0.2
	anstream-0.6.4
	anstyle-1.0.4
	anstyle-parse-0.2.2
	anstyle-query-1.0.0
	anstyle-wincon-3.0.1
	anyhow-1.0.75
	async-trait-0.1.74
	autocfg-1.1.0
	backtrace-0.3.69
	bitflags-1.3.2
	bumpalo-3.14.0
	byteorder-1.5.0
	bytes-1.5.0
	cairo-rs-0.17.10
	cairo-sys-rs-0.17.10
	cc-1.0.83
	cfg-expr-0.15.5
	cfg-if-1.0.0
	clap-4.4.7
	clap_builder-4.4.7
	clap_derive-4.4.7
	clap_lex-0.6.0
	colorchoice-1.0.0
	crc32fast-1.3.2
	equivalent-1.0.1
	field-offset-0.3.6
	flate2-1.0.28
	flume-0.10.14
	fragile-2.0.0
	futures-0.3.29
	futures-channel-0.3.29
	futures-core-0.3.29
	futures-executor-0.3.29
	futures-io-0.3.29
	futures-macro-0.3.29
	futures-sink-0.3.29
	futures-task-0.3.29
	futures-util-0.3.29
	gdk-pixbuf-0.17.10
	gdk-pixbuf-sys-0.17.10
	gdk4-0.6.3
	gdk4-sys-0.6.3
	getrandom-0.2.10
	gimli-0.28.0
	gio-0.17.10
	gio-sys-0.17.10
	glib-0.17.10
	glib-macros-0.17.10
	glib-sys-0.17.10
	gobject-sys-0.17.10
	graphene-rs-0.17.10
	graphene-sys-0.17.10
	gsk4-0.6.3
	gsk4-sys-0.6.3
	gtk4-0.6.6
	gtk4-macros-0.6.6
	gtk4-sys-0.6.3
	gvdb-0.4.2
	hashbrown-0.14.2
	heck-0.4.1
	hermit-abi-0.3.3
	indexmap-2.1.0
	itoa-1.0.9
	js-sys-0.3.65
	lazy_static-1.4.0
	libadwaita-0.4.4
	libadwaita-sys-0.4.4
	libc-0.2.150
	lock_api-0.4.11
	log-0.4.20
	memchr-2.6.4
	memmap2-0.7.1
	memoffset-0.9.0
	miniz_oxide-0.7.1
	mio-0.8.9
	nanorand-0.7.0
	num_cpus-1.16.0
	object-0.32.1
	once_cell-1.18.0
	pango-0.17.10
	pango-sys-0.17.10
	pangocairo-0.17.10
	pangocairo-sys-0.17.10
	parking_lot-0.12.1
	parking_lot_core-0.9.9
	pin-project-1.1.3
	pin-project-internal-1.1.3
	pin-project-lite-0.2.13
	pin-utils-0.1.0
	pkg-config-0.3.27
	proc-macro-crate-1.3.1
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.69
	quick-xml-0.29.0
	quote-1.0.33
	redox_syscall-0.4.1
	relm4-0.6.2
	relm4-icons-0.6.0
	relm4-macros-0.6.2
	rustc-demangle-0.1.23
	rustc_version-0.4.0
	ryu-1.0.15
	safe-transmute-0.11.2
	same-file-1.0.6
	scopeguard-1.2.0
	semver-1.0.20
	serde-1.0.192
	serde_derive-1.0.192
	serde_json-1.0.108
	serde_spanned-0.6.4
	signal-hook-registry-1.4.1
	slab-0.4.9
	smallvec-1.11.1
	socket2-0.5.5
	spin-0.9.8
	static_assertions-1.1.0
	strsim-0.10.0
	syn-1.0.109
	syn-2.0.39
	system-deps-6.2.0
	target-lexicon-0.12.12
	thiserror-1.0.50
	thiserror-impl-1.0.50
	tokio-1.33.0
	tokio-macros-2.1.0
	toml-0.8.8
	toml_datetime-0.6.5
	toml_edit-0.19.15
	toml_edit-0.21.0
	tracing-0.1.40
	tracing-attributes-0.1.27
	tracing-core-0.1.32
	unicode-ident-1.0.12
	utf8parse-0.2.1
	version-compare-0.1.1
	version_check-0.9.4
	walkdir-2.4.0
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.88
	wasm-bindgen-backend-0.2.88
	wasm-bindgen-macro-0.2.88
	wasm-bindgen-macro-support-0.2.88
	wasm-bindgen-shared-0.2.88
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.6
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.48.0
	windows-targets-0.48.5
	windows_aarch64_gnullvm-0.48.5
	windows_aarch64_msvc-0.48.5
	windows_i686_gnu-0.48.5
	windows_i686_msvc-0.48.5
	windows_x86_64_gnu-0.48.5
	windows_x86_64_gnullvm-0.48.5
	windows_x86_64_msvc-0.48.5
	winnow-0.5.19
	zvariant-3.15.0
	zvariant_derive-3.15.0
	zvariant_utils-1.0.1
"

inherit cargo desktop xdg

DESCRIPTION="A screenshot annotation tool inspired by Swappy and Flameshot."
HOMEPAGE="https://github.com/gabm/satty"
SRC_URI="
		https://github.com/gabm/Satty/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		${CARGO_CRATE_URIS}"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

M_PN=Satty
S="${WORKDIR}/${M_PN}-${PV}"

RDEPEND="virtual/rust
		x11-libs/pango
		dev-libs/glib:2
		x11-libs/cairo
		gui-libs/libadwaita
		gui-libs/gtk:4
		x11-libs/gdk-pixbuf:2
"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_install() {
	dodoc README.md

	if use debug ; then
		cd target/debug || die
	else
		cd target/release  || die
	fi

	dobin satty
	#Just add the icon and desktop file
	doicon "${S}/assets/satty.svg"
	domenu "${S}/satty.desktop"
}
