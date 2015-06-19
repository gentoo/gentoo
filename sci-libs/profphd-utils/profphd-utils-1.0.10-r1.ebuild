# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/profphd-utils/profphd-utils-1.0.10-r1.ebuild,v 1.1 2014/11/24 07:30:58 jlec Exp $

EAPI=5

inherit fortran-2 toolchain-funcs

DESCRIPTION="Additional utils for profphd"
HOMEPAGE="https://rostlab.org/"
SRC_URI="ftp://rostlab.org/profphd-utils/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="dev-lang/perl"

src_compile() {
	emake \
		F77=$(tc-getF77) \
		AM_FFLAGS=""
}

src_install() {
	emake \
		DESTDIR="${D}" \
		prefix="${EPREFIX}"/usr \
		install
	dodoc ChangeLog AUTHORS
}
