# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# No tests since we don't have junit-jupiter
JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.objenesis:objenesis:3.3"
# JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A library for instantiating Java objects"
HOMEPAGE="http://objenesis.org/"
SRC_URI="https://github.com/easymock/objenesis/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ppc64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/${P}"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="main/src/test/java"

src_compile() {
#	if use test; then
#		einfo "Compiling objenesis-test"
#		JAVA_AUTOMATIC_MODULE_NAME="org.objenesis.test"
#		JAVA_SRC_DIR="test/src/main/java"
#		JAVA_JAR_FILENAME="objenesis-test.jar"
#		java-pkg-simple_src_compile
#		JAVA_GENTOO_CLASSPATH_EXTRA+=":objenesis-test.jar"
#		rm -r target || die
#	fi

	einfo "Compiling objenesis"
	JAVA_SRC_DIR="main/src/main/java"
	JAVA_JAR_FILENAME="objenesis.jar"
	JAVA_AUTOMATIC_MODULE_NAME="org.objenesis"
	java-pkg-simple_src_compile
}
