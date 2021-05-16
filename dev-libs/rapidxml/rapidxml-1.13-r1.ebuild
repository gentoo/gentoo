# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Fast XML parser"
HOMEPAGE="http://rapidxml.sourceforge.net/"
SRC_URI="mirror://sourceforge/rapidxml/rapidxml-${PV}.zip"

LICENSE="Boost-1.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${P}-clang.patch
)

src_install() {
	insinto /usr/include/rapidxml
	doins *.hpp
	docinto html
	dodoc manual.html
}
