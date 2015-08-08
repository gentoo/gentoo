# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Apache XML-RPC is a Java implementation of XML-RPC"
HOMEPAGE="http://ws.apache.org/xmlrpc/"
SRC_URI="https://archive.apache.org/dist/ws/${PN}/sources/apache-${P}-src.tar.bz2
		http://dev.gentoo.org/~ercpe/distfiles/${CATEGORY}/${PN}/${P}-build.tar.gz"

LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="amd64 ppc x86"

CDEPEND="dev-java/commons-httpclient:3
	dev-java/commons-codec:0
	dev-java/ws-commons-util:0
	dev-java/commons-logging:0
	java-virtuals/servlet-api:2.4
	"
DEPEND=">=virtual/jdk-1.6
	test? (
		dev-java/ant-junit:0
		dev-java/junit:4
	)
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

IUSE=""

S="${WORKDIR}/apache-${P}-src"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="commons-httpclient-3,commons-codec,ws-commons-util"
EANT_GENTOO_CLASSPATH+=",commons-logging" # client
EANT_GENTOO_CLASSPATH+=",servlet-api-2.4" # server
EANT_GENTOO_CLASSPATH_EXTRA="${S}/common/target/${PN}-common.jar"

java_prepare() {
	# Doesn't work.
	rm -v \
		server/src/test/java/org/apache/xmlrpc/test/SerializerTest.java
}

EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junit-4,ant-junit"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar common/target/xmlrpc-common.jar server/target/xmlrpc-server.jar client/target/xmlrpc-client.jar

	use doc && java-pkg_dojavadoc {common,server,client}/target/site/apidocs
	use source && java-pkg_dosrc {common,server,client}/src/main/java/*
}
