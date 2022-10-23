# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://ftp.wayne.edu/apache//commons/bcel/source/bcel-6.5.0-src.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris" --ebuild bcel-6.5.0-r1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.bcel:bcel:6.5.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Apache Commons Bytecode Engineering Library"
HOMEPAGE="https://commons.apache.org/proper/commons-bcel/"
SRC_URI="mirror://apache/commons/${PN}/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# Compile dependencies
# POM: pom.xml
# test? javax:javaee-api:6.0 -> !!!groupId-not-found!!!
# test? junit:junit:4.13 -> >=dev-java/junit-4.13.1:4
# test? net.java.dev.jna:jna:5.5.0 -> !!!groupId-not-found!!!
# test? net.java.dev.jna:jna-platform:5.5.0 -> !!!groupId-not-found!!!
# test? org.apache.commons:commons-lang3:3.10 -> >=dev-java/commons-lang-3.11:3.6

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		dev-java/commons-collections:4
		dev-java/commons-io:1
		dev-java/commons-lang:3.6
		dev-java/javax-mail:0
		dev-java/jmh-core:0
		dev-java/jna:4
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
"

RESTRICT="!test? ( test )"

S="${WORKDIR}/${P}-src"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="commons-collections-4,commons-io-1,commons-lang-3.6,jmh-core,jna-4,junit-4,javax-mail"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_prepare() {
	default
	sed \
		-e '/public void/s:testB79:notTestB79:' \
		-e '/public void/s:testB295:notTestB295:' \
		-i src/test/java/org/apache/bcel/PLSETestCase.java || die
	sed \
		-e '/public void/s:testLocalVariableCount:notTestLocalVariableCount:' \
		-e '/public void/s:testLocalVariableTableCount:notTestLocalVariableTableCount:' \
		-i src/test/java/org/apache/bcel/CounterVisitorTestCase.java || die
	sed \
		-e '/import org.junit.Test/a import org.junit.Ignore;' \
		-e '/testRemoveLocalVariable()/i @Ignore' \
		-e '/testRemoveLocalVariables()/i @Ignore' \
		-e '/testInvalidNullMethodBody_MailDateFormat()/i @Ignore' \
		-i src/test/java/org/apache/bcel/generic/MethodGenTestCase.java || die
}

src_test() {
	pushd src/test/java || die
		local JAVA_TEST_RUN_ONLY=$(find * \
			-wholename "**/*TestCase.java" \
			! -name "Abstract*TestCase.java" \
			)
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	popd
	java-pkg-simple_src_test
}
