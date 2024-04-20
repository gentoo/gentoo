# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Compute various size metrics for a Git repository"
HOMEPAGE="https://github.com/github/git-sizer"
SRC_URI="https://github.com/github/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~dlan/distfiles/dev-vcs/git-sizer/${P}-deps.tar.xz"

LICENSE="MIT Apache-2.0 BSD BSD-2 ISC"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"  # tests work only in git repo

RDEPEND="dev-vcs/git"

src_compile() {
	emake GOFLAGS="${GOFLAGS} -ldflags=-X=main.BuildVersion=v${PV}"
}

src_install() {
	dobin bin/git-sizer
	dodoc README.md CONTRIBUTING.md
}
