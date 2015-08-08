# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A utility that allows simple XML documents to be constructed using Java"
HOMEPAGE="https://code.google.com/p/java-xmlbuilder/"
SRC_URI="http://dev.gentoo.org/~ercpe/distfiles/${CATEGORY}/${PN}/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-java/base64:0"
RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.5
	${CDEPEND}
	test? ( dev-java/junit:0 )
"

S="${WORKDIR}/${P}"
JAVA_SRC_DIR="src/main/java"
JAVA_GENTOO_CLASSPATH="base64"

src_test() {
	mkdir target/tests || die
	testcp="$(java-pkg_getjars ${JAVA_GENTOO_CLASSPATH},junit):target/tests:${S}/${PN}.jar"
	ejavac -cp "${testcp}" -d target/tests src/test/java/com/jamesmurty/utils/TestXmlBuilder.java
	ejunit4 -cp "${testcp}" com.jamesmurty.utils.TestXmlBuilder
}
