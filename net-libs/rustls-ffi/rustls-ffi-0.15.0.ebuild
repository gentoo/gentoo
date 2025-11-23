# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# May need to use cargo-ebuild to generate this list to get workspace crates.
CRATES="
	aho-corasick@1.1.3
	alloc-no-stdlib@2.0.4
	alloc-stdlib@0.2.2
	autocfg@1.4.0
	aws-lc-fips-sys@0.13.0
	aws-lc-rs@1.12.0
	aws-lc-sys@0.24.0
	bindgen@0.69.5
	bitflags@2.6.0
	brotli@7.0.0
	brotli-decompressor@4.0.1
	bytes@1.9.0
	cc@1.2.5
	cesu8@1.1.0
	cexpr@0.6.0
	cfg-if@1.0.0
	clang-sys@1.8.1
	cmake@0.1.52
	combine@4.6.7
	core-foundation@0.10.0
	core-foundation-sys@0.8.7
	dunce@1.0.5
	either@1.13.0
	errno@0.3.10
	fs_extra@1.3.0
	getrandom@0.2.15
	glob@0.3.1
	hashbrown@0.12.3
	home@0.5.11
	indexmap@1.9.3
	itertools@0.12.1
	jni@0.21.1
	jni-sys@0.3.0
	jobserver@0.1.32
	lazy_static@1.5.0
	lazycell@1.3.0
	libc@0.2.171
	libloading@0.8.6
	linux-raw-sys@0.4.14
	log@0.4.26
	memchr@2.7.4
	minimal-lexical@0.2.1
	nom@7.1.3
	nom8@0.2.0
	once_cell@1.20.2
	openssl-probe@0.1.5
	paste@1.0.15
	prettyplease@0.2.25
	proc-macro2@1.0.92
	quote@1.0.37
	regex@1.11.1
	regex-automata@0.4.9
	regex-syntax@0.8.5
	ring@0.17.8
	rustc-hash@1.1.0
	rustix@0.38.42
	rustls@0.23.25
	rustls-native-certs@0.8.1
	rustls-pki-types@1.11.0
	rustls-platform-verifier@0.5.1
	rustls-platform-verifier-android@0.1.1
	rustls-webpki@0.103.0
	rustversion@1.0.18
	same-file@1.0.6
	schannel@0.1.27
	security-framework@3.1.0
	security-framework-sys@2.13.0
	serde@1.0.219
	serde_derive@1.0.219
	serde_spanned@0.6.8
	shlex@1.3.0
	spin@0.9.8
	subtle@2.6.1
	syn@2.0.90
	thiserror@1.0.69
	thiserror-impl@1.0.69
	toml@0.6.0
	toml_datetime@0.5.1
	toml_edit@0.18.1
	unicode-ident@1.0.14
	untrusted@0.9.0
	walkdir@2.5.0
	wasi@0.11.0+wasi-snapshot-preview1
	webpki-root-certs@0.26.7
	which@4.4.2
	winapi-util@0.1.9
	windows-sys@0.45.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.42.2
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.42.2
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.42.2
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.42.2
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.42.2
	windows_x86_64_msvc@0.52.6
	zeroize@1.8.1
	zlib-rs@0.4.1
"
RUST_MULTILIB=1
RUST_MIN_VER="1.81"
inherit cargo flag-o-matic multilib-minimal rust-toolchain

DESCRIPTION="C-to-rustls bindings"
HOMEPAGE="https://github.com/rustls/rustls-ffi"
SRC_URI="https://github.com/rustls/rustls-ffi/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" ${CARGO_CRATE_URIS}"

# Strictly speaking the core package is "|| ( Apache-2.0 MIT ISC )"
# but dependencies explicitly require at least one of each.
LICENSE+=" Apache-2.0 BSD ISC MIT Unicode-3.0 MPL-2.0"
# For Ring (see its LICENSE)
LICENSE+=" ISC openssl SSLeay MIT"
SLOT="0/${PV%.*}"
KEYWORDS="~amd64"

BDEPEND="dev-util/cargo-c"

QA_FLAGS_IGNORED="usr/lib.*/librustls.*"

src_prepare() {
	default

	# Currently only used for development, we can skip this
	# and significantly reduce the number of required crates.
	# Produces a docgen binary that we may want to use in the future. Just API docs?
	rm -r tools || die
	sed '/    "tools"/d' -i Cargo.toml || die
	cargo_update_crates

	multilib_copy_sources
}

src_configure() {
	# bug #927231
	filter-lto

	multilib-minimal_src_configure
}

src_compile() {
	multilib-minimal_src_compile
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

src_test() {
	multilib-minimal_src_test
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

src_install() {
	multilib-minimal_src_install
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
