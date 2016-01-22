# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Guice is a lightweight dependency injection framework for Java 5 and above"
HOMEPAGE="https://github.com/google/guice/"
SRC_URI="https://github.com/google/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="4"
KEYWORDS="~amd64 ~x86"

IUSE=""

CDEPEND="dev-java/aopalliance:1
	dev-java/asm:4
	dev-java/guava:18
	>=dev-java/cglib-3.1:3
	>=dev-java/jarjar-1.4:1
	dev-java/javax-inject:0"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"

RESTRICT="test"

JAVA_PKG_BSFIX_NAME="build.xml common.xml servlet/build.xml"
JAVA_ANT_REWRITE_CLASSPATH="yes"

EANT_GENTOO_CLASSPATH="
	asm-4
	cglib-3
	guava-18
	javax-inject
	aopalliance-1
"

java_prepare() {
	# Where could we get this FREAKIN jar?
	cp ./lib/build/bnd-0.0.384.jar "${T}" || die

	find . -name '*.jar' -exec rm -v {} + || die
	find . -name '*.class' -exec rm -v {} + || die

	cp "${T}"/*.jar ./lib/build/ || die

	java-pkg_jar-from --into lib cglib-3 cglib.jar cglib-3.1.jar
	java-pkg_jar-from --into lib/build cglib-3 cglib.jar cglib-3.1.jar

	java-pkg_jar-from --into lib asm-4
	java-pkg_jar-from --into lib/build asm-4
	java-pkg_jar-from --into lib/build asm-4 asm.jar asm-5.0.3.jar

	java-pkg_jar-from --into lib guava-18
	java-pkg_jar-from --into lib javax-inject
	java-pkg_jar-from --into lib aopalliance-1
}

src_compile() {
	ANT_TASKS="jarjar-1" \
		java-pkg-2_src_compile
}

src_install() {
	java-pkg_newjar build/dist/"${PN}"-snapshot.jar "${PN}".jar
	use source && java-pkg_dosrc core/src/com
}
