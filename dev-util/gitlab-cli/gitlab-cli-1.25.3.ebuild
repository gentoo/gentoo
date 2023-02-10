# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module
GIT_COMMIT=7ab3ef14820c565a9430fa0da58a491048699638

DESCRIPTION="the official gitlab command line interface"
HOMEPAGE="https://gitlab.com/gitlab-org/cli"
SRC_URI="https://gitlab.com/gitlab-org/cli/-/archive/v${PV}/${PN}-v${PV}.tar.bz2 -> ${P}.tar.bz2"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# tests communicate with gitlab.com and require a personal access token
RESTRICT="test"

S="${WORKDIR}/cli-v${PV}-${GIT_COMMIT}"

src_compile() {
	emake \
		GLAB_VERSION=v${PV} \
		build manpage
}

src_install() {
	dobin bin/glab
	dodoc README.md
	doman share/man/man1/*
}
