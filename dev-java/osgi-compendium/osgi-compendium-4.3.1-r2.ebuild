# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="OSGi Service Platform Compendium API (Companion Code)"
HOMEPAGE="http://wiki.osgi.org/wiki/Release_4.3"
SRC_URI="https://osgi.org/download/r4v43/osgi.cmpn-${PV}.jar"

LICENSE="Apache-2.0 OSGi-Specification-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"

CDEPEND="dev-java/glassfish-persistence:0
	dev-java/osgi-core-api:0
	dev-java/osgi-foundation:0
	dev-java/tomcat-servlet-api:4.0"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"

BDEPEND="app-arch/unzip"

JAVA_SRC_DIR="OSGI-OPT/src"

JAVA_GENTOO_CLASSPATH="
	osgi-core-api
	osgi-foundation
	glassfish-persistence
	tomcat-servlet-api-4.0
"

src_prepare() {
	default
	rm -r org || die
}
