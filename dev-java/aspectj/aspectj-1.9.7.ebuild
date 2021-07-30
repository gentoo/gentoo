# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A seamless aspect-oriented extension to the Java programming language"
HOMEPAGE="https://eclipse.org/aspectj/"
SRC_URI="https://github.com/eclipse/org.aspectj/archive/refs/tags/V${PV//./_}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-java/asm:9
	dev-java/commons-logging:0
	dev-java/ant-apache-regexp:0"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.8:*"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"
BDEPEND="app-arch/zip"

S=${WORKDIR}/org.${P//./_}

JAVA_GENTOO_CLASSPATH_EXTRA="aspectjweaver.jar"
JAVA_GENTOO_CLASSPATH="commons-logging,asm-9,ant-apache-regexp"
JAVA_ENCODING="iso8859-1"

src_compile() {
	JAVA_SRC_DIR=( {asm,bcel-builder,bridge,loadtime,org.aspectj.matcher,runtime,util,weaver}/src/main/java )
	JAVA_RESOURCE_DIRS=( {bridge,org.aspectj.matcher,weaver}/src/main/resources )
	JAVA_JAR_FILENAME="aspectjweaver.jar"
	java-pkg-simple_src_compile
	rm -rf target || die

	JAVA_SRC_DIR=( runtime/src/main )
	JAVA_JAR_FILENAME="aspectjrt.jar"
	java-pkg-simple_src_compile
	zip -d aspectjrt.jar *.dtd org/aspectj/{bridge,weaver}/* || die
	rm -rf target || die

	# package org.eclipse.core.resources does not exist
	# package org.eclipse.core.runtime does not exist
#	JAVA_SRC_DIR=( org/aspectj/{ajde,ajdt,apache,asm,bridge,internal,lang,org,runtime,tools,util,weaver} )
#	JAVA_JAR_FILENAME="aspectjtools.jar"
#	java-pkg-simple_src_compile

	# bcel-verifier is needed for testing dev-java/asm:3
	# should go away once aspectjtools.jar can be built (included there)
	JAVA_SRC_DIR=( bcel-builder/verifier-src )
	JAVA_JAR_FILENAME="bcel-verifier.jar"
	java-pkg-simple_src_compile
	rm -rf target || die

	# once again for javadocs
	if use doc; then
		JAVA_SRC_DIR=( {asm,bcel-builder,bridge,loadtime,org.aspectj.matcher,runtime,util,weaver}/src/main/java )
		JAVA_JAR_FILENAME="ignoreme.jar"
		java-pkg-simple_src_compile
	fi
}

src_install() {
	java-pkg_dojar "aspectjweaver.jar"
	java-pkg_dojar "aspectjrt.jar"
#	java-pkg_dojar "aspectjtools.jar"
	java-pkg_dojar "bcel-verifier.jar"

	if use doc; then
		java-pkg_dojavadoc target/api
	fi

	if use source; then
		java-pkg_dosrc "org"
	fi
}
