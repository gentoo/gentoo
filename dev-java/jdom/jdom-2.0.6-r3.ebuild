# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="source test doc"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java API to manipulate XML data"
SRC_URI="http://www.jdom.org/dist/binary/${P}.zip"
HOMEPAGE="http://www.jdom.org"
LICENSE="JDOM"
SLOT="2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

CDEPEND="
	test? (
		dev-java/junit:4
	)
	dev-java/xalan:0
	dev-java/jaxen:1.1
	dev-java/iso-relax:0
	dev-java/xml-commons-external:1.4"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${CDEPEND}"
IUSE=""

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="xalan,jaxen-1.1,iso-relax,xml-commons-external-1.4"
JAVA_SRC_DIR="org"

# Dubious tests:
# They either do not pass or don't have runnable methods (i.e. tests)
UNIT_TESTS=(
	org/jdom2/test/cases/input/sax/TestXMLReaderSAX2Factory.java
	org/jdom2/test/cases/input/sax/TestXMLReaderSingletons.java
	org/jdom2/test/cases/input/sax/TestXMLReaderXSDFactory.java
	org/jdom2/test/cases/input/sax/TestXMLReaderJAXPFactory.java
	org/jdom2/test/cases/input/sax/TestXMLReaderSchemaFactory.java
	org/jdom2/test/cases/input/TestSAXComplexSchema.java
	org/jdom2/test/cases/input/TestSAXBuilder.java
	org/jdom2/test/cases/input/TestSAXHandler.java
	org/jdom2/test/cases/input/TestDOMBuilder.java
	org/jdom2/test/cases/input/TestDTDParser.java
	org/jdom2/test/cases/input/TestJDOMParseExceptn.java
	org/jdom2/test/cases/input/TestStAXEventBuilder.java
	org/jdom2/test/cases/input/TestBuilderErrorHandler.java
	org/jdom2/test/cases/input/TestStAXStreamBuilder.java
	org/jdom2/test/cases/input/HelpTestDOMBuilder.java
	org/jdom2/test/cases/special/TestIssue008ExpandEntity.java
	org/jdom2/test/cases/located/TestLocatedJDOMFactory.java
	org/jdom2/test/cases/xpath/TestJaxenXPathHelper.java
	org/jdom2/test/cases/xpath/TestDefaultXPathHelper.java
)

src_unpack() {
	default
	cd "${S}"
	unpack ./"${P}-sources".jar
}

java_prepare() {
	find "${S}"/lib -type f -delete || die
	if use test; then
		JAVA_GENTOO_CLASSPATH+=",junit-4"
	else
		# Override the array with different files.
		UNIT_TESTS=(
			org/jdom2/test
			org/jdom2/Test*.java
			org/jdom2/contrib/android/TranslateTests.java
			org/jdom2/input/sax/TestTextBuffer.java
		)
	fi

	rm -rf "${UNIT_TESTS[@]}" || die
}

src_compile() {
	java-pkg-simple_src_compile
}

src_install() {
	java-pkg-simple_src_install
	use source && java-pkg_dosrc org
}

src_test() {
	local DIR="org/jdom2/test"
	local CP="${DIR}:${PN}.jar:$(java-pkg_getjars junit-4,${JAVA_GENTOO_CLASSPATH})"
	local TESTS=()

	while read -d $'\0' -r file; do
		basefile=$(basename ${file})
		{
			# Skip if starts with Abstract
			[[ ${basefile} =~ ^Abstract ]] || \
			# Skip if doesn't starts with Test
			[[ ! ${basefile} =~ ^Test ]] || \
			# Skip if doesn't end with the .java extension
			[[ ! ${basefile} =~ \.java$ ]]
		} && continue
		TESTS+=(${file})
	done < <(find "${DIR}" -type f -print0)

	# Turn ${TESTS[@}} array into a string
	TESTS="${TESTS[@]}"
	TESTS="${TESTS//src\/test\/java\/}"
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejunit4 -classpath "${CP}" ${TESTS}
}
