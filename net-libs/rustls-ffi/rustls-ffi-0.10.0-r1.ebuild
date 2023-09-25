# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	autocfg-1.1.0
	base64-0.13.1
	bumpalo-3.12.0
	cc-1.0.79
	cfg-if-1.0.0
	hashbrown-0.12.3
	indexmap-1.9.3
	js-sys-0.3.61
	libc-0.2.140
	log-0.4.17
	memchr-2.5.0
	num_enum-0.5.11
	num_enum_derive-0.5.11
	once_cell-1.17.1
	proc-macro-crate-1.3.1
	proc-macro2-1.0.55
	quote-1.0.26
	ring-0.16.20
	rustls-0.21.0
	rustls-pemfile-0.2.1
	rustls-webpki-0.100.1
	rustversion-1.0.12
	sct-0.7.0
	spin-0.5.2
	syn-1.0.109
	toml_datetime-0.6.1
	toml_edit-0.19.8
	unicode-ident-1.0.8
	untrusted-0.7.1
	wasm-bindgen-0.2.84
	wasm-bindgen-backend-0.2.84
	wasm-bindgen-macro-0.2.84
	wasm-bindgen-macro-support-0.2.84
	wasm-bindgen-shared-0.2.84
	web-sys-0.3.61
	webpki-0.22.0
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
	winnow-0.4.1
"

inherit cargo multilib-minimal rust-toolchain

DESCRIPTION="C-to-rustls bindings"
HOMEPAGE="https://github.com/rustls/rustls-ffi"
SRC_URI="https://github.com/rustls/rustls-ffi/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" $(cargo_crate_uris)"

# From cargo-ebuild (note that webpki is also just ISC)
LICENSE="|| ( MIT Apache-2.0 ) BSD Boost-1.0 ISC MIT MPL-2.0 Unicode-DFS-2016"
# Dependent crate licenses
LICENSE+=" ISC MIT Unicode-DFS-2016"
# For Ring (see its LICENSE)
LICENSE+=" ISC openssl SSLeay MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"

BDEPEND="dev-util/cargo-c"

QA_FLAGS_IGNORED="usr/lib.*/librustls.*"

PATCHES=(
	"${FILESDIR}"/${PN}-0.10.0-cargo-c.patch
)

src_prepare() {
	default

	multilib_copy_sources
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
	cargo_src_test --target="$(rust_abi)"
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
