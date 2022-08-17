# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="check source code for non-inclusive language"
HOMEPAGE="https://getwoke.tech/"
SRC_URI="https://github.com/get-woke/woke/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	ego build .
}

src_install() {
	dobin woke
	dodoc README.md example.yaml
}
