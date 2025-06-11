# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.fasterxml.woodstox:woodstox-core:7.1.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="An XML processor that implements Stax (JSR-173), SAX2 and Stax2 APIs"
HOMEPAGE="https://github.com/FasterXML/woodstox"
SRC_URI="https://github.com/FasterXML/woodstox/archive/${P}.tar.gz"
S="${WORKDIR}/woodstox-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

CP_DEPEND="
	dev-java/bnd-annotation:0
	dev-java/msv:0
	dev-java/osgi-core:0
	dev-java/relaxng-datatype:0
	dev-java/stax2-api:0
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-11:*
	dev-java/xsdlib:0
	test? ( dev-java/mockito:4 )
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( {README,SECURITY}.md release-notes/{CREDITS,VERSION} )

JAVA_CLASSPATH_EXTRA="xsdlib"
JAVA_SRC_DIR=( src/{main/java,moditect} )
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_TEST_GENTOO_CLASSPATH="junit-4,mockito-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_prepare() {
	java-pkg-2_src_prepare

	# src/moditect/module-info.java:33: error: cannot find symbol
	#    provides org.codehaus.stax2.validation.XMLValidationSchemaFactory.dtd with com.ctc.wstx.dtd.DTDSchemaFactory;
	# https://bugs.gentoo.org/858302
	sed -e '/com.ctc.wstx.shaded.msv/d' \
		-e '/org.codehaus.stax2.validation/d' \
		-i "src/moditect/module-info.java" || die
}

# https://github.com/FasterXML/woodstox/blob/woodstox-core-6.3.0/pom.xml#L229-L243
src_test() {
	local JAVA_TEST_RUN_ONLY=$(find src/test/java \
		\( -path "**/Test*.java" -o -path "**/*Test.java" \) \
		! -path '**/failing/*.java' \
		! -path "**/Base*.java" -printf "%P\n")
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	java-pkg-simple_src_test
}
