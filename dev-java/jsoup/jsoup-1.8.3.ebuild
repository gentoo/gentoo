# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-pkg-simple

MY_PV="${PV}a"
MY_P="${PN}-${PN}-${MY_PV}"

DESCRIPTION="Java HTML parser that makes sense of real-world HTML soup"
HOMEPAGE="http://jsoup.org/"
SRC_URI="https://github.com/jhy/${PN}/archive/${PN}-${MY_PV}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6
	test? ( dev-java/junit:4 )"

S="${WORKDIR}/${MY_P}"

JAVA_SRC_DIR="src/main/java"

java_prepare() {
	rm pom.xml || die
	mkdir -p target/classes/org/jsoup/nodes/ || die
	cp src/main/java/org/jsoup/nodes/*.properties target/classes/org/jsoup/nodes/ || die
}

src_test() {
	testcp="${S}/${PN}.jar:$(java-pkg_getjars junit-4):target/tests"

	mkdir target/tests || die
	ejavac -cp "${testcp}" -d target/tests $(find src/test/java -name "*.java")
	cp -r src/test/resources/* target/tests || die

	tests=$(find target/tests -name "*Test.class" \
			| sed -e 's/target\/tests\///g' -e "s/\.class//" -e "s/\//./g" \
			| grep -vP '\$');
	ejunit4 -cp "${testcp}" ${tests}
}
