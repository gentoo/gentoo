# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.easymock:easymock:5.6.0"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5

DESCRIPTION="Mock Objects for interfaces in JUnit tests by generating them on the fly"
HOMEPAGE="https://easymock.org/"
DMV="1.5"	# dexmaker isn't yet packaged
SRC_URI="https://github.com/${PN}/${PN}/archive/${P}.tar.gz
	https://repo1.maven.org/maven2/org/droidparts/dexmaker/dexmaker/${DMV}/dexmaker-${DMV}.jar"
S="${WORKDIR}/${PN}-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-java/byte-buddy-1.17.5:0
	dev-java/junit:4
	dev-java/junit:5
	dev-java/objenesis:0
	>=virtual/jdk-1.8:*
	test? (
		>=dev-java/asm-9.8-r1:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_CLASSPATH_EXTRA="byte-buddy junit-4 junit-5 objenesis"
JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/dexmaker-${DMV}.jar"
JAVA_SRC_DIR="core/src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="asm byte-buddy junit-5"
JAVA_TEST_SRC_DIR="core/src/test/java"

src_prepare() {
	java-pkg-2_src_prepare

	# error: package org.testng does not exist
	# this class seems to be needed only for running with testng
	rm core/src/main/java/org/easymock/EasyMockListener.java || die
}
