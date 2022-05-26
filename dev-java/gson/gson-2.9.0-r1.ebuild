# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/google/gson/archive/gson-parent-2.9.0.tar.gz --slot 2.6 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild gson-2.9.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.google.code.gson:gson:2.9.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Gson JSON library"
HOMEPAGE="https://github.com/google/gson"
SRC_URI="https://github.com/google/${PN}/archive/${PN}-parent-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2.9"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND="
	virtual/jdk:11
"

# Set to jre-11:* since jre-1.8:* causes errors:
# error: Invalid SafeVarargs annotation. Instance method <T>assertIterationOrder(Iterable<T>,T...) is not final.
# in src/test/java/com/google/gson/internal/LinkedTreeMapTest.java:164:
RDEPEND="
	>=virtual/jre-11:*
"

S="${WORKDIR}/${PN}-${PN}-parent-${PV}/${PN}"

JAVA_SRC_DIR=(
	"src/main/java"
	"src/main/java-templates"
)

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS=(
	"src/test/resources"
)

JAVA_TEST_EXCLUDES=(
	# requires the test class to be obfuscated using proguard which we do not have atm
	"com.google.gson.functional.EnumWithObfuscatedTest"
	# FAILURES!!!
	# Tests run: 1090,  Failures: 3
	# testComGoogleGsonAnnotationsPackage(com.google.gson.regression.OSGiTest)
	# junit.framework.AssertionFailedError: Cannot find com.google.gson OSGi bundle manifest
	"com.google.gson.regression.OSGiTest"
	# testSerializeInternalImplementationObject(com.google.gson.functional.ReflectionAccessTest)
	# java.lang.IllegalStateException: Expected BEGIN_ARRAY but was BEGIN_OBJECT at line 1 column 2 path $
	"com.google.gson.functional.ReflectionAccessTest"
)

src_prepare() {
	default
	sed -i "s/\${project.version}/${PV}/g" src/main/java-templates/com/google/gson/internal/GsonBuildConfig.java || die "Failed to set version"
}
