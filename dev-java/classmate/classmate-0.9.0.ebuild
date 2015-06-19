# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/classmate/classmate-0.9.0.ebuild,v 1.1 2013/09/25 17:40:20 ercpe Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-pkg-simple vcs-snapshot

DESCRIPTION="Library for introspecting generic type information of types, member/static methods, fields"
HOMEPAGE="https://github.com/cowtowncoder/java-classmate/"
SRC_URI="https://github.com/cowtowncoder/java-classmate/archive/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	test? ( dev-java/junit:4 )"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src/main/java"

java_prepare() {
	rm pom.xml || die
}

src_test() {
	testcp="${S}/${PN}.jar:$(java-pkg_getjars junit-4):target/tests"

	mkdir target/tests || die
	ejavac -cp "${testcp}" -d target/tests $(find src/test/java -name "*.java")

	tests=$(find target/tests -name "*Test.class" -not -name "BaseTest.class" \
			| sed -e 's/target\/tests\///g' -e "s/\.class//" -e "s/\//./g" \
			| grep -vP '\$');
	ejunit4 -cp "${testcp}" ${tests}
}
