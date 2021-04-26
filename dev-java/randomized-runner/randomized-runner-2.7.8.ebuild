# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/randomizedtesting/randomizedtesting/archive/refs/tags/release/2.7.8.tar.gz --slot 0 --keywords "~amd64 ~x86" --ebuild randomized-runner-2.7.8.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.carrotsearch.randomizedtesting:randomizedtesting-runner:2.7.8"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JUnit test runner and plugins for running JUnit tests with pseudo-randomness."
HOMEPAGE="https://github.com/randomizedtesting/randomizedtesting/randomizedtesting-runner"
SRC_URI="https://github.com/randomizedtesting/randomizedtesting/archive/refs/tags/release/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Common dependencies
# POM: pom.xml
# junit:junit:4.12 -> >=dev-java/junit-4.12:4

CDEPEND="
	>=dev-java/junit-4.12:4
"

# Compile dependencies
# POM: pom.xml
# test? org.assertj:assertj-core:2.2.0 -> >=dev-java/assertj-core-2.3.0:2

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
	test? (
		>=dev-java/assertj-core-2.3.0:2
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}"

S="${WORKDIR}/randomizedtesting-release-${PV}/${PN}"

JAVA_GENTOO_CLASSPATH="junit-4"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="assertj-core-2"
JAVA_TEST_SRC_DIR="src/test/java"
