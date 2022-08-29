# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/google/gson/archive/gson-parent-2.9.1.tar.gz --slot 2.6 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild gson-2.9.1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.google.code.gson:gson:2.9.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Gson JSON library"
HOMEPAGE="https://github.com/google/gson"
SRC_URI="https://github.com/google/gson/archive/gson-parent-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2.6"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND=">=virtual/jdk-11:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/gson-gson-parent-${PV}/gson"

JAVA_SRC_DIR=(
	"src/main/java"
	"src/main/java-templates"
)

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

JAVA_TEST_EXCLUDES=(
	# requires the test class to be obfuscated using proguard which we do not have atm
	"com.google.gson.functional.EnumWithObfuscatedTest"
	# FAILURES!!!
	# Tests run: 1135,  Failures: 3
	# testComGoogleGsonAnnotationsPackage(com.google.gson.regression.OSGiTest)
	# junit.framework.AssertionFailedError: Cannot find com.google.gson OSGi bundle manifest
	"com.google.gson.regression.OSGiTest"
	# testSerializeInternalImplementationObject(com.google.gson.functional.ReflectionAccessTest)
	# java.lang.IllegalStateException: Expected BEGIN_ARRAY but was BEGIN_OBJECT at line 1 column 2 path $
	"com.google.gson.functional.ReflectionAccessTest"
)

src_prepare() {
	default
	sed -e "s/\${project.version}/${PV}/g" \
		-i src/main/java-templates/com/google/gson/internal/GsonBuildConfig.java \
			|| die "Failed to set version"

	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge "17" ; then
		JAVA_TEST_EXCLUDES+=( "com.google.gson.internal.bind.DefaultDateTypeAdapterTest" )
	fi
}
