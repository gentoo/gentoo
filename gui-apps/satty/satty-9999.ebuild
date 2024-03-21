# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.21.0
	adler@1.0.2
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.6.13
	anstyle-parse@0.2.3
	anstyle-query@1.0.2
	anstyle-wincon@3.0.2
	anstyle@1.0.6
	anyhow@1.0.80
	arrayvec@0.7.4
	async-trait@0.1.77
	autocfg@1.1.0
	backtrace@0.3.69
	bitflags@1.3.2
	bitflags@2.4.2
	bumpalo@3.15.3
	bytemuck@1.14.3
	byteorder@1.5.0
	bytes@1.5.0
	cairo-rs@0.17.10
	cairo-sys-rs@0.17.10
	cc@1.0.88
	cfg-expr@0.15.7
	cfg-if@1.0.0
	chrono@0.4.34
	clap@4.5.1
	clap_builder@4.5.1
	clap_complete@4.5.1
	clap_complete_fig@4.5.0
	clap_complete_nushell@4.5.1
	clap_derive@4.5.0
	clap_lex@0.7.0
	color_quant@1.1.0
	colorchoice@1.0.0
	core-foundation-sys@0.8.6
	crc32fast@1.4.0
	epoxy@0.1.0
	equivalent@1.0.1
	femtovg@0.8.2
	field-offset@0.3.6
	flate2@1.0.28
	flume@0.10.14
	fnv@1.0.7
	fragile@2.0.0
	futures-channel@0.3.30
	futures-core@0.3.30
	futures-executor@0.3.30
	futures-io@0.3.30
	futures-macro@0.3.30
	futures-sink@0.3.30
	futures-task@0.3.30
	futures-util@0.3.30
	futures@0.3.30
	gdk-pixbuf-sys@0.17.10
	gdk-pixbuf@0.17.10
	gdk4-sys@0.6.3
	gdk4@0.6.3
	generational-arena@0.2.9
	getrandom@0.2.12
	gimli@0.28.1
	gio-sys@0.17.10
	gio-sys@0.19.0
	gio@0.17.10
	gl_generator@0.9.0
	glib-macros@0.17.10
	glib-macros@0.19.2
	glib-sys@0.17.10
	glib-sys@0.19.0
	glib@0.17.10
	glib@0.19.2
	glow@0.13.1
	gobject-sys@0.17.10
	gobject-sys@0.19.0
	graphene-rs@0.17.10
	graphene-sys@0.17.10
	gsk4-sys@0.6.3
	gsk4@0.6.3
	gtk4-macros@0.6.6
	gtk4-sys@0.6.3
	gtk4@0.6.6
	gvdb@0.4.2
	hashbrown@0.14.3
	heck@0.4.1
	hermit-abi@0.3.8
	hex_color@3.0.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.60
	image@0.24.9
	imgref@1.10.1
	indexmap@2.2.3
	itoa@1.0.10
	js-sys@0.3.68
	khronos_api@2.2.0
	lazy_static@1.4.0
	libadwaita-sys@0.4.4
	libadwaita@0.4.4
	libc@0.2.153
	libloading@0.8.1
	lock_api@0.4.11
	log@0.4.20
	lru@0.12.3
	memchr@2.7.1
	memmap2@0.7.1
	memoffset@0.9.0
	miniz_oxide@0.7.2
	mio@0.8.10
	nanorand@0.7.0
	num-traits@0.2.18
	num_cpus@1.16.0
	object@0.32.2
	once_cell@1.19.0
	pango-sys@0.17.10
	pango@0.17.10
	parking_lot@0.12.1
	parking_lot_core@0.9.9
	pin-project-internal@1.1.4
	pin-project-lite@0.2.13
	pin-project@1.1.4
	pin-utils@0.1.0
	pkg-config@0.3.30
	ppv-lite86@0.2.17
	proc-macro-crate@1.3.1
	proc-macro-crate@3.1.0
	proc-macro-error-attr@1.0.4
	proc-macro-error@1.0.4
	proc-macro2@1.0.78
	quick-xml@0.29.0
	quote@1.0.35
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	redox_syscall@0.4.1
	relm4-icons@0.6.0
	relm4-macros@0.6.2
	relm4@0.6.2
	resource@0.5.0
	rgb@0.8.37
	rustc-demangle@0.1.23
	rustc_version@0.4.0
	rustybuzz@0.11.0
	ryu@1.0.17
	safe-transmute@0.11.2
	same-file@1.0.6
	scopeguard@1.2.0
	semver@1.0.22
	serde@1.0.197
	serde_derive@1.0.197
	serde_json@1.0.114
	serde_spanned@0.6.5
	shared_library@0.1.9
	signal-hook-registry@1.4.1
	slab@0.4.9
	slotmap@1.0.7
	smallvec@1.13.1
	socket2@0.5.6
	spin@0.9.8
	static_assertions@1.1.0
	strsim@0.11.0
	syn@1.0.109
	syn@2.0.51
	system-deps@6.2.0
	target-lexicon@0.12.14
	thiserror-impl@1.0.57
	thiserror@1.0.57
	tokio-macros@2.2.0
	tokio@1.36.0
	toml@0.8.10
	toml_datetime@0.6.5
	toml_edit@0.19.15
	toml_edit@0.21.1
	toml_edit@0.22.6
	tracing-attributes@0.1.27
	tracing-core@0.1.32
	tracing@0.1.40
	ttf-parser@0.20.0
	unicode-bidi-mirroring@0.1.0
	unicode-bidi@0.3.15
	unicode-ccc@0.1.2
	unicode-ident@1.0.12
	unicode-properties@0.1.1
	unicode-script@0.5.6
	unicode-segmentation@1.11.0
	utf8parse@0.2.1
	version-compare@0.1.1
	version_check@0.9.4
	walkdir@2.4.0
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.91
	wasm-bindgen-macro-support@0.2.91
	wasm-bindgen-macro@0.2.91
	wasm-bindgen-shared@0.2.91
	wasm-bindgen@0.2.91
	web-sys@0.3.68
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.48.5
	windows-targets@0.52.3
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.3
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.3
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.3
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.3
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.3
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.3
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.3
	winnow@0.5.40
	winnow@0.6.2
	xdg@2.5.2
	xml-rs@0.7.0
	zvariant@3.15.2
	zvariant_derive@3.15.2
	zvariant_utils@1.0.1
"

inherit cargo desktop xdg

DESCRIPTION="A screenshot annotation tool inspired by Swappy and Flameshot."
HOMEPAGE="https://github.com/gabm/satty"

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gabm/Satty.git"
else
	SRC_URI="
		https://github.com/gabm/Satty/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		${CARGO_CRATE_URIS}
	"
	M_PN=Satty
	S="${WORKDIR}/${M_PN}-${PV}"
	KEYWORDS="~amd64"
fi

LICENSE="MPL-2.0"
SLOT="0"

RDEPEND="virtual/rust
		dev-libs/glib:2
		media-libs/libepoxy
		media-libs/mesa[opengl]
		gui-libs/libadwaita
		gui-libs/gtk:4
		x11-libs/gdk-pixbuf:2
"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_unpack() {
	if [[ "${PV}" == 9999 ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

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
