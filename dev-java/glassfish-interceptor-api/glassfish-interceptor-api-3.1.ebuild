# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

TOMEE_PV="1.5.2"

DESCRIPTION="Project GlassFish Interceptor API"
HOMEPAGE="https://glassfish.java.net/"
SRC_URI="http://dev.gentoo.org/~tomwij/files/dist/${P}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

CDEPEND=""

DEPEND=">=virtual/jdk-1.7
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.7
	${CDEPEND}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH=""
JAVA_PKG_BSFIX_NAME="maven-build.xml"

java_prepare() {
	epatch "${FILESDIR}"/${P}-build.xml.patch
}

src_install() {
	java-pkg_newjar target/javax.interceptor-api-${PV}.jar

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/javax
}
