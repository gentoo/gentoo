# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/jakartaee/mail-api/archive/2.0.1.tar.gz --slot 0 --keywords "~amd64" --ebuild jakarta-mail-2.0.1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.sun.mail:jakarta.mail:2.0.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Implementation of the Jakarta Mail API"
HOMEPAGE="https://github.com/jakartaee/mail-api"
SRC_URI="https://github.com/jakartaee/mail-api/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-1.0 EPL-2.0 GPL-2-with-classpath-exception"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

# Common dependencies
# POM: pom.xml
# com.sun.activation:jakarta.activation:2.0.1 -> >=dev-java/jakarta-activation-2.0.1:2

CP_DEPEND="dev-java/jakarta-activation:2"

DEPEND="
	>=virtual/jdk-11:*
	${CP_DEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

DOCS=( ../{CONTRIBUTING,NOTICE,README}.md )

S="${WORKDIR}/mail-api-${PV}/mail"

JAVA_ENCODING="iso-8859-1"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_EXTRA_ARGS=( -ea )
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_prepare() {
	default
	mv src/main/{resources,java}/jakarta/mail/Version.java || die
}

src_test() {
	pushd src/test/java || die
		# Selection according to 137,138 pom.xml
		# This one does not run because of
		# "java.io.IOException: Permission denied"
		# excluding it costs 141 tests.
		# 1) com.sun.mail.util.logging.MailHandlerTest
		local JAVA_TEST_RUN_ONLY=$(find * \
			\( -wholename "**/*TestSuite.java" \
			-o -wholename "**/*Test.java" \) \
			! -name "MailHandlerTest.java" \
			)
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	popd

	java-pkg-simple_src_test
}
