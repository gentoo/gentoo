# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri mirror://apache/commons/collections/source/commons-collections4-4.4-src.tar.gz --slot 4 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild commons-collections-4.4.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.commons:commons-collections4:4.4"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Extends the JCF classes with new interfaces, implementations and utilities"
HOMEPAGE="https://commons.apache.org/proper/commons-collections/"
SRC_URI="mirror://apache/commons/collections/source/${PN}4-${PV}-src.tar.gz -> ${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="4"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# Compile dependencies
# POM: pom.xml
# test? junit:junit:4.12 -> >=dev-java/junit-4.13.2:4
# test? org.apache.commons:commons-lang3:3.9 -> >=dev-java/commons-lang-3.12.0:3.6
# test? org.easymock:easymock:4.0.2 -> !!!suitable-mavenVersion-not-found!!!

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		dev-java/easymock:3.2
		dev-java/commons-lang:3.6
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
"

DOCS=( {CONTRIBUTING,README}.md {LICENSE,NOTICE,RELEASE-NOTES}.txt )
HTML_DOCS=( {DEVELOPERS-GUIDE,PROPOSAL}.html )

S="${WORKDIR}/commons-collections4-${PV}-src"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4,commons-lang-3.6,easymock-3.2"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_AUTOMATIC_MODULE_NAME="org.apache.commons.collections4"

src_test() {
	# https://github.com/apache/commons-collections/blob/cab58b3a8093a2f6b84f12783a3fb358747310f7/pom.xml#L542-L550
	pushd src/test/java || die
		local TESTS=$(find * -name "*Test.java" ! -name "TestUtils.java"  ! -name "Abstract*.java" ! -name "BulkTest.java")
		TESTS="${TESTS//.java}"
		TESTS="${TESTS//\//.}"
	popd

	JAVA_TEST_RUN_ONLY=( "${TESTS}" )
	java-pkg-simple_src_test
}

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
