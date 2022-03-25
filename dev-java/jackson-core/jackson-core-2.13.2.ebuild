# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/FasterXML/jackson-core/archive/jackson-core-2.13.2.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild jackson-core-2.13.2.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.fasterxml.jackson.core:jackson-core:2.13.2"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Core Jackson processing abstractions (Streaming API), implementation for JSON"
HOMEPAGE="https://github.com/FasterXML/jackson-core"
SRC_URI="https://github.com/FasterXML/${PN}/archive/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( README.md release-notes/{CREDITS-2.x,VERSION-2.x} )

S="${WORKDIR}/${PN}-${P}"

JAVA_SRC_DIR=( "src/main/java" "src/moditect" )
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_prepare() {
	default

	sed -e 's:@package@:com.fasterxml.jackson.core.json:g' \
		-e "s:@projectversion@:${PV}:g" \
		-e 's:@projectgroupid@:com.fasterxml.jackson.core:g' \
		-e 's:@projectartifactid@:jackson-core:g' \
		"${JAVA_SRC_DIR}/com/fasterxml/jackson/core/json/PackageVersion.java.in" \
		> "${JAVA_SRC_DIR}/com/fasterxml/jackson/core/json/PackageVersion.java" || die

	java-pkg-2_src_prepare
}

src_test() {
	pushd src/test/java || die
		local JAVA_TEST_RUN_ONLY=$(find * -name "*Test*.java" \
			! -wholename "**/failing**/*.java" \
			! -wholename "**/testsupport**/*.java" \
			! -wholename "perf**/*.java" \
			! -name "*TestBase.java" \
			! -name "*BaseTest.java" \
			)
	popd

	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	java-pkg-simple_src_test
}

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
