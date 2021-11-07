# Copyright 2013-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Handwriting model data of Japanese"
HOMEPAGE="https://tegaki.github.io/"
SRC_URI="https://github.com/tegaki/tegaki/releases/download/v${PV}/${P}.zip"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

src_prepare() {
	sed -i -e "/^installpath=/s:local/::" Makefile || die
	sed -i -e "/^installpath=/s:installpath=:installpath=${ED}:" Makefile || die
}

src_compile() {
	:
}
