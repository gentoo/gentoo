# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler2@2.0.0
	aho-corasick@1.0.5
	anyhow@1.0.75
	approx@0.5.1
	autocfg@1.1.0
	bitflags@1.3.2
	bitflags@2.6.0
	block@0.1.6
	bytemuck@1.14.0
	bytemuck_derive@1.5.0
	byteorder-lite@0.1.0
	byteorder@1.4.3
	cairo-rs@0.20.1
	cairo-sys-rs@0.20.0
	cast@0.3.0
	cc@1.0.83
	cfg-expr@0.17.0
	cfg-if@1.0.0
	cfg_aliases@0.2.1
	color_quant@1.1.0
	const-random-macro@0.1.16
	const-random@0.1.18
	crc32fast@1.4.2
	crossbeam-channel@0.5.8
	crossbeam-deque@0.8.3
	crossbeam-epoch@0.9.15
	crossbeam-utils@0.8.16
	crunchy@0.2.2
	cssparser-macros@0.6.1
	cssparser@0.31.2
	data-url@0.3.0
	derive_more@0.99.17
	dirs-sys@0.4.1
	dirs@5.0.1
	dlv-list@0.5.2
	drm-ffi@0.7.1
	drm-fourcc@2.2.0
	drm-sys@0.6.1
	drm@0.11.1
	dtoa-short@0.3.4
	dtoa@1.0.9
	either@1.9.0
	encoding_rs@0.8.33
	equivalent@1.0.1
	errno@0.3.8
	fdeflate@0.3.5
	flate2@1.0.34
	float-cmp@0.9.0
	form_urlencoded@1.2.0
	freedesktop-icons@0.2.6
	freetype-rs@0.37.0
	freetype-sys@0.21.0
	futf@0.1.5
	futures-channel@0.3.28
	futures-core@0.3.28
	futures-executor@0.3.28
	futures-io@0.3.28
	futures-macro@0.3.28
	futures-task@0.3.28
	futures-util@0.3.28
	fxhash@0.2.1
	getrandom@0.2.10
	gif@0.13.1
	gio-sys@0.20.4
	gio@0.20.4
	glib-macros@0.20.4
	glib-sys@0.20.4
	glib@0.20.4
	gobject-sys@0.20.4
	hashbrown@0.14.5
	heck@0.5.0
	hermit-abi@0.3.2
	idna@0.4.0
	image-webp@0.1.3
	image@0.25.2
	indexmap@2.5.0
	input-linux-sys@0.9.0
	input-linux@0.7.1
	input-sys@1.17.0
	input@0.8.3
	io-lifetimes@1.0.11
	itertools@0.13.0
	itoa@1.0.9
	language-tags@0.3.2
	lazy_static@1.4.0
	libc@0.2.159
	libredox@0.1.3
	librsvg@2.59.1
	libudev-sys@0.1.4
	linux-raw-sys@0.4.13
	linux-raw-sys@0.6.4
	locale_config@0.3.0
	lock_api@0.4.10
	log@0.4.20
	mac@0.1.1
	malloc_buf@0.0.6
	markup5ever@0.12.1
	matrixmultiply@0.3.7
	memchr@2.7.4
	memoffset@0.7.1
	memoffset@0.9.0
	miniz_oxide@0.8.0
	nalgebra-macros@0.2.2
	nalgebra@0.33.0
	new_debug_unreachable@1.0.4
	nix@0.26.4
	nix@0.29.0
	num-complex@0.4.4
	num-integer@0.1.45
	num-rational@0.4.1
	num-traits@0.2.16
	num_cpus@1.16.0
	objc-foundation@0.1.1
	objc@0.2.7
	objc_id@0.1.1
	once_cell@1.20.2
	option-ext@0.2.0
	ordered-multimap@0.7.3
	pango-sys@0.20.4
	pango@0.20.4
	pangocairo-sys@0.20.4
	pangocairo@0.20.4
	parking_lot@0.12.1
	parking_lot_core@0.9.8
	paste@1.0.14
	percent-encoding@2.3.0
	phf@0.10.1
	phf@0.11.2
	phf_codegen@0.10.0
	phf_codegen@0.11.2
	phf_generator@0.10.0
	phf_generator@0.11.2
	phf_macros@0.11.2
	phf_shared@0.10.0
	phf_shared@0.11.2
	pin-project-lite@0.2.13
	pin-utils@0.1.0
	pkg-config@0.3.27
	png@0.17.14
	ppv-lite86@0.2.17
	precomputed-hash@0.1.1
	privdrop@0.5.4
	proc-macro-crate@3.2.0
	proc-macro2@1.0.86
	quick-error@2.0.1
	quote@1.0.37
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rawpointer@0.2.1
	rayon-core@1.11.0
	rayon@1.7.0
	rctree@0.6.0
	redox_syscall@0.3.5
	redox_users@0.4.6
	regex-automata@0.3.8
	regex-syntax@0.7.5
	regex@1.9.5
	rgb@0.8.36
	rust-ini@0.20.0
	rustix@0.38.30
	safe_arch@0.7.1
	scopeguard@1.2.0
	selectors@0.25.0
	serde@1.0.188
	serde_derive@1.0.188
	serde_spanned@0.6.4
	servo_arc@0.3.0
	simba@0.9.0
	simd-adler32@0.3.7
	siphasher@0.3.11
	slab@0.4.9
	smallvec@1.13.2
	stable_deref_trait@1.2.0
	string_cache@0.8.7
	string_cache_codegen@0.5.2
	syn@1.0.109
	syn@2.0.79
	system-deps@7.0.3
	target-lexicon@0.12.16
	tendril@0.4.3
	thiserror-impl@1.0.65
	thiserror@1.0.65
	tiny-keccak@2.0.2
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	toml@0.8.8
	toml_datetime@0.6.8
	toml_edit@0.21.0
	toml_edit@0.22.22
	typenum@1.16.0
	udev@0.7.0
	unicode-bidi@0.3.13
	unicode-ident@1.0.11
	unicode-normalization@0.1.22
	url@2.4.1
	utf-8@0.7.6
	version-compare@0.2.0
	wasi@0.11.0+wasi-snapshot-preview1
	weezl@0.1.8
	wide@0.7.11
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
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
	winnow@0.5.15
	winnow@0.6.20
	xdg@2.5.2
	xml5ever@0.18.1
	zune-core@0.4.12
	zune-jpeg@0.4.13
"

inherit cargo udev systemd linux-info

DESCRIPTION="The most basic dynamic function row daemon possible"
HOMEPAGE="https://github.com/AsahiLinux/tiny-dfr"

SRC_URI="
	${CARGO_CRATE_URIS}
	https://github.com/AsahiLinux/tiny-dfr/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

DEPEND="
	dev-libs/libinput
	x11-libs/pango
	x11-libs/gdk-pixbuf
"

RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="usr/bin/tiny-dfr"
QA_PRESTRIPPED="usr/bin/tiny-dfr"

pkg_setup() {
	linux-info_pkg_setup
	rust_pkg_setup
}

pkg_pretend() {
	local CONFIG_CHECK="~INPUT_UINPUT"
	[[ ${MERGE_TYPE} != buildonly ]] && check_extra_config
}

src_install() {
	cargo_src_install

	insinto /usr/share/tiny-dfr
	doins share/tiny-dfr/*

	udev_dorules etc/udev/rules.d/*
	systemd_dounit etc/systemd/system/*
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
