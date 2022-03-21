# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Project GlassFish XML RPC API"
HOMEPAGE="https://glassfish.java.net/"
SRC_URI="https://dev.gentoo.org/~tomwij/files/dist/${P}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

CP_DEPEND="
	dev-java/jakarta-xml-soap-api:1
	java-virtuals/servlet-api:3.0
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_ANT_CLASSPATH_TAGS="javac javadoc"
JAVA_PKG_BSFIX_NAME="maven-build.xml"

src_install() {
	java-pkg_newjar "target/javax.xml.rpc-api-${PV}.jar"

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/javax
}
