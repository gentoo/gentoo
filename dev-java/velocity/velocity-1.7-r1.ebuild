# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="examples doc source"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="A Java-based template engine for easy creation/rendering of documents that format and present data"
HOMEPAGE="http://velocity.apache.org"
SRC_URI="mirror://apache/${PN}/engine/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE="test"

CDEPEND="
	dev-java/commons-collections:0
	dev-java/commons-lang:2.1
	dev-java/commons-logging:0
	dev-java/jdom:0
	dev-java/log4j:0
	dev-java/avalon-logkit:2.0
	dev-java/jakarta-oro:2.0
	java-virtuals/servlet-api:2.3
	dev-java/werken-xpath:0
	dev-java/ant-core:0
"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.4
	test? (
		dev-java/ant-junit:0
		dev-java/ant-antlr:0
		dev-db/hsqldb:0
	)
"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.4"

JAVA_PKG_FILTER_COMPILER="jikes"
JAVA_ANT_REWRITE_CLASSPATH="yes"

EANT_GENTOO_CLASSPATH="
	commons-collections
	commons-lang-2.1
	commons-logging
	jdom
	log4j
	avalon-logkit-2.0
	jakarta-oro-2.0
	servlet-api-2.3
	werken-xpath
	ant-core
"

# One test fails. see #219668
RESTRICT="test"

java_prepare() {
	rm -v *.jar lib/test/*.jar lib/*.jar || die
}

src_compile () {
	cd "${S}"/build
	eant jar -Dskip-download=true #prebuilt javadocs
}

src_test() {
	mkdir -p bin/test-lib || die
	cd bin/test-lib || die
	java-pkg_jar-from junit,hsqldb
	java-pkg_jar-from --virtual servlet-api-2.3
	cd "${S}"/build
	ANT_TASKS="ant-junit ant-antlr" eant test -Dskip-download=true
}

src_install () {
	java-pkg_newjar bin/*.jar

	dodoc NOTICE README.txt
	# has other stuff besides api too
	use doc && java-pkg_dohtml -r docs/*
	use examples && java-pkg_doexamples examples
	use source && java-pkg_dosrc src/java/*
}
