# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="OSGi Enterprise Release 5 Companion Code"
HOMEPAGE="http://www.osgi.org/Main/HomePage"
SRC_URI="https://docs.osgi.org/download/r5/osgi.enterprise-${PV}.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

RESTRICT="bindist"

CP_DEPEND="dev-java/glassfish-persistence:0
	dev-java/osgi-core-api:0
	dev-java/javax-servlet-api:2.5"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"

BDEPEND="app-arch/unzip"

JAVA_SRC_DIR="OSGI-OPT/src"

src_prepare() {
	default
	rm -r org || die
}
