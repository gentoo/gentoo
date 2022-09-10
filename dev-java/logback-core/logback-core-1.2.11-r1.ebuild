# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/qos-ch/logback/archive/v_1.2.11.tar.gz --slot 0 --keywords "~amd64" --ebuild logback-core-1.2.11.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="ch.qos.logback:logback-core:1.2.11"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="logback-core module"
HOMEPAGE="https://logback.qos.ch"
SRC_URI="https://github.com/qos-ch/logback/archive/v_${PV}.tar.gz -> logback-${PV}.tar.gz"

LICENSE="EPL-1.0 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

# Common dependencies
# POM: pom.xml
# javax.mail:mail:1.4 -> !!!groupId-not-found!!!
# javax.servlet:javax.servlet-api:3.1.0 -> !!!groupId-not-found!!!
# org.codehaus.janino:janino:3.0.6 -> >=dev-java/janino-3.1.6:0
# org.fusesource.jansi:jansi:1.9 -> >=dev-java/jansi-1.13:0

CP_DEPEND="
	dev-java/jakarta-servlet-api:4
	dev-java/janino:0
	dev-java/jansi:0
	dev-java/javax-mail:0
"

# Compile dependencies
# POM: pom.xml
# test? joda-time:joda-time:2.9.2 -> >=dev-java/joda-time-2.10.10:0
# test? junit:junit:4.10 -> >=dev-java/junit-4.13.2:4
# test? org.assertj:assertj-core:1.7.1 -> >=dev-java/assertj-core-2.3.0:2
# test? org.mockito:mockito-core:2.7.9 -> >=dev-java/mockito-4.4.0:4

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
	test? (
		dev-java/assertj-core:3
		dev-java/joda-time:0
		dev-java/mockito:4
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

DOCS=( ../README.md )

S="${WORKDIR}/logback-v_${PV}/logback-core"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="joda-time,junit-4,assertj-core-3,mockito-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_prepare() {
	default
	sed \
		-e 's:org.mockito.Matchers:org.mockito.ArgumentMatchers:' \
		-i 'src/test/java/ch/qos/logback/core/net/AbstractSocketAppenderIntegrationTest.java' || die

	# Ignore test failing under Java 16
	# See https://github.com/qos-ch/logback/commit/d6a8200cea6d960bf6832b9b95aed64e87474afb
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if [[ "${vm_version}" -ge "17" ]] ; then
		eapply "${FILESDIR}/logback-core-1.2.11-Ignore-test-failing-under-Java-16.patch"
	fi
}

src_test() {
	# 67,73 logback-core/pom.xml
	# <excludes>
	#   <exclude>**/All*Test.java</exclude>
	#   <exclude>**/PackageTest.java</exclude>
	#   <!-- ConsoleAppenderTest redirects System.out which is not well tolerated by Maven -->
	#   <exclude>**/ConsoleAppenderTest.java</exclude>
	#   <!--<exclude>**/TimeBasedRollingTest.java</exclude>-->
	# </excludes>
	pushd src/test/java || die
		local JAVA_TEST_RUN_ONLY=$(find * \
			-name "*Test.java" \
			! -wholename "**/All*Test.java" \
			! -wholename "**/PackageTest.java" \
			! -name "AbstractAppenderTest.java" \
			! -name "AbstractPatternLayoutBaseTest.java" \
			! -name "AbstractSocketAppenderIntegrationTest.java" \
			)
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	popd

	# accessible: module java.base does not "opens java.lang" to unnamed module @42bb2aee
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if [[ "${vm_version}" -ge "17" ]] ; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.lang=ALL-UNNAMED )
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.io=ALL-UNNAMED )
	fi
	java-pkg-simple_src_test
}
