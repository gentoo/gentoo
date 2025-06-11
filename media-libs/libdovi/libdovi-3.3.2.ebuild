# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER=1.85.0
RUST_MULTILIB=1
inherit cargo edo multilib-minimal rust-toolchain

DESCRIPTION="Dolby Vision metadata parsing and writing"
HOMEPAGE="https://github.com/quietvoid/dovi_tool/"
SRC_URI="
	https://github.com/quietvoid/dovi_tool/archive/refs/tags/${P}.tar.gz
	https://dev.gentoo.org/~ionen/distfiles/${P}-vendor.tar.xz
"
S=${WORKDIR}/dovi_tool-${P}/dolby_vision

LICENSE="MIT"
LICENSE+=" Apache-2.0 Unicode-3.0" # crates
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64"

BDEPEND="
	dev-util/cargo-c
"

QA_FLAGS_IGNORED="usr/lib.*/${PN}.*"

src_prepare() {
	default

	multilib_copy_sources
}

src_configure() {
	multilib_src_configure() {
		local -n cargoargs=${PN}_CARGOARGS_${ABI}

		cargoargs=(
			--prefix="${EPREFIX}/usr"
			--libdir="${EPREFIX}/usr/$(get_libdir)"
			--library-type=cdylib
			--target="$(rust_abi)"
			$(usex debug --profile=dev --release)
		)
	}

	multilib-minimal_src_configure
}

src_compile() {
	multilib_src_compile() {
		local -n cargoargs=${PN}_CARGOARGS_${ABI}

		edo cargo cbuild "${cargoargs[@]}"
	}

	multilib-minimal_src_compile
}

src_test() { :; } # no tests, and must not run cargo_src_test

src_install() {
	multilib_src_install() {
		local -n cargoargs=${PN}_CARGOARGS_${ABI}

		edo cargo cinstall --destdir="${D}" "${cargoargs[@]}"
	}

	multilib-minimal_src_install
}
