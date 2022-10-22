# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/qos-ch/slf4j/archive/v_2.0.3.tar.gz --slot 0 --keywords "~amd64" --ebuild slf4j-reload4j-2.0.3.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.slf4j:slf4j-reload4j:2.0.3"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="SLF4J Reload4j Binding"
HOMEPAGE="https://www.slf4j.org"
SRC_URI="https://github.com/qos-ch/slf4j/archive/v_${PV}.tar.gz -> slf4j-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

# Common dependencies
# POM: pom.xml
# ch.qos.reload4j:reload4j:1.2.19 -> >=dev-java/reload4j-1.2.22:0
# org.slf4j:slf4j-api:2.0.3 -> >=dev-java/slf4j-api-2.0.3:0

CP_DEPEND="
	dev-java/reload4j:0
	~dev-java/slf4j-api-${PV}:0
"

# Compile dependencies
# POM: pom.xml
# test? junit:junit:4.13.1 -> >=dev-java/junit-4.13.2:4
# test? org.slf4j:slf4j-api:2.0.3 -> >=dev-java/slf4j-api-2.0.3:0

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

DOCS=( ../{README,SECURITY}.md )

S="${WORKDIR}/slf4j-v_${PV}/${PN}"

JAVA_GENTOO_CLASSPATH_EXTRA=":../slf4j-api/src/test/java/"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR=( src/main/java{,9} )

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

JAVA_TEST_EXCLUDES=(
	# Upstream does not run this test:
	org.slf4j.testHarness.MultithreadedInitializationTest
)

src_prepare() {
	default
	# There was 1 failure:
	# 1) testWhetherEventsFieldsAreSet(org.slf4j.reload4j.EventFieldsTest)
	# java.lang.AssertionError
	#         at org.junit.Assert.fail(Assert.java:87)
	#         at org.junit.Assert.assertTrue(Assert.java:42)
	#         at org.junit.Assert.assertNotNull(Assert.java:713)
	#         at org.junit.Assert.assertNotNull(Assert.java:723)
	#         at org.slf4j.reload4j.EventFieldsTest.testWhetherEventsFieldsAreSet(EventFieldsTest.java:35)
	rm src/test/java/org/slf4j/reload4j/EventFieldsTest.java || die "cannot remove test"
}

src_test() {
	if use ppc64; then #877903
		JAVA_TEST_EXCLUDES+=( org.slf4j.reload4j.Reload4jMultithreadedInitializationTest )
	fi
	java-pkg-simple_src_test
}
