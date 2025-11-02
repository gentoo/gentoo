# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion

DESCRIPTION="A tool to create identical machine images for multiple platforms"
HOMEPAGE="https://www.packer.io"
SRC_URI="https://github.com/hashicorp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~expeditioneer/distfiles/${CATEGORY}/${PN}/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD MIT MPL-2.0 unicode Unicode-DFS-2016 ISC BUSL-1.1 CC-BY-4.0 GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

DOCS=( {README,CHANGELOG}.md )

RESTRICT+=" test"

src_compile() {
	ego build \
		-mod=readonly \
		-ldflags "${go_ldflags}" \
		-work -o "bin/${PN}" ./ || die
}

src_install() {
	dobin bin/packer

	einstalldocs

	dozshcomp  contrib/zsh-completion/_packer
}
