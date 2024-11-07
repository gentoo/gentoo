# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.1
	autocfg@1.2.0
	aws-lc-rs@1.9.0
	aws-lc-sys@0.21.1
	base64@0.22.0
	bindgen@0.69.4
	bitflags@1.3.2
	bitflags@2.6.0
	bytes@1.6.0
	cc@1.1.18
	cesu8@1.1.0
	cexpr@0.6.0
	cfg-if@1.0.0
	clang-sys@1.8.1
	cmake@0.1.50
	combine@4.6.6
	core-foundation-sys@0.8.6
	core-foundation@0.9.4
	dunce@1.0.4
	either@1.13.0
	errno@0.3.9
	fs_extra@1.3.0
	getrandom@0.2.11
	glob@0.3.1
	hashbrown@0.12.3
	home@0.5.9
	indexmap@1.9.3
	itertools@0.12.1
	jni-sys@0.3.0
	jni@0.19.0
	jobserver@0.1.31
	lazy_static@1.5.0
	lazycell@1.3.0
	libc@0.2.158
	libloading@0.8.4
	linux-raw-sys@0.4.14
	log@0.4.22
	memchr@2.6.4
	minimal-lexical@0.2.1
	mirai-annotations@1.12.0
	nom8@0.2.0
	nom@7.1.3
	num-bigint@0.4.4
	num-integer@0.1.46
	num-traits@0.2.18
	once_cell@1.19.0
	openssl-probe@0.1.5
	paste@1.0.15
	prettyplease@0.2.17
	proc-macro2@1.0.79
	quote@1.0.35
	regex-automata@0.3.9
	regex-syntax@0.7.5
	regex@1.9.6
	ring@0.17.5
	rustc-hash@1.1.0
	rustix@0.38.34
	rustls-native-certs@0.7.1
	rustls-pemfile@2.1.3
	rustls-pki-types@1.7.0
	rustls-platform-verifier-android@0.1.1
	rustls-platform-verifier@0.3.4
	rustls-webpki@0.102.8
	rustls@0.23.13
	rustversion@1.0.14
	same-file@1.0.6
	schannel@0.1.23
	security-framework-sys@2.10.0
	security-framework@2.10.0
	serde@1.0.203
	serde_derive@1.0.203
	serde_spanned@0.6.0
	shlex@1.3.0
	spin@0.9.8
	subtle@2.5.0
	syn@2.0.58
	thiserror-impl@1.0.58
	thiserror@1.0.58
	toml@0.6.0
	toml_datetime@0.5.1
	toml_edit@0.18.1
	unicode-ident@1.0.12
	untrusted@0.9.0
	walkdir@2.5.0
	wasi@0.11.0+wasi-snapshot-preview1
	webpki-roots@0.26.3
	which@4.4.2
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.48.5
	windows-targets@0.52.4
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.4
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.4
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.4
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.4
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.4
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.4
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.4
	zeroize@1.7.0
"

inherit cargo flag-o-matic multilib-minimal rust-toolchain

DESCRIPTION="C-to-rustls bindings"
HOMEPAGE="https://github.com/rustls/rustls-ffi"
SRC_URI="https://github.com/rustls/rustls-ffi/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" ${CARGO_CRATE_URIS}"

LICENSE="|| ( Apache-2.0 MIT ISC )"
# Dependent crate licenses
LICENSE+=" BSD ISC MIT"
# For Ring (see its LICENSE)
LICENSE+=" ISC openssl SSLeay MIT"
SLOT="0/${PV%.*}"
KEYWORDS="~amd64"

BDEPEND="dev-util/cargo-c"

QA_FLAGS_IGNORED="usr/lib.*/librustls.*"

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
		--prefix="${EPREFIX}"/usr
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--target="$(rust_abi)"
		$(usev !debug '--release')
	)

	cargo cbuild "${cargoargs[@]}" || die "cargo cbuild failed"
}

multilib_src_test() {
	local cargoargs=(
		--prefix="${EPREFIX}"/usr
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--target="$(rust_abi)"
		$(usex debug '--debug' '--release')
	)

	cargo ctest "${cargoargs[@]}" || die "cargo ctest failed"
}

multilib_src_install() {
	local cargoargs=(
		--library-type=cdylib
		--prefix="${EPREFIX}"/usr
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--target="$(rust_abi)"
		--destdir="${D}"
		$(usex debug '--debug' '--release')
	)

	cargo cinstall "${cargoargs[@]}" || die "cargo cinstall failed"
}
