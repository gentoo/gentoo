# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/glassfish-servlet-api/glassfish-servlet-api-2_beta44.ebuild,v 1.4 2011/02/10 17:57:36 tomka Exp $

JAVA_PKG_IUSE="doc source"

inherit base java-pkg-2 java-ant-2

MY_PV="${PV/_beta/-b}"
DESCRIPTION="Glassfish reference implementation of Servlet API 2.5 and JSP API 2.1"
HOMEPAGE="https://glassfish.dev.java.net/javaee5/webtier/webtierhome.html"
SRC_URI="http://download.java.net/javaee5/trunk/promoted/source/glassfish-v${MY_PV}-src.zip"
LICENSE="CDDL"
SLOT="2.5"
KEYWORDS="amd64 x86"

DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"

RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/glassfish/servlet-api/"

PATCHES=( "${FILESDIR}/build_xml.patch" )

src_compile() {
	eant build $(use doc || echo -Ddocs.uptodate=true)
}

src_install() {
	java-pkg_dojar "${S}"/src/jakarta-servletapi-5/jsr154/dist/lib/*.jar
	java-pkg_dojar "${S}"/src/jsr245/dist/lib/*.jar

	use doc && java-pkg_dojavadoc src/jsr245/build/docs/api
	use source && java-pkg_dosrc src/*
}
