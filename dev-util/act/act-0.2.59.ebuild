# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="run github workflows locally"
HOMEPAGE="https://nektosact.com"
SRC_URI="https://github.com/nektos/act/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	emake VERSION="${PV}" build
}

src_install() {
dobin dist/local/act
}
