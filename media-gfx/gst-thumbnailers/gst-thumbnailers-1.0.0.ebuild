# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.4
	alloca@0.4.0
	anes@0.1.6
	anstyle@1.0.13
	atomic_refcell@0.1.13
	autocfg@1.5.0
	bitflags@2.11.0
	bumpalo@3.20.2
	bytemuck@1.25.0
	byteorder-lite@0.1.0
	cast@0.3.0
	cc@1.2.56
	cfg-expr@0.20.7
	cfg-if@1.0.4
	ciborium-io@0.2.2
	ciborium-ll@0.2.2
	ciborium@0.2.2
	clap@4.6.0
	clap_builder@4.6.0
	clap_derive@4.6.0
	clap_lex@1.1.0
	criterion-plot@0.8.2
	criterion@0.8.2
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	crunchy@0.2.4
	either@1.15.0
	equivalent@1.0.2
	find-msvc-tools@0.1.9
	futures-channel@0.3.32
	futures-core@0.3.32
	futures-executor@0.3.32
	futures-io@0.3.32
	futures-macro@0.3.32
	futures-sink@0.3.32
	futures-task@0.3.32
	futures-util@0.3.32
	gio-sys@0.22.0
	gio@0.22.2
	glib-macros@0.22.2
	glib-sys@0.22.0
	glib@0.22.2
	gobject-sys@0.22.0
	gstreamer-app-sys@0.25.0
	gstreamer-app@0.25.0
	gstreamer-base-sys@0.25.0
	gstreamer-base@0.25.0
	gstreamer-sys@0.25.0
	gstreamer-video-sys@0.25.0
	gstreamer-video@0.25.0
	gstreamer@0.25.1
	half@2.7.1
	hashbrown@0.16.1
	heck@0.5.0
	image@0.25.10
	indexmap@2.13.0
	itertools@0.13.0
	itertools@0.14.0
	itoa@1.0.17
	js-sys@0.3.91
	kstring@2.0.2
	libc@0.2.183
	libglycin-rebind-sys@0.1.0
	libglycin-rebind@0.1.0
	memchr@2.8.0
	moxcms@0.8.1
	muldiv@1.0.1
	num-integer@0.1.46
	num-rational@0.4.2
	num-traits@0.2.19
	once_cell@1.21.4
	oorandom@11.1.5
	option-operations@0.6.1
	page_size@0.6.0
	pastey@0.2.1
	pin-project-lite@0.2.17
	pkg-config@0.3.32
	plotters-backend@0.3.7
	plotters-svg@0.3.7
	plotters@0.3.7
	proc-macro2@1.0.106
	pxfm@0.1.28
	quote@1.0.45
	rayon-core@1.13.0
	rayon@1.11.0
	regex-automata@0.4.14
	regex-syntax@0.8.10
	regex@1.12.3
	rustversion@1.0.22
	same-file@1.0.6
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.149
	serde_spanned@1.0.4
	shlex@1.3.0
	slab@0.4.12
	smallvec@1.15.1
	static_assertions@1.1.0
	syn@2.0.117
	system-deps@7.0.7
	target-lexicon@0.13.3
	thiserror-impl@2.0.18
	thiserror@2.0.18
	tinytemplate@1.2.1
	toml@0.9.12+spec-1.1.0
	toml_datetime@0.7.5+spec-1.1.0
	toml_parser@1.0.9+spec-1.1.0
	toml_writer@1.0.6+spec-1.1.0
	unicode-ident@1.0.24
	version-compare@0.2.1
	walkdir@2.5.0
	wasm-bindgen-macro-support@0.2.114
	wasm-bindgen-macro@0.2.114
	wasm-bindgen-shared@0.2.114
	wasm-bindgen@0.2.114
	web-sys@0.3.91
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.11
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-link@0.2.1
	windows-sys@0.61.2
	winnow@0.7.15
	zerocopy-derive@0.8.42
	zerocopy@0.8.42
	zmij@1.0.21
"

RUST_MIN_VER=1.88.0

inherit cargo gnome.org meson

DESCRIPTION="Gstreamer based thumbnailer for GNOME desktop"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gst-thumbnailers"
# gnome.org for package tarball
SRC_URI+=" ${CARGO_CRATE_URIS}"

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+=" Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0"

SLOT="0"
IUSE="ffmpeg heif jpegxl svg test"

# meson.build
RDEPEND="
	>=media-libs/gstreamer-1.26:1.0
	media-libs/glycin:2
	media-libs/glycin-loaders:2[heif?,jpegxl?,svg?]
"
# crates
RDEPEND+="
	>=dev-libs/glib-2.56:2
	>=media-libs/gst-plugins-base-1.14:1.0
"

# Uses gstreamer to generate thumbnails so install the corresponding plugin with
# the appropriate codec support. The image is then displayed using libglycin.
RDEPEND+="media-plugins/gst-plugins-meta[ffmpeg?]"
DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
	test? ( sys-apps/bubblewrap )
"

RESTRICT="!test? ( test )"

src_configure() {
	meson_src_configure

	ln -s "${CARGO_HOME}" "${BUILD_DIR}"/cargo-home || die
}

src_test() {
	# TODO: Get bwrap to work in portage's sandbox
	#local -x SANDBOX_ON=0
	meson_src_test
}
