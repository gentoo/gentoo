# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2 java-pkg-simple

MY_PN="portlet-api"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Portlet API 2.0 developed by the Java Community Process JSR-286"
HOMEPAGE="https://jcp.org/en/jsr/detail?id=286"
SRC_URI="http://mirrors.ibiblio.org/maven2/javax/portlet/${MY_PN}/${PV}/${MY_P}-sources.jar"

LICENSE="Apache-2.0"
SLOT="2.0"
KEYWORDS="amd64 ppc64 x86"

IUSE=""

CDEPEND="dev-java/tomcat-servlet-api:3.0"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${CDEPEND}"

JAVA_SRC_DIR="src"

JAVA_ENCODING="ISO-8859-1"
JAVA_GENTOO_CLASSPATH="tomcat-servlet-api-3.0"

java_prepare() {
	mkdir src || die
	mv * src
}
