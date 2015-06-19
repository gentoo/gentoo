# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/gnu-hylafax/gnu-hylafax-1.0.3-r1.ebuild,v 1.1 2015/04/14 18:25:45 monsieurp Exp $

EAPI=5

JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java API designed to implement the client protocol portion of the hfaxd server"
HOMEPAGE="http://gnu-hylafax.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${P}-bin.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-java/commons-logging:0
		dev-java/commons-cli:1
		java-virtuals/javamail:0
		dev-java/java-getopt:1
		dev-java/log4j:0"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"

S="${WORKDIR}/${P}"

JAVA_GENTOO_CLASSPATH="commons-logging,commons-cli-1,javamail,java-getopt-1,log4j"

java_prepare() {
	rm -rv "${S}"/lib || die
	find -name "pom.xml" -delete || die

	# tarball contains the same sources in gnu-.../sources and gnu-.../main/
	rm -r gnu-hylafax-*/sources || die

	# bug 546502
	epatch "${FILESDIR}"/"${P}"-ClientPool.patch
}
