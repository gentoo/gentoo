# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5

DESCRIPTION="Support for reading and writing YAML-encoded data via Jackson abstractions"
HOMEPAGE="https://github.com/FasterXML/jackson-dataformats-text"
SRC_URI="https://github.com/FasterXML/jackson-dataformats-text/archive/jackson-dataformats-text-${PV}.tar.gz"
S="${WORKDIR}/jackson-dataformats-text-jackson-dataformats-text-${PV}/yaml"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	~dev-java/jackson-annotations-$(ver_cut 1-2):0
	~dev-java/jackson-core-${PV}:0
	~dev-java/jackson-databind-${PV}:0
	>=dev-java/snakeyaml-2.5:0
	>=virtual/jdk-11:*
	test? ( dev-java/fastdoubleparser:0 )
"

RDEPEND="
	>=virtual/jre-1.8:*
"

DOCS=( README.md release-notes/{CREDITS,VERSION} )
JAVA_CLASSPATH_EXTRA="jackson-annotations jackson-core jackson-databind snakeyaml"
JAVA_INTERMEDIATE_JAR_NAME="com.fasterxml.jackson.dataformat.yaml"
JAVA_RELEASE_SRC_DIRS=( ["9"]="src/moditect" )
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="fastdoubleparser junit-5"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare

	sed -e 's:@package@:com.fasterxml.jackson.dataformat.yaml:g' \
		-e "s:@projectversion@:${PV}:g" \
		-e 's:@projectgroupid@:com.fasterxml.jackson.dataformat:g' \
		-e "s:@projectartifactid@:${PN}:g" \
		"${JAVA_SRC_DIR}/com/fasterxml/jackson/dataformat/yaml/PackageVersion.java.in" \
		> "${JAVA_SRC_DIR}/com/fasterxml/jackson/dataformat/yaml/PackageVersion.java" || die
}
