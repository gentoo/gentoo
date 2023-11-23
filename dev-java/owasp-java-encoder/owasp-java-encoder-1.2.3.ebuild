# Copyright 2023 Gentoo Authors
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
KEYWORDS="amd64"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"

PATCHES=( "${FILESDIR}/owasp-java-encoder-1.2.3-BenchmarkTest.patch" )

JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
}
