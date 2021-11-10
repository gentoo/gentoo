# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/jnr/jnr-constants/archive/refs/tags/jnr-constants-0.10.3.tar.gz --slot 0 --keywords "~amd64 ~arm64 ~x86" --ebuild jnr-constants-0.10.3.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.github.jnr:jnr-constants:0.10.3"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A set of platform constants (e.g. errno values)"
HOMEPAGE="https://github.com/jnr/jnr-constants"
SRC_URI="https://github.com/jnr/${PN}/archive/refs/tags/${P}.tar.gz -> ${P}-sources.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

DEPEND="
	>=virtual/jdk-1.8:*
"

RDEPEND="
	>=virtual/jre-1.8:*
"

S="${WORKDIR}/${PN}-${P}"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
