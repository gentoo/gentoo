# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/junit/junit-4.6.ebuild,v 1.9 2012/01/01 22:39:29 sera Exp $

# WARNING: JUNIT.JAR IS _NOT_ SYMLINKED TO ANT-CORE LIB FOLDER AS JUNIT3 IS

JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2

MY_P=${P/-/}
DESCRIPTION="Simple framework to write repeatable tests"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"
HOMEPAGE="http://www.junit.org/"
LICENSE="CPL-1.0"
SLOT="4"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

CDEPEND="=dev-java/hamcrest-core-1.1*"
RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.5
	userland_GNU? ( >=sys-apps/findutils-4.3 )
	app-arch/unzip
	${CDEPEND}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	mkdir -p src/main/java src/test/java || die
	unzip -qq -d src/main/java ${P}-src.jar || die "unzip failed"

	# fix javadoc compilation
	if use doc ; then
		cp "${S}"/javadoc/stylesheet.css "${S}" || die
	fi

	rm -rf javadoc temp.hamcrest.source *.jar || die
	find . -name "*.class" -delete || die
}

src_compile() {
	eant build jars -Dhamcrestlib=$(java-pkg_getjars hamcrest-core) $(use_doc javadoc)
}

src_test() {
	mkdir classes || die
	cd junit/tests || die
	local cp=$(java-pkg_getjars hamcrest-core):${S}/${PN}${PV}/${PN}-dep-${PV}.jar
	ejavac -sourcepath java -classpath ${cp} -d "${S}"/classes $(find . -name "*.java")

	cd "${S}"/classes || die
	for FILE in $(find . -name "AllTests\.class"); do
		local CLASS=$(echo ${FILE} | sed -e "s/\.class//" | sed -e "s%/%.%g" | sed -e "s/\.\.//")
		java -classpath .:${cp} org.junit.runner.JUnitCore ${CLASS} || die "Test ${CLASS} failed"
	done
}

src_install() {
	java-pkg_newjar ${PN}${PV}/${PN}-dep-${PV}.jar
	dodoc README.html doc/ReleaseNotes${PV}.txt || die

	use examples && java-pkg_doexamples org/junit/samples
	use source && java-pkg_dosrc src/main/java/org src/main/java/junit

	if use doc; then
		dohtml -r doc/*
		java-pkg_dojavadoc ${PN}${PV}/javadoc
	fi
}
