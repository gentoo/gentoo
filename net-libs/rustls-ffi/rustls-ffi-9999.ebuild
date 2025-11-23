# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

#CRATES=""

RUST_MULTILIB=1
RUST_MIN_VER="1.81"
inherit cargo flag-o-matic multilib-minimal rust-toolchain

DESCRIPTION="C-to-rustls bindings"
HOMEPAGE="https://github.com/rustls/rustls-ffi"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rustls/rustls-ffi.git"
else
	SRC_URI="https://github.com/rustls/rustls-ffi/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	SRC_URI+=" ${CARGO_CRATE_URIS}"
	KEYWORDS="~amd64"
fi

# Strictly speaking the core package is "|| ( Apache-2.0 MIT ISC )"
# but dependencies explicitly require at least one of each.
LICENSE+=" Apache-2.0 BSD ISC MIT Unicode-3.0 MPL-2.0"
# For Ring (see its LICENSE)
LICENSE+=" ISC openssl SSLeay MIT"
SLOT="0/${PV%.*}"

BDEPEND="dev-util/cargo-c"

QA_FLAGS_IGNORED="usr/lib.*/librustls.*"

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_prepare() {
	default

	if ! [[ ${PV} == 9999 ]]; then # We already fetched all the crates...
		# Currently only used for development, we can skip this
		# and significantly reduce the number of required crates.
		# Produces a docgen binary that we may want to use in the future. Just API docs?
		rm -r tools || die
		sed '/    "tools"/d' -i Cargo.toml || die
		cargo_update_crates
	fi

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
