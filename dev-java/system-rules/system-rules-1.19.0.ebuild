# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/stefanbirkner/system-rules/archive/system-rules-1.19.0.tar.gz --slot 0 --keywords "~amd64" --ebuild system-rules-1.19.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.github.stefanbirkner:system-rules:1.19.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A collection of JUnit rules for testing code which uses java.lang.System."
HOMEPAGE="https://stefanbirkner.github.io/system-rules/"
SRC_URI="https://github.com/stefanbirkner/${PN}/archive/${P}.tar.gz"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

# Common dependencies
# POM: pom.xml
# junit:junit-dep:[4.9,) -> !!!artifactId-not-found!!!

CP_DEPEND="dev-java/junit:4"

# Compile dependencies
# POM: pom.xml
# test? com.github.stefanbirkner:fishbowl:1.4.0 -> >=dev-java/fishbowl-1.4.1:0
# test? commons-io:commons-io:2.4 -> >=dev-java/commons-io-2.11.0:1
# test? org.assertj:assertj-core:1.7.1 -> >=dev-java/assertj-core-2.3.0:2
# test? org.mockito:mockito-core:1.10.19 -> >=dev-java/mockito-4.4.0:4

# Restricting to jdk:1.8 since it doesn't work with java 11 or higher.
DEPEND="
	virtual/jdk:1.8
	${CP_DEPEND}
	test? (
		dev-java/assertj-core:3
		dev-java/commons-io:1
		dev-java/fishbowl:0
		dev-java/mockito:4
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

S="${WORKDIR}/${PN}-${P}"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="fishbowl,commons-io-1,assertj-core-3,mockito-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
