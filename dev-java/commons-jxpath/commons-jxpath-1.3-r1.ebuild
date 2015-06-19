# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-jxpath/commons-jxpath-1.3-r1.ebuild,v 1.2 2015/05/26 07:52:55 monsieurp Exp $

EAPI=5
JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Applies XPath expressions to graphs of objects of all kinds"
HOMEPAGE="http://commons.apache.org/jxpath/"
SRC_URI="mirror://apache/commons/jxpath/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

S="${WORKDIR}/${P}-src"

CDEPEND="dev-java/commons-beanutils:1.7
	java-virtuals/servlet-api:2.5
	dev-java/jdom:1.0"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	test? (
		dev-java/commons-collections:0
		dev-java/commons-logging:0
	)
	${CDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	mkdir -p "${S}/target/lib"
	cd "${S}/target/lib"
	java-pkg_jar-from commons-beanutils-1.7
	java-pkg_jar-from servlet-api-2.5
	java-pkg_jar-from jdom-1.0
}

src_prepare() {
	# Don't automatically run tests
	sed 's/depends="compile,test"/depends="compile"/' -i build.xml || die
}

src_test() {
	# this one needs mockrunner #259027
	rm src/test/org/apache/commons/jxpath/servlet/JXPathServletContextTest.java || die
	java-pkg_jar-from --into target/lib \
		commons-collections,commons-logging,junit
	ANT_TASKS="ant-junit" eant test
}

src_install() {
	java-pkg_dojar target/${PN}.jar
	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/*
}
