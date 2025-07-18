# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

# update this on every bump
GIT_COMMIT=35361bb2

DESCRIPTION="terminal based UI to manage kubernetes clusters"
HOMEPAGE="https://k9scli.io"
SRC_URI="https://github.com/derailed/k9s/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"
S="${WORKDIR}/k9s-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64"

BDEPEND=">=dev-lang/go-1.24.0"

src_prepare() {
	default
	# I will look into opening an upstream PR to do this.
	sed -i -e 's/-w -s -X/-X/' Makefile || die
}

src_compile() {
	emake GIT_REV=${GIT_COMMIT} VERSION=v${PV} build
}

src_install() {
	dobin execs/k9s
	dodoc -r change_logs plugins skins README.md
}
