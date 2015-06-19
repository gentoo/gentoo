# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/phred/phred-071220.ebuild,v 1.2 2009/07/07 22:53:19 flameeyes Exp $

DESCRIPTION="A base caller for Sanger DNA sequencing"
HOMEPAGE="http://phrap.org/phredphrapconsed.html"
SRC_URI="phred-dist-071220.b-acd.tar.gz"

LICENSE="phrap"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}"

RESTRICT="fetch"

pkg_nofetch() {
	elog "Please visit ${HOMEPAGE} and obtain the file"
	elog "${SRC_URI}, then place it in ${DISTDIR}"
}

src_compile() {
	sed -i -e 's/CFLAGS=/CFLAGS += /' Makefile
	emake daev || die
	emake || die
}

src_install() {
	dobin phred daev || die
	insinto /usr/share/${PN}
	doins phredpar.dat || die
	echo "PHRED_PARAMETER_FILE=/usr/share/${PN}/phredpar.dat" > 99phred
	doenvd 99phred || die
	newdoc DAEV.DOC DAEV.DOC.txt
	newdoc PHRED.DOC PHRED.DOC.txt
}
