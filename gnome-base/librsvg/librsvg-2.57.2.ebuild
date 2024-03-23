# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..12} )

CRATES="
	adler@1.0.2
	aho-corasick@1.1.2
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anes@0.1.6
	anstream@0.6.5
	anstyle-parse@0.2.3
	anstyle-query@1.0.2
	anstyle-wincon@3.0.2
	anstyle@1.0.4
	anyhow@1.0.75
	approx@0.5.1
	assert_cmd@2.0.12
	autocfg@1.1.0
	bit-set@0.5.3
	bit-vec@0.6.3
	bitflags@1.3.2
	bitflags@2.4.1
	block@0.1.6
	bstr@1.8.0
	bumpalo@3.14.0
	bytemuck@1.14.0
	byteorder@1.5.0
	cairo-rs@0.18.3
	cairo-sys-rs@0.18.2
	cast@0.3.0
	cc@1.0.83
	cfg-expr@0.15.5
	cfg-if@1.0.0
	chrono@0.4.31
	ciborium-io@0.2.1
	ciborium-ll@0.2.1
	ciborium@0.2.1
	clap@4.4.11
	clap_builder@4.4.11
	clap_complete@4.4.4
	clap_derive@4.4.7
	clap_lex@0.6.0
	colorchoice@1.0.0
	const-cstr@0.3.0
	core-foundation-sys@0.8.6
	crc32fast@1.3.2
	criterion-plot@0.5.0
	criterion@0.5.1
	crossbeam-deque@0.8.4
	crossbeam-epoch@0.9.16
	crossbeam-utils@0.8.17
	cssparser-macros@0.6.1
	cssparser@0.31.2
	cstr@0.2.11
	data-url@0.3.1
	deranged@0.3.10
	derive_more@0.99.17
	difflib@0.4.0
	dlib@0.5.2
	doc-comment@0.3.3
	dtoa-short@0.3.4
	dtoa@1.0.9
	either@1.9.0
	encoding_rs@0.8.33
	equivalent@1.0.1
	errno@0.3.8
	fastrand@2.0.1
	fdeflate@0.3.1
	flate2@1.0.28
	float-cmp@0.9.0
	fnv@1.0.7
	form_urlencoded@1.2.1
	futf@0.1.5
	futures-channel@0.3.29
	futures-core@0.3.29
	futures-executor@0.3.29
	futures-io@0.3.29
	futures-macro@0.3.29
	futures-task@0.3.29
	futures-util@0.3.29
	fxhash@0.2.1
	gdk-pixbuf-sys@0.18.0
	gdk-pixbuf@0.18.3
	getrandom@0.2.11
	gio-sys@0.18.1
	gio@0.18.4
	glib-macros@0.18.3
	glib-sys@0.18.1
	glib@0.18.4
	gobject-sys@0.18.0
	half@1.8.2
	hashbrown@0.14.3
	heck@0.4.1
	hermit-abi@0.3.3
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.58
	idna@0.5.0
	indexmap@2.1.0
	is-terminal@0.4.9
	itertools@0.10.5
	itertools@0.11.0
	itoa@1.0.10
	js-sys@0.3.66
	language-tags@0.3.2
	lazy_static@1.4.0
	libc@0.2.151
	libloading@0.8.1
	libm@0.2.8
	linked-hash-map@0.5.6
	linux-raw-sys@0.4.12
	locale_config@0.3.0
	lock_api@0.4.11
	log@0.4.20
	lopdf@0.31.0
	mac@0.1.1
	malloc_buf@0.0.6
	markup5ever@0.11.0
	matches@0.1.10
	matrixmultiply@0.3.8
	md5@0.7.0
	memchr@2.6.4
	memoffset@0.9.0
	minimal-lexical@0.2.1
	miniz_oxide@0.7.1
	nalgebra-macros@0.2.1
	nalgebra@0.32.3
	new_debug_unreachable@1.0.4
	nom@7.1.3
	normalize-line-endings@0.3.0
	num-complex@0.4.4
	num-integer@0.1.45
	num-rational@0.4.1
	num-traits@0.2.17
	objc-foundation@0.1.1
	objc@0.2.7
	objc_id@0.1.1
	once_cell@1.19.0
	oorandom@11.1.3
	pango-sys@0.18.0
	pango@0.18.3
	pangocairo-sys@0.18.0
	pangocairo@0.18.0
	parking_lot@0.12.1
	parking_lot_core@0.9.9
	paste@1.0.14
	percent-encoding@2.3.1
	phf@0.10.1
	phf@0.11.2
	phf_codegen@0.10.0
	phf_generator@0.10.0
	phf_generator@0.11.2
	phf_macros@0.11.2
	phf_shared@0.10.0
	phf_shared@0.11.2
	pin-project-lite@0.2.13
	pin-utils@0.1.0
	pkg-config@0.3.27
	plotters-backend@0.3.5
	plotters-svg@0.3.5
	plotters@0.3.5
	png@0.17.10
	powerfmt@0.2.0
	ppv-lite86@0.2.17
	precomputed-hash@0.1.1
	predicates-core@1.0.6
	predicates-tree@1.0.9
	predicates@3.0.4
	proc-macro-crate@2.0.1
	proc-macro-error-attr@1.0.4
	proc-macro-error@1.0.4
	proc-macro2@1.0.70
	proptest@1.4.0
	quick-error@1.2.3
	quick-error@2.0.1
	quote@1.0.33
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rand_xorshift@0.3.0
	rawpointer@0.2.1
	rayon-core@1.12.0
	rayon@1.8.0
	rctree@0.5.0
	redox_syscall@0.4.1
	regex-automata@0.4.3
	regex-syntax@0.8.2
	regex@1.10.2
	rgb@0.8.37
	rustix@0.38.28
	rusty-fork@0.3.0
	ryu@1.0.16
	safe_arch@0.7.1
	same-file@1.0.6
	scopeguard@1.2.0
	selectors@0.25.0
	serde@1.0.193
	serde_derive@1.0.193
	serde_json@1.0.108
	serde_spanned@0.6.4
	servo_arc@0.3.0
	simba@0.8.1
	simd-adler32@0.3.7
	siphasher@0.3.11
	slab@0.4.9
	smallvec@1.11.2
	stable_deref_trait@1.2.0
	string_cache@0.8.7
	string_cache_codegen@0.5.2
	strsim@0.10.0
	syn@1.0.109
	syn@2.0.41
	system-deps@6.2.0
	target-lexicon@0.12.12
	tempfile@3.8.1
	tendril@0.4.3
	termtree@0.4.1
	thiserror-impl@1.0.50
	thiserror@1.0.50
	time-core@0.1.2
	time-macros@0.2.15
	time@0.3.30
	tinytemplate@1.2.1
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	toml@0.8.2
	toml_datetime@0.6.3
	toml_edit@0.20.2
	typenum@1.17.0
	unarray@0.1.4
	unicode-bidi@0.3.14
	unicode-ident@1.0.12
	unicode-normalization@0.1.22
	url@2.5.0
	utf-8@0.7.6
	utf8parse@0.2.1
	version-compare@0.1.1
	version_check@0.9.4
	wait-timeout@0.2.0
	walkdir@2.4.0
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.89
	wasm-bindgen-macro-support@0.2.89
	wasm-bindgen-macro@0.2.89
	wasm-bindgen-shared@0.2.89
	wasm-bindgen@0.2.89
	web-sys@0.3.66
	weezl@0.1.7
	wide@0.7.13
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.51.1
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
	winnow@0.5.28
	xml5ever@0.17.0
	yeslogic-fontconfig-sys@4.0.1
"

inherit cargo gnome2 multilib-minimal python-any-r1 rust-toolchain vala

DESCRIPTION="Scalable Vector Graphics (SVG) rendering library"
HOMEPAGE="https://wiki.gnome.org/Projects/LibRsvg https://gitlab.gnome.org/GNOME/librsvg"
SRC_URI+=" ${CARGO_CRATE_URIS}"

LICENSE="LGPL-2.1+"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD ISC MIT MPL-2.0
	Unicode-DFS-2016
"

SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

IUSE="gtk-doc +introspection +vala"
REQUIRED_USE="
	gtk-doc? ( introspection )
	vala? ( introspection )
"

RDEPEND="
	>=x11-libs/cairo-1.17.0[glib,svg(+),${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.9:2[${MULTILIB_USEDEP}]
	>=x11-libs/gdk-pixbuf-2.20:2[introspection?,${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.50.0:2[${MULTILIB_USEDEP}]
	>=media-libs/harfbuzz-2.0.0:=[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4:2[${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.50.0[${MULTILIB_USEDEP}]

	introspection? ( >=dev-libs/gobject-introspection-0.10.8:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=virtual/rust-1.70.0[${MULTILIB_USEDEP}]
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
