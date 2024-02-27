# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler32@1.2.0
	anyhow@1.0.75
	apple-nvram@0.2.1
	asahi-bless@0.2.1
	autocfg@1.1.0
	bitflags@1.3.2
	bitflags@2.4.1
	cairo-rs@0.18.3
	cairo-sys-rs@0.18.2
	cfg-expr@0.15.5
	cfg-if@1.0.0
	crc-catalog@2.4.0
	crc32fast@1.3.2
	crc@3.0.1
	equivalent@1.0.1
	field-offset@0.3.6
	futures-channel@0.3.29
	futures-core@0.3.29
	futures-executor@0.3.29
	futures-io@0.3.29
	futures-macro@0.3.29
	futures-task@0.3.29
	futures-util@0.3.29
	gdk-pixbuf-sys@0.18.0
	gdk-pixbuf@0.18.3
	gdk4-sys@0.7.2
	gdk4@0.7.3
	getrandom@0.2.11
	gio-sys@0.18.1
	gio@0.18.4
	glib-build-tools@0.18.0
	glib-macros@0.18.3
	glib-sys@0.18.1
	glib@0.18.4
	gobject-sys@0.18.0
	gpt@3.1.0
	graphene-rs@0.18.1
	graphene-sys@0.18.1
	gsk4-sys@0.7.3
	gsk4@0.7.3
	gtk4-macros@0.7.2
	gtk4-sys@0.7.3
	gtk4@0.7.3
	hashbrown@0.14.3
	heck@0.4.1
	indexmap@2.1.0
	libadwaita-sys@0.5.3
	libadwaita@0.5.3
	libc@0.2.151
	log@0.4.20
	memchr@2.6.4
	memoffset@0.7.1
	memoffset@0.9.0
	nix@0.26.4
	once_cell@1.19.0
	pango-sys@0.18.0
	pango@0.18.3
	pin-project-lite@0.2.13
	pin-utils@0.1.0
	pkg-config@0.3.27
	ppv-lite86@0.2.17
	proc-macro-crate@1.3.1
	proc-macro-crate@2.0.1
	proc-macro-error-attr@1.0.4
	proc-macro-error@1.0.4
	proc-macro2@1.0.70
	quote@1.0.33
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rustc_version@0.4.0
	semver@1.0.20
	serde@1.0.193
	serde_derive@1.0.193
	serde_spanned@0.6.4
	slab@0.4.9
	smallvec@1.11.2
	sudo@0.6.0
	syn@1.0.109
	syn@2.0.41
	system-deps@6.2.0
	target-lexicon@0.12.12
	thiserror-impl@1.0.50
	thiserror@1.0.50
	toml@0.8.2
	toml_datetime@0.6.3
	toml_edit@0.19.15
	toml_edit@0.20.2
	unicode-ident@1.0.12
	uuid@1.6.1
	version-compare@0.1.1
	version_check@0.9.4
	wasi@0.11.0+wasi-snapshot-preview1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	winnow@0.5.28
"

inherit cargo xdg

DESCRIPTION="Interface to choose the startup volume on Apple Silicon systems"
HOMEPAGE="https://gitlab.gnome.org/davide125/startup-disk"
SRC_URI="
	${CARGO_CRATE_URIS}
	https://gitlab.gnome.org/davide125/startup-disk/-/archive/${PV}/startup-disk-${PV}.tar.gz -> ${P}.tar.gz
"
S="${WORKDIR}/startup-disk-${PV}"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0-with-LLVM-exceptions MIT Unicode-DFS-2016 ZLIB"
SLOT="0"
KEYWORDS="~arm64"

RDEPEND="
	>=dev-libs/glib-2.78.3
	>=x11-libs/cairo-1.18.0
	>=gui-libs/libadwaita-1.4.2
	gui-libs/gtk:4[X]
"
DEPEND="
	${RDEPEND}
"

src_install() {
	emake DESTDIR="${D}" install-bin install-data
}
