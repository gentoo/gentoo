# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Applies XPath expressions to graphs of objects of all kinds"
HOMEPAGE="http://commons.apache.org/jxpath/"
SRC_URI="mirror://apache/commons/jxpath/source/${P}-src.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

S="${WORKDIR}/${P}-src"

CDEPEND="
	dev-java/jdom:0
	java-virtuals/servlet-api:3.0
	dev-java/commons-beanutils:1.7"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	test? (
		dev-java/ant-junit:0
		dev-java/commons-logging:0
		dev-java/commons-collections:0
	)
	>=virtual/jdk-1.6"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_GENTOO_CLASSPATH="jdom,servlet-api-3.0,commons-beanutils-1.7"

EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},commons-logging,commons-collections,ant-junit"
ANT_TASKS="ant-junit"
EANT_TEST_TARGET="test"

# This one needs mockrunner. See #259027.
JAVA_RM_FILES=(
	src/test/org/apache/commons/jxpath/servlet/JXPathServletContextTest.java
)

java_prepare() {
	# Don't automatically run tests.
	sed 's/depends="compile,test"/depends="compile"/' -i build.xml || die
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar target/${PN}.jar
	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/*
}
