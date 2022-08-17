# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Check for java programs vulnerable to log4shell"
HOMEPAGE="https://github.com/1lann/log4shelldetect"
SRC_URI="https://github.com/1lann/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	ego build .
}

src_install() {
	dobin log4shelldetect
	dodoc README.md
}
