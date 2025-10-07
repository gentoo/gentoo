# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

# update this on every bump
GIT_COMMIT=73fa0087

DESCRIPTION="terminal based UI to manage kubernetes clusters"
HOMEPAGE="https://k9scli.io"
SRC_URI="https://github.com/derailed/k9s/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/k9s/releases/download/v${PV}/k9s-${PV}-vendor.tar.xz"
S=${WORKDIR}/k9s-${PV}

LICENSE="Apache-2.0"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 CC0-1.0 GPL-2 ISC MIT MPL-2.0 Unicode-DFS-2016 Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND=">=dev-lang/go-1.24.4"

src_prepare() {
	default
	# I will look into opening an upstream PR to do this.
	sed -i -e 's/-w -s -X/-X/' Makefile || die
}

src_compile() {
	emake GIT_REV=${GIT_COMMIT} VERSION=v${PV} GO_FLAGS="-mod=vendor" build
}

src_install() {
	dobin execs/k9s
	dodoc -r change_logs plugins skins README.md
}
