# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/profphd-utils/profphd-utils-1.0.10.ebuild,v 1.2 2013/04/25 07:38:09 jlec Exp $

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
		prefix="${EPREFIX}" \
		install
	dodoc ChangeLog AUTHORS
}
