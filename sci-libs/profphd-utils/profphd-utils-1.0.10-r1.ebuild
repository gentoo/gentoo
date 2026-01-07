# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fortran-2 toolchain-funcs

DESCRIPTION="Additional utils for profphd"
HOMEPAGE="https://rostlab.org/"
SRC_URI="ftp://rostlab.org/profphd-utils/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-lang/perl"

src_compile() {
	emake \
		F77="$(tc-getF77)" \
		AM_FFLAGS=""
}

src_install() {
	emake \
		DESTDIR="${D}" \
		prefix="${EPREFIX}"/usr \
		install
	dodoc ChangeLog AUTHORS
}
