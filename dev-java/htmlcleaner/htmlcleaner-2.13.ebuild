# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="HTML parser written in Java that can be used as a tool, library or Ant task"
HOMEPAGE="http://htmlcleaner.sourceforge.net/"
SRC_URI="mirror://sourceforge/htmlcleaner/files/${P}-src.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND="dev-java/jdom:2"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.5"

DEPEND="
	${CDEPEND}
	app-arch/unzip
	dev-java/ant-core:0
	test? ( dev-java/junit:4 )
	>=virtual/jdk-1.5"

JAVA_SRC_DIR="src/main/java"
JAVA_GENTOO_CLASSPATH="jdom-2"

src_prepare() {
	# Don't require default.xml to be in the current directory.
	sed -i "s:\"default\.xml\":\"${JAVA_PKG_SHAREPATH}/default.xml\":g" \
		src/main/java/org/htmlcleaner/ConfigFileTagProvider.java || die
}

src_configure() {
	JAVA_GENTOO_CLASSPATH_EXTRA=$(java-pkg_getjars --build-only ant-core)
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_register-ant-task
	java-pkg_dolauncher ${PN} --main org.${PN}.CommandLine

	insinto "${JAVA_PKG_SHAREPATH}"
	newins example.xml default.xml
}

src_test() {
	local DIR="src/test/java"
	local CP="${DIR}:${PN}.jar:$(java-pkg_getjars junit-4,${JAVA_GENTOO_CLASSPATH})"

	local TESTS=$(find "${DIR}" -name "*Test.java" ! -name "Abstract*")
	TESTS="${TESTS//src\/test\/java\/}"
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -classpath "${CP}" -d "${DIR}" $(find "${DIR}" -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
