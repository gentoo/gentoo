# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.neilalexander:jnacl:1.0"
# JAVA_TESTING_FRAMEWORKS="testng"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Pure Java implementation of NaCl: Networking and Cryptography library"
HOMEPAGE="https://github.com/neilalexander/jnacl"
SRC_URI="https://github.com/neilalexander/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

# We don't have fest-assert
RESTRICT="test"

DEPEND=">=virtual/jdk-11:*"	# module-info
RDEPEND=">=virtual/jre-1.8:*"

JAVA_SRC_DIR="src/main/java"

src_compile() {
	JAVA_JAR_FILENAME="com.neilalexander.${PN}.jar"
	java-pkg-simple_src_compile	# creates a legacy jar file without module-info

	jdeps --generate-module-info \
		src/main/java \
		--multi-release 9 \
		"${JAVA_JAR_FILENAME}" || die

	JAVA_JAR_FILENAME="${PN}.jar"
	java-pkg-simple_src_compile	# creates the final jar file including module-info
}
