# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/htmlparser-org/htmlparser-org-1.6.ebuild,v 1.1 2014/07/11 17:54:09 ercpe Exp $

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-pkg-simple

MY_PN=${PN/-org/}
MY_PV=$(replace_all_version_separators _)
SRC_VER="20060610"

DESCRIPTION="Java library used to parse HTML (from htmlparser.org)"
HOMEPAGE="http://htmlparser.sourceforge.net/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_PN}${MY_PV}_${SRC_VER}.zip"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

S="${WORKDIR}/${MY_PN}${MY_PV}"

DEPEND="app-arch/unzip
	>=virtual/jdk-1.6
	test? ( dev-java/junit:0 )"
RDEPEND=">=virtual/jre-1.6"

JAVA_SRC_DIR="src"

java_prepare() {
	unzip src.zip || die
	rm build.xml lib/* || die
	mkdir -p src-test/org/htmlparser/tests || die
	mv src/org/htmlparser/tests/* src-test/org/htmlparser/tests || die
}

src_test() {
	mkdir target/tests || die
	testcp="$(java-pkg_getjars junit):target/tests:${PN}.jar:${JAVA_HOME}/lib/tools.jar"
	ejavac -cp "${testcp}" -d target/tests $(find src-test/ -name "*.java")
	tests=$(find target/tests -name "*Test.class" \
			| sed -e 's/target\/tests\///g' -e "s/\.class//" -e "s/\//./g" \
			| grep -vP '\$');
	ejunit -cp "${testcp}" ${tests}
}
