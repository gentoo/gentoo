# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5

DESCRIPTION="The class loader framework of the Plexus project"
HOMEPAGE="https://codehaus-plexus.github.io/plexus-classworlds/"
SRC_URI="https://github.com/codehaus-plexus/plexus-classworlds/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc64"

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		>=dev-java/ant-1.10.15:0
		>=dev-java/jaxb-api-4.0.2:4
		>=dev-java/log4j-api-2.25.2:0
	)
"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_MAIN_CLASS="org.codehaus.plexus.classworlds.launcher.Launcher"
JAVA_SRC_DIR="src/main/java/"
JAVA_TEST_GENTOO_CLASSPATH="junit-5"
JAVA_TEST_RESOURCE_DIRS="src/test/test-data"
JAVA_TEST_SRC_DIR="src/test/java"

src_test(){
	mkdir -p target/test-lib || die
	java-pkg_jar-from --into target/test-lib ant ant.jar ant-1.10.14.jar
	java-pkg_jar-from --into target/test-lib jaxb-api-4 jaxb-api.jar jakarta.xml.bind-api-4.0.2.jar
	java-pkg_jar-from --into target/test-lib log4j-api log4j-api.jar log4j-api-2.23.1.jar
	junit5_src_test
}
