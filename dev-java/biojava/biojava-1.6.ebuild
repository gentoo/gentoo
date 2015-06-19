# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/biojava/biojava-1.6.ebuild,v 1.1 2009/01/25 19:33:17 weaver Exp $

# TODO:
# -Fix javadoc generation OutOfMemoryError
# -Add launchers for 2 apps in biojava-apps.jar
# -Decide on demo packaging. (Whether to install its jar as done or sources by examples USE flag)

EAPI=2

#JAVA_PKG_IUSE="doc source test"
JAVA_PKG_IUSE="source test"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A Java framework for processing biological data"
HOMEPAGE="http://biojava.org"
SRC_URI="http://www.biojava.org/download/bj16/all/${P}-all.jar"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND="dev-java/jgrapht:0
	dev-java/commons-cli:1
	dev-java/commons-dbcp:0
	dev-java/commons-pool:0
	dev-java/bytecode:0"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEPEND}
	test?
	(
		dev-java/junit:4
		dev-java/ant-junit4
	)"

S="${WORKDIR}/biojava-live_${PV}"

JAVA_ANT_IGNORE_SYSTEM_CLASSES="true"

src_prepare() {
	einfo "Removing budled jars."
	find . -name "*.jar" -print -delete
	rm -r doc/*
	java-pkg_jar-from jgrapht jgrapht.jar jgrapht-jdk1.5.jar
	java-pkg_jar-from commons-cli-1
	java-pkg_jar-from commons-dbcp commons-dbcp.jar commons-dbcp-1.1.jar
	java-pkg_jar-from commons-pool commons-pool.jar commons-pool-1.1.jar
	java-pkg_jar-from bytecode
}

src_compile() {
	#ANT_OPTS="${ANT_OPTS} -Xmx512m"
	eant package-biojava package-biojava package-demos package-apps #$(use_doc javadocs-all)
}

src_install() {
	java-pkg_newjar ant-build/biojava.jar ${PN}.jar
	java-pkg_newjar ant-build/apps.jar ${PN}-apps.jar
	java-pkg_newjar ant-build/demos.jar ${PN}-demos.jar
	#use doc && java-pkg_dojavadoc ant-build/doc/{biojava,apps,demos}
	use source && java-pkg_dosrc {src,apps,demos}/org
}

src_test() {
	java-pkg_jar-from junit-4 junit.jar junit-4.4.jar
	ANT_TASKS="ant-junit4" eant runtests
}
