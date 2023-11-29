# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="io.github.java-diff-utils:java-diff-utils:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Library for computing diffs, applying patches, generationg side-by-side view"
HOMEPAGE="https://java-diff-utils.github.io/java-diff-utils/"
SRC_URI="https://github.com/java-diff-utils/java-diff-utils/archive/java-diff-utils-parent-${PV}.tar.gz"
S="${WORKDIR}/java-diff-utils-java-diff-utils-parent-${PV}/java-diff-utils"

LICENSE="Apache-2.0"
SLOT="4"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
RESTRICT="test" #839681

BDEPEND="app-arch/unzip"
DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="io.github.javadiffutils"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="
	assertj-core-3
	junit-5
"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
