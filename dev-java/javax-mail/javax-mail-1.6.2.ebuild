# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom mail/pom.xml --download-uri https://github.com/javaee/javamail/archive/refs/tags/JAVAMAIL-1_6_2.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild oracle-javamail-1.6.2.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.sun.mail:javax.mail:1.6.2"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JavaMail API"
HOMEPAGE="https://javaee.github.io/javamail/"
SRC_URI="https://github.com/javaee/javamail/archive/refs/tags/JAVAMAIL-${PV//./_}.tar.gz"

LICENSE="|| ( CDDL GPL-2-with-classpath-exception )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

# No clue how to deal with ${S}/exclude.xml
# RESTRICT="test"

# Common dependencies
# POM: mail/pom.xml
# javax.activation:activation:1.1 -> !!!groupId-not-found!!!

CP_DEPEND="
	dev-java/jakarta-activation-api:1
"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( ../{LICENSE.txt,README.md} )

S="${WORKDIR}/javamail-JAVAMAIL-${PV//./_}/mail"

JAVA_ENCODING="iso-8859-1"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_prepare() {
	default
	mv src/main/{resources,java}/javax/mail/Version.java || die
}

src_test() {
	pushd src/test/java || die
		# Selection according to 201,202 pom.xml
		local JAVA_TEST_RUN_ONLY=$(find * \
			-name "*TestSuite.java" -o -name "*Test.java" \
			! -name "MailHandlerTest.java" \
			! -name "DurationFilterTest.java" \
			! -name "CompactFormatterTest.java" \
			! -name "CollectorFormatterTest.java" \
			! -name "WriteTimeoutSocketTest.java" \
			)
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	popd

	# With higher Java versions tests run forever.
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if [[ "${vm_version}" == "1.8" ]] ; then
		java-pkg-simple_src_test
	fi
}

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
