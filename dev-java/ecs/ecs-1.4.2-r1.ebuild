# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java library to generate markup language text such as HTML and XML"
HOMEPAGE="http://jakarta.apache.org/ecs"
SRC_URI="mirror://apache/jakarta/${PN}/source/${P}-src.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.4
	=dev-java/jakarta-regexp-1.3*
	>=dev-java/xerces-2.7"
DEPEND=">=virtual/jdk-1.4
	${RDEPEND}"

S="${WORKDIR}/${P}-src"

src_unpack() {
	unpack ${A}

	cd "${S}"
	rm -v lib/*.jar || die
	rm -v build/*.jar || die
	rm -v ecs*.jar || die

	java-ant_bsfix_one build/build-ecs.xml

	cd "${S}/lib"
	java-pkg_jar-from xerces-2 xercesImpl.jar xerces.jar
	java-pkg_jar-from jakarta-regexp-1.3 jakarta-regexp.jar regexp.jar
}

EANT_BUILD_XML="build/build-ecs.xml"
EANT_DOC_TARGET="javadocs"

src_install() {
	java-pkg_newjar bin/${P}.jar

	dodoc AUTHORS ChangeLog README || die
	use doc && java-pkg_dojavadoc docs/*
	use source && java-pkg_dosrc src/java/*
}
