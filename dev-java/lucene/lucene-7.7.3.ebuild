# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="High-performance, full-featured text search engine written entirely in Java"
HOMEPAGE="https://lucene.apache.org"
SRC_URI="https://archive.apache.org/dist/${PN}/java/${PV}/${P}-src.tgz
	verify-sig?	( https://archive.apache.org/dist/${PN}/java/${PV}/${P}-src.tgz.asc )"
S=${WORKDIR}/${P}

LICENSE="Apache-2.0"
SLOT="7.7.3"
KEYWORDS="~amd64 ~x86"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/lucene.apache.org.asc"
BDEPEND="
	doc? ( app-arch/zip )
	verify-sig? ( sec-keys/openpgp-keys-apache-lucene )
"
DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVADOC_SRC_DIRS=( {core,sandbox,queries,queryparser,grouping}/src/java )

src_compile() {
	einfo "Compiling lucene-core.jar"
	JAVA_JAR_FILENAME="lucene-core.jar"
	JAVA_RESOURCE_DIRS=( core/src/resources )
	JAVA_SRC_DIR="core/src/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":lucene-core.jar"
	rm -r target || die

	einfo "Compiling lucene-sandbox.jar"
	JAVA_JAR_FILENAME="lucene-sandbox.jar"
	JAVA_RESOURCE_DIRS=( sandbox/src/resources )
	JAVA_SRC_DIR="sandbox/src/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":lucene-sandbox.jar"
	rm -r target || die

	einfo "Compiling lucene-queries.jar"
	JAVA_JAR_FILENAME="lucene-queries.jar"
	JAVA_RESOURCE_DIRS=()
	JAVA_SRC_DIR="queries/src/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":lucene-queries.jar"
	rm -r target || die

	einfo "Compiling lucene-queryparser.jar"
	JAVA_JAR_FILENAME="lucene-queryparser.jar"
	JAVA_RESOURCE_DIRS=( queryparser/src/resources )
	JAVA_SRC_DIR="queryparser/src/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":lucene-queryparser.jar"
	rm -r target || die

	einfo "Compiling lucene-grouping.jar"
	JAVA_JAR_FILENAME="lucene-grouping.jar"
	JAVA_RESOURCE_DIRS=()
	JAVA_SRC_DIR="grouping/src/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":lucene-grouping.jar"
	rm -r target || die

	use doc && ejavadoc
}

# needs com.carrotsearch.* and others not in portage
#src_test() {
#}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dojar lucene-{core,sandbox,queries,queryparser,grouping}.jar
	if use source; then
		java-pkg_dosrc {core,sandbox,queries,queryparser,grouping}/src/java/*
	fi
}
