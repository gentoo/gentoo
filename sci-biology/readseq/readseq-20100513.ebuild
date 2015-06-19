# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/readseq/readseq-20100513.ebuild,v 1.2 2014/08/10 20:31:52 slyfox Exp $

EAPI=5

inherit java-pkg-2 java-ant-2

DESCRIPTION="Reads and writes nucleic/protein sequences in various formats"
HOMEPAGE="http://iubio.bio.indiana.edu/soft/molbio/readseq/"
SRC_URI="http://dev.gentoo.org/~ercpe/distfiles/${CATEGORY}/${PN}/${P}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="!=sci-biology/meme-4.8.1
	>=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"

S=${WORKDIR}

java_prepare() {
	rm "${S}"/lib/* || die
	epatch "${FILESDIR}"/20080420-*
}

src_install() {
	java-pkg_dojar build/readseq.jar
	java-pkg_dolauncher
}

pkg_postinst() {
	elog "Documentation is available at"
	elog "http://iubio.bio.indiana.edu/soft/molbio/readseq/java/Readseq2-help.html"
}
