# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="YAML data format extension for Jackson"
HOMEPAGE="https://github.com/FasterXML/jackson-dataformat-yaml"
SRC_URI="https://github.com/FasterXML/${PN}/archive/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64"
IUSE="test"

CDEPEND="~dev-java/jackson-${PV}:${SLOT}
	~dev-java/jackson-databind-${PV}:${SLOT}
	dev-java/snakeyaml:0"
RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.5
	${CDEPEND}
	test? (
		~dev-java/jackson-annotations-${PV}:${SLOT}
		dev-java/junit:4
	)"

S="${WORKDIR}/${PN}-${P}/src"
JAVA_SRC_DIR="main/java"
JAVA_GENTOO_CLASSPATH="jackson-${SLOT},jackson-databind-${SLOT},snakeyaml"

java_prepare() {
	sed -e 's:@package@:com.fasterxml.jackson.dataformat.yaml:g' \
		-e "s:@projectversion@:${PV}:g" \
		-e 's:@projectgroupid@:com.fasterxml.jackson.dataformat:g' \
		-e 's:@projectartifactid@:jackson-dataformat-yaml:g' \
		  "${S}/main/java/com/fasterxml/jackson/dataformat/yaml/PackageVersion.java.in" \
		> "${S}/main/java/com/fasterxml/jackson/dataformat/yaml/PackageVersion.java" || die

	# Requires OPS4J Pax Exam, which isn't packaged yet.
	rm "${S}/test/java/com/fasterxml/jackson/dataformat/yaml/failsafe/OSGiIT.java" || die
}

src_install() {
	java-pkg-simple_src_install
	dodoc ../README.md ../release-notes/{CREDITS,VERSION}
}

src_test() {
	cd test/java || die

	local CP=".:../resources:${S}/${PN}.jar:$(java-pkg_getjars jackson-annotations-${SLOT},junit-4,${JAVA_GENTOO_CLASSPATH})"
	local TESTS=$(find * -name "*Test*.java" ! -name "*TestBase*" ! -path "*/failing/*")
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -cp "${CP}" -d . $(find * -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
