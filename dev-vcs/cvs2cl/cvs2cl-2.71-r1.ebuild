# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="produces a GNU-style ChangeLog for CVS-controlled sources"
HOMEPAGE="https://www.red-bean.com/cvs2cl/"
SRC_URI="mirror://gentoo/${P}.pl.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DEPEND="dev-lang/perl"

S=${WORKDIR}

src_install() {
	newbin ${P}.pl ${PN}
}
