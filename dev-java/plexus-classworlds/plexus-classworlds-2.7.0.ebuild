# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.codehaus.plexus:plexus-classworlds:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="The class loader framework of the Plexus project"
HOMEPAGE="https://codehaus-plexus.github.io/plexus-classworlds/"
SRC_URI="https://github.com/codehaus-plexus/plexus-classworlds/archive/plexus-classworlds-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		dev-java/ant-core:0
		dev-java/commons-logging:0
		dev-java/xml-commons-external:1.4
	)
"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_MAIN_CLASS="org.codehaus.plexus.classworlds.launcher.Launcher"
JAVA_SRC_DIR="src/main/java/"

# Invalid test class, No runnable methods
JAVA_TEST_EXCLUDES="org.codehaus.plexus.classworlds.TestUtil"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS="src/test/test-data"
JAVA_TEST_SRC_DIR="src/test/java"

src_test(){
	# java.io.FileNotFoundException: target/test-lib/xml-apis-1.3.02.jar
	mkdir -p target/test-lib || die
	java-pkg_jar-from --into target/test-lib xml-commons-external-1.4 xml-commons-external.jar xml-apis-1.3.02.jar
	java-pkg_jar-from --into target/test-lib ant-core ant.jar ant-1.9.0.jar
	java-pkg_jar-from --into target/test-lib commons-logging commons-logging.jar commons-logging-1.0.3.jar
	java-pkg-simple_src_test
}
