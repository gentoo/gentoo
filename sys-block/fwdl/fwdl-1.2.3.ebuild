# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Seagate Fibre-Channel disk firmware upgrade tool"
HOMEPAGE="http://www.tc.umn.edu/~erick205/Projects/"
SRC_URI="http://www.tc.umn.edu/~erick205/Projects/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"

src_prepare() {
	use debug || { sed -i -e "s/^EXTRA_DEFINES/#\0/" Makefile || die ; }
}

src_compile() {
	emake COMPILE_LINUX="$(tc-getCXX) ${CXXFLAGS} ${LDFLAGS}"
}

src_install() {
	dosbin fwdl
	dodoc CHANGES INSTALL README
}
