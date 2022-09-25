# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.osgi:osgi.cmpn:8.0.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="OSGi Service Platform Compendium API (Companion Code)"
HOMEPAGE="https://docs.osgi.org"
SRC_URI="https://docs.osgi.org/download/r$(ver_cut 1)/${PN/-/.}-${PV}.jar -> ${P}.jar"

LICENSE="Apache-2.0 OSGi-Specification-2.0"
SLOT="8"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64"

CP_DEPEND="
	dev-java/cdi-api:0
	dev-java/glassfish-persistence:0
	dev-java/jakarta-servlet-api:4
	dev-java/javax-inject:0
	dev-java/jaxrs-api:0
	dev-java/osgi-annotation:0
	dev-java/osgi-core:0
"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-11:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

BDEPEND="app-arch/unzip"

JAVA_SRC_DIR="OSGI-OPT/src"

src_prepare() {
	default
	java-pkg_clean org
	sed \
		-e 's/javax\(.enterprise\)/jakarta\1/' \
		-i OSGI-OPT/src/org/osgi/service/cdi/*/*.java || die
}
