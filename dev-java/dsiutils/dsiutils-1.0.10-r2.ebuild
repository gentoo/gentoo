# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/dsiutils/dsiutils-1.0.10-r2.ebuild,v 1.6 2014/08/10 20:12:36 slyfox Exp $

EAPI="4"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A Mish Mash of classes that were initially distributed with mg4j (amount others)"
HOMEPAGE="http://dsiutils.dsi.unimi.it/"
SRC_URI="http://dsiutils.dsi.unimi.it/${P}-src.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

COMMON_DEP="
	dev-java/commons-io:1
	dev-java/jsap:0
	dev-java/log4j:0
	dev-java/commons-collections:0
	dev-java/colt:0
	dev-java/fastutil:5.0
	dev-java/commons-configuration:0
	dev-java/commons-lang:2.1
	dev-java/junit:0"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.5"
# Failes to build with jdk7 #423519
DEPEND="${COMMON_DEP}
	|| ( virtual/jdk:1.6 virtual/jdk:1.5 )
	test? (
		dev-java/emma:0
		dev-java/ant-junit:0
		dev-java/ant-trax:0
	)"

JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_CLASSPATH_TAGS+=" javadoc"

EANT_GENTOO_CLASSPATH="commons-io-1,jsap,log4j,commons-collections,colt,fastutil-5.0,commons-configuration,commons-lang-2.1,junit"

EANT_TEST_TARGET="junit"
EANT_TEST_ANT_TASKS="ant-trax"
EANT_TEST_EXTRA_ARGS="-Djar.base=/usr/share/emma/lib"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar "${P}.jar"
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc src/it
}
