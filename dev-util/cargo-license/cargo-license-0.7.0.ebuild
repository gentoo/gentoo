# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=" "
inherit cargo

DESCRIPTION="Cargo subcommand to see license of dependencies"
HOMEPAGE="https://github.com/onur/cargo-license"
SRC_URI="https://github.com/onur/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-crate-dist/anki/releases/download/v${PV}/${P}-crates.tar.xz"

LICENSE="Apache-2.0 Boost-1.0 MIT Unicode-DFS-2016 Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

QA_FLAGS_IGNORED="/usr/bin/${PN}"

src_install() {
	cargo_src_install
	einstalldocs
}
