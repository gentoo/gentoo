# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.4
	anes@0.1.6
	anstyle@1.0.13
	atomic_refcell@0.1.13
	autocfg@1.5.0
	bitflags@2.10.0
	bumpalo@3.19.0
	bytemuck@1.24.0
	byteorder-lite@0.1.0
	cast@0.3.0
	cfg-expr@0.20.4
	cfg-if@1.0.4
	ciborium-io@0.2.2
	ciborium-ll@0.2.2
	ciborium@0.2.2
	clap@4.5.53
	clap_builder@4.5.53
	clap_derive@4.5.49
	clap_lex@0.7.6
	criterion-plot@0.6.0
	criterion@0.7.0
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	crunchy@0.2.4
	either@1.15.0
	equivalent@1.0.2
	futures-channel@0.3.31
	futures-core@0.3.31
	futures-executor@0.3.31
	futures-io@0.3.31
	futures-macro@0.3.31
	futures-sink@0.3.31
	futures-task@0.3.31
	futures-util@0.3.31
	gio-sys@0.21.2
	gio@0.21.4
	glib-macros@0.21.4
	glib-sys@0.21.2
	glib@0.21.4
	gobject-sys@0.21.2
	gstreamer-app-sys@0.24.0
	gstreamer-app@0.24.2
	gstreamer-base-sys@0.24.2
	gstreamer-base@0.24.2
	gstreamer-sys@0.24.2
	gstreamer-video-sys@0.24.1
	gstreamer-video@0.24.3
	gstreamer@0.24.3
	half@2.7.1
	hashbrown@0.16.1
	heck@0.5.0
	image@0.25.9
	indexmap@2.12.1
	itertools@0.13.0
	itertools@0.14.0
	itoa@1.0.15
	js-sys@0.3.82
	kstring@2.0.2
	libc@0.2.177
	libglycin-rebind-sys@0.0.1
	libglycin-rebind@0.0.1
	memchr@2.7.6
	moxcms@0.7.9
	muldiv@1.0.1
	num-integer@0.1.46
	num-rational@0.4.2
	num-traits@0.2.19
	once_cell@1.21.3
	oorandom@11.1.5
	option-operations@0.6.0
	pastey@0.1.1
	pin-project-lite@0.2.16
	pin-utils@0.1.0
	pkg-config@0.3.32
	plotters-backend@0.3.7
	plotters-svg@0.3.7
	plotters@0.3.7
	proc-macro-crate@3.4.0
	proc-macro2@1.0.103
	pxfm@0.1.25
	quote@1.0.42
	rayon-core@1.13.0
	rayon@1.11.0
	regex-automata@0.4.13
	regex-syntax@0.8.8
	regex@1.12.2
	rustversion@1.0.22
	ryu@1.0.20
	same-file@1.0.6
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.145
	serde_spanned@1.0.3
	slab@0.4.11
	smallvec@1.15.1
	static_assertions@1.1.0
	syn@2.0.111
	system-deps@7.0.7
	target-lexicon@0.13.3
	thiserror-impl@2.0.17
	thiserror@2.0.17
	tinytemplate@1.2.1
	toml@0.9.8
	toml_datetime@0.7.3
	toml_edit@0.23.7
	toml_parser@1.0.4
	toml_writer@1.0.4
	unicode-ident@1.0.22
	version-compare@0.2.1
	walkdir@2.5.0
	wasm-bindgen-macro-support@0.2.105
	wasm-bindgen-macro@0.2.105
	wasm-bindgen-shared@0.2.105
	wasm-bindgen@0.2.105
	web-sys@0.3.82
	winapi-util@0.1.11
	windows-link@0.2.1
	windows-sys@0.61.2
	winnow@0.7.14
	zerocopy-derive@0.8.30
	zerocopy@0.8.30
"

RUST_MIN_VER=1.88.0

inherit cargo gnome.org meson

MY_P="${PV/_alpha/.alpha.}"
MY_P="${PN}"-"${MY_P}"

DESCRIPTION="Gstreamer based thumbnailer for GNOME desktop"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gst-thumbnailers"
# gnome.org for package tarball
SRC_URI+=" ${CARGO_CRATE_URIS}"

S="${WORKDIR}"/"${MY_P}"

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+=" Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0"

SLOT="0"
if [[ ${PV} != *_[ab]* ]]; then
	KEYWORDS="~amd64"
fi
IUSE="ffmpeg heif jpeg2k jpegxl svg test"

# meson.build
RDEPEND="
	>=media-libs/gstreamer-1.26:1.0
	>=media-libs/glycin-2.0.0:2
	>=media-libs/glycin-loaders-2.0.0:2[heif?,jpeg2k?,jpegxl?,svg?]
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
	test? ( sys-apps/bubblewrap )
	virtual/pkgconfig
"

RESTRICT="!test? ( test )"

src_configure() {
	meson_src_configure

	ln -s "${CARGO_HOME}" "${BUILD_DIR}"/cargo-home || die
}

src_test() {
	#	TODO: Get bwrap to work in portage's sandbox
	#local -x SANDBOX_ON=0
	meson_src_test
}
