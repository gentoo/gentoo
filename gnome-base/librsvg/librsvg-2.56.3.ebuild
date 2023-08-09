# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..12} )

CRATES="
	adler-1.0.2
	aho-corasick-1.0.2
	android-tzdata-0.1.1
	android_system_properties-0.1.5
	anes-0.1.6
	anstream-0.3.2
	anstyle-1.0.1
	anstyle-parse-0.2.1
	anstyle-query-1.0.0
	anstyle-wincon-1.0.1
	anyhow-1.0.72
	approx-0.5.1
	assert_cmd-2.0.11
	atty-0.2.14
	autocfg-1.1.0
	base-x-0.2.11
	bit-set-0.5.3
	bit-vec-0.6.3
	bitflags-1.3.2
	bitflags-2.3.3
	block-0.1.6
	bstr-1.6.0
	bumpalo-3.13.0
	bytemuck-1.13.1
	byteorder-1.4.3
	cairo-rs-0.17.10
	cairo-sys-rs-0.17.10
	cast-0.3.0
	cc-1.0.79
	cfg-expr-0.15.3
	cfg-if-1.0.0
	chrono-0.4.26
	ciborium-0.2.1
	ciborium-io-0.2.1
	ciborium-ll-0.2.1
	clap-3.2.25
	clap-4.3.17
	clap_builder-4.3.17
	clap_complete-4.3.2
	clap_derive-4.3.12
	clap_lex-0.2.4
	clap_lex-0.5.0
	colorchoice-1.0.0
	const-cstr-0.3.0
	const_fn-0.4.9
	convert_case-0.4.0
	core-foundation-sys-0.8.4
	crc32fast-1.3.2
	criterion-0.4.0
	criterion-plot-0.5.0
	crossbeam-channel-0.5.8
	crossbeam-deque-0.8.3
	crossbeam-epoch-0.9.15
	crossbeam-utils-0.8.16
	cssparser-0.29.6
	cssparser-macros-0.6.1
	data-url-0.2.0
	derive_more-0.99.17
	difflib-0.4.0
	discard-1.0.4
	dlib-0.5.2
	doc-comment-0.3.3
	dtoa-1.0.9
	dtoa-short-0.3.4
	either-1.8.1
	encoding-0.2.33
	encoding-index-japanese-1.20141219.5
	encoding-index-korean-1.20141219.5
	encoding-index-simpchinese-1.20141219.5
	encoding-index-singlebyte-1.20141219.5
	encoding-index-tradchinese-1.20141219.5
	encoding_index_tests-0.1.4
	encoding_rs-0.8.32
	equivalent-1.0.1
	errno-0.3.1
	errno-dragonfly-0.1.2
	fastrand-2.0.0
	fdeflate-0.3.0
	flate2-1.0.26
	float-cmp-0.9.0
	fnv-1.0.7
	form_urlencoded-1.2.0
	futf-0.1.5
	futures-channel-0.3.28
	futures-core-0.3.28
	futures-executor-0.3.28
	futures-io-0.3.28
	futures-macro-0.3.28
	futures-task-0.3.28
	futures-util-0.3.28
	fxhash-0.2.1
	gdk-pixbuf-0.17.10
	gdk-pixbuf-sys-0.17.10
	getrandom-0.1.16
	getrandom-0.2.10
	gio-0.17.10
	gio-sys-0.17.10
	glib-0.17.10
	glib-macros-0.17.10
	glib-sys-0.17.10
	gobject-sys-0.17.10
	half-1.8.2
	hashbrown-0.12.3
	hashbrown-0.14.0
	heck-0.4.1
	hermit-abi-0.1.19
	hermit-abi-0.3.2
	iana-time-zone-0.1.57
	iana-time-zone-haiku-0.1.2
	idna-0.4.0
	indexmap-1.9.3
	indexmap-2.0.0
	is-terminal-0.4.9
	itertools-0.10.5
	itoa-1.0.9
	js-sys-0.3.64
	language-tags-0.3.2
	lazy_static-1.4.0
	libc-0.2.147
	libloading-0.8.0
	libm-0.2.7
	linked-hash-map-0.5.6
	linux-raw-sys-0.4.3
	locale_config-0.3.0
	lock_api-0.4.10
	log-0.4.19
	lopdf-0.29.0
	mac-0.1.1
	malloc_buf-0.0.6
	markup5ever-0.11.0
	matches-0.1.10
	matrixmultiply-0.3.7
	memchr-2.5.0
	memoffset-0.9.0
	miniz_oxide-0.7.1
	nalgebra-0.32.3
	nalgebra-macros-0.2.1
	new_debug_unreachable-1.0.4
	nodrop-0.1.14
	normalize-line-endings-0.3.0
	num-complex-0.4.3
	num-integer-0.1.45
	num-rational-0.4.1
	num-traits-0.2.15
	num_cpus-1.16.0
	objc-0.2.7
	objc-foundation-0.1.1
	objc_id-0.1.1
	once_cell-1.18.0
	oorandom-11.1.3
	os_str_bytes-6.5.1
	pango-0.17.10
	pango-sys-0.17.10
	pangocairo-0.17.10
	pangocairo-sys-0.17.10
	parking_lot-0.12.1
	parking_lot_core-0.9.8
	paste-1.0.14
	percent-encoding-2.3.0
	phf-0.8.0
	phf-0.10.1
	phf_codegen-0.8.0
	phf_codegen-0.10.0
	phf_generator-0.8.0
	phf_generator-0.10.0
	phf_macros-0.10.0
	phf_shared-0.8.0
	phf_shared-0.10.0
	pin-project-lite-0.2.10
	pin-utils-0.1.0
	pkg-config-0.3.27
	plotters-0.3.5
	plotters-backend-0.3.5
	plotters-svg-0.3.5
	png-0.17.9
	pom-3.3.0
	ppv-lite86-0.2.17
	precomputed-hash-0.1.1
	predicates-2.1.5
	predicates-3.0.3
	predicates-core-1.0.6
	predicates-tree-1.0.9
	proc-macro-crate-1.3.1
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro-hack-0.5.20+deprecated
	proc-macro2-1.0.66
	proptest-1.2.0
	quick-error-1.2.3
	quote-1.0.31
	rand-0.7.3
	rand-0.8.5
	rand_chacha-0.2.2
	rand_chacha-0.3.1
	rand_core-0.5.1
	rand_core-0.6.4
	rand_hc-0.2.0
	rand_pcg-0.2.1
	rand_xorshift-0.3.0
	rawpointer-0.2.1
	rayon-1.7.0
	rayon-core-1.11.0
	rctree-0.5.0
	redox_syscall-0.3.5
	regex-1.9.1
	regex-automata-0.3.3
	regex-syntax-0.6.29
	regex-syntax-0.7.4
	rgb-0.8.36
	rustc_version-0.2.3
	rustc_version-0.4.0
	rustix-0.38.4
	rusty-fork-0.3.0
	ryu-1.0.15
	safe_arch-0.7.1
	same-file-1.0.6
	scopeguard-1.2.0
	selectors-0.24.0
	semver-0.9.0
	semver-1.0.18
	semver-parser-0.7.0
	serde-1.0.173
	serde_derive-1.0.173
	serde_json-1.0.103
	serde_spanned-0.6.3
	servo_arc-0.2.0
	sha1-0.6.1
	sha1_smol-1.0.0
	simba-0.8.1
	simd-adler32-0.3.5
	siphasher-0.3.10
	slab-0.4.8
	smallvec-1.11.0
	stable_deref_trait-1.2.0
	standback-0.2.17
	stdweb-0.4.20
	stdweb-derive-0.5.3
	stdweb-internal-macros-0.2.9
	stdweb-internal-runtime-0.1.5
	string_cache-0.8.7
	string_cache_codegen-0.5.2
	strsim-0.10.0
	syn-1.0.109
	syn-2.0.26
	system-deps-6.1.1
	target-lexicon-0.12.10
	tempfile-3.7.0
	tendril-0.4.3
	termtree-0.4.1
	textwrap-0.16.0
	thiserror-1.0.43
	thiserror-impl-1.0.43
	time-0.2.27
	time-macros-0.1.1
	time-macros-impl-0.1.2
	tinytemplate-1.2.1
	tinyvec-1.6.0
	tinyvec_macros-0.1.1
	toml-0.7.6
	toml_datetime-0.6.3
	toml_edit-0.19.14
	typenum-1.16.0
	unarray-0.1.4
	unicode-bidi-0.3.13
	unicode-ident-1.0.11
	unicode-normalization-0.1.22
	url-2.4.0
	utf-8-0.7.6
	utf8parse-0.2.1
	version-compare-0.1.1
	version_check-0.9.4
	wait-timeout-0.2.0
	walkdir-2.3.3
	wasi-0.9.0+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.87
	wasm-bindgen-backend-0.2.87
	wasm-bindgen-macro-0.2.87
	wasm-bindgen-macro-support-0.2.87
	wasm-bindgen-shared-0.2.87
	web-sys-0.3.64
	weezl-0.1.7
	wide-0.7.11
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-0.48.0
	windows-sys-0.48.0
	windows-targets-0.48.1
	windows_aarch64_gnullvm-0.48.0
	windows_aarch64_msvc-0.48.0
	windows_i686_gnu-0.48.0
	windows_i686_msvc-0.48.0
	windows_x86_64_gnu-0.48.0
	windows_x86_64_gnullvm-0.48.0
	windows_x86_64_msvc-0.48.0
	winnow-0.5.0
	xml5ever-0.17.0
	yeslogic-fontconfig-sys-4.0.1
"

inherit cargo gnome2 multilib-minimal python-any-r1 rust-toolchain vala

DESCRIPTION="Scalable Vector Graphics (SVG) rendering library"
HOMEPAGE="https://wiki.gnome.org/Projects/LibRsvg https://gitlab.gnome.org/GNOME/librsvg"
SRC_URI+=" $(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 BSD CC0-1.0 LGPL-2.1+ ISC MIT MPL-2.0 Unicode-DFS-2016"

SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

IUSE="gtk-doc +introspection +vala"
REQUIRED_USE="
	gtk-doc? ( introspection )
	vala? ( introspection )
"

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
	>=virtual/rust-1.65.0[${MULTILIB_USEDEP}]
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
