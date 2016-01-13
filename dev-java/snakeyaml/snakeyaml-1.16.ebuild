# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple vcs-snapshot

DESCRIPTION="A YAML 1.1 parser and emitter for Java 5"
HOMEPAGE="https://bitbucket.org/asomov/snakeyaml"
SRC_URI="https://bitbucket.org/asomov/${PN}/get/v${PV}.tar.bz2 -> ${P}.tar.bz2"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND=">=virtual/jdk-1.6
	test? (
		dev-java/joda-time:0
		dev-java/junit:4 )"

RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}/${P}"
JAVA_SRC_DIR="src/main/java"

java_prepare() {
	# Remove some tests with tricky dependencies.
	rm -rv src/test/java/{examples/SpringTest.java,org/yaml/snakeyaml/{emitter/template/VelocityTest.java,issues/issue9}} || die
}

src_install() {
	java-pkg-simple_src_install
	dodoc README.md src/etc/announcement.msg
}

src_test() {
	local DIR="src/test/java"
	local CP="${DIR}/../resources:${DIR}:${PN}.jar:$(java-pkg_getjars joda-time,junit-4)"

	local TESTS=$(find "${DIR}" -name "*Test.java" ! -name AbstractTest.java ! -name PyImportTest.java)
	TESTS="${TESTS//src\/test\/java\/}"
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -cp "${CP}" -d "${DIR}" $(find "${DIR}" -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
