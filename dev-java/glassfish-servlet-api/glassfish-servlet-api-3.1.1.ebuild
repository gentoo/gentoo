# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="javax.servlet"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Glassfish reference implementation of Servlet API 2.5 and JSP API 2.1"
HOMEPAGE="https://glassfish.dev.java.net/javaee5/webtier/webtierhome.html"
SRC_URI="http://central.maven.org/maven2/org/glassfish/javax.servlet/${PV}/${MY_P}-sources.jar"
LICENSE="CDDL"
SLOT="3.1.1"
KEYWORDS="amd64 x86"

DEPEND=">=virtual/jdk-1.6
	app-arch/unzip"

RDEPEND=">=virtual/jre-1.6"
