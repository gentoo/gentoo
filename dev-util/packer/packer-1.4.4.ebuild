# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-base go-module

DESCRIPTION="A tool to create identical machine images for multiple platforms"
HOMEPAGE="https://www.packer.io"

EGO_PN="github.com/hashicorp/packer"
SRC_URI="https://github.com/hashicorp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD-2 BSD-4 ECL-2.0 icu imagemagick ISC JSON MIT MPL-2.0"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""
DEPEND=""

DOCS=( {README,CHANGELOG}.md )

src_compile() {
	GOCACHE="${T}/go-cache" go build \
		-work -o "bin/${PN}" ./ || die
}

src_install() {
	dobin bin/packer

	einstalldocs

	insinto /usr/share/zsh/site-functions
	doins contrib/zsh-completion/_packer
}
