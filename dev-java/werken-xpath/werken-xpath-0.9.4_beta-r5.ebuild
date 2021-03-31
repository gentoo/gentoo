# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"
WANT_ANT_TASKS="ant-antlr"

inherit java-pkg-2 java-ant-2

MY_PN=${PN/-/.}
MY_PV=${PV//_/-}
MY_P=${MY_PN}-${MY_PV}

DESCRIPTION="W3C XPath-Rec implementation for DOM4J"
HOMEPAGE="https://sourceforge.net/projects/werken-xpath/"
SRC_URI="mirror://gentoo/${MY_P}-src.tar.gz"
# This tarball was acquired from jpackage's src rpm of the package by the same name

LICENSE="JDOM"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEP="
	dev-java/jdom:0
	>=dev-java/antlr-2.7.7-r7:0"
DEPEND=">=virtual/jdk-1.8:*
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.8:*
	${COMMON_DEP}"

S=${WORKDIR}/${MY_PN}

EANT_BUILD_TARGET="package"
JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_GENTOO_CLASSPATH="antlr,jdom"

src_prepare() {
	default
	# Courtesy of JPackages :)
	eapply "${FILESDIR}"/${P}-jpp-compile.patch
	eapply "${FILESDIR}"/${P}-jpp-jdom.patch
	eapply "${FILESDIR}"/${P}-jpp-tests.patch
	eapply "${FILESDIR}"/${P}-gentoo.patch

	# API updates to support jdom-1
	eapply "${FILESDIR}"/${P}-jdom-1.0.patch

	java-pkg_clean
	rm -rv lib/bin || die
}

src_install() {
	java-pkg_newjar build/${MY_PN}.jar

	dodoc README TODO LIMITATIONS
	use doc && java-pkg_dojavadoc build/apidocs
	use source && java-pkg_dosrc src/*
}
