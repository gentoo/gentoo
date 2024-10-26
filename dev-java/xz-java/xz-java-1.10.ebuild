# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc examples source"
MAVEN_ID="org.tukaani:xz:1.10"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Implementation of xz data compression in pure java"
HOMEPAGE="https://tukaani.org/xz/java.html"
SRC_URI="https://tukaani.org/xz/${P}.zip
	verify-sig? ( https://tukaani.org/xz/${P}.zip.sig )"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

DEPEND=">=virtual/jdk-11:*"
RDEPEND=">=virtual/jre-1.8:*"

BDEPEND="
	app-arch/unzip
	verify-sig? ( sec-keys/openpgp-keys-lassecollin )
"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/lassecollin.asc"

JAVA_SRC_DIR="src"

DOCS=( {AUTHORS,NEWS,README,THANKS}.md )

src_compile() {
	local JAVA_MODULE_NAME="org.tukaani.xz"
	JAVA_JAR_FILENAME="${JAVA_MODULE_NAME}.jar"
	java-pkg-simple_src_compile	# creates a legacy jar file without module-info

	# compile module-info.java
	ejavac \
		-source 9 -target 9 \
		--patch-module "${JAVA_MODULE_NAME}"="${JAVA_MODULE_NAME}.jar" \
		-d target/versions/9 \
		-sourcepath src9 \
		$(find src9 -type f -name '*.java')

	# package
	JAVA_JAR_FILENAME="${PN}.jar"
	jar cvf "${JAVA_JAR_FILENAME}" \
		-C target/classes . \
		--release 9 -C target/versions/9 . || die
}

src_install() {
	java-pkg-simple_src_install
	use examples && java-pkg_doexamples src/*Demo.java
}
