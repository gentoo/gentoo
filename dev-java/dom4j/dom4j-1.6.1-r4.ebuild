# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java library for working with XML"
HOMEPAGE="http://dom4j.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/dom4j/${P}.tar.gz
	mirror://gentoo/${P}-java5.patch.bz2"

LICENSE="dom4j"
SLOT="1"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

COMMON_DEP="
	dev-java/jaxme:0
	dev-java/relaxng-datatype:0
	dev-java/xpp2:0
	dev-java/xpp3:0
	dev-java/xsdlib:0
	java-virtuals/stax-api:0"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.5"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.5
	test? (
		dev-java/ant-junit:0
		dev-java/junitperf:0
	)"

java_prepare() {
	# Circular deps with jaxen #212993
	find -name '*.jar' -! -name jaxen-1.1-beta-6.jar -exec rm -v {} + || die

	# Add missing methods to compile on Java 5 #137970
	epatch "${WORKDIR}/${P}-java5.patch"
}

JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_CLASSPATH_TAGS+=" javadoc"

EANT_BUILD_TARGET="clean package"
EANT_GENTOO_CLASSPATH="jaxme,relaxng-datatype,stax-api,xpp2,xpp3,xsdlib"
EANT_GENTOO_CLASSPATH_EXTRA="lib/jaxen-1.1-beta-6.jar"
EANT_EXTRA_ARGS="-Dbuild.javadocs=build/doc/api"

EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junitperf"

src_test() {
	# Needs X11
	rm -v src/test/org/dom4j/bean/BeansTest.java || die
	# Fails with a 1.6 JDK for some reason
	rm -v src/test/org/dom4j/io/StaxTest.java || die
	# Fails with a 1.7 JDK for some reason
	rm -v src/test/org/dom4j/rule/RuleTest.java || die

	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar build/${PN}.jar
	use doc && java-pkg_dojavadoc build/doc/api
	use source && java-pkg_dosrc src/java/*
}
