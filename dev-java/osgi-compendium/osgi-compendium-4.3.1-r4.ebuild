# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="OSGi Service Platform Compendium API (Companion Code)"
HOMEPAGE="https://docs.osgi.org"
SRC_URI="https://docs.osgi.org/download/r4v43/osgi.cmpn-${PV}.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

CP_DEPEND="
	dev-java/glassfish-persistence:0
	dev-java/osgi-core-api:0
	dev-java/osgi-foundation:0
	dev-java/jakarta-servlet-api:4"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

BDEPEND="app-arch/unzip"

JAVA_SRC_DIR="OSGI-OPT/src"

src_prepare() {
	default
	rm -r org || die
}
