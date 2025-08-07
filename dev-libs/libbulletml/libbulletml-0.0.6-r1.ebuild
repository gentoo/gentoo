# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dot-a toolchain-funcs

DESCRIPTION="A Library of Bullet Markup Language"
HOMEPAGE="https://shinh.skr.jp/libbulletml/index_en.html"
SRC_URI="https://shinh.skr.jp/libbulletml/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="dev-libs/boost"
RDEPEND=${DEPEND}

PATCHES=(
	"${FILESDIR}"/${P}-gcc4{3,6}.patch
	"${FILESDIR}"/${P}-Makefile.patch
)

S="${WORKDIR}"/${PN#lib}/src

src_prepare() {
	default
	rm -r boost || die
}

src_configure() {
	tc-export AR CXX
	lto-guarantee-fat
}

src_install() {
	dolib.a libbulletml.a
	strip-lto-bytecode

	insinto /usr/include/bulletml
	doins *.h

	insinto /usr/include/bulletml/tinyxml
	doins tinyxml/tinyxml.h

	insinto /usr/include/bulletml/ygg
	doins ygg/ygg.h

	dodoc ../README*
}
