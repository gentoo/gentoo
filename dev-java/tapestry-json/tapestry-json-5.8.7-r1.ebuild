# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.tapestry:tapestry-json:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Tapestry JSON"
HOMEPAGE="https://tapestry.apache.org/"
SRC_URI="https://downloads.apache.org/tapestry/apache-tapestry-${PV}-sources.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

BDEPEND="app-arch/unzip"

#	dev-java/asm:0	# seems bundled in plastic/src/external/

DEPEND="
	dev-java/slf4j-api:0
	>=virtual/jdk-1.8:*
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="org.apache.tapestry.json"
JAVA_CLASSPATH_EXTRA="slf4j-api"
JAVA_GENTOO_CLASSPATH_EXTRA="target/deps"
JAVA_SRC_DIR="tapestry-json/src/main/java"

src_compile() {
	# build classes needed for compilation
	mkdir -p target/deps || die "mkdir" # openjdk:8 doesn't do it.
	ejavac -d target/deps \
		-cp "$(java-pkg_getjars --build-only slf4j-api)" \
		$(find \
			commons/src/main/java \
			plastic-asm/src/main/java \
			plastic/src/external/java \
			plastic/src/main/java \
			tapestry5-annotations/src/main/java \
			tapestry-func/src/main/java \
			-name "*.java") || die

	java-pkg-simple_src_compile
}
