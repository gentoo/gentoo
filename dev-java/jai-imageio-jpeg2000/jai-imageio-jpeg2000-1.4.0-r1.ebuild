# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.github.jai-imageio:jai-imageio-jpeg2000:1.4.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JPEG2000 support for Java Advanced Imaging Image I/O Tools API"
HOMEPAGE="https://github.com/jai-imageio/jai-imageio-jpeg2000"
SRC_URI="https://github.com/jai-imageio/${PN}/archive/${P}.tar.gz"
S="${WORKDIR}"

LICENSE="Sun-BSD-no-nuclear-2005"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

CP_DEPEND="dev-java/jai-imageio-core:0"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_RESOURCE_DIRS="${PN}-${P}/src/main/resources"
JAVA_SRC_DIR="${PN}-${P}/src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS="${PN}-${P}/src/test/resources"
JAVA_TEST_SRC_DIR="${PN}-${P}/src/test/java"
