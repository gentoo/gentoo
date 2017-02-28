# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Data-binding functionality and tree-model for the Java Jackson data processor"
HOMEPAGE="https://github.com/FasterXML/jackson-databind"
SRC_URI="https://github.com/FasterXML/${PN}/archive/${PN}-${PV}.tar.gz"
LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="test" # Missing deps.

CP_DEPEND="~dev-java/jackson-${PV}:${SLOT}
	~dev-java/jackson-annotations-${PV}:${SLOT}"

RDEPEND=">=virtual/jre-1.7
	${CP_DEPEND}"

DEPEND=">=virtual/jdk-1.7
	${CP_DEPEND}
	test? ( dev-java/junit:4 )"

S="${WORKDIR}/${PN}-${P}"
JAVA_SRC_DIR="src/main/java"

src_prepare() {
	default

	sed -e 's:@package@:com.fasterxml.jackson.databind.cfg:g' \
		-e "s:@projectversion@:${PV}:g" \
		-e 's:@projectgroupid@:com.fasterxml.jackson.core:g' \
		-e 's:@projectartifactid@:jackson-databind:g' \
		"${JAVA_SRC_DIR}/com/fasterxml/jackson/databind/cfg/PackageVersion.java.in" \
		> "${JAVA_SRC_DIR}/com/fasterxml/jackson/databind/cfg/PackageVersion.java" || die

	# Requires newer JScience. Could be any class but they chose this!
	rm "${S}/src/test/java/com/fasterxml/jackson/databind/introspect/NoClassDefFoundWorkaroundTest.java" || die

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

	local CP=".:../resources:${S}/${PN}.jar:$(java-pkg_getjars junit-4,${JAVA_GENTOO_CLASSPATH})"
	local TESTS=$(find * -name "Test*.java")
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -cp "${CP}" -d . $(find * -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
