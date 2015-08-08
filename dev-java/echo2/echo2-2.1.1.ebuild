# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

JAVA_PKG_IUSE="doc source"
inherit java-pkg-2 java-ant-2

MY_PN="NextApp_Echo2"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Echo2 is the next-generation of the Echo Web Framework"
HOMEPAGE="http://www.nextapp.com/platform/echo2/echo/"
SRC_URI="http://download.nextapp.com/downloads/echo2/${PV}/${MY_PN}.tgz -> ${MY_P}.tgz"

LICENSE="|| ( MPL-1.1 GPL-2 LGPL-2.1 )"
SLOT="2.1"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEP="java-virtuals/servlet-api:2.4"

DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

S=${WORKDIR}/${MY_PN}/

java_prepare() {
	rm -rfv BinaryLibraries || die
	echo "servlet.lib.jar=$(java-pkg_getjars servlet-api-2.4)" >> SourceCode/ant.properties || die
}

src_compile() {
	cd SourceCode || die
	eant dist $(use_doc doc.public)
}

src_install() {
	java-pkg_dojar SourceCode/dist/lib/*.jar
	use doc && {
		cp Documentation/api/public/*.html SourceCode/javadoc/public
		java-pkg_dojavadoc SourceCode/javadoc/public
	}
	use source && java-pkg_dosrc SourceCode/src
	dodoc ReadMe.txt || die "dodoc failed"
}
