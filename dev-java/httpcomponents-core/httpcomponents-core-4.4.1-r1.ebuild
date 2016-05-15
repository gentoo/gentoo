# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="source examples test"

# "components"
CMPT=${PN%%-*}

# "core"
CORE=${PN##*-}

# "httpcore"
HTTPCORE="http${CORE}"

# "httpcore-nio"
HTTPNIO="${HTTPCORE}-nio"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A low level toolset of Java components focused on HTTP and associated protocols"
HOMEPAGE="http://hc.apache.org/index.html"
SRC_URI="mirror://apache/httpcomponents/${HTTPCORE}/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="4.4"
KEYWORDS="amd64 x86"

RDEPEND=">=virtual/jre-1.6"

DEPEND="
	test? (
		dev-java/commons-logging:0
		dev-java/ant-junit:0
		dev-java/mockito:0
	)
	>=virtual/jdk-1.6"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_BUILD_TARGET="package"
EANT_GENTOO_CLASSPATH_EXTRA="${S}/${HTTPCORE}/target/${HTTPCORE}-${PV}.jar"

java_prepare() {
	cp "${FILESDIR}"/${P}-${HTTPCORE}-build.xml ${HTTPCORE}/build.xml || die
	cp "${FILESDIR}"/${P}-${HTTPNIO}-build.xml ${HTTPNIO}/build.xml || die

	# Why have these classes been deprecated although other libraries are built
	# on them (i.e. httpcomponents-client) is mindboggling. See bug 553234.
	cp -r "${S}"/httpcore/src/main/java-deprecated/* \
		"${S}"/httpcore/src/main/java/* || die
	cp -r "${S}"/httpcore-nio/src/main/java-deprecated/* \
		"${S}"/httpcore-nio/src/main/java/* || die
}

src_compile() {
	# first, compile httpcore module
	EANT_BUILD_XML="${HTTPCORE}/build.xml" java-pkg-2_src_compile

	# then, httpnio module
	EANT_BUILD_XML="${HTTPNIO}/build.xml" java-pkg-2_src_compile
}

EANT_TEST_GENTOO_CLASSPATH="
	commons-logging
	mockito
"

src_test() {
	# run junit tests for httpcore module
	EANT_BUILD_XML="${HTTPCORE}/build.xml" java-pkg-2_src_test

	# run junit tests for httpcore-nio module
	EANT_BUILD_XML="${HTTPNIO}/build.xml" java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar ${HTTPCORE}/target/${HTTPCORE}-${PV}.jar ${HTTPCORE}.jar
	java-pkg_newjar ${HTTPNIO}/target/${HTTPNIO}-${PV}.jar ${HTTPNIO}.jar

	use source && java-pkg_dosrc httpcore{,-nio}/src/main/java
	use examples && java-pkg_doexamples httpcore{,-nio}/src/examples

	dodoc {README,RELEASE_NOTES,NOTICE}.txt
}
