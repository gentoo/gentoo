# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="XML data format extension for Jackson"
HOMEPAGE="https://github.com/FasterXML/jackson-dataformat-xml"
SRC_URI="https://github.com/FasterXML/${PN}/archive/${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="test" # Lots of failures, new Woodstox needed?

CP_DEPEND="~dev-java/jackson-${PV}:${SLOT}
	~dev-java/jackson-annotations-${PV}:${SLOT}
	~dev-java/jackson-databind-${PV}:${SLOT}
	~dev-java/jackson-module-jaxb-annotations-${PV}:${SLOT}
	dev-java/stax2-api:0"

RDEPEND=">=virtual/jre-1.7
	${CP_DEPEND}"

DEPEND=">=virtual/jdk-1.7
	${CP_DEPEND}
	test? (
		dev-java/hamcrest-core:1.3
		dev-java/junit:4
	)"

S="${WORKDIR}/${PN}-${P}"
JAVA_SRC_DIR="src/main/java"

src_prepare() {
	default

	sed -e 's:@package@:com.fasterxml.jackson.dataformat.xml:g' \
		-e "s:@projectversion@:${PV}:g" \
		-e 's:@projectgroupid@:com.fasterxml.jackson.dataformat:g' \
		-e 's:@projectartifactid@:jackson-dataformat-xml:g' \
		  "${JAVA_SRC_DIR}/com/fasterxml/jackson/dataformat/xml/PackageVersion.java.in" \
		> "${JAVA_SRC_DIR}/com/fasterxml/jackson/dataformat/xml/PackageVersion.java" || die

	java-pkg-2_src_prepare
}

src_compile() {
	java-pkg-simple_src_compile
	java-pkg_addres ${PN}.jar src/main/resources
}

src_install() {
	java-pkg-simple_src_install
	dodoc README.md release-notes/{CREDITS,VERSION}
}

src_test() {
	cd src/test/java || die

	local CP=".:../resources:${S}/${PN}.jar:$(java-pkg_getjars hamcrest-core-1.3,junit-4,${JAVA_GENTOO_CLASSPATH})"
	local TESTS=$(find * -name "Test*.java" ! -path "*/failing/*")
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -cp "${CP}" -d . $(find * -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
