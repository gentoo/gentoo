# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.3
	async-channel@2.5.0
	async-recursion@1.1.1
	autocfg@1.5.0
	bimap@0.6.3
	bitflags@2.11.1
	block@0.1.6
	bstr@1.12.1
	cairo-rs@0.22.0
	cairo-sys-rs@0.22.0
	cc@1.2.37
	cfg-expr@0.20.2
	cfg-if@1.0.3
	concurrent-queue@2.5.0
	crossbeam-utils@0.8.21
	encoding_rs@0.8.35
	encoding_rs_io@0.1.7
	equivalent@1.0.2
	errno@0.3.14
	event-listener-strategy@0.5.4
	event-listener@5.4.1
	fastrand@2.3.0
	field-offset@0.3.6
	find-msvc-tools@0.1.1
	fnv@1.0.7
	futures-channel@0.3.31
	futures-core@0.3.31
	futures-executor@0.3.31
	futures-io@0.3.31
	futures-macro@0.3.31
	futures-sink@0.3.31
	futures-task@0.3.31
	futures-util@0.3.31
	futures@0.3.31
	gdk-pixbuf-sys@0.22.0
	gdk-pixbuf@0.22.0
	gdk4-sys@0.11.2
	gdk4@0.11.2
	getrandom@0.3.3
	gettext-rs@0.7.2
	gettext-sys@0.22.5
	gio-sys@0.22.0
	gio@0.22.6
	glib-macros@0.22.6
	glib-sys@0.22.6
	glib@0.22.7
	glob@0.3.3
	globset@0.4.18
	gobject-sys@0.22.6
	graphene-rs@0.22.0
	graphene-sys@0.22.0
	grep-cli@0.1.12
	grep-matcher@0.1.8
	grep-printer@0.3.1
	grep-regex@0.1.14
	grep-searcher@0.1.16
	grep@0.4.1
	gsk4-sys@0.11.1
	gsk4@0.11.1
	gtk4-macros@0.11.0
	gtk4-sys@0.11.3
	gtk4@0.11.3
	hashbrown@0.15.5
	heck@0.5.0
	indexmap@2.11.1
	io-lifetimes@2.0.4
	itoa@1.0.17
	lazy_static@1.5.0
	libc@0.2.175
	linux-raw-sys@0.11.0
	locale_config@0.3.0
	log@0.4.29
	malloc_buf@0.0.6
	memchr@2.8.0
	memmap2@0.9.8
	memoffset@0.9.1
	objc-foundation@0.1.1
	objc@0.2.7
	objc_id@0.1.1
	once_cell@1.21.3
	pango-sys@0.22.0
	pango@0.22.6
	parking@2.2.1
	pin-project-lite@0.2.16
	pin-utils@0.1.0
	pkg-config@0.3.32
	proc-macro-crate@3.3.0
	proc-macro2@1.0.101
	quick-error@1.2.3
	quote@1.0.40
	r-efi@5.3.0
	regex-automata@0.4.10
	regex-syntax@0.8.6
	regex@1.11.2
	rustc_version@0.4.1
	rustix@1.1.2
	rusty-fork@0.3.0
	semver@1.0.27
	serde@1.0.223
	serde_core@1.0.223
	serde_derive@1.0.223
	serde_json@1.0.149
	serde_spanned@0.6.9
	shlex@1.3.0
	slab@0.4.11
	smallvec@1.15.1
	syn@2.0.117
	system-deps@7.0.5
	target-lexicon@0.13.2
	temp-dir@0.1.16
	tempfile@3.22.0
	termcolor@1.4.1
	toml@0.8.23
	toml_datetime@0.6.11
	toml_edit@0.22.27
	unicode-ident@1.0.19
	unicode-segmentation@1.12.0
	version-compare@0.2.0
	vte4-sys@0.10.0
	vte4@0.10.0
	wait-timeout@0.2.1
	wasi@0.14.5+wasi-0.2.4
	wasip2@1.0.0+wasi-0.2.4
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.11
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-link@0.2.0
	windows-sys@0.61.0
	winnow@0.7.13
	wit-bindgen@0.45.1
	zmij@1.0.17
"
RUST_MIN_VER="1.92"
inherit cargo gnome2 meson optfeature xdg

DESCRIPTION="A graphical, full featured, twin-panel file manager"
HOMEPAGE="https://gnome.pages.gitlab.gnome.org/gnome-commander/"
SRC_URI+="
	${CARGO_CRATE_URIS}
"
LICENSE="GPL-3"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD MIT Unicode-3.0
"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc exif gsf pdf taglib"
RESTRICT="test" # tests dependencies cannot be fulfilled yet

RDEPEND="
	doc? ( gnome-extra/yelp )
	>=dev-libs/glib-2.70.0:2
	>=gui-libs/gtk-4.14.0
	exif? ( >=media-gfx/exiv2-0.14:= )
	gsf? ( >=gnome-extra/libgsf-1.12:= )
	gui-libs/vte
	pdf? ( app-text/poppler:=[cairo] )
	taglib? ( >=media-libs/taglib-1.4:= )
"

BDEPEND="
	doc? ( app-text/yelp-tools )
	dev-util/glib-utils
	app-alternatives/lex
	>=sys-devel/gettext-0.19.7
"

DEPEND="
	${RDEPEND}
"

# Rust
QA_FLAGS_IGNORED="usr/bin/gnome-commander"
# This one should be fixable
QA_PRESTRIPPED="usr/bin/gnome-commander"

src_prepare() {
	default
	cargo_update_crates

	# this hackery is copied from media-sound/pwvucontrol
	# meson.build overrides CARGO_HOME, symlink to use our config.toml
	# # (note need to set BUILD_DIR either way due to cargo_env's subshell)
	BUILD_DIR=${WORKDIR}/${P}-build
	mkdir -p -- "${BUILD_DIR}" || die
	ln -s -- "${CARGO_HOME}" "${BUILD_DIR}"/cargo-home || die
}

src_configure() {
	cargo_src_configure
	local emesonargs=(
		$(meson_feature exif exiv2)
		$(meson_feature gsf libgsf)
		$(meson_feature pdf poppler)
		$(meson_feature taglib)
		$(meson_use doc help)
	)
	cargo_env meson_src_configure
}

src_compile() {
	cargo_env meson_src_compile
}

src_install() {
	cargo_env meson_src_install
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_pkg_postinst
	optfeature "synchronizing files and directories" dev-util/meld
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
