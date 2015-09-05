# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils java-pkg-2 java-pkg-simple

DESCRIPTION="Project Mojarra - GlassFish's Implementation for JavaServer Faces API"
HOMEPAGE="https://javaserverfaces.dev.java.net/"
SRC_URI="https://maven.java.net/content/repositories/releases/org/glassfish/javax.faces/${PV}/javax.faces-${PV}-sources.jar"

LICENSE="CDDL"
SLOT="2.2"
KEYWORDS="amd64 x86"

IUSE=""

CDEPEND="dev-java/glassfish-persistence:0
	dev-java/glassfish-ejb-api:0
	java-virtuals/servlet-api:3.0
	dev-java/tomcat-jstl-spec:1.2.5
	dev-java/tomcat-jstl-impl:1.2.5
	dev-java/validation-api:1.0
	dev-java/javax-inject:0
	dev-java/cdi-api:1.2"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${CDEPEND}"

JAVA_SRC_DIR="src"

JAVA_GENTOO_CLASSPATH="glassfish-persistence,glassfish-ejb-api,tomcat-jstl-spec-1.2.5,tomcat-jstl-impl-1.2.5,validation-api-1.0,cdi-api-1.2,servlet-api-3.0,javax-inject"

java_prepare() {
	mkdir src || die
	mv * src

	# We *MUST* bump Groovy to 2.4 at some point 
	# to make this stuff work correctly. 
	rm -v src/com/sun/faces/scripting/groovy/GroovyHelperImpl.java || die
	epatch "${FILESDIR}"/${P}-Util.java.patch
}
