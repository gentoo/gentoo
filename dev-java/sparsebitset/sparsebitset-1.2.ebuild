# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/brettwooldridge/SparseBitSet/archive/refs/tags/SparseBitSet-1.2.tar.gz --slot 0 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild sparsebitset-1.2.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.zaxxer:SparseBitSet:1.2"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="An efficient sparse bitset implementation for Java"
HOMEPAGE="https://github.com/brettwooldridge/SparseBitSet"
SRC_URI="https://github.com/brettwooldridge/SparseBitSet/archive/refs/tags/SparseBitSet-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

DEPEND="
	>=virtual/jdk-1.8:*
"

RDEPEND="
	>=virtual/jre-1.8:*
"

S="${WORKDIR}/SparseBitSet-SparseBitSet-${PV}"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
