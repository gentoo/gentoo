# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2 java-ant-2

MY_P="${PN}-source-${PV}"
DESCRIPTION="Reads and writes nucleic/protein sequences in various formats"
HOMEPAGE="http://iubio.bio.indiana.edu/soft/molbio/readseq/"
# Originally unversioned at
# http://iubio.bio.indiana.edu/soft/molbio/readseq/java/readseq-source.zip.
# Renamed to the date of the modification and mirrored
SRC_URI="https://dev.gentoo.org/~dberkholz/distfiles/${MY_P}.zip"

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
	epatch "${FILESDIR}"/${PV}-*
}

src_install() {
	java-pkg_dojar build/readseq.jar
	java-pkg_dolauncher
}

pkg_postinst() {
	elog "Documentation is available at"
	elog "http://iubio.bio.indiana.edu/soft/molbio/readseq/java/Readseq2-help.html"
}
