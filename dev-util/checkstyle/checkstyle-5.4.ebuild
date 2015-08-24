# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A development tool to help programmers write Java code that adheres to a coding standard"
HOMEPAGE="http://checkstyle.sourceforge.net"
SRC_URI="mirror://sourceforge/checkstyle/${P}-src.tar.gz
	https://dev.gentoo.org/~sera/distfiles/${P}-maven-build.xml.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEP="
	dev-java/ant-core:0
	>=dev-java/antlr-2.7.7:0[java]
	dev-java/commons-beanutils:1.7
	dev-java/commons-cli:1
	dev-java/commons-logging:0
	dev-java/guava:0"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.5"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.5
	dev-java/ant-nodeps:0
	test? (
		dev-java/ant-junit
		dev-java/junit:4
	)"

java_prepare() {
	EPATCH_OPTS="-p1" epatch "${WORKDIR}"/maven-build.xml.patch

	# maven ant:ant can't handle it.
	pushd src/checkstyle/com/puppycrawl/tools/checkstyle/grammars > /dev/null || die
		java -cp $(java-pkg_getjars antlr) antlr.Tool java.g || die
	popd > /dev/null
}

JAVA_PKG_BSFIX_NAME="maven-build.xml"
JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_CLASSPATH_TAGS="${JAVA_ANT_CLASSPATH_TAGS} javadoc"
JAVA_ANT_ENCODING="iso-8859-1"

EANT_BUILD_XML="maven-build.xml"
EANT_GENTOO_CLASSPATH="ant-core,antlr,commons-beanutils-1.7,commons-cli-1,commons-logging,guava"
EANT_BUILD_TARGET="package"
EANT_ANT_TASKS="ant-nodeps"
EANT_NEEDS_TOOLS="true"

src_test() {
	EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junit-4"
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar target/${P}.jar

	dodoc README
	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/${PN}/com

	# Install check files
	insinto /usr/share/checkstyle/checks
	doins suppressions.xml sun_checks.xml import-control.xml checkstyle_checks.xml

	# Install extra files
	insinto  /usr/share/checkstyle/contrib
	doins -r contrib/*

	java-pkg_dolauncher ${PN} \
		--main com.puppycrawl.tools.checkstyle.Main

	java-pkg_dolauncher ${PN}-gui \
		--main com.puppycrawl.tools.checkstyle.gui.Main
}
