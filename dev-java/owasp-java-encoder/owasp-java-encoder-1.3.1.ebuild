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

# skipping 10 tests because they seem to be unreliable depending on hardware used
# as some of them fail on some setups because the benchmark results don't align
# with the hardcoded value 200 for the expected results. here are some examples:
# Benchmarked Encode.forJavaScript: 442,382250 ns/op (+253,85% on baseline)
# Benchmarked Encode.forCssString: 446,929231 ns/op (+257,49% on baseline)
# Benchmarked Encode.forJava: 409,038065 ns/op (+227,18% on baseline)
JAVA_RM_FILES=( src/test/java/org/owasp/encoder/BenchmarkTest.java )
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
