# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Provides easy-to-use wrappers around Reflection and Introspection APIs"
HOMEPAGE="http://commons.apache.org/beanutils/"
SRC_URI="mirror://apache/commons/beanutils/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="1.7"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

COMMON_DEP="
	dev-java/commons-collections:0
	dev-java/commons-logging:0"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	test? (
		dev-java/ant-junit
		dev-java/junit:0
		dev-java/commons-collections[test-framework]
	)
	${COMMON_DEP}"

S="${WORKDIR}/${P}-src"

java_prepare() {
	rm -vr src/main/java/org/apache/commons/collections/ || die
	# from pom.xml:
	# <!-- This test case is known to fail, and there isn't any proposed fix
	#   -  so we will just exclude it until someone comes up with a solution.
	# -->
	JAVA_ANT_CLASSPATH_TAGS="javac java" java-ant_rewrite-classpath
}

EANT_GENTOO_CLASSPATH="commons-logging,commons-collections"

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
	java-pkg_newjar dist/${PN}-core-${PV}.jar ${PN}-core.jar
	java-pkg_newjar dist/${PN}-bean-collections-${PV}.jar ${PN}-bean-collections.jar

	dodoc README.txt RELEASE-NOTES.txt || die

	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/main/java/org
}
