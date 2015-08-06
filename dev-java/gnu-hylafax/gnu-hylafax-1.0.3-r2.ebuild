# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/gnu-hylafax/gnu-hylafax-1.0.3-r2.ebuild,v 1.1 2015/08/06 22:01:18 monsieurp Exp $

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
		dev-java/oracle-javamail:0
		dev-java/java-getopt:1
		dev-java/log4j:0"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"

JAVA_GENTOO_CLASSPATH="
	commons-logging
	commons-cli-1
	oracle-javamail
	java-getopt-1
	log4j"

S="${WORKDIR}/${P}"

# bug 546502
PATCHES=(
	"${FILESDIR}"/"${P}"-ClientPool.patch
)

java_prepare() {
	rm -rv "${S}"/lib || die
	find -name "pom.xml" -delete || die

	# tarball contains the same sources in gnu-.../sources and gnu-.../main/
	rm -r gnu-hylafax-*/sources || die

	epatch ${PATCHES[@]}

}
