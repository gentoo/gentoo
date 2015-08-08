# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A library of several reusable components used by Apache Batik and Apache FOP"
HOMEPAGE="http://xmlgraphics.apache.org/commons/index.html"
SRC_URI="mirror://apache/xmlgraphics/commons/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 x86 ppc ppc64"

CDEPEND="dev-java/commons-io:1
	>=dev-java/commons-logging-1:0"

DEPEND=">=virtual/jdk-1.6
	test? (
		dev-java/mockito:0
		dev-java/ant-junit:0
		dev-java/xml-commons-resolver:0
	)
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.6
		${CDEPEND}"

java_prepare() {
	find "${S}" -name '*.jar' -print -delete || die
}

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_BUILD_TARGET="jar-main"
EANT_DOC_TARGET="javadocs"

EANT_GENTOO_CLASSPATH="
	commons-io-1
	commons-logging
"

EANT_TEST_GENTOO_CLASSPATH="
	${EANT_GENTOO_CLASSPATH}
	xml-commons-resolver
	mockito
"

EANT_TEST_TARGET="junit-basic"

src_test() {
	EANT_ANT_TASKS="ant-junit" \
		java-pkg-2_src_test
}

src_install(){
	java-pkg_newjar build/${P}.jar

	use source && java-pkg_dosrc src/java/org
	use doc && java-pkg_dojavadoc build/javadocs
}
