# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A library of utility classes commonly used in transactional Java programming"
SRC_URI="mirror://apache/commons/transaction/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.4
	dev-java/commons-codec:0
	java-virtuals/transaction-api
	dev-java/log4j:0
	dev-java/commons-logging:0
	dev-java/glassfish-connector-api:0"
DEPEND=">=virtual/jdk-1.4
	${RDEPEND}"

S="${WORKDIR}/${P}-src"

java_prepare() {
	rm -v *.jar lib/*.jar || die
}

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="commons-codec,log4j,transaction-api,commons-logging,glassfish-connector-api"
EANT_DOC_TARGET="javadocs"
EANT_EXTRA_ARGS="-Djta.present=true -Djca.present=true -Dservlet.present=true"

src_install() {
	java-pkg_newjar dist/lib/${P}.jar ${PN}.jar

	dodoc NOTICE.txt README.txt RELEASE-NOTES.txt || die
	dohtml -r xdocs/* || die
	use doc && java-pkg_dojavadoc build/doc/apidocs
	use source && java-pkg_dosrc src/java/*
}
