# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri mirror://apache/commons/digester/source/commons-digester-2.1-src.tar.gz --slot 2.1 --keywords "~amd64 ~ppc64 ~x86" --ebuild commons-digester-2.1-r2.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="commons-digester:commons-digester:2.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Reads XML configuration files to provide initialization of various Java objects"
HOMEPAGE="https://commons.apache.org/digester/"
SRC_URI="mirror://apache/commons/digester/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="2.1"
KEYWORDS="amd64 ppc64 x86"

# Common dependencies
# POM: pom.xml
# commons-beanutils:commons-beanutils:1.8.3 -> >=dev-java/commons-beanutils-1.9.4:1.7
# commons-logging:commons-logging:1.1.1 -> >=dev-java/commons-logging-1.2:0

CP_DEPEND="
	>=dev-java/commons-beanutils-1.9.4:1.7
	>=dev-java/commons-logging-1.2:0
"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( {LICENSE,NOTICE,RELEASE-NOTES}.txt )

S="${WORKDIR}/commons-digester-${PV}-src"

JAVA_ENCODING="iso-8859-1"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_test() {
	pushd src/test/java || die
		# Exclusions according to 212,215 pom.xml
		local JAVA_TEST_RUN_ONLY=$(find * \
			! -name "Abstract*.java" ! -name "TestBean.java" \
			! -name "TestRule.java" ! -name "TestRuleSet.java" \
			-name "*TestCase.java" -o -name "*Test.java")
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	popd
	java-pkg-simple_src_test
}

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
