# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/jahlborn/jackcess/archive/refs/tags/jackcess-4.0.0.tar.gz --slot 1 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild jackcess-4.0.0.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.healthmarketscience.jackcess:jackcess:4.0.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A pure Java library for reading from and writing to MS Access databases"
HOMEPAGE="https://jackcess.sourceforge.io"
SRC_URI="https://github.com/jahlborn/${PN}/archive/refs/tags/${P}.tar.gz -> ${P}-sources.tar.gz"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"

# Common dependencies
# POM: pom.xml
# commons-logging:commons-logging:1.2 -> >=dev-java/commons-logging-1.2:0
# org.apache.commons:commons-lang3:3.10 -> >=dev-java/commons-lang-3.11:3.6
# org.apache.poi:poi:4.0.0 -> >=dev-java/poi-5.0.0:0

CDEPEND="
	>=dev-java/commons-lang-3.11:3.6
	>=dev-java/commons-logging-1.2:0
	>=dev-java/poi-5.0.0:0
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}"

S="${WORKDIR}/${PN}-${P}"

PATCHES=(
	"${FILESDIR}/${P}-fix-tests.patch"
)

JAVA_GENTOO_CLASSPATH="commons-logging,commons-lang-3.6,poi"
JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

JAVA_TEST_EXCLUDES=(
	# initializationError(com.healthmarketscience.jackcess.TestUtil)
	# org.junit.runners.model.InvalidTestClassError: Invalid test class 'com.healthmarketscience.jackcess.TestUtil'
	"com.healthmarketscience.jackcess.TestUtil"
)

src_prepare() {
	default
	java-utils-2_src_prepare
}

src_test() {
	export TZ=UTC
	export LC_ALL=C
	java-pkg-simple_src_test
}
