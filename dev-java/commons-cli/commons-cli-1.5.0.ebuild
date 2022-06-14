# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="commons-cli:commons-cli:1.5.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A Java library for working with the command line arguments and options"
HOMEPAGE="https://commons.apache.org/proper/commons-cli/"
SRC_URI="mirror://apache/commons/cli/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

RDEPEND=">=virtual/jre-1.8:*"

DEPEND=">=virtual/jdk-1.8:*"

S="${WORKDIR}/${P}-src"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

# There were 62 failures:
# 1) testSimpleLong(org.apache.commons.cli.ParserTestCase)
# java.lang.InstantiationException
#         at java.base/jdk.internal.reflect.InstantiationExceptionConstructorAccessorImpl.newInstance(InstantiationExceptionConstructorAccessorImpl.java:48)
# FAILURES!!!
# Tests run: 444,  Failures: 62
JAVA_TEST_EXCLUDES="org.apache.commons.cli.ParserTestCase"

src_install() {
	default
	java-pkg-simple_src_install
}
