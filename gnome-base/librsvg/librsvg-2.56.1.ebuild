# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..12} )

CRATES="
	adler-1.0.2
	aho-corasick-1.0.1
	android-tzdata-0.1.1
	android_system_properties-0.1.5
	anes-0.1.6
	anstream-0.3.2
	anstyle-1.0.0
	anstyle-parse-0.2.0
	anstyle-query-1.0.0
	anstyle-wincon-1.0.1
	anyhow-1.0.71
	approx-0.5.1
	assert_cmd-2.0.11
	atty-0.2.14
	autocfg-1.1.0
	base-x-0.2.11
	bit-set-0.5.3
	bit-vec-0.6.3
	bitflags-1.3.2
	block-0.1.6
	bstr-1.5.0
	bumpalo-3.13.0
	bytemuck-1.13.1
	byteorder-1.4.3
	cairo-rs-0.17.0
	cairo-sys-rs-0.17.0
	cast-0.3.0
	cc-1.0.79
	cfg-expr-0.15.1
	cfg-if-1.0.0
	chrono-0.4.25
	ciborium-0.2.1
	ciborium-io-0.2.1
	ciborium-ll-0.2.1
	clap-3.2.25
	clap-4.3.0
	clap_builder-4.3.0
	clap_complete-4.3.0
	clap_derive-4.3.0
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
	crossbeam-epoch-0.9.14
	crossbeam-utils-0.8.15
	cssparser-0.29.6
	cssparser-macros-0.6.0
	data-url-0.2.0
	derive_more-0.99.17
	difflib-0.4.0
	discard-1.0.4
	dlib-0.5.0
	doc-comment-0.3.3
	dtoa-0.4.8
	dtoa-short-0.3.3
	either-1.8.1
	encoding-0.2.33
	encoding-index-japanese-1.20141219.5
	encoding-index-korean-1.20141219.5
	encoding-index-simpchinese-1.20141219.5
	encoding-index-singlebyte-1.20141219.5
	encoding-index-tradchinese-1.20141219.5
	encoding_index_tests-0.1.4
	encoding_rs-0.8.32
	errno-0.3.1
	errno-dragonfly-0.1.2
	fastrand-1.9.0
	fdeflate-0.3.0
	flate2-1.0.26
	float-cmp-0.9.0
	fnv-1.0.7
	form_urlencoded-1.1.0
	futf-0.1.5
	futures-channel-0.3.28
	futures-core-0.3.28
	futures-executor-0.3.28
	futures-io-0.3.28
	futures-macro-0.3.28
	futures-task-0.3.28
	futures-util-0.3.28
	fxhash-0.2.1
	gdk-pixbuf-0.17.0
	gdk-pixbuf-sys-0.17.0
	getrandom-0.1.16
	getrandom-0.2.9
	gio-0.17.9
	gio-sys-0.17.4
	glib-0.17.9
	glib-macros-0.17.9
	glib-sys-0.17.4
	gobject-sys-0.17.4
	half-1.8.2
	hashbrown-0.12.3
	heck-0.4.1
	hermit-abi-0.1.19
	hermit-abi-0.2.6
	hermit-abi-0.3.1
	iana-time-zone-0.1.56
	iana-time-zone-haiku-0.1.2
	idna-0.3.0
	indexmap-1.9.3
	instant-0.1.12
	io-lifetimes-1.0.11
	is-terminal-0.4.7
	itertools-0.10.5
	itoa-1.0.6
	js-sys-0.3.63
	language-tags-0.3.2
	lazy_static-1.4.0
	libc-0.2.144
	libloading-0.7.4
	libm-0.2.7
	linked-hash-map-0.5.6
	linux-raw-sys-0.3.8
	locale_config-0.3.0
	lock_api-0.4.9
	log-0.4.18
	lopdf-0.29.0
	mac-0.1.1
	malloc_buf-0.0.6
	markup5ever-0.11.0
	matches-0.1.10
	matrixmultiply-0.3.7
	memchr-2.5.0
	memoffset-0.8.0
	miniz_oxide-0.7.1
	nalgebra-0.32.2
	nalgebra-macros-0.2.0
	new_debug_unreachable-1.0.4
	nodrop-0.1.14
	normalize-line-endings-0.3.0
	num-complex-0.4.3
	num-integer-0.1.45
	num-rational-0.4.1
	num-traits-0.2.15
	num_cpus-1.15.0
	objc-0.2.7
	objc-foundation-0.1.1
	objc_id-0.1.1
	once_cell-1.17.2
	oorandom-11.1.3
	os_str_bytes-6.5.0
	pango-0.17.4
	pango-sys-0.17.0
	pangocairo-0.17.0
	pangocairo-sys-0.17.3
	parking_lot-0.12.1
	parking_lot_core-0.9.7
	paste-1.0.12
	percent-encoding-2.2.0
	phf-0.8.0
	phf-0.10.1
	phf_codegen-0.8.0
	phf_codegen-0.10.0
	phf_generator-0.8.0
	phf_generator-0.10.0
	phf_macros-0.10.0
	phf_shared-0.8.0
	phf_shared-0.10.0
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	pkg-config-0.3.27
	plotters-0.3.4
	plotters-backend-0.3.4
	plotters-svg-0.3.3
	png-0.17.8
	pom-3.2.0
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
	proc-macro2-1.0.59
	proptest-1.2.0
	quick-error-1.2.3
	quote-1.0.28
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
	redox_syscall-0.2.16
	redox_syscall-0.3.5
	regex-1.8.3
	regex-automata-0.1.10
	regex-syntax-0.6.29
	regex-syntax-0.7.2
	rgb-0.8.36
	rustc_version-0.2.3
	rustc_version-0.4.0
	rustix-0.37.19
	rusty-fork-0.3.0
	ryu-1.0.13
	safe_arch-0.6.0
	same-file-1.0.6
	scopeguard-1.1.0
	selectors-0.24.0
	semver-0.9.0
	semver-1.0.17
	semver-parser-0.7.0
	serde-1.0.163
	serde_derive-1.0.163
	serde_json-1.0.96
	serde_spanned-0.6.2
	servo_arc-0.2.0
	sha1-0.6.1
	sha1_smol-1.0.0
	simba-0.8.1
	simd-adler32-0.3.5
	siphasher-0.3.10
	slab-0.4.8
	smallvec-1.10.0
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
	syn-2.0.18
	system-deps-6.1.0
	target-lexicon-0.12.7
	tempfile-3.5.0
	tendril-0.4.3
	termtree-0.4.1
	textwrap-0.16.0
	thiserror-1.0.40
	thiserror-impl-1.0.40
	time-0.2.27
	time-macros-0.1.1
	time-macros-impl-0.1.2
	tinytemplate-1.2.1
	tinyvec-1.6.0
	tinyvec_macros-0.1.1
	toml-0.7.4
	toml_datetime-0.6.2
	toml_edit-0.19.10
	typenum-1.16.0
	unarray-0.1.4
	unicode-bidi-0.3.13
	unicode-ident-1.0.9
	unicode-normalization-0.1.22
	url-2.3.1
	utf-8-0.7.6
	utf8parse-0.2.1
	version-compare-0.1.1
	version_check-0.9.4
	wait-timeout-0.2.0
	walkdir-2.3.3
	wasi-0.9.0+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.86
	wasm-bindgen-backend-0.2.86
	wasm-bindgen-macro-0.2.86
	wasm-bindgen-macro-support-0.2.86
	wasm-bindgen-shared-0.2.86
	web-sys-0.3.63
	weezl-0.1.7
	wide-0.7.9
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-0.48.0
	windows-sys-0.45.0
	windows-sys-0.48.0
	windows-targets-0.42.2
	windows-targets-0.48.0
	windows_aarch64_gnullvm-0.42.2
	windows_aarch64_gnullvm-0.48.0
	windows_aarch64_msvc-0.42.2
	windows_aarch64_msvc-0.48.0
	windows_i686_gnu-0.42.2
	windows_i686_gnu-0.48.0
	windows_i686_msvc-0.42.2
	windows_i686_msvc-0.48.0
	windows_x86_64_gnu-0.42.2
	windows_x86_64_gnu-0.48.0
	windows_x86_64_gnullvm-0.42.2
	windows_x86_64_gnullvm-0.48.0
	windows_x86_64_msvc-0.42.2
	windows_x86_64_msvc-0.48.0
	winnow-0.4.6
	xml5ever-0.17.0
	yeslogic-fontconfig-sys-4.0.1
"

inherit cargo gnome2 multilib-minimal python-any-r1 rust-toolchain vala

DESCRIPTION="Scalable Vector Graphics (SVG) rendering library"
HOMEPAGE="https://wiki.gnome.org/Projects/LibRsvg https://gitlab.gnome.org/GNOME/librsvg"
SRC_URI+=" $(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 BSD CC0-1.0 LGPL-2.1+ ISC MIT MPL-2.0 Unicode-DFS-2016"

SLOT="2"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv sparc x86"

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
