# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Contexts and Dependency Injection for the Java EE platform"
HOMEPAGE="http://www.cdi-spec.org/"
SRC_URI="https://repo1.maven.org/maven2/javax/enterprise/${PN}/${PV}/${P}-sources.jar -> ${P}.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

CDEPEND="
	dev-java/javax-inject:0
	dev-java/tomcat-servlet-api:3.0
	dev-java/glassfish-interceptor-api:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	app-arch/unzip
	>=virtual/jdk-1.6"

JAVA_GENTOO_CLASSPATH="javax-inject,tomcat-servlet-api-3.0,glassfish-interceptor-api"

JAVA_SRC_DIR="javax"

src_compile() {
	java-pkg-simple_src_compile
	java-pkg_addres "${PN}.jar" . -name "*.xsd"
}
