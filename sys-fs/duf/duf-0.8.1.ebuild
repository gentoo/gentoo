# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Disk Usage/Free Utility - a better 'df' alternative"
HOMEPAGE="https://github.com/muesli/duf"
SRC_URI="https://github.com/muesli/duf/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/mrmagic223325/deps/releases/download/${P}/${P}-deps.tar.xz"

LICENSE="MIT BSD Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="pie"

src_compile() {
	use pie && GOFLAGS+=" -buildmode=pie"
	ego build
}

src_install() {
	dobin duf
	dodoc README.md
	doman duf.1
}
