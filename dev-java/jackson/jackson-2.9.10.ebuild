# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="High-performance JSON processor"
HOMEPAGE="https://github.com/FasterXML/jackson-core"
SRC_URI="https://github.com/FasterXML/${PN}-core/archive/${PN}-core-${PV}.tar.gz"
LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=virtual/jre-1.7"
DEPEND=">=virtual/jdk-1.7
	test? ( dev-java/junit:4 )"

S="${WORKDIR}/${PN}-core-${PN}-core-${PV}"
JAVA_SRC_DIR="src/main/java"

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

src_compile() {
	java-pkg-simple_src_compile
	java-pkg_addres ${PN}.jar src/main/resources
}

src_install() {
	java-pkg-simple_src_install
	dodoc README.md release-notes/{CREDITS,VERSION}-2.x
}

src_test() {
	cd src/test/java || die

	local CP=".:../resources:${S}/${PN}.jar:$(java-pkg_getjars junit-4)"
	local TESTS=$(find * -name "Test*.java")
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -cp "${CP}" -d . $(find * -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
