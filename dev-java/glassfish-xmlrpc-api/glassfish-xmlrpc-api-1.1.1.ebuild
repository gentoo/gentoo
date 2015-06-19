# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/glassfish-xmlrpc-api/glassfish-xmlrpc-api-1.1.1.ebuild,v 1.4 2015/06/08 21:27:03 monsieurp Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

TOMEE_PV="1.5.2"

DESCRIPTION="Project GlassFish XML RPC API"
HOMEPAGE="https://glassfish.java.net/"
SRC_URI="http://dev.gentoo.org/~tomwij/files/dist/${P}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"

CDEPEND="java-virtuals/servlet-api:3.0"

DEPEND=">=virtual/jdk-1.7
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.7
	${CDEPEND}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="servlet-api-3.0"
JAVA_PKG_BSFIX_NAME="maven-build.xml"

src_install() {
	java-pkg_newjar target/javax.xml.rpc-api-${PV}.jar

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/javax
}
