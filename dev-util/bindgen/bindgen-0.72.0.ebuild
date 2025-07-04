# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=" "
inherit rust-toolchain cargo

DESCRIPTION="Automatically generates Rust FFI bindings to C and C++ libraries."
HOMEPAGE="https://rust-lang.github.io/rust-bindgen/"
SRC_URI="https://github.com/rust-lang/rust-${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/gentoo-crate-dist/rust-${PN}/releases/download/v${PV}/rust-${P}-crates.tar.xz
"
S=${WORKDIR}/rust-${P}

LICENSE="BSD"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD ISC MIT Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv"

DEPEND="${RUST_DEPEND}"
RDEPEND="${DEPEND}
	llvm-core/clang:*
"

QA_FLAGS_IGNORED="usr/bin/bindgen"

src_test () {
	# required by clang during tests
	local -x TARGET=$(rust_abi)

	cargo_src_test --bins --lib
}

src_install () {
	cargo_src_install --path "${S}/bindgen-cli"

	einstalldocs
}
