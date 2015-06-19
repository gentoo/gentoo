# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jaxr/jaxr-1.0.6.ebuild,v 1.1 2007/05/01 19:56:51 nelchael Exp $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Java API for XML Registries"
HOMEPAGE="https://glassfish.dev.java.net/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

COMMON_DEP="=dev-java/jaxb-2*
	dev-java/jsr173
	dev-java/jsr67
	dev-java/jsr93
	dev-java/sun-jaf"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"

S="${WORKDIR}/${PN}-ri"

EANT_BUILD_TARGET="compile"
EANT_DOC_TARGET="javadoc-build"

src_unpack() {

	unpack ${A}

	mkdir "${S}/lib" || die
	cd "${S}/lib"

	java-pkg_jar-from jaxb-2
	java-pkg_jar-from jsr67 jsr67.jar saaj-api.jar
	java-pkg_jar-from jsr173 jsr173.jar jsr173_1.0_api.jar
	java-pkg_jar-from jsr93 jsr93-api.jar jaxr-api.jar
	java-pkg_jar-from sun-jaf

	cd "${S}"
	epatch "${FILESDIR}/${P}-javadoc.patch"

}

src_install() {

	java-pkg_dojar lib/jaxr-impl.jar

	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc src/java/*

}
