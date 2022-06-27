# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom mail/pom.xml --download-uri https://github.com/eclipse-ee4j/mail/archive/refs/tags/1.6.7.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild javax-mail-1.6.7.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.sun.mail:jakarta.mail:1.6.7"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta Mail API"
HOMEPAGE="https://eclipse-ee4j.github.io/mail/"
SRC_URI="https://github.com/eclipse-ee4j/mail/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-1.0 EPL-2.0 GPL-2-with-classpath-exception"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# Common dependencies
# POM: mail/pom.xml
# com.sun.activation:jakarta.activation:1.2.1 -> >=dev-java/jakarta-activation-1.2.2:1

CDEPEND="
	>=dev-java/jakarta-activation-1.2.2:1
"

DEPEND="
	>=virtual/jdk-11:*
	${CDEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}"

DOCS=( ../{LICENSE,NOTICE,README}.md )

S="${WORKDIR}/mail-${PV}/mail"

src_prepare() {
	default
	mv src/main/{resources,java}/javax/mail/Version.java || die
}

JAVA_ENCODING="iso-8859-1"

JAVA_GENTOO_CLASSPATH="jakarta-activation-1"
JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_EXTRA_ARGS=( -ea )

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

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
