# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Transparent threading solution for non-freezing Swing applications"
HOMEPAGE="http://spin.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}-all.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"

COMMON_DEP="dev-java/cglib:3"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.6
	${COMMON_DEP}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	cp "${FILESDIR}/${PV}-build.xml" build.xml || die
	cp "${FILESDIR}/${PV}-maven-build.properties" maven-build.properties || die
	rm -v lib/*.jar || die
	java-pkg_filter-compiler jikes
}

EANT_GENTOO_CLASSPATH="cglib-3"

# Needs X
RESTRICT="test"

src_test() {
	ANT_TASKS="ant-junit" eant test
}

src_install() {
	java-pkg_newjar target/${P}.jar

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/*
}
