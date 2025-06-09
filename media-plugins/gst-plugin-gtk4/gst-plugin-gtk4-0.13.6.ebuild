# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	async-channel@2.3.1
	atomic_refcell@0.1.13
	autocfg@1.4.0
	bitflags@2.9.0
	bumpalo@3.17.0
	cairo-rs@0.20.10
	cairo-sys-rs@0.20.10
	cc@1.2.22
	cfg-expr@0.17.2
	cfg-if@1.0.0
	chrono@0.4.41
	concurrent-queue@2.5.0
	core-foundation-sys@0.8.7
	crossbeam-utils@0.8.21
	either@1.15.0
	equivalent@1.0.2
	event-listener-strategy@0.5.4
	event-listener@5.4.0
	field-offset@0.3.6
	futures-channel@0.3.31
	futures-core@0.3.31
	futures-executor@0.3.31
	futures-io@0.3.31
	futures-macro@0.3.31
	futures-task@0.3.31
	futures-util@0.3.31
	gdk-pixbuf-sys@0.20.10
	gdk-pixbuf@0.20.10
	gdk4-sys@0.9.6
	gdk4-wayland-sys@0.9.6
	gdk4-wayland@0.9.6
	gdk4-win32-sys@0.9.5
	gdk4-win32@0.9.5
	gdk4-x11-sys@0.9.6
	gdk4-x11@0.9.6
	gdk4@0.9.6
	gio-sys@0.20.10
	gio@0.20.10
	glib-macros@0.20.10
	glib-sys@0.20.10
	glib@0.20.10
	gobject-sys@0.20.10
	graphene-rs@0.20.10
	graphene-sys@0.20.10
	gsk4-sys@0.9.6
	gsk4@0.9.6
	gst-plugin-version-helper@0.8.2
	gstreamer-allocators-sys@0.23.5
	gstreamer-allocators@0.23.5
	gstreamer-base-sys@0.23.6
	gstreamer-base@0.23.6
	gstreamer-gl-egl-sys@0.23.6
	gstreamer-gl-egl@0.23.6
	gstreamer-gl-sys@0.23.6
	gstreamer-gl-wayland-sys@0.23.5
	gstreamer-gl-wayland@0.23.5
	gstreamer-gl-x11-sys@0.23.5
	gstreamer-gl-x11@0.23.5
	gstreamer-gl@0.23.6
	gstreamer-sys@0.23.6
	gstreamer-video-sys@0.23.6
	gstreamer-video@0.23.6
	gstreamer@0.23.6
	gtk4-macros@0.9.5
	gtk4-sys@0.9.6
	gtk4@0.9.6
	hashbrown@0.15.3
	heck@0.5.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.63
	indexmap@2.9.0
	itertools@0.14.0
	js-sys@0.3.77
	khronos-egl@6.0.0
	libc@0.2.172
	log@0.4.27
	memchr@2.7.4
	memoffset@0.9.1
	muldiv@1.0.1
	num-integer@0.1.46
	num-rational@0.4.2
	num-traits@0.2.19
	once_cell@1.21.3
	option-operations@0.5.0
	pango-sys@0.20.10
	pango@0.20.10
	parking@2.2.1
	paste@1.0.15
	pin-project-lite@0.2.16
	pin-utils@0.1.0
	pkg-config@0.3.32
	proc-macro-crate@3.3.0
	proc-macro2@1.0.95
	quote@1.0.40
	rustc_version@0.4.1
	rustversion@1.0.20
	semver@1.0.26
	serde@1.0.219
	serde_derive@1.0.219
	serde_spanned@0.6.8
	shlex@1.3.0
	slab@0.4.9
	smallvec@1.15.0
	syn@2.0.101
	system-deps@7.0.3
	target-lexicon@0.12.16
	thiserror-impl@2.0.12
	thiserror@2.0.12
	toml@0.8.22
	toml_datetime@0.6.9
	toml_edit@0.22.26
	unicode-ident@1.0.18
	version-compare@0.2.0
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
	windows-sys@0.52.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	winnow@0.7.10
"

inherit cargo rust-toolchain toolchain-funcs

DESCRIPTION="GStreamer GTK 4 sink element"
HOMEPAGE="
	https://lib.rs/crates/gst-plugin-gtk4
	https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/
"
SRC_URI="
	https://crates.io/api/v1/crates/${PN}/${PV}/download
		-> ${P}.crate
	${CARGO_CRATE_URIS}
"

LICENSE="MPL-2.0"
# Dependent crate licenses
LICENSE+=" Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0"
SLOT="1.0"
KEYWORDS="~amd64 ~arm64"
IUSE="+egl +gles2 opengl wayland +X" # Keep default IUSE mirrored with gst-plugins-base

DEPEND="
	dev-libs/glib
	>=gui-libs/gtk-4.16:4
	>=media-libs/gstreamer-1.24:1.0
	>=media-libs/gst-plugins-base-1.24:${SLOT}[egl=,gles2=,opengl=,wayland=,X=]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/cargo-c
"

QA_FLAGS_IGNORED="usr/lib.*/gstreamer-1.0/libgstgtk4.so"

src_configure() {
	local myfeatures=(
		# match that with gtk dep above, we don't really care to support
		# older versions here
		gtk_v4_16
	)

	# see https://github.com/GStreamer/gst-plugins-rs/blob/main/meson.build
	local gl_winsys=$(
		$(tc-getPKG_CONFIG) --variable=gl_winsys gstreamer-gl-1.0 || die
	)
	if has wayland ${gl_winsys}; then
		myfeatures+=( waylandegl )
	fi
	if has x11 ${gl_winsys}; then
		if has egl ${gl_winsys}; then
			myfeatures+=( x11egl )
		fi
		if has glx ${gl_winsys}; then
			myfeatures+=( x11glx )
		fi
	fi

	CARGO_ARGS=(
		--library-type=cdylib
		--prefix="${EPREFIX}"/usr
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--target="$(rust_abi)"
		$(usev !debug '--release')
	)

	cargo_src_configure
}

src_compile() {
	cargo cbuild "${CARGO_ARGS[@]}" || die
}

src_test() {
	# no tests, cargo [c]test just rebuilds everything for no gain
	:
}

src_install() {
	cargo cinstall "${CARGO_ARGS[@]}" --destdir="${D}" || die
}
