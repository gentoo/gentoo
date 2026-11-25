# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion

DESCRIPTION="A tool to create identical machine images for multiple platforms"
HOMEPAGE="https://www.packer.io"
SRC_URI="https://github.com/hashicorp/packer/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="BUSL-1.1"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 CC0-1.0 GPL-2 ISC MIT MPL-2.0 Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

BDEPEND=">=dev-lang/go-1.26.3"

DOCS=( {README,CHANGELOG}.md )

RESTRICT+=" test"

src_compile() {
	ego build -work -o "bin/${PN}" ./
}

src_install() {
	dobin bin/packer

	einstalldocs

	dozshcomp  contrib/zsh-completion/_packer
}
