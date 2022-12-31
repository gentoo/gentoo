# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Disk Usage/Free Utility - a better 'df' alternative"
HOMEPAGE="https://github.com/muesli/duf"
SRC_URI="
	https://github.com/muesli/duf/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/mrmagic223325/duf/releases/download/${PV}/${P}-deps.tar.xz
"

LICENSE="MIT BSD Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="pie"

src_compile() {
	local GOFLAGS=""
	use pie && GOFLAGS+="-buildmode=pie"
	ego build "${GOFLAGS}"
}

src_install() {
	dobin duf
	dodoc README.md
	doman duf.1
}
