# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source examples"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Ant-tasks to compile various source languages and produce executables"
HOMEPAGE="http://ant-contrib.sourceforge.net/"
SRC_URI="mirror://sourceforge/ant-contrib/ant-contrib/${P/_/-}/${P/_beta/b}.tar.gz"
S="${WORKDIR}/${P/_beta/b}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

CDEPEND="
	dev-java/ant-core:0
	dev-java/xerces:2"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.6"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.6"

JAVA_ANT_REWRITE_CLASSPATH="yes"

EANT_BUILD_TARGET="jars"
EANT_DOC_TARGET="javadocs -Dbuild.javadocs=build/api"
EANT_GENTOO_CLASSPATH="ant-core,xerces-2"

src_prepare() {
	default
	find -name '*.jar' -exec rm -v {} + || die
}

src_install() {
	java-pkg_dojar target/lib/${PN}.jar

	java-pkg_register-ant-task

	dodoc NOTICE
	use doc && java-pkg_dojavadoc build/api
	use examples && java-pkg_doexamples src/samples/*
	use source && java-pkg_dosrc src/main/java/*
}
