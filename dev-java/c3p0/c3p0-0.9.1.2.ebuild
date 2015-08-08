# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
JAVA_PKG_IUSE="doc source"
JAVA_PKG_WANT_BOOTCLASSPATH="1.5"

inherit java-pkg-2 java-ant-2

SRC_P="${P}.src"

JAVA_PKG_WANT_SOURCE="1.4"
JAVA_PKG_WANT_TARGET="1.4"

DESCRIPTION="Library for augmenting traditional (DriverManager-based) JDBC drivers with JNDI-bindable DataSources"
HOMEPAGE="http://c3p0.sourceforge.net/"
# how to package the generated sources:
# 1) comment out the sed build.xml calls below and compile with forced sun-jdk-1.5
# 2) go to the ${WORKDIR}
# 3) tar -cjf c3p0-0.9.1.2-codegen.tar.bz2 c3p0-0.9.1.2.src/build/codegen/
SRC_URI="mirror://sourceforge/${PN}/${SRC_P}.tgz
	mirror://gentoo/c3p0-0.9.1.2-codegen.tar.bz2"
# Does not like Java 1.6's JDBC API
COMMON_DEPEND="dev-java/log4j"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEPEND}"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

S="${WORKDIR}/${SRC_P}"

src_prepare() {
	echo "j2ee.jar.base.dir=${JAVA_HOME}" > build.properties
	echo "log4j.jar.file=$(java-pkg_getjar log4j log4j.jar)" >> build.properties

	java-ant_rewrite-bootclasspath 1.5
	# don't generate sources, use the pregenerated from gentoo mirrors
	# since generator uses reflection, it's not as simple as javac bootclasspath rewrite
	sed -i 's/depends="codegen"//' build.xml
	sed -i 's/depends="codegen,/depends="init,/' build.xml
}

EANT_DOC_TARGET="javadocs"

src_install() {
	java-pkg_newjar build/${P}.jar
	dodoc README-SRC
	use doc && java-pkg_dojavadoc build/apidocs
	use source && java-pkg_dosrc src/classes/com
}
