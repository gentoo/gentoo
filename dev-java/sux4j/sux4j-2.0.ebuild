# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Sux: Implementing Succinct Data Structures"
HOMEPAGE="http://sux.dsi.unimi.it/"
SRC_URI="http://sux.dsi.unimi.it/${P}-src.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

COMMON_DEP="dev-java/fastutil:5.0
			dev-java/commons-io:1
			dev-java/colt:0
			dev-java/dsiutils:0
			dev-java/log4j:0
			dev-java/commons-collections:0
			dev-java/commons-configuration:0
			dev-java/jsap:0
			dev-java/commons-lang:2.1
			dev-java/junit:0"

RDEPEND=">=virtual/jre-1.5
		${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
		app-arch/unzip
		${COMMON_DEP}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	java-ant_rewrite-classpath
}

EANT_GENTOO_CLASSPATH="fastutil-5.0,commons-io-1,colt,dsiutils,log4j,commons-collections,commons-configuration,jsap,commons-lang-2.1,junit"

src_install() {
	java-pkg_newjar "${P}.jar"
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc src
}
