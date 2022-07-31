# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/conversant/disruptor/archive/1.2.20.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild conversant-disruptor-1.2.20.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.conversantmedia:disruptor:1.2.20"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Conversant Disruptor - very high throughput Java BlockingQueue"
HOMEPAGE="https://github.com/conversant/disruptor"
SRC_URI="https://github.com/conversant/disruptor/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# Compile dependencies
# POM: pom.xml
# test? junit:junit:4.13.1 -> >=dev-java/junit-4.13.2:4
# test? org.slf4j:slf4j-api:1.7.30 -> >=dev-java/slf4j-api-1.7.36:0

DEPEND="
	>=virtual/jdk-11:*
	test? (
		dev-java/slf4j-api:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
"

S="${WORKDIR}/disruptor-${PV}"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4,slf4j-api"
JAVA_TEST_SRC_DIR="src/test/java"

src_test() {
	# Using the defaults of java-pkg-simple would exclude
	# AbstractWaitingConditionTest and AbstractConditionTest
	# which both are run by "mvn test".
	pushd src/test/java || die
		local JAVA_TEST_RUN_ONLY=$(find * -name "*Test.java" )
	popd
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	java-pkg-simple_src_test
}

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
