# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.codehaus.plexus:plexus-classworlds:2.6.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="The class loader framework of the Plexus project"
HOMEPAGE="https://codehaus-plexus.github.io/plexus-classworlds/"
SRC_URI="https://github.com/codehaus-plexus/plexus-classworlds/archive/plexus-classworlds-${PV}.tar.gz"

LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		dev-java/commons-logging
		dev-java/xml-commons-external:1.4
	)
"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/${PN}-${P}"

JAVA_MAIN_CLASS="org.codehaus.plexus.classworlds.launcher.Launcher"
JAVA_SRC_DIR="src/main/java/"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/test-data"
JAVA_TEST_EXCLUDES="org.codehaus.plexus.classworlds.TestUtil"

src_prepare() {
	default
	# Ignore one test case testing the presence of ant-core
	sed \
		-e '/testConfigure_Valid/i @Ignore' \
		-e '/import org.junit.Test/a import org.junit.Ignore;' \
		-i src/test/java/org/codehaus/plexus/classworlds/launcher/ConfiguratorTest.java || die
}

src_test(){
	mkdir -p target/test-lib || die
	# https://github.com/codehaus-plexus/plexus-classworlds/blob/plexus-classworlds-2.6.0/pom.xml#L159-L161
	ln -s "$(java-pkg_getjars --build-only xml-commons-external-1.4)" \
		target/test-lib/xml-apis-1.3.02.jar || die
	# symlinking works only if java-pkg_getjars finds only one file
	# but commons-logging has  multiple jar files.
	ln -s "${SYSROOT}"/usr/share/commons-logging/lib/commons-logging.jar \
		target/test-lib/commons-logging-1.0.3.jar || die
	java-pkg-simple_src_test
}
