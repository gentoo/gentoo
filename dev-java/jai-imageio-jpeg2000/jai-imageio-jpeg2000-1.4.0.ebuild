# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom jai-imageio-jpeg2000-jai-imageio-jpeg2000-1.4.0/pom.xml --download-uri https://github.com/jai-imageio/jai-imageio-jpeg2000/archive/refs/tags/jai-imageio-jpeg2000-1.4.0.tar.gz --slot 0 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild jai-imageio-jpeg2000-1.4.0.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.github.jai-imageio:jai-imageio-jpeg2000:1.4.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JPEG2000 support for Java Advanced Imaging Image I/O Tools API"
HOMEPAGE="https://github.com/jai-imageio/jai-imageio-jpeg2000"
SRC_URI="https://github.com/jai-imageio/${PN}/archive/refs/tags/${P}.tar.gz"

LICENSE="Sun-BSD-no-nuclear-2005"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc64 x86"

# Common dependencies
# POM: ${PN}-${P}/pom.xml
# com.github.jai-imageio:jai-imageio-core:1.4.0 -> >=dev-java/jai-imageio-core-1.4.0:0

CDEPEND="dev-java/jai-imageio-core:0"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.8:*"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:* "

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="jai-imageio-core"
JAVA_SRC_DIR="${PN}-${P}/src/main/java"
JAVA_RESOURCE_DIRS="${PN}-${P}/src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="${PN}-${P}/src/test/java"
JAVA_TEST_RESOURCE_DIRS="${PN}-${P}/src/test/resources"
