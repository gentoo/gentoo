# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="jakarta.enterprise:jakarta.enterprise.cdi-api:${PV}"
JAVA_TESTING_FRAMEWORKS="testng"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="APIs for CDI (Contexts and Dependency Injection for Java)"
HOMEPAGE="https://projects.eclipse.org/projects/ee4j.cdi"
SRC_URI="https://github.com/jakartaee/cdi/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/cdi-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

EL_API_SLOT="5.0"

DEPEND="
	dev-java/injection-api:0
	dev-java/jakarta-annotations-api:0
	dev-java/jakarta-el-api:${EL_API_SLOT}
	dev-java/jakarta-interceptors:0
	>=virtual/jdk-11:*
"
RDEPEND=">=virtual/jre-11:*"

DOCS=( CONTRIBUTING.adoc {NOTICE,README}.md )

PATCHES=(
	# https://bugs.gentoo.org/856412
	# org.jboss.cdi.api.test.se.SeContainerInitializerTest # Tests run: 4, Failures: 1
	# org.jboss.cdi.api.test.CDITest # Tests run: 11, Failures: 5
	"${FILESDIR}/cdi-api-4.0.1-skip-tests.patch"
)

JAVA_TEST_EXCLUDES=(
	# Tests run: 1, Failures: 1
	org.jboss.cdi.api.test.privileged.CDIPrivilegedTest
)
JAVA_TEST_EXTRA_ARGS=( -DserviceDir="target/test-classes/META-INF/services" )
JAVA_TEST_GENTOO_CLASSPATH="testng"
JAVA_TEST_SRC_DIR="api/src/test/java"
JAVA_TEST_RESOURCE_DIRS="api/src/test/resources"
JAVADOC_SRC_DIRS=(
	"lang-model/src/main/java"
	"api/src/main/java"
)

src_prepare(){
	default # https://bugs.gentoo.org/780585
	java-pkg-2_src_prepare
}

src_compile() {
	JAVA_CLASSPATH_EXTRA="
		injection-api
		jakarta-annotations-api
		jakarta-el-api-${EL_API_SLOT}
		jakarta-interceptors
	"
	JAVA_SRC_DIR="lang-model/src/main/java"
	JAVA_JAR_FILENAME="lang-model.jar"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":lang-model.jar"
	rm -r target || die

	JAVA_SRC_DIR="api/src/main/java"
	JAVA_RESOURCE_DIRS="api/src/main/resources"
	JAVA_JAR_FILENAME="cdi-api.jar"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":cdi-api.jar"
	rm -r target || die

	einfo "running ejavadoc"
	JAVADOC_CLASSPATH="${JAVA_CLASSPATH_EXTRA}"
	rm {api,lang-model}/src/main/java/module-info.java || die #923599
	use doc && ejavadoc
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dojar "lang-model.jar"

	if use source; then
		java-pkg_dosrc "lang-model/src/main/java/*"
		java-pkg_dosrc "api/src/main/java/*"
	fi
}
