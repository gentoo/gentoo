# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="a loop-free distance-vector routing protocol"
HOMEPAGE="http://www.pps.jussieu.fr/~jch/software/babel/"
SRC_URI="http://www.pps.jussieu.fr/~jch/software/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_compile() {
	emake CDEBUGFLAGS="${CFLAGS}"
}

src_install(){
	emake "TARGET=${D}"  PREFIX="${EPREFIX}"/usr install
	dodoc CHANGES README
	doinitd "${FILESDIR}"/${PN}
}
