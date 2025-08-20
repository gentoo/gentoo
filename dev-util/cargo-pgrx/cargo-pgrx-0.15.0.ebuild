# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""

DESCRIPTION="pgrx: A Rust framework for creating Postgres extensions"
HOMEPAGE="https://github.com/pgcentralfoundation/pgrx/"

inherit cargo

MY_PV="${PV/alpha/alpha.}"
MY_PV="${MY_PV/_/-}"
SRC_URI="
	https://github.com/pgcentralfoundation/pgrx/archive/refs/tags/v${MY_PV}.tar.gz -> pgrx-${PV}.tar.gz
"
SRC_URI+=" https://github.com/gentoo-crate-dist/${PN#cargo-}/releases/download/v${PV}/${P#cargo-}-crates.tar.xz"

S=${WORKDIR}/pgrx-${MY_PV}/cargo-pgrx
LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD ISC MIT MPL-2.0 Unicode-DFS-2016 ZLIB"
SLOT="0"

KEYWORDS="~amd64"

RESTRICT="test" # needs custom setup

src_unpack() {
	cargo_src_unpack
	mkdir -p "${WORKDIR}"/pgrx-${PV}/.pgrx
	export PGRX_HOME="${WORKDIR}"/pgrx-${PV}/.pgrx
}
