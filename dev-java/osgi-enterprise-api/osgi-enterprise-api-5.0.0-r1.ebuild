# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="OSGi Enterprise Release 5 Companion Code"
HOMEPAGE="http://www.osgi.org/Main/HomePage"
SRC_URI="https://docs.osgi.org/download/r5/osgi.enterprise-${PV}.jar"

LICENSE="Apache-2.0 OSGi-Specification-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"

RESTRICT="bindist"

CDEPEND="dev-java/glassfish-persistence:0
	dev-java/osgi-core-api:0
	java-virtuals/servlet-api:2.5"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.8:*
	app-arch/unzip"

JAVA_SRC_DIR="OSGI-OPT/src"

JAVA_GENTOO_CLASSPATH="glassfish-persistence,osgi-core-api,servlet-api-2.5"

src_prepare() {
	default
	rm -r org || die
}
