# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.healthmarketscience.jackcess:jackcess:4.0.7"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A pure Java library for reading from and writing to MS Access databases"
HOMEPAGE="https://jackcess.sourceforge.io"
SRC_URI="https://github.com/jahlborn/${PN}/archive/${P}.tar.gz -> ${P}-sources.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~amd64-linux ~x86-linux ~ppc-macos"

CP_DEPEND="
	>=dev-java/commons-lang-3.17:3.6
	>=dev-java/commons-logging-1.3.1:0[log4j]
	>=dev-java/poi-5.2.5:0
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

PATCHES=( "${FILESDIR}/jackcess-4.0.0-fix-tests.patch" )

JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

JAVA_TEST_EXCLUDES=(
	# initializationError(com.healthmarketscience.jackcess.TestUtil)
	# org.junit.runners.model.InvalidTestClassError: Invalid test class 'com.healthmarketscience.jackcess.TestUtil'
	"com.healthmarketscience.jackcess.TestUtil"
)

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
}

src_test() {
	export TZ=UTC
	export LC_ALL=C
	java-pkg-simple_src_test
}
