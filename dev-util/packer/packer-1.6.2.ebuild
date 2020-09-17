# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module
GIT_COMMIT=e3ac7de9655b3de4b0b0e0f7563fcfc17d6f5150

DESCRIPTION="A tool to create identical machine images for multiple platforms"
HOMEPAGE="https://www.packer.io"
SRC_URI="https://github.com/hashicorp/packer/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD-2 BSD-4 MIT MPL-2.0 unicode"
SLOT="0"
KEYWORDS="~amd64"

DOCS=( {README,CHANGELOG}.md )

RESTRICT+=" test"

src_compile() {
	local go_ldflags
	go_ldflags="-X github.com/hashicorp/packer/version.GitCommit=${GIT_COMMIT} -s -w"
	CGO_ENABLED=0 \
		go build \
		-ldflags "${go_ldflags}" \
		-mod=vendor \
		-o "bin/${PN}" ./ || die
}

src_install() {
	dobin bin/${PN}

	einstalldocs

	insinto /usr/share/zsh/site-functions
	doins contrib/zsh-completion/_packer
}
