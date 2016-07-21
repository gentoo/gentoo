# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit fortran-2 toolchain-funcs

DESCRIPTION="Neural network architecture for profacc"
HOMEPAGE="https://rostlab.org/"
SRC_URI="ftp://rostlab.org/profnet/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="sys-libs/libunwind"
DEPEND="${RDEPEND}"

src_prepare() {
	sed \
		-e '/$@/s:-o:$(LDFLAGS) -o:g' \
		-i src-phd/Makefile || die
}

src_compile() {
	emake \
		F77=$(tc-getF77) \
		FFLAGS="${FFLAGS}"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		prefix="${EPREFIX}/usr" \
		install
}
