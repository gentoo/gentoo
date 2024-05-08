# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ansi_term-0.12.1
	atty-0.2.14
	autocfg-1.1.0
	base64-0.13.1
	bitflags-1.3.2
	bumpalo-3.11.1
	cbindgen-0.19.0
	cc-1.0.77
	cfg-if-1.0.0
	clap-2.34.0
	fastrand-1.8.0
	hashbrown-0.12.3
	heck-0.3.3
	hermit-abi-0.1.19
	indexmap-1.9.2
	instant-0.1.12
	itoa-1.0.4
	js-sys-0.3.60
	libc-0.2.138
	log-0.4.17
	num_enum-0.5.7
	num_enum_derive-0.5.7
	once_cell-1.16.0
	proc-macro-crate-1.2.1
	proc-macro2-1.0.47
	quote-1.0.21
	redox_syscall-0.2.16
	remove_dir_all-0.5.3
	ring-0.16.20
	rustls-0.20.4
	rustls-pemfile-0.2.1
	rustversion-1.0.9
	ryu-1.0.11
	sct-0.7.0
	serde-1.0.149
	serde_derive-1.0.149
	serde_json-1.0.89
	spin-0.5.2
	strsim-0.8.0
	syn-1.0.105
	tempfile-3.3.0
	textwrap-0.11.0
	thiserror-1.0.37
	thiserror-impl-1.0.37
	toml-0.5.9
	unicode-ident-1.0.5
	unicode-segmentation-1.10.0
	unicode-width-0.1.10
	untrusted-0.7.1
	vec_map-0.8.2
	wasm-bindgen-0.2.83
	wasm-bindgen-backend-0.2.83
	wasm-bindgen-macro-0.2.83
	wasm-bindgen-macro-support-0.2.83
	wasm-bindgen-shared-0.2.83
	web-sys-0.3.60
	webpki-0.22.0
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo flag-o-matic multilib-minimal rust-toolchain

DESCRIPTION="C-to-rustls bindings"
HOMEPAGE="https://github.com/rustls/rustls-ffi"
SRC_URI="https://github.com/rustls/rustls-ffi/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" $(cargo_crate_uris)"

# From cargo-ebuild (note that webpki is also just ISC)
LICENSE="|| ( MIT Apache-2.0 ) BSD Boost-1.0 ISC MIT MPL-2.0 Unicode-DFS-2016"
# For Ring (see its LICENSE)
LICENSE+=" ISC openssl SSLeay MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"

BDEPEND="dev-util/cargo-c"

QA_FLAGS_IGNORED="usr/lib.*/librustls.*"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.1-cargo-c.patch
	"${FILESDIR}"/${PN}-0.9.1-tests-32-bit.patch
)

src_prepare() {
	default

	multilib_copy_sources
}

src_configure() {
	# bug #927231
	filter-lto

	multilib-minimal_src_configure
}

multilib_src_compile() {
	local cargoargs=(
		--library-type=cdylib
		--prefix=/usr
		--libdir="/usr/$(get_libdir)"
		--target="$(rust_abi)"
		$(usev !debug '--release')
	)

	cargo cbuild "${cargoargs[@]}" || die "cargo cbuild failed"
}

multilib_src_test() {
	local cargoargs=(
		--prefix=/usr
		--libdir="/usr/$(get_libdir)"
		--target="$(rust_abi)"
		$(usex debug '--debug' '--release')
	)

	cargo ctest "${cargoargs[@]}" || die "cargo ctest failed"
}

multilib_src_install() {
	local cargoargs=(
		--library-type=cdylib
		--prefix=/usr
		--libdir="/usr/$(get_libdir)"
		--target="$(rust_abi)"
		--destdir="${ED}"
		$(usex debug '--debug' '--release')
	)

	cargo cinstall "${cargoargs[@]}" || die "cargo cinstall failed"
}
