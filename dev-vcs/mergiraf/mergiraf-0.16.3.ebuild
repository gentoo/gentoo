# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""
RUST_MIN_VER="1.88"
inherit cargo

DESCRIPTION="Syntax-aware git merge driver"
HOMEPAGE="https://mergiraf.org/"
SRC_URI="https://codeberg.org/mergiraf/mergiraf/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-crate-dist/mergiraf/releases/download/v${PV}/${P}-crates.tar.xz"
S=${WORKDIR}/${PN}

LICENSE="GPL-3"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT Unicode-3.0 ZLIB"
SLOT="0"
KEYWORDS="~amd64"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_install() {
	default
	cargo_src_install
}
