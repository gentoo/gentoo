# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""
inherit cargo

DESCRIPTION="Structural diff tool that understands syntax "
HOMEPAGE="https://difftastic.wilfred.me.uk/ https://github.com/Wilfred/difftastic"
SRC_URI="https://github.com/Wilfred/difftastic/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-crate-dist/${PN}/releases/download/${PV}/${P}-crates.tar.xz"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT Unicode-DFS-2016 ZLIB"
SLOT="0"
KEYWORDS="~amd64"

DOCS=( README.md CHANGELOG.md )

src_install() {
	cargo_src_install
	einstalldocs
	doman difft.1
}
