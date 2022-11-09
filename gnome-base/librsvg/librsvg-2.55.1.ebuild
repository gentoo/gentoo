# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )

CRATES="
	adler-1.0.2
	aho-corasick-0.7.19
	android_system_properties-0.1.5
	ansi_term-0.12.1
	anyhow-1.0.64
	approx-0.5.1
	assert_cmd-2.0.4
	atty-0.2.14
	autocfg-1.1.0
	base-x-0.2.11
	bit-set-0.5.3
	bit-vec-0.6.3
	bitflags-1.3.2
	block-0.1.6
	bstr-0.2.17
	bumpalo-3.11.0
	bytemuck-1.12.1
	byteorder-1.4.3
	cairo-rs-0.15.12
	cairo-sys-rs-0.15.1
	cast-0.3.0
	cfg-expr-0.10.3
	cfg-if-1.0.0
	chrono-0.4.22
	clap-2.34.0
	const-cstr-0.3.0
	const_fn-0.4.9
	convert_case-0.4.0
	core-foundation-sys-0.8.3
	crc32fast-1.3.2
	criterion-0.3.6
	criterion-plot-0.4.5
	crossbeam-channel-0.5.6
	crossbeam-deque-0.8.2
	crossbeam-epoch-0.9.10
	crossbeam-utils-0.8.11
	cssparser-0.28.1
	cssparser-macros-0.6.0
	csv-1.1.6
	csv-core-0.1.10
	data-url-0.1.1
	derive_more-0.99.17
	difflib-0.4.0
	discard-1.0.4
	doc-comment-0.3.3
	dtoa-0.4.8
	dtoa-short-0.3.3
	either-1.8.0
	encoding-0.2.33
	encoding-index-japanese-1.20141219.5
	encoding-index-korean-1.20141219.5
	encoding-index-simpchinese-1.20141219.5
	encoding-index-singlebyte-1.20141219.5
	encoding-index-tradchinese-1.20141219.5
	encoding_index_tests-0.1.4
	fastrand-1.8.0
	flate2-1.0.24
	float-cmp-0.9.0
	fnv-1.0.7
	form_urlencoded-1.0.1
	futf-0.1.5
	futures-channel-0.3.24
	futures-core-0.3.24
	futures-executor-0.3.24
	futures-io-0.3.24
	futures-task-0.3.24
	futures-util-0.3.24
	fxhash-0.2.1
	gdk-pixbuf-0.15.11
	gdk-pixbuf-sys-0.15.10
	getrandom-0.1.16
	getrandom-0.2.7
	gio-0.15.12
	gio-sys-0.15.10
	glib-0.15.12
	glib-macros-0.15.11
	glib-sys-0.15.10
	glob-0.3.0
	gobject-sys-0.15.10
	half-1.8.2
	heck-0.4.0
	hermit-abi-0.1.19
	iana-time-zone-0.1.47
	idna-0.2.3
	instant-0.1.12
	itertools-0.10.3
	itoa-0.4.8
	itoa-1.0.3
	js-sys-0.3.59
	language-tags-0.3.2
	lazy_static-1.4.0
	libc-0.2.132
	linked-hash-map-0.5.6
	locale_config-0.3.0
	lock_api-0.4.8
	log-0.4.17
	lopdf-0.26.0
	lzw-0.10.0
	mac-0.1.1
	malloc_buf-0.0.6
	markup5ever-0.10.1
	matches-0.1.9
	matrixmultiply-0.3.2
	memchr-2.5.0
	memoffset-0.6.5
	miniz_oxide-0.5.4
	nalgebra-0.29.0
	nalgebra-macros-0.1.0
	new_debug_unreachable-1.0.4
	nodrop-0.1.14
	normalize-line-endings-0.3.0
	num-complex-0.4.2
	num-integer-0.1.45
	num-rational-0.4.1
	num-traits-0.2.15
	num_cpus-1.13.1
	objc-0.2.7
	objc-foundation-0.1.1
	objc_id-0.1.1
	once_cell-1.14.0
	oorandom-11.1.3
	pango-0.15.10
	pango-sys-0.15.10
	pangocairo-0.15.1
	pangocairo-sys-0.15.1
	parking_lot-0.12.1
	parking_lot_core-0.9.3
	paste-1.0.9
	percent-encoding-2.1.0
	phf-0.8.0
	phf_codegen-0.8.0
	phf_generator-0.8.0
	phf_generator-0.10.0
	phf_macros-0.8.0
	phf_shared-0.8.0
	phf_shared-0.10.0
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	pkg-config-0.3.25
	plotters-0.3.3
	plotters-backend-0.3.4
	plotters-svg-0.3.3
	png-0.17.6
	pom-3.2.0
	ppv-lite86-0.2.16
	precomputed-hash-0.1.1
	predicates-2.1.1
	predicates-core-1.0.3
	predicates-tree-1.0.5
	proc-macro-crate-1.2.1
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro-hack-0.5.19
	proc-macro2-0.4.30
	proc-macro2-1.0.43
	proptest-1.0.0
	quick-error-1.2.3
	quick-error-2.0.1
	quote-0.6.13
	quote-1.0.21
	rand-0.7.3
	rand-0.8.5
	rand_chacha-0.2.2
	rand_chacha-0.3.1
	rand_core-0.5.1
	rand_core-0.6.3
	rand_hc-0.2.0
	rand_pcg-0.2.1
	rand_xorshift-0.3.0
	rawpointer-0.2.1
	rayon-1.5.3
	rayon-core-1.9.3
	rctree-0.4.0
	redox_syscall-0.2.16
	regex-1.6.0
	regex-automata-0.1.10
	regex-syntax-0.6.27
	remove_dir_all-0.5.3
	rgb-0.8.33
	rustc_version-0.2.3
	rustc_version-0.4.0
	rusty-fork-0.3.0
	ryu-1.0.11
	safe_arch-0.6.0
	same-file-1.0.6
	scopeguard-1.1.0
	selectors-0.23.0
	semver-0.9.0
	semver-1.0.13
	semver-parser-0.7.0
	serde-1.0.144
	serde_cbor-0.11.2
	serde_derive-1.0.144
	serde_json-1.0.85
	servo_arc-0.1.1
	sha1-0.6.1
	sha1_smol-1.0.0
	simba-0.6.0
	siphasher-0.3.10
	slab-0.4.7
	smallvec-1.9.0
	stable_deref_trait-1.2.0
	standback-0.2.17
	stdweb-0.4.20
	stdweb-derive-0.5.3
	stdweb-internal-macros-0.2.9
	stdweb-internal-runtime-0.1.5
	string_cache-0.8.4
	string_cache_codegen-0.5.2
	strsim-0.8.0
	syn-0.15.44
	syn-1.0.99
	system-deps-6.0.2
	tempfile-3.3.0
	tendril-0.4.3
	termtree-0.2.4
	test-generator-0.3.0
	textwrap-0.11.0
	thiserror-1.0.34
	thiserror-impl-1.0.34
	time-0.1.44
	time-0.2.27
	time-macros-0.1.1
	time-macros-impl-0.1.2
	tinytemplate-1.2.1
	tinyvec-1.6.0
	tinyvec_macros-0.1.0
	toml-0.5.9
	typenum-1.15.0
	unicode-bidi-0.3.8
	unicode-ident-1.0.3
	unicode-normalization-0.1.21
	unicode-width-0.1.9
	unicode-xid-0.1.0
	url-2.2.2
	utf-8-0.7.6
	vec_map-0.8.2
	version-compare-0.1.0
	version_check-0.9.4
	wait-timeout-0.2.0
	walkdir-2.3.2
	wasi-0.9.0+wasi-snapshot-preview1
	wasi-0.10.0+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.82
	wasm-bindgen-backend-0.2.82
	wasm-bindgen-macro-0.2.82
	wasm-bindgen-macro-support-0.2.82
	wasm-bindgen-shared-0.2.82
	web-sys-0.3.59
	wide-0.7.4
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.36.1
	windows_aarch64_msvc-0.36.1
	windows_i686_gnu-0.36.1
	windows_i686_msvc-0.36.1
	windows_x86_64_gnu-0.36.1
	windows_x86_64_msvc-0.36.1
	xml5ever-0.16.2
	yeslogic-fontconfig-sys-2.11.2
"

inherit cargo gnome2 multilib-minimal python-any-r1 rust-toolchain vala

DESCRIPTION="Scalable Vector Graphics (SVG) rendering library"
HOMEPAGE="https://wiki.gnome.org/Projects/LibRsvg https://gitlab.gnome.org/GNOME/librsvg"
SRC_URI+=" $(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 BSD CC0-1.0 LGPL-2.1+ MIT MPL-2.0 Unicode-DFS-2016"

SLOT="2"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv sparc ~x86"

IUSE="gtk-doc +introspection +vala"
REQUIRED_USE="
	gtk-doc? ( introspection )
	vala? ( introspection )
"
RESTRICT="test" # Lots of issues on 32bit builds, 64bit build seems to get into an infinite compilation sometimes, etc.

RDEPEND="
	>=x11-libs/cairo-1.16.0[glib,svg(+),${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.9:2[${MULTILIB_USEDEP}]
	>=x11-libs/gdk-pixbuf-2.20:2[introspection?,${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.50.0:2[${MULTILIB_USEDEP}]
	>=media-libs/harfbuzz-2.0.0:=[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4:2[${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.48.11[${MULTILIB_USEDEP}]

	introspection? ( >=dev-libs/gobject-introspection-0.10.8:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=virtual/rust-1.58[${MULTILIB_USEDEP}]
	x11-libs/gdk-pixbuf
	${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/docutils[${PYTHON_USEDEP}]')
	gtk-doc? ( dev-util/gi-docgen )
	virtual/pkgconfig
	vala? ( $(vala_depend) )

	dev-libs/gobject-introspection-common
	dev-libs/vala-common
"
# dev-libs/gobject-introspection-common, dev-libs/vala-common needed by eautoreconf

QA_FLAGS_IGNORED="
	usr/bin/rsvg-convert
	usr/lib.*/librsvg.*
"

src_prepare() {
	use vala && vala_setup
	gnome2_src_prepare
}

multilib_src_configure() {
	local myconf=(
		--disable-static
		--disable-debug
		$(multilib_native_use_enable gtk-doc)
		$(multilib_native_use_enable introspection)
		$(multilib_native_use_enable vala)
		--enable-pixbuf-loader
	)

	if ! multilib_is_native_abi; then
		myconf+=(
			# Set the rust target, which can differ from CHOST
			RUST_TARGET="$(rust_abi)"
			# RUST_TARGET is only honored if cross_compiling, but non-native ABIs aren't cross as
			# far as C parts and configure auto-detection are concerned as CHOST equals CBUILD
			cross_compiling=yes
		)
	fi

	ECONF_SOURCE=${S} \
	gnome2_src_configure "${myconf[@]}"

	if multilib_is_native_abi; then
		ln -s "${S}"/doc/html doc/html || die
	fi
}

multilib_src_compile() {
	gnome2_src_compile
}

multilib_src_install() {
	gnome2_src_install
}

multilib_src_install_all() {
	find "${ED}" -name '*.la' -delete || die

	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
		mv "${ED}"/usr/share/doc/Rsvg-2.0 "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}

pkg_postinst() {
	multilib_foreach_abi gnome2_pkg_postinst
}

pkg_postrm() {
	multilib_foreach_abi gnome2_pkg_postrm
}
