# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Tests not enabled, wants junit-jupiter.
# "${S}/settings.gradle.kts"
JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.mockito:mockito-core:4.4.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Mockito mock objects library core API and implementation"
HOMEPAGE="https://github.com/mockito/mockito"
SRC_URI="https://codeload.github.com/mockito/mockito/tar.gz/v${PV} -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="4"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"

# Common dependencies
# POM: ${PN}-core-${PV}.pom
# net.bytebuddy:byte-buddy:1.12.8 -> >=dev-java/byte-buddy-1.12.8:0
# net.bytebuddy:byte-buddy-agent:1.12.8 -> >=dev-java/byte-buddy-agent-1.12.8:0

CP_DEPEND="
	dev-java/byte-buddy:0
	dev-java/byte-buddy-agent:0
	dev-java/junit:4
	dev-java/objenesis:0
	dev-java/opentest4j:0
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
"

# Runtime dependencies
# POM: ${PN}-core-${PV}.pom
# org.objenesis:objenesis:3.2 -> >=dev-java/objenesis-3.2:0

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src/main/java"

src_install() {
	java-pkg-simple_src_install
	einstalldocs # https://bugs.gentoo.org/789582
}
