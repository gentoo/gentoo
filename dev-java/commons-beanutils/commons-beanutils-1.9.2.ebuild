# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Provides easy-to-use wrappers around Reflection and Introspection APIs"
HOMEPAGE="http://commons.apache.org/beanutils/"
SRC_URI="mirror://apache/commons/beanutils/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="1.7"
KEYWORDS="amd64 ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

CDEPEND="dev-java/commons-collections:0
	dev-java/commons-logging:0"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.6
	test? (
		dev-java/ant-junit:0
		dev-java/junit:0
		dev-java/commons-collections[test-framework]
	)
	${CDEPEND}"

S="${WORKDIR}/${P}-src"

# Buggy tests.
JAVA_RM_FILES=(
	src/test/java/org/apache/commons/beanutils/IndexedPropertyTestCase.java
	src/test/java/org/apache/commons/beanutils/BeanMapTestCase.java
	src/test/java/org/apache/commons/beanutils/bugs/Jira422TestCase.java
	src/test/java/org/apache/commons/beanutils/BeanificationTestCase.java
	src/test/java/org/apache/commons/beanutils/DefaultIntrospectionContextTestCase.java
)

EANT_GENTOO_CLASSPATH="commons-logging,commons-collections"

java_prepare() {
	JAVA_ANT_CLASSPATH_TAGS="javac java" java-ant_rewrite-classpath
}

src_test() {
	EANT_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junit"
	ANT_TASKS="ant-junit" eant \
		-Dcommons-collections.jar=$(java-pkg_getjar commons-collections commons-collections.jar) \
		-Dcommons-collections-testframework.jar=$(java-pkg_getjar commons-collections commons-collections-testframework.jar) \
		-Dcommons-logging.jar=$(java-pkg_getjar commons-logging commons-logging.jar) \
		test
}

src_install() {
	java-pkg_newjar dist/${P}.jar

	dodoc RELEASE-NOTES.txt || die

	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/main/java/org
}
