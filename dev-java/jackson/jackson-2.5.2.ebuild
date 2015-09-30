# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="High-performance JSON processor"
HOMEPAGE="https://github.com/FasterXML/jackson-core"
SRC_URI="https://github.com/FasterXML/${PN}-core/archive/${PN}-core-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	test? ( dev-java/junit:4 )"

S="${WORKDIR}/${PN}-core-${PN}-core-${PV}/src"
JAVA_SRC_DIR="main/java"

java_prepare() {
	sed -e 's:@package@:com.fasterxml.jackson.core.json:g' \
		-e "s:@projectversion@:${PV}:g" \
		-e 's:@projectgroupid@:com.fasterxml.jackson.core:g' \
		-e 's:@projectartifactid@:jackson-core:g' \
		"${S}/main/java/com/fasterxml/jackson/core/json/PackageVersion.java.in" \
		> "${S}/main/java/com/fasterxml/jackson/core/json/PackageVersion.java" || die
}

src_install() {
	java-pkg-simple_src_install
	dodoc ../README.md ../release-notes/{CREDITS,VERSION}
}

src_test() {
	cd test/java || die

	local CP=".:../resources:${S}/${PN}.jar:$(java-pkg_getjars junit-4)"
	local TESTS=$(find * -name "Test*.java")
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -cp "${CP}" -d . $(find * -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
