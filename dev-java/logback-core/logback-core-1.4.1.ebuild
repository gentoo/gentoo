# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom logback-core/pom.xml --download-uri https://github.com/qos-ch/logback/archive/v_1.4.1.tar.gz --slot 0 --keywords "~amd64" --ebuild logback-core-1.4.1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="ch.qos.logback:logback-core:1.4.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="logback-core module"
HOMEPAGE="https://logback.qos.ch"
SRC_URI="https://github.com/qos-ch/logback/archive/v_${PV}.tar.gz -> logback-${PV}.tar.gz"

LICENSE="EPL-1.0 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

# Common dependencies
# POM: ${PN}/pom.xml
# com.sun.mail:jakarta.mail:2.0.1 -> >=dev-java/jakarta-mail-2.0.1:0
# jakarta.mail:jakarta.mail-api:2.0.1 -> >=dev-java/jakarta-mail-api-2.1.0:0
# jakarta.servlet:jakarta.servlet-api:5.0.0 -> >=dev-java/jakarta-servlet-api-6.0.0:6
# org.codehaus.janino:janino:3.1.7 -> >=dev-java/janino-3.1.7:0
# org.fusesource.jansi:jansi:1.18 -> >=dev-java/jansi-2.4.0:2

CP_DEPEND="
	dev-java/jakarta-mail:0
	dev-java/jakarta-mail-api:0
	dev-java/jakarta-servlet-api:6
	~dev-java/janino-3.1.7:0
	dev-java/jansi:2
"

# Compile dependencies
# POM: ${PN}/pom.xml
# test? junit:junit:4.13.1 -> >=dev-java/junit-4.13.2:4
# test? org.assertj:assertj-core:1.7.1 -> >=dev-java/assertj-core-2.3.0:2
# test? org.mockito:mockito-core:4.3.0 -> >=dev-java/mockito-4.7.0:4

DEPEND="
	>=virtual/jdk-11:*
	${CP_DEPEND}
	test? (
		dev-java/assertj-core:3
		dev-java/mockito:4
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

#	DOCS=( ../README.md )

S="${WORKDIR}/logback-v_${PV}/logback-core"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4,assertj-core-3,mockito-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_test() {
	# 83,88 logback-core/pom.xml
	# <excludes>
	#   <exclude>**/All*Test.java</exclude>
	#   <exclude>**/PackageTest.java</exclude>
	#   <!-- ConsoleAppenderTest redirects System.out which is not well tolerated by Maven -->
	#   <exclude>**/ConsoleAppenderTest.java</exclude>
	# </excludes>
	rm src/test/java/ch/qos/logback/core/appender/ConsoleAppenderTest.java || die
	pushd src/test/java || die
		local JAVA_TEST_RUN_ONLY=$(find * \
			-name "*Test.java" \
			! -wholename "**/All*Test.java" \
			! -wholename "**/PackageTest.java" \
			! -name "AbstractAppenderTest.java" \
			! -name "AbstractPatternLayoutBaseTest.java" \
			)
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	popd

	# accessible: module java.base does not "opens java.lang" to unnamed module @42bb2aee
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if [[ "${vm_version}" -ge 17 ]]; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.lang=ALL-UNNAMED )
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.io=ALL-UNNAMED )
	fi
	java-pkg-simple_src_test
}
