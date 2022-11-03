# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/greenmail-mail-test/greenmail/archive/release-2.0.0-alpha-2.tar.gz --slot 2 --keywords "~amd64" --ebuild greenmail-2.0.0_alpha2.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.icegreen:greenmail:2.0.0-alpha-2"
# No tests, dependencies are not packaged
# JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="GreenMail - Email Test Servers"
HOMEPAGE="https://greenmail-mail-test.github.io/greenmail/"
SRC_URI="https://github.com/greenmail-mail-test/greenmail/archive/release-${PV/_alpha/-alpha-}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64"

# Common dependencies
# POM: pom.xml
# com.sun.mail:jakarta.mail:2.0.1 -> >=dev-java/jakarta-mail-2.0.1:0
# jakarta.activation:jakarta.activation-api:2.0.1 -> >=dev-java/jakarta-activation-api-2.1.0:2
# junit:junit:4.13.2 -> >=dev-java/junit-4.13.2:4
# org.slf4j:slf4j-api:1.7.32 -> >=dev-java/slf4j-api-1.7.36:0

CP_DEPEND="
	dev-java/jakarta-activation-api:2
	dev-java/jakarta-mail:0
	dev-java/junit:4
	dev-java/slf4j-api:0
"

# Compile dependencies
# POM: pom.xml
# test? org.assertj:assertj-core:3.19.0 -> !!!suitable-mavenVersion-not-found!!!
# test? org.hamcrest:hamcrest-core:2.2 -> !!!suitable-mavenVersion-not-found!!!
# test? org.hamcrest:hamcrest-library:2.2 -> !!!suitable-mavenVersion-not-found!!!
# test? org.slf4j:slf4j-log4j12:1.7.32 -> !!!artifactId-not-found!!!

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

DOCS=( ../README.md )

S="${WORKDIR}/greenmail-release-${PV/_alpha/-alpha-}/greenmail-core"

JAVA_SRC_DIR="src/main/java"
