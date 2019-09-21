# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

DESCRIPTION="qmail-qsanity checks your queue data structures for internal consistency"
HOMEPAGE="http://www.qmail.org/"
SRC_URI="mirror://qmail/${P}"

LICENSE="qmail-nelson"
SLOT="0"
# Should run on all platforms without issue
KEYWORDS="~hppa ~ppc x86"
IUSE=""

DEPEND=""
RDEPEND="virtual/qmail dev-lang/perl"

S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}"/${P} ${PN}
}

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	dobin ${PN}
}
