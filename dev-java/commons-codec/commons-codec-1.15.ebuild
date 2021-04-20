# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom commons-codec-1.15-src/pom.xml --download-uri https://apache.osuosl.org/commons/codec/source/commons-codec-1.15-src.tar.gz --slot 0 --keywords "~amd64 ~ppc64 ~x86" --ebuild commons-codec-1.15.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="commons-codec:commons-codec:1.15"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Implementations of common encoders and decoders in Java"
HOMEPAGE="https://commons.apache.org/proper/commons-codec/"
SRC_URI="mirror://apache/commons/codec/source/${P}-src.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"

# Compile dependencies
# POM: ${P}-src/pom.xml
# test? junit:junit:4.13 -> >=dev-java/junit-4.13.1:4
# test? org.apache.commons:commons-lang3:3.8 -> >=dev-java/commons-lang-3.11:3.6

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		>=dev-java/commons-lang-3.11:3.6
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
"

S="${WORKDIR}/${P}-src"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS=(
	"src/main/resources"
)

JAVA_TEST_GENTOO_CLASSPATH="junit-4,commons-lang-3.6"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS=(
	"src/test/resources"
)
