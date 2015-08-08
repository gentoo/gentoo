# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Jar Bundler Ant Task"
HOMEPAGE="http://www.loomcom.com/jarbundler/"
SRC_URI="http://downloads.sourceforge.net/project/jarbundler/JarBundler/v${PV}/${PN}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

COMMON_DEP="
	>=dev-java/xerces-2.8.1:2"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.6"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.6
	>=dev-java/ant-core-1.7:0"

java_prepare() {
	find -name '*.jar' -delete || die
}

JAVA_ANT_REWRITE_CLASSPATH="yes"

EANT_GENTOO_CLASSPATH="ant-core,xerces-2"
EANT_DOC_TARGET="javadocs"

src_install() {
	java-pkg_newjar "build/${P}.jar"
	java-pkg_register-ant-task

	use doc && java-pkg_dojavadoc javadoc/
	use source && java-pkg_dosrc src/*
}
