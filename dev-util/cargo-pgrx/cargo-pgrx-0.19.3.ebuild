# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""
RUST_MIN_VER="1.96.0"
inherit cargo

DESCRIPTION="pgrx: A Rust framework for creating Postgres extensions"
HOMEPAGE="https://github.com/pgcentralfoundation/pgrx/"

MY_PV="${PV/alpha/alpha.}"
MY_PV="${MY_PV/_/-}"
SRC_URI="
	https://github.com/pgcentralfoundation/pgrx/archive/refs/tags/v${MY_PV}.tar.gz -> pgrx-${PV}.tar.gz
"
SRC_URI+=" https://github.com/gentoo-crate-dist/${PN#cargo-}/releases/download/v${PV}/${P#cargo-}-crates.tar.xz"

S=${WORKDIR}/pgrx-${MY_PV}/cargo-pgrx
LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD CDLA-Permissive-2.0 ISC MIT Unicode-3.0 ZLIB BZIP2
	|| ( CC0-1.0 MIT-0 )
"
SLOT="0"

KEYWORDS="~amd64"

RESTRICT="test" # needs custom setup

src_unpack() {
	cargo_src_unpack
	mkdir -p "${WORKDIR}"/pgrx-${PV}/.pgrx
	export PGRX_HOME="${WORKDIR}"/pgrx-${PV}/.pgrx
}
