# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="XML Java library"
HOMEPAGE="http://dom4j.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/dom4j/${P}.tar.gz
	mirror://gentoo/${P}-java5.patch.bz2"

LICENSE="dom4j"
SLOT="1"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

CDEPEND="
	dev-java/xpp2:0
	dev-java/xpp3:0
	dev-java/xsdlib:0
	dev-java/relaxng-datatype:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	test? (
		dev-java/xalan:0
		dev-java/ant-junit:0
		dev-java/junitperf:0
	)
	>=virtual/jdk-1.6"

PDEPEND="dev-java/jaxen:1.1"

# Add missing methods to compile on Java 5 #137970
PATCHES=( "${WORKDIR}/${P}-java5.patch" )

JAVA_RM_FILES=(
	src/test/org/dom4j/bean/BeansTest.java
	src/test/org/dom4j/io/StaxTest.java
	src/test/org/dom4j/rule/RuleTest.java
	src/test/org/dom4j/ThreadingTest.java
	src/test/org/dom4j/io/XPP3ReaderTest.java
)

src_prepare() {
	default

	# Circular deps with jaxen #212993
	find -name '*.jar' -! -name jaxen-1.1-beta-6.jar -exec rm -v {} + || die

	rm -v "${JAVA_RM_FILES[@]}" || die
}

JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_CLASSPATH_TAGS+=" javadoc"

JAVA_ANT_ENCODING="ISO-8859-1"

EANT_BUILD_TARGET="clean package"
EANT_GENTOO_CLASSPATH="relaxng-datatype,xpp2,xpp3,xsdlib"
EANT_GENTOO_CLASSPATH_EXTRA="lib/jaxen-1.1-beta-6.jar"
EANT_EXTRA_ARGS="-Dbuild.javadocs=build/doc/api"

EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junitperf,xalan"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar "build/${PN}.jar"
	java-pkg_register-dependency jaxen-1.1
	use doc && java-pkg_dojavadoc build/doc/api
	use source && java-pkg_dosrc src/java/*
}
