# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.1
	base64@0.21.5
	cc@1.0.83
	cfg-if@1.0.0
	getrandom@0.2.11
	libc@0.2.153
	log@0.4.21
	memchr@2.6.4
	regex-automata@0.3.9
	regex-syntax@0.7.5
	regex@1.9.6
	ring@0.17.5
	rustls-pemfile@2.1.1
	rustls-pki-types@1.3.1
	rustls-webpki@0.102.0
	rustls@0.22.0
	rustversion@1.0.14
	spin@0.9.8
	subtle@2.5.0
	untrusted@0.9.0
	wasi@0.11.0+wasi-snapshot-preview1
	windows-sys@0.48.0
	windows-targets@0.48.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.48.5
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
SLOT="0/${PV}"
KEYWORDS="~amd64"

BDEPEND="dev-util/cargo-c"

QA_FLAGS_IGNORED="usr/lib.*/librustls.*"

PATCHES=(
	"${FILESDIR}"/rustls-ffi-0.12.1-no-rust-nightly.patch
)

src_prepare() {
	default

	multilib_copy_sources
}

src_configure() {
	# bug #927231
	filter-lto

	# textrels in ring
	# Hopefully fixed with https://github.com/rustls/rustls-ffi/pull/389
	export RUSTFLAGS="${RUSTFLAGS} -C link-arg=-Wl,-z,notext"

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
