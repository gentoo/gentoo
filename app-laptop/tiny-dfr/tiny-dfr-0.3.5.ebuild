# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anyhow@1.0.75
	autocfg@1.1.0
	bitflags@1.3.2
	bitflags@2.6.0
	bumpalo@3.17.0
	bytemuck@1.14.0
	bytemuck_derive@1.5.0
	cairo-rs@0.20.1
	cairo-sys-rs@0.20.0
	cc@1.0.83
	cfg-expr@0.17.0
	cfg-if@1.0.0
	cfg_aliases@0.2.1
	chrono@0.4.40
	core-foundation-sys@0.8.7
	dirs-sys@0.4.1
	dirs@5.0.1
	drm-ffi@0.7.1
	drm-fourcc@2.2.0
	drm-sys@0.6.1
	drm@0.11.1
	equivalent@1.0.1
	errno@0.3.8
	freedesktop-icons@0.4.0
	freetype-rs@0.37.0
	freetype-sys@0.21.0
	futures-channel@0.3.28
	futures-core@0.3.28
	futures-executor@0.3.28
	futures-io@0.3.28
	futures-macro@0.3.28
	futures-task@0.3.28
	futures-util@0.3.28
	gdk-pixbuf-sys@0.20.7
	getrandom@0.2.10
	gio-sys@0.20.9
	gio@0.20.4
	glib-macros@0.20.4
	glib-sys@0.20.9
	glib@0.20.4
	gobject-sys@0.20.4
	hashbrown@0.14.5
	heck@0.5.0
	hermit-abi@0.3.2
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.63
	indexmap@2.5.0
	ini_core@0.2.0
	input-linux-sys@0.9.0
	input-linux@0.7.1
	input-sys@1.17.0
	input@0.8.3
	io-lifetimes@1.0.11
	js-sys@0.3.77
	libc@0.2.159
	libredox@0.1.3
	librsvg-rebind-sys@0.1.0
	librsvg-rebind@0.1.0
	libudev-sys@0.1.4
	linux-raw-sys@0.4.13
	linux-raw-sys@0.6.4
	log@0.4.20
	memchr@2.7.4
	memoffset@0.7.1
	nix@0.26.4
	nix@0.29.0
	num-traits@0.2.19
	once_cell@1.20.2
	option-ext@0.2.0
	pin-project-lite@0.2.13
	pin-utils@0.1.0
	pkg-config@0.3.27
	ppv-lite86@0.2.17
	privdrop@0.5.4
	proc-macro-crate@3.2.0
	proc-macro2@1.0.86
	pure-rust-locales@0.8.1
	quote@1.0.37
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	redox_users@0.4.6
	rustix@0.38.30
	rustversion@1.0.20
	serde@1.0.188
	serde_derive@1.0.188
	serde_spanned@0.6.4
	slab@0.4.9
	smallvec@1.13.2
	syn@2.0.79
	system-deps@7.0.3
	target-lexicon@0.12.16
	thiserror-impl@1.0.65
	thiserror@1.0.65
	toml@0.8.8
	toml_datetime@0.6.8
	toml_edit@0.21.0
	toml_edit@0.22.22
	tracing-attributes@0.1.28
	tracing-core@0.1.33
	tracing@0.1.41
	udev@0.7.0
	unicode-ident@1.0.11
	version-compare@0.2.0
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.100
	wasm-bindgen-macro-support@0.2.100
	wasm-bindgen-macro@0.2.100
	wasm-bindgen-shared@0.2.100
	wasm-bindgen@0.2.100
	windows-core@0.61.0
	windows-implement@0.60.0
	windows-interface@0.59.1
	windows-link@0.1.1
	windows-result@0.3.2
	windows-strings@0.4.0
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
	winnow@0.5.15
	winnow@0.6.20
	xdg@2.5.2
"

inherit cargo udev systemd linux-info

DESCRIPTION="The most basic dynamic function row daemon possible"
HOMEPAGE="https://github.com/AsahiLinux/tiny-dfr"

SRC_URI="
	${CARGO_CRATE_URIS}
	https://github.com/AsahiLinux/tiny-dfr/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

DEPEND="
	dev-libs/libinput
	gnome-base/librsvg
	x11-libs/pango
	x11-libs/gdk-pixbuf
"

RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="usr/bin/tiny-dfr"
QA_PRESTRIPPED="usr/bin/tiny-dfr"

pkg_setup() {
	linux-info_pkg_setup
	rust_pkg_setup
}

pkg_pretend() {
	local CONFIG_CHECK="~INPUT_UINPUT"
	[[ ${MERGE_TYPE} != buildonly ]] && check_extra_config
}

src_install() {
	cargo_src_install

	insinto /usr/share/tiny-dfr
	doins share/tiny-dfr/*

	udev_dorules etc/udev/rules.d/*
	systemd_dounit etc/systemd/system/*
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
