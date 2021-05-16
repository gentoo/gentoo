# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

TOMEE_PV="1.5.2"

DESCRIPTION="Project GlassFish Enterprise JavaBean API"
HOMEPAGE="https://glassfish.java.net/"
SRC_URI="https://dev.gentoo.org/~tomwij/files/dist/${P}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

CDEPEND="java-virtuals/xmlrpc-api:0
	java-virtuals/transaction-api:0"

DEPEND=">=virtual/jdk-1.7
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.7
	${CDEPEND}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="xmlrpc-api,transaction-api"
JAVA_PKG_BSFIX_NAME="maven-build.xml"

src_install() {
	java-pkg_newjar target/javax.ejb-api-${PV}.jar

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/javax
}
