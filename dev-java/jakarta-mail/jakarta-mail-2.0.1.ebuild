# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.sun.mail:jakarta.mail:2.0.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Implementation of the Jakarta Mail API"
HOMEPAGE="https://github.com/jakartaee/mail-api"
SRC_URI="https://github.com/jakartaee/mail-api/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/mail-api-${PV}/mail"

LICENSE="EPL-1.0 EPL-2.0 GPL-2-with-classpath-exception"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

CP_DEPEND="dev-java/jakarta-activation:2"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-11:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( ../{CONTRIBUTING,NOTICE,README}.md )

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
	# test failure with jdk:21
	# 1) testCheckAccessPresent(com.sun.mail.util.logging.LogManagerPropertiesTest)
	# java.lang.UnsupportedOperationException:
	# The Security Manager is deprecated and will be removed in a future release
	# 	at java.base/java.lang.System.setSecurityManager(System.java:429)
	# 	at com.sun.mail.util.logging.LogManagerPropertiesTest.testCheckAccessPresent(LogManagerPropertiesTest.java:89)
	# https://github.com/jakartaee/mail-api/pull/704#issuecomment-1911924741
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 21; then
		eapply "${FILESDIR}/jakarta-mail-2.0.1-LogManagerPropertiesTest.patch"
	fi
	pushd src/test/java || die
		# Selection according to 137,138 pom.xml
		# MailHandlerTest does not run because of
		# "java.io.IOException: Permission denied"
		# excluding it costs 141 tests.
		local JAVA_TEST_RUN_ONLY=$(find * \
			\( -path "**/*TestSuite.java" \
			-o -path "**/*Test.java" \) \
			! -name "MailHandlerTest.java" \
			)
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	popd

	java-pkg-simple_src_test
}
