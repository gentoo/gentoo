# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.testng:testng:6.11"
JAVA_TESTING_FRAMEWORKS="testng"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Testing framework inspired by JUnit and NUnit with new features"
HOMEPAGE="https://testng.org/"
# Presently we install the binary version of jquery since it is not packaged in ::gentoo.
JQV="3.5.1"
# Currently we bundle the binary versions of spock-core, groovy-all and apache-groovy-binary.
# These are used only for tests, we don't install them.
SCV="1.0-groovy-2.4"
GAV="2.4.7"
AGV="2.4.21"
SRC_URI="https://github.com/testng-team/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://repo1.maven.org/maven2/org/webjars/jquery/${JQV}/jquery-${JQV}.jar
	test? (
		https://repo1.maven.org/maven2/org/spockframework/spock-core/${SCV}/spock-core-${SCV}.jar
		https://repo1.maven.org/maven2/org/codehaus/groovy/groovy-all/${GAV}/groovy-all-${GAV}.jar
		https://downloads.apache.org/groovy/${AGV}/distribution/apache-groovy-binary-${AGV}.zip
	)"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"
SLOT="0"

CP_DEPEND="
	dev-java/ant-core:0
	dev-java/bsh:0
	dev-java/guice:4
	dev-java/jcommander:1.64
	dev-java/junit:4
	dev-java/snakeyaml:0
"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? (
		dev-java/assertj-core:3
		dev-java/guava:0
	)"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

BDEPEND="app-arch/unzip"

DOCS=( README {ANNOUNCEMENT,CHANGES}.txt )

JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="assertj-core-3"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_RUN_ONLY="src/test/resources/testng.xml"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare
	java-pkg_clean ! -path "./src/*"

	rm src/main/resources/META-INF/MANIFEST.MF || die
}

src_test() {
	# This contains the compiler groovyc
	unzip "${DISTDIR}/apache-groovy-binary-${AGV}.zip"

	JAVA_GENTOO_CLASSPATH_EXTRA=":${DISTDIR}/spock-core-${SCV}.jar"

	ejavac -cp "${JAVA_TEST_SRC_DIR}:${PN}.jar:$(java-pkg_getjars guava)" \
		src/test/java/test/SimpleBaseTest.java || die

	# java-pkg-simple.eclass expects generated test classes in this
	# directory and will copy them to target/test-classes
	mkdir generated-test || die "cannot create generated-test directory"
	"groovy-${AGV}/bin/groovyc" \
		-cp "${JAVA_TEST_SRC_DIR}:${DISTDIR}/spock-core-${SCV}.jar" \
		-d generated-test \
		src/test/groovy/test/groovy/* || die

	JAVA_GENTOO_CLASSPATH_EXTRA+=":${DISTDIR}/groovy-all-${GAV}.jar"
	java-pkg-simple_src_test
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dolauncher ${PN} --main org.testng.TestNG

	java-pkg_newjar "${DISTDIR}/jquery-${JQV}.jar" jquery.jar
	java-pkg_regjar "${ED}/usr/share/${PN}/lib/jquery.jar"

	java-pkg_register-ant-task
}
