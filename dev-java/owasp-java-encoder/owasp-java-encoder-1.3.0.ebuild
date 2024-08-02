# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.owasp.encoder:encoder:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="OWASP Java Encoder"
HOMEPAGE="https://owasp.org/www-project-java-encoder/"
SRC_URI="https://github.com/OWASP/owasp-java-encoder/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}/core"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

# skipping 10 tests because kinda unpredictable as it expects that it cannot
# surpass a predefined value, which in some case obviously doesn't work.
JAVA_RM_FILES=( src/test/java/org/owasp/encoder/BenchmarkTest.java )
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
