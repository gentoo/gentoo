# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils xdg-utils

CRATES="
	addr2line@0.21.0
	adler@1.0.2
	aho-corasick@1.1.2
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.6.12
	anstyle-parse@0.2.3
	anstyle-query@1.0.2
	anstyle-wincon@3.0.2
	anstyle@1.0.6
	anyhow@1.0.80
	async-trait@0.1.77
	autocfg@1.1.0
	backtrace@0.3.69
	base64@0.21.7
	bitflags@1.3.2
	bitflags@2.4.2
	block-buffer@0.10.4
	block@0.1.6
	bumpalo@3.15.2
	bytes@1.5.0
	cairo-rs@0.19.2
	cairo-sys-rs@0.19.2
	cc@1.0.86
	cfg-expr@0.15.7
	cfg-if@1.0.0
	chrono-tz-build@0.2.1
	chrono-tz@0.8.6
	chrono@0.4.34
	colorchoice@1.0.0
	core-foundation-sys@0.8.6
	core-foundation@0.9.4
	crypto-common@0.1.6
	digest@0.10.7
	env_filter@0.1.0
	env_logger@0.11.2
	equivalent@1.0.1
	field-offset@0.3.6
	fnv@1.0.7
	futures-channel@0.3.30
	futures-core@0.3.30
	futures-executor@0.3.30
	futures-io@0.3.30
	futures-macro@0.3.30
	futures-task@0.3.30
	futures-util@0.3.30
	gdk-pixbuf-sys@0.19.0
	gdk-pixbuf@0.19.2
	gdk4-sys@0.8.0
	gdk4@0.8.0
	generic-array@0.14.7
	getrandom@0.2.12
	gettext-rs@0.7.0
	gettext-sys@0.21.3
	gimli@0.28.1
	gio-sys@0.19.0
	gio@0.19.2
	glib-macros@0.19.2
	glib-sys@0.19.0
	glib@0.19.2
	gobject-sys@0.19.0
	graphene-rs@0.19.2
	graphene-sys@0.19.0
	gsk4-sys@0.8.0
	gsk4@0.8.0
	gtk4-macros@0.8.0
	gtk4-sys@0.8.0
	gtk4@0.8.0
	hafas-rs@0.2.3
	hashbrown@0.14.3
	heck@0.4.1
	hermit-abi@0.3.6
	hex@0.4.3
	http-body@0.4.6
	http@0.2.11
	httparse@1.8.0
	httpdate@1.0.3
	humantime@2.1.0
	hyper-rustls@0.24.2
	hyper@0.14.28
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.60
	indexmap@2.2.3
	itoa@1.0.10
	js-sys@0.3.68
	lazy_static@1.4.0
	libadwaita-sys@0.6.0
	libadwaita@0.6.0
	libc@0.2.153
	locale_config@0.3.0
	log@0.4.20
	malloc_buf@0.0.6
	md-5@0.10.6
	memchr@2.7.1
	memoffset@0.9.0
	miniz_oxide@0.7.2
	mio@0.8.11
	num-traits@0.2.18
	num_cpus@1.16.0
	objc-foundation@0.1.1
	objc@0.2.7
	objc_id@0.1.1
	object@0.32.2
	once_cell@1.19.0
	openssl-probe@0.1.5
	pango-sys@0.19.0
	pango@0.19.2
	parse-zoneinfo@0.3.0
	phf@0.11.2
	phf_codegen@0.11.2
	phf_generator@0.11.2
	phf_shared@0.11.2
	pin-project-lite@0.2.13
	pin-utils@0.1.0
	pkg-config@0.3.30
	proc-macro-crate@3.1.0
	proc-macro-error-attr@1.0.4
	proc-macro-error@1.0.4
	proc-macro2@1.0.78
	quote@1.0.35
	rand@0.8.5
	rand_core@0.6.4
	regex-automata@0.4.5
	regex-syntax@0.8.2
	regex@1.10.3
	ring@0.17.8
	rustc-demangle@0.1.23
	rustc_version@0.4.0
	rustls-native-certs@0.6.3
	rustls-pemfile@1.0.4
	rustls-webpki@0.101.7
	rustls@0.21.11
	ryu@1.0.17
	schannel@0.1.23
	sct@0.7.1
	security-framework-sys@2.9.1
	security-framework@2.9.2
	semver@1.0.22
	serde@1.0.197
	serde_derive@1.0.197
	serde_json@1.0.114
	serde_repr@0.1.18
	serde_spanned@0.6.5
	siphasher@0.3.11
	slab@0.4.9
	smallvec@1.13.1
	socket2@0.5.5
	spin@0.9.8
	syn@1.0.109
	syn@2.0.50
	system-deps@6.2.0
	target-lexicon@0.12.13
	temp-dir@0.1.12
	thiserror-impl@1.0.57
	thiserror@1.0.57
	tokio-macros@2.2.0
	tokio-rustls@0.24.1
	tokio@1.36.0
	toml@0.8.2
	toml_datetime@0.6.5
	toml_edit@0.20.2
	toml_edit@0.21.1
	tower-service@0.3.2
	tracing-core@0.1.32
	tracing@0.1.40
	try-lock@0.2.5
	typenum@1.17.0
	unicode-ident@1.0.12
	untrusted@0.9.0
	utf8parse@0.2.1
	version-compare@0.1.1
	version_check@0.9.4
	want@0.3.1
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.91
	wasm-bindgen-macro-support@0.2.91
	wasm-bindgen-macro@0.2.91
	wasm-bindgen-shared@0.2.91
	wasm-bindgen@0.2.91
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.48.5
	windows-targets@0.52.0
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.0
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.0
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.0
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.0
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.0
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.0
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.0
	winnow@0.5.40
"

inherit cargo meson

DESCRIPTION="Travel with all your train information in one place"
HOMEPAGE="
	https://mobile.schmidhuberj.de/railway/
	https://gitlab.com/schmiddi-on-mobile/railway/
"
SRC_URI="
	https://gitlab.com/schmiddi-on-mobile/railway/-/archive/${PV}/${P}.tar.bz2
	${CARGO_CRATE_URIS}
"

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions ISC MIT Unicode-DFS-2016
	|| ( AGPL-3+ EUPL-1.2 )
"
# ring
LICENSE+=" openssl"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/glib-2.66
	>=gui-libs/gtk-4.0.0:4
	gui-libs/libadwaita
	media-libs/graphene
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-libs/glib
	sys-devel/gettext
"

BUILD_DIR=${WORKDIR}/build
ECARGO_HOME=${BUILD_DIR}/cargo-home

QA_PREBUILT=usr/bin/diebahn

src_prepare() {
	default

	sed -e "s:get_option('profile.*:$(usex debug false true):" \
		-i src/meson.build || die
}

src_install() {
	meson_src_install
	dosym diebahn /usr/bin/railway
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_icon_cache_update
}
