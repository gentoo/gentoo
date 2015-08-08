# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="source doc test"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Fast, efficient Java serialization and cloning"
HOMEPAGE="https://code.google.com/p/kryo/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.zip"

LICENSE="BSD-2"
SLOT="1"
KEYWORDS="~amd64 ~x86"

IUSE=""

CDEPEND="dev-java/objenesis:0
	dev-java/reflectasm:0
	dev-java/minlog:0"

DEPEND="${CDEPEND}
	test? ( dev-java/junit:4 )
	>=virtual/jdk-1.5"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.5"

S="${WORKDIR}/${P}"

JAVA_GENTOO_CLASSPATH="objenesis,reflectasm,minlog"
JAVA_SRC_DIR="${PN}/src"

src_prepare() {
	rm "${S}"/${PN}/pom.xml || die
	find "${S}" -name "*.jar" -delete || die
}

src_test() {
	mkdir target/tests || die
	local testcp="${S}/${PN}.jar:target/tests:$(java-pkg_getjars junit-4)"
	testcp+=":$(java-pkg_getjars --with-dependencies ${JAVA_GENTOO_CLASSPATH})"

	ejavac -cp "${testcp}" -d target/tests $(find ${PN}/test -name "*.java")
	tests=$(find target/tests -name "*Test.class" \
			| sed -e 's/target\/tests\///g' -e "s/\.class//" -e "s/\//./g" \
			| grep -vP '\$');
	ejunit4 -cp "${testcp}" ${tests}
}
