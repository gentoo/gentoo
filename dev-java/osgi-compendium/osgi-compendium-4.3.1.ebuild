# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="OSGi Service Platform Compendium API (Companion Code)"
HOMEPAGE="http://www.osgi.org/Specifications/HomePage"
SRC_URI="http://www.osgi.org/download/r4v43/osgi.cmpn-${PV}.jar"

LICENSE="Apache-2.0 OSGi-Specification-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

RESTRICT="bindist fetch"

COMMON_DEPEND="dev-java/glassfish-persistence:0
	dev-java/osgi-core-api:0
	dev-java/osgi-foundation:0
	dev-java/tomcat-servlet-api:3.0"

DEPEND="${COMMON_DEPEND}
	>=virtual/jdk-1.5
	app-arch/unzip"

RDEPEND="${COMMON_DEPEND}
	>=virtual/jre-1.5"

JAVA_SRC_DIR="OSGI-OPT/src"

JAVA_GENTOO_CLASSPATH="glassfish-persistence,osgi-core-api,osgi-foundation,tomcat-servlet-api-3.0"

pkg_nofetch() {
	einfo "Please download osgi.cmpn-${PV}.jar from"
	einfo "  http://www.osgi.org/Download/Release4V43"
	einfo "which you can find listed as"
	einfo "  OSGi Service Platform Release 4 Version 4.3 Compendium Companion Code"
	einfo "after accepting the license."
}

java_prepare() {
	rm -r org || die
}
