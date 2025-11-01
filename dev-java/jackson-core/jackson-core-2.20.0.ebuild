# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5

DESCRIPTION="Core Jackson processing abstractions (Streaming API), implementation for JSON"
HOMEPAGE="https://github.com/FasterXML/jackson-core"
SRC_URI="https://github.com/FasterXML/${PN}/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-java/fastdoubleparser:0
	>=virtual/jdk-11:*
	test? ( >=dev-java/assertj-core-3.27.6:0 )
"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( {README,SECURITY}.md release-notes/{CREDITS-2.x,VERSION-2.x} )
JAVA_CLASSPATH_EXTRA="fastdoubleparser"
JAVA_INTERMEDIATE_JAR_NAME="com.fasterxml.jackson.core"
JAVA_RELEASE_SRC_DIRS=( ["9"]="src/moditect" )
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="assertj-core"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_prepare() {
	java-pkg-2_src_prepare

	sed -e 's:@package@:com.fasterxml.jackson.core.json:g' \
		-e "s:@projectversion@:${PV}:g" \
		-e 's:@projectgroupid@:com.fasterxml.jackson.core:g' \
		-e 's:@projectartifactid@:jackson-core:g' \
		"${JAVA_SRC_DIR}/com/fasterxml/jackson/core/json/PackageVersion.java.in" \
		> "${JAVA_SRC_DIR}/com/fasterxml/jackson/core/json/PackageVersion.java" || die
}
