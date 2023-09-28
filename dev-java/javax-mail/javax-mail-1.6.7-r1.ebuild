# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.sun.mail:jakarta.mail:1.6.7"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta Mail API"
HOMEPAGE="https://jakartaee.github.io/mail-api/"
SRC_URI="https://github.com/jakartaee/mail-api/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/mail-${PV}/mail"

LICENSE="EPL-1.0 EPL-2.0 GPL-2-with-classpath-exception"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

CDEPEND="
	dev-java/jakarta-activation:1
"

DEPEND="
	>=virtual/jdk-11:*
	${CDEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}"

DOCS=( ../{NOTICE,README}.md )

src_prepare() {
	java-pkg-2_src_prepare
	mv src/main/{resources,java}/javax/mail/Version.java || die
}

JAVA_ENCODING="iso-8859-1"
JAVA_GENTOO_CLASSPATH="jakarta-activation-1"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_EXTRA_ARGS=( -ea )
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_test() {
	pushd src/test/java || die
		# Selection according to 137,138 pom.xml
		# 1) com.sun.mail.util.logging.MailHandlerTest
		# java.io.IOException: Permission denied
		local JAVA_TEST_RUN_ONLY=$(find * \
			-name "*TestSuite.java" -o -name "*Test.java" \
			! -name "MailHandlerTest.java" \
			)
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	popd

	java-pkg-simple_src_test
}
