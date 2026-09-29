# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="OWASP Java Encoder"
HOMEPAGE="https://owasp.org/projects/java-encoder"
SRC_URI="https://github.com/OWASP/owasp-java-encoder/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}/core"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=virtual/jdk-11:*
	>=dev-java/jsoup-1.23.2:0
	test? (
		>=dev-java/felix-framework-7.0.5-r3:0
		>=dev-java/jackson-core-2.20.0:0
		>=dev-java/jackson-databind-2.20.0:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_CLASSPATH_EXTRA="jsoup"
JAVA_INTERMEDIATE_JAR_NAME="owasp.encoder"
JAVA_RELEASE_SRC_DIRS=( ["9"]="src/main/java9" )
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="felix-framework jackson-core jackson-databind junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
