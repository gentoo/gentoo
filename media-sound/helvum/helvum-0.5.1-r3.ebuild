# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.1
	anyhow@1.0.75
	autocfg@1.1.0
	bindgen@0.66.1
	bitflags@1.3.2
	bitflags@2.4.0
	cairo-rs@0.18.2
	cairo-sys-rs@0.18.2
	cc@1.0.83
	cexpr@0.6.0
	cfg-expr@0.15.5
	cfg-if@1.0.0
	clang-sys@1.6.1
	convert_case@0.6.0
	cookie-factory@0.3.2
	equivalent@1.0.1
	field-offset@0.3.6
	futures-channel@0.3.28
	futures-core@0.3.28
	futures-executor@0.3.28
	futures-io@0.3.28
	futures-macro@0.3.28
	futures-task@0.3.28
	futures-util@0.3.28
	gdk-pixbuf-sys@0.18.0
	gdk-pixbuf@0.18.0
	gdk4-sys@0.7.2
	gdk4@0.7.3
	gio-sys@0.18.1
	gio@0.18.2
	glib-macros@0.18.2
	glib-sys@0.18.1
	glib@0.18.2
	glob@0.3.1
	gobject-sys@0.18.0
	graphene-rs@0.18.1
	graphene-sys@0.18.1
	gsk4-sys@0.7.3
	gsk4@0.7.3
	gtk4-macros@0.7.2
	gtk4-sys@0.7.3
	gtk4@0.7.3
	hashbrown@0.14.0
	heck@0.4.1
	indexmap@2.0.1
	lazy_static@1.4.0
	lazycell@1.3.0
	libadwaita-sys@0.5.3
	libadwaita@0.5.3
	libc@0.2.148
	libloading@0.7.4
	libspa-sys@0.7.2
	libspa@0.7.2
	log@0.4.20
	memchr@2.6.3
	memoffset@0.7.1
	memoffset@0.9.0
	minimal-lexical@0.2.1
	nix@0.26.4
	nom@7.1.3
	once_cell@1.18.0
	pango-sys@0.18.0
	pango@0.18.0
	peeking_take_while@0.1.2
	pin-project-lite@0.2.13
	pin-utils@0.1.0
	pipewire-sys@0.7.2
	pipewire@0.7.2
	pkg-config@0.3.27
	proc-macro-crate@1.3.1
	proc-macro-error-attr@1.0.4
	proc-macro-error@1.0.4
	proc-macro2@1.0.67
	quote@1.0.33
	regex-automata@0.3.8
	regex-syntax@0.7.5
	regex@1.9.5
	rustc-hash@1.1.0
	rustc_version@0.4.0
	semver@1.0.19
	serde@1.0.188
	serde_derive@1.0.188
	serde_spanned@0.6.3
	shlex@1.2.0
	slab@0.4.9
	smallvec@1.11.1
	syn@1.0.109
	syn@2.0.37
	system-deps@6.1.1
	target-lexicon@0.12.11
	thiserror-impl@1.0.49
	thiserror@1.0.49
	toml@0.7.8
	toml_datetime@0.6.3
	toml_edit@0.19.15
	unicode-ident@1.0.12
	unicode-segmentation@1.10.1
	version-compare@0.1.1
	version_check@0.9.4
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	winnow@0.5.15
"

LLVM_COMPAT=( {16..18} )

inherit cargo desktop llvm-r1 xdg

DESCRIPTION="A GTK patchbay for pipewire"
HOMEPAGE="https://gitlab.freedesktop.org/pipewire/helvum"
SRC_URI="
	https://gitlab.freedesktop.org/pipewire/helvum/-/archive/${PV}/${P}.tar.bz2
	${CARGO_CRATE_URIS}
"

LICENSE="GPL-3"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD ISC MIT
	Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="~amd64"

# Clang needed for bindgen
BDEPEND="
	>=dev-build/meson-0.59.0
	$(llvm_gen_dep '
		sys-devel/clang:${LLVM_SLOT}=
		sys-devel/llvm:${LLVM_SLOT}=
		virtual/rust:0/llvm-${LLVM_SLOT}
	')
	virtual/pkgconfig
"
DEPEND="
	>=dev-libs/glib-2.66:2
	>=gui-libs/gtk-4.4.0:4
	>=gui-libs/libadwaita-1.3:1
	media-libs/graphene
	>=media-video/pipewire-0.3:=
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_install() {
	cargo_src_install

	dodoc README.md

	doicon --size scalable data/icons/org.pipewire.Helvum.svg

	insopts -m 0644
	insinto /usr/share/icons/hicolor/symbolic/apps
	doins data/icons/org.pipewire.Helvum-symbolic.svg

	make_desktop_entry "${PN}" Helvum org.pipewire.Helvum \
		"AudioVideo;Audio;Video;Midi;Settings;GNOME;GTK" "Terminal=false\nGenericName=Patchbay"
}

pkg_postinst() {
	xdg_pkg_postinst
	xdg_icon_cache_update
}
