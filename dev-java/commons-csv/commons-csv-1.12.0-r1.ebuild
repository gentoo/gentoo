# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.commons:commons-csv:1.12.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Simple interface for reading and writing CSV files of various types"
HOMEPAGE="https://commons.apache.org/proper/commons-csv/"
SRC_URI="mirror://apache/commons/csv/source/${P}-src.tar.gz
	verify-sig? ( https://archive.apache.org/dist/commons/csv/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

RESTRICT="test"	#839681

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"

DEPEND="
	>=virtual/jdk-11:*
	dev-java/commons-codec:0
	>=dev-java/commons-io-2.17.0:1
	test? (
		>=dev-java/commons-lang-3.12.0:3.6
		dev-java/junit:5
		dev-java/mockito:4
	)
"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( LICENSE.txt NOTICE.txt RELEASE-NOTES.txt )

JAVA_CLASSPATH_EXTRA="
	commons-codec
	commons-io-1
"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="
	commons-io-1
	commons-lang-3.6
	junit-5
	mockito-4
"

JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_compile() {
	# getting dependencies into the modulepath
	DEPENDENCIES=(
		commons-codec
		commons-io-1
	)
	local modulepath
	for dependency in ${DEPENDENCIES[@]}; do
		modulepath="${modulepath}:$(java-pkg_getjars --build-only ${dependency})"
	done

	local JAVA_MODULE_NAME="org.apache.${PN/-/.}"
	JAVA_JAR_FILENAME="${JAVA_MODULE_NAME}.jar"
	java-pkg-simple_src_compile	# creates a legacy jar file without module-info

	# generate module-info.java
	jdeps \
		--module-path "${modulepath}" \
		--add-modules=ALL-MODULE-PATH \
		--generate-module-info src/main \
		--multi-release 9 \
		"${JAVA_MODULE_NAME}.jar" || die

	# compile module-info.java
	ejavac \
		-source 9 -target 9 \
		--module-path "${modulepath}" \
		--patch-module "${JAVA_MODULE_NAME}"="${JAVA_MODULE_NAME}.jar" \
		-d target/versions/9 \
		src/main/"${JAVA_MODULE_NAME}"/versions/9/module-info.java

	# package
	JAVA_JAR_FILENAME="${PN}.jar"
	jar cvf "${JAVA_JAR_FILENAME}" \
		-C target/classes . \
		--release 9 -C target/versions/9 . || die
}
