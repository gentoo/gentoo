# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/FasterXML/woodstox/archive/woodstox-core-6.4.0.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild woodstox-core-6.4.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.fasterxml.woodstox:woodstox-core:6.4.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="An XML processor that implements Stax (JSR-173), SAX2 and Stax2 APIs"
HOMEPAGE="https://github.com/FasterXML/woodstox"
SRC_URI="https://github.com/FasterXML/woodstox/archive/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# Common dependencies
# POM: pom.xml
# net.java.dev.msv:msv-core:2013.6.1 -> >=dev-java/msv-2022.7:0
# net.java.dev.msv:xsdlib:2013.6.1 -> >=dev-java/xsdlib-2022.7:0
# org.codehaus.woodstox:stax2-api:4.2.1 -> >=dev-java/stax2-api-4.2.1:0
# relaxngDatatype:relaxngDatatype:20020414 -> >=dev-java/relaxng-datatype-20020414:0

CP_DEPEND="
	dev-java/msv:0
	dev-java/relaxng-datatype:0
	dev-java/stax2-api:0
	dev-java/xsdlib:0
"

# Compile dependencies
# POM: pom.xml
# biz.aQute.bnd:biz.aQute.bnd.annotation:6.3.1 -> >=dev-java/aqute-bnd-annotation-6.3.1:0
# org.osgi:osgi.core:5.0.0 -> >=dev-java/osgi-core-8.0.0:0
# POM: pom.xml
# test? junit:junit:4.13.2 -> >=dev-java/junit-4.13.2:4

DEPEND="${CP_DEPEND}
	>=virtual/jdk-11:*
	dev-java/bnd-annotation:0
	dev-java/osgi-core:0"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( {README,SECURITY}.md release-notes/{CREDITS,VERSION} )

S="${WORKDIR}/woodstox-${P}"

JAVA_CLASSPATH_EXTRA="bnd-annotation,osgi-core"
JAVA_SRC_DIR=( "src/main/java" "src/moditect" )
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

# https://github.com/FasterXML/woodstox/blob/woodstox-core-6.3.0/pom.xml#L229-L243
src_test() {
	pushd src/test/java > /dev/null || die
		local JAVA_TEST_RUN_ONLY=$(find * \
			\( -wholename "**/Test*.java" \
			-o -wholename "**/*Test.java" \) \
			! -wholename "failing/*.java" \
			! -wholename "**/Abstract*.jav" \
			! -wholename "**/Base*.java" \
			)
	popd > /dev/null
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	java-pkg-simple_src_test
}

src_prepare() {
	default

	# src/moditect/module-info.java:33: error: cannot find symbol
	#    provides org.codehaus.stax2.validation.XMLValidationSchemaFactory.dtd with com.ctc.wstx.dtd.DTDSchemaFactory;
	# https://bugs.gentoo.org/858302
	sed -e '/com.ctc.wstx.shaded.msv/d' \
		-e '/org.codehaus.stax2.validation/d' \
		-i "src/moditect/module-info.java" || die
}
