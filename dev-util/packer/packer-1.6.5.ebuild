# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="A tool to create identical machine images for multiple platforms"
HOMEPAGE="https://www.packer.io"
SRC_URI="https://github.com/hashicorp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD-2 BSD-4 MIT MPL-2.0 unicode"
SLOT="0"
KEYWORDS="~amd64"

DOCS=( {README,CHANGELOG}.md )

RESTRICT+=" test"

src_compile() {
	go build \
		-ldflags "${go_ldflags}" \
		-mod=vendor \
		-work -o "bin/${PN}" ./ || die
}

src_install() {
	dobin bin/packer

	einstalldocs

	insinto /usr/share/zsh/site-functions
	doins contrib/zsh-completion/_packer
}
