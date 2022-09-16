# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/stefanbirkner/fishbowl/archive/fishbowl-1.4.1.tar.gz --slot 0 --keywords "~amd64" --ebuild fishbowl-1.4.1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.github.stefanbirkner:fishbowl:1.4.1"
# Tests not possible, several test dependencies are missing.
# JAVA_TESTING_FRAMEWORKS="testng junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Use the AAA pattern for writing tests for code that throws an exception"
HOMEPAGE="https://github.com/stefanbirkner/fishbowl/"
SRC_URI="https://github.com/stefanbirkner/${PN}/archive/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

# Compile dependencies
# POM: pom.xml
# test? com.google.truth:truth:0.25 -> !!!groupId-not-found!!!
# test? de.bechte.junit:junit-hierarchicalcontextrunner:4.12.0 -> !!!groupId-not-found!!!
# test? junit:junit:4.12 -> >=dev-java/junit-4.13.2:4
# test? org.assertj:assertj-core:1.7.1 -> >=dev-java/assertj-core-2.3.0:2
# test? org.easytesting:fest-assert:1.4 -> !!!groupId-not-found!!!
# test? org.hamcrest:hamcrest-core:1.3 -> >=dev-java/hamcrest-core-1.3:1.3
# test? org.hamcrest:hamcrest-library:1.3 -> >=dev-java/hamcrest-library-1.3:1.3
# test? org.mockito:mockito-core:1.10.19 -> >=dev-java/mockito-4.4.0:4
# test? org.testng:testng:6.8.17 -> !!!groupId-not-found!!!

DEPEND=">=virtual/jdk-1.8:*"
# 	test? (
# 		!!!groupId-not-found!!!
# 		>=dev-java/assertj-core-2.3.0:2
# 		>=dev-java/hamcrest-core-1.3:1.3
# 		>=dev-java/hamcrest-library-1.3:1.3
# 		>=dev-java/mockito-4.4.0:4
# 	)
# "

RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/${PN}-${P}"

JAVA_SRC_DIR="src/main/java"

# JAVA_TEST_GENTOO_CLASSPATH="!!!groupId-not-found!!!,!!!groupId-not-found!!!,junit-4,assertj-core-2,!!!groupId-not-found!!!,hamcrest-core-1.3,hamcrest-library-1.3,mockito-4,!!!groupId-not-found!!!"
# JAVA_TEST_SRC_DIR="src/test/java"
