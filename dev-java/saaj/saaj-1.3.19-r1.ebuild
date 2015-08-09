# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

JAVA_PKG_IUSE="examples source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="SOAP with Attachments API for Java"
HOMEPAGE="https://saaj.dev.java.net/"
# svn export https://svn.java.net/svn/saaj~svn/tags/saaj-impl-1.3.19 saaj-1.3.19
# tar cjf saaj-1.3.19.tar.bz2 saaj-1.3.19
SRC_URI="https://dev.gentoo.org/~sera/distfiles/${P}.tar.bz2"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

# jaf and saaj-api only for java 5
COMMON_DEP="
	dev-java/mimepull:0
	dev-java/xerces:2
	dev-java/xml-commons-external:1.4
	java-virtuals/jaf:0
	java-virtuals/saaj-api:0"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.5"
# servlet-api 2.5 for java 5. 3.0 is java 6.
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.5
	test? (
		dev-java/ant-junit:0
		dev-java/xalan:0
		java-virtuals/servlet-api:2.5
	)"

java_prepare() {
	find -name '*.jar' -exec rm -v {} + || die

	epatch "${FILESDIR}"/${P}-java-5-bootclasspath.patch

	# YES! There's nothing like using com.sun...internal ! YAY!
	find src -name '*.java' -exec sed -i \
		-e 's,com.sun.org.apache.xerces.internal,org.apache.xerces,g' \
		-e 's,com.sun.org.apache.xalan.internal.xsltc.trax,org.apache.xalan.xsltc.trax,g' \
		{} + || die
}

JAVA_ANT_REWRITE_CLASSPATH="yes"

EANT_GENTOO_CLASSPATH="mimepull,jaf,saaj-api,xerces-2,xml-commons-external-1.4"

EANT_TEST_TARGET="test-all"
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},servlet-api-2.5,xalan"
src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar build/lib/saaj-impl.jar ${PN}.jar
	dohtml -r docs/*

	use examples && java-pkg_doexamples samples
	use source && java-pkg_dosrc src/java/*
}
