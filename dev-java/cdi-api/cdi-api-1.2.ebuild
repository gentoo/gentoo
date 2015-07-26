# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/cdi-api/cdi-api-1.2.ebuild,v 1.3 2015/07/21 13:16:59 monsieurp Exp $

EAPI=5

inherit eutils java-pkg-2 java-pkg-simple

DESCRIPTION="Contexts and Dependency Injection for the Java EE platform"
HOMEPAGE="http://www.cdi-spec.org/"
SRC_URI="https://repo1.maven.org/maven2/javax/enterprise/${PN}/${PV}/${P}-sources.jar"

LICENSE="Apache-2.0"
SLOT="1.2"
KEYWORDS="~amd64 ~x86"

IUSE=""

CDEPEND="dev-java/javax-inject:0
	dev-java/glassfish-interceptor-api:0
	dev-java/tomcat-servlet-api:3.0"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${CDEPEND}"

JAVA_SRC_DIR="src"

JAVA_GENTOO_CLASSPATH="javax-inject,tomcat-servlet-api-3.0,glassfish-interceptor-api"

java_prepare() {
	mkdir src || die
	mv * src
}
