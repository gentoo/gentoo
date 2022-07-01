# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom jai-imageio-core-jai-imageio-core-1.4.0/pom.xml --download-uri https://github.com/jai-imageio/jai-imageio-core/archive/refs/tags/jai-imageio-core-1.4.0.tar.gz --slot 0 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild jai-imageio-core-1.4.0.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.github.jai-imageio:jai-imageio-core:1.4.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java Advanced Imaging Image I/O Tools API core (standalone)"
HOMEPAGE="https://github.com/jai-imageio/jai-imageio-core"
SRC_URI="https://github.com/jai-imageio/${PN}/archive/refs/tags/${P}.tar.gz"

LICENSE="Sun-BSD-no-nuclear-2005"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}"

JAVA_SRC_DIR="${PN}-${P}/src/main/java"
JAVA_RESOURCE_DIRS="${PN}-${P}/src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="${PN}-${P}/src/test/java"
JAVA_TEST_RESOURCE_DIRS="${PN}-${P}/src/test/resources"
