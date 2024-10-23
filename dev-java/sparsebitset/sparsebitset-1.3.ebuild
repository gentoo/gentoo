# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.zaxxer:SparseBitSet:1.3"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="An efficient sparse bitset implementation for Java"
HOMEPAGE="https://github.com/brettwooldridge/SparseBitSet"
SRC_URI="https://github.com/brettwooldridge/SparseBitSet/archive/SparseBitSet-${PV}.tar.gz"
S="${WORKDIR}/SparseBitSet-SparseBitSet-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

DEPEND=">=virtual/jdk-1.8:*
	test? ( dev-java/junit:4 )"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="com.zaxxer.sparsebitset"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
