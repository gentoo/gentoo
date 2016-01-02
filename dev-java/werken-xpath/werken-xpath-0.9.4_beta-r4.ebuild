# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source"
WANT_ANT_TASKS="ant-antlr"

inherit java-pkg-2 java-ant-2 eutils versionator

MY_PN=${PN/-/.}
MY_PV=$(replace_version_separator 3 '-')
MY_P=${MY_PN}-${MY_PV}

DESCRIPTION="W3C XPath-Rec implementation for DOM4J"
HOMEPAGE="http://sourceforge.net/projects/werken-xpath/"
SRC_URI="mirror://gentoo/${MY_P}-src.tar.gz"
# This tarball was acquired from jpackage's src rpm of the package by the same name

LICENSE="JDOM"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"

COMMON_DEP="
	dev-java/jdom:0
	>=dev-java/antlr-2.7.7-r7:0"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

S=${WORKDIR}/${MY_PN}

EANT_BUILD_TARGET="package"
JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_GENTOO_CLASSPATH="antlr,jdom"

java_prepare() {
	# Courtesy of JPackages :)
	epatch "${FILESDIR}"/${P}-jpp-compile.patch
	epatch "${FILESDIR}"/${P}-jpp-jdom.patch
	epatch "${FILESDIR}"/${P}-jpp-tests.patch
	epatch "${FILESDIR}"/${P}-gentoo.patch

	# API updates to support jdom-1
	epatch "${FILESDIR}"/${P}-jdom-1.0.patch

	java-pkg_clean
	rm -rv lib/bin || die
}

src_install() {
	java-pkg_newjar build/${MY_PN}.jar

	dodoc README TODO LIMITATIONS
	use doc && java-pkg_dojavadoc build/apidocs
	use source && java-pkg_dosrc src/*
}
