# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://mirror.dkm.cz/apache//commons/csv/source/commons-csv-1.8-src.tar.gz --slot 0 --keywords "~amd64 ~x86" --ebuild commons-csv-1.8.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.commons:commons-csv:1.8"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Simple interface for reading and writing CSV files of various types."
HOMEPAGE="https://commons.apache.org/proper/commons-csv/"
SRC_URI="https://mirror.dkm.cz/apache//commons/csv/source/${P}-src.tar.gz -> ${P}-sources.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

# missing test deps
RESTRICT="test"

# Compile dependencies
# POM: pom.xml
# test? com.h2database:h2:1.4.200 -> !!!groupId-not-found!!!
# test? commons-io:commons-io:2.6 -> >=dev-java/commons-io-2.8.0:1
# test? org.apache.commons:commons-lang3:3.9 -> >=dev-java/commons-lang-3.12.0:3.6
# test? org.hamcrest:hamcrest:2.2 -> !!!artifactId-not-found!!!
# test? org.junit.jupiter:junit-jupiter:5.6.0 -> !!!groupId-not-found!!!
# test? org.mockito:mockito-core:3.2.4 -> !!!suitble-mavenVersion-not-found!!!

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		>=dev-java/commons-io-2.8.0:1
		>=dev-java/commons-lang-3.12.0:3.6
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
"

S="${WORKDIR}/${P}-src"

DOCS=( LICENSE.txt NOTICE.txt RELEASE-NOTES.txt )

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS=(
	"src/main/resources"
)

JAVA_TEST_GENTOO_CLASSPATH="commons-io-1,commons-lang-3.6"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS=(
	"src/test/resources"
)
