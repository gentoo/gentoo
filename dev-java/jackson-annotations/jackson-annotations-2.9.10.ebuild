# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Annotations for the Java Jackson data processor"
HOMEPAGE="https://github.com/FasterXML/jackson-annotations"
SRC_URI="https://github.com/FasterXML/${PN}/archive/${PN}-${PV}.tar.gz"
LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=virtual/jre-1.7"

DEPEND=">=virtual/jdk-1.7
	test? ( dev-java/junit:4 )"

S="${WORKDIR}/${PN}-${P}"
JAVA_SRC_DIR="src/main/java"

src_install() {
	java-pkg-simple_src_install
	dodoc README.md release-notes/VERSION
}

src_compile() {
	java-pkg-simple_src_compile
	java-pkg_addres ${PN}.jar src/main/resources
}

src_test() {
	cd src/test/java || die

	local CP=".:${S}/${PN}.jar:$(java-pkg_getjars junit-4)"
	local TESTS=$(find * -name "*Test.java")
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -cp "${CP}" -d . $(find * -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
