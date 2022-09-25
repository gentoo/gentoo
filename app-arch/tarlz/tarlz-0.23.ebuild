# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs unpacker

DESCRIPTION="A parallel archiver combining tar and lzip"
HOMEPAGE="https://www.nongnu.org/lzip/tarlz.html"
SRC_URI="https://download.savannah.gnu.org/releases/lzip/${PN}/${P}.tar.lz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=app-arch/lzlib-1.12
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	$(unpacker_src_uri_depends)
"

src_configure() {
	econf \
		CXX="$(tc-getCXX)" \
		CXXFLAGS="${CXXFLAGS}" \
		CPPFLAGS="${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}
