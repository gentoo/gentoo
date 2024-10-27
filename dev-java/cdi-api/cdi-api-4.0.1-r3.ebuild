# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="jakarta.enterprise:jakarta.enterprise.cdi-api:4.0.1"
JAVA_TESTING_FRAMEWORKS="testng"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="APIs for CDI (Contexts and Dependency Injection for Java)"
HOMEPAGE="https://projects.eclipse.org/projects/ee4j.cdi"
SRC_URI="https://github.com/jakartaee/cdi/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/cdi-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

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

JAVA_GENTOO_CLASSPATH_EXTRA="cdi-api.jar"	# tests need it on classpath
JAVA_TEST_EXCLUDES=(
	# Tests run: 1, Failures: 1
	org.jboss.cdi.api.test.privileged.CDIPrivilegedTest
)
JAVA_TEST_EXTRA_ARGS=( -DserviceDir="target/test-classes/META-INF/services" )
JAVA_TEST_GENTOO_CLASSPATH="injection-api testng"
JAVA_TEST_RESOURCE_DIRS="api/src/test/resources"
JAVA_TEST_SRC_DIR="api/src/test/java"

src_prepare(){
	default #780585
	java-pkg-2_src_prepare

	# fixing the directory structure to allow multi-mode compilation
	mkdir -p src/jakarta.cdi{,.lang.model} || die
	cp -r api/src/main/java/* src/jakarta.cdi/ || die
	cp -r lang-model/src/main/java/* src/jakarta.cdi.lang.model || die
}

src_compile() {
	mkdir -p target/classes || die

	# getting the modulepath
	DEPENDENCIES=(
		jakarta-el-api-${EL_API_SLOT}
		jakarta-annotations-api
		jakarta-interceptors
		injection-api
	)
	local modulepath
	for dependency in ${DEPENDENCIES[@]}; do
		modulepath="${modulepath}:$(java-pkg_getjars --build-only ${dependency})"
	done

	# Multi-module compilation, https://openjdk.org/projects/jigsaw/quick-start
	ejavac -d target/classes \
		--module-version ${PV} \
		--module-path "${modulepath}" \
		--module-source-path ./src $(find src -type f -name '*.java') || die

	if use doc; then
		ejavadoc -d target/api \
		--module-path "${modulepath}" \
		--module-source-path ./src $(find src -type f -name '*.java') || die
	fi

	# packaging seems possible only per each module (?)
	jar cvf cdi-api.jar -C target/classes/jakarta.cdi . || die
	jar cvf lang-model.jar -C target/classes/jakarta.cdi.lang.model . || die

	java-pkg_addres cdi-api.jar api/src/main/resources
}

src_install() {
	java-pkg_dojar {cdi-api,lang-model}.jar

	use doc && java-pkg_dojavadoc target/api

	if use source; then
		java-pkg_dosrc lang-model/src/main/java/*
		java-pkg_dosrc api/src/main/java/*
	fi

	einstalldocs
}
