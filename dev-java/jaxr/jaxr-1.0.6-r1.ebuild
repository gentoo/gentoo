# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jaxr/jaxr-1.0.6-r1.ebuild,v 1.1 2015/07/27 12:41:25 monsieurp Exp $
EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Java API for XML Registries"
HOMEPAGE="https://glassfish.dev.java.net/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

CDEPEND="dev-java/jaxb:2
	dev-java/jsr173:0
	dev-java/jsr67:0
	dev-java/jsr93:0
	dev-java/sun-jaf:0"
DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

S="${WORKDIR}/${PN}-ri"

EANT_BUILD_TARGET="compile"
EANT_DOC_TARGET="javadoc-build"

EANT_GENTOO_CLASSPATH="
	jaxb-2
	jsr67
	jsr173
	jsr93
	sun-jaf
"

java_prepare() {
	mkdir "${S}"/lib || die

	java-pkg_jar-from --into lib jaxb-2
	java-pkg_jar-from --into lib jsr67 jsr67.jar saaj-api.jar
	java-pkg_jar-from --into lib jsr173 jsr173.jar jsr173_1.0_api.jar
	java-pkg_jar-from --into lib jsr93 jsr93-api.jar jaxr-api.jar
	java-pkg_jar-from --into lib sun-jaf

	epatch "${FILESDIR}/${P}-javadoc.patch"

	if use doc; then
		java-ant_xml-rewrite \
			-f "${S}"/build.xml \
			-c -e javadoc \
			-a failonerror \
			-v "false"
	fi
}

src_install() {
	java-pkg_dojar lib/${PN}-impl.jar

	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc src/java/*

}
