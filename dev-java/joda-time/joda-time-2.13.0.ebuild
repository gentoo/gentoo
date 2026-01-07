# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="joda-time:joda-time:2.13.0"
JAVA_TESTING_FRAMEWORKS="junit"

inherit edo java-pkg-2 java-pkg-simple

DESCRIPTION="Date and time library to replace JDK date handling"
HOMEPAGE="https://www.joda.org/joda-time/"
SRC_URI="https://github.com/JodaOrg/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

DEPEND="
	dev-java/joda-convert:0
	>=virtual/jdk-1.8:*
"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( NOTICE.txt README.md RELEASE-NOTES.txt )

JAVA_AUTOMATIC_MODULE_NAME="org.joda.time"
JAVA_CLASSPATH_EXTRA="joda-convert"
JAVA_RESOURCE_DIRS="src/main/res"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_RUN_ONLY="org.joda.time.TestAllPackages"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	default
	# move .properties files to JAVA_RESOURCE_DIRS
	mkdir -p src/main/res/META-INF ZoneInfoCompiler || die
	cp -r src/main/{java/*,res} || die
	find src/main/res -type f ! -name '*.properties' -exec rm -rf {} + || die
	mv src/main/res{ources,}/META-INF/native-image || die
}

src_compile() {
	# Generate the missing "org/joda/time/tz/data/ZoneInfoMap"
	# Arguments from https://github.com/JodaOrg/joda-time/blob/v2.10.10/pom.xml#L413-L427
	ejavac \
		-d ZoneInfoCompiler \
		-cp ${JAVA_SRC_DIR}:$(java-pkg_getjars --build-only joda-convert) \
		src/main/java/org/joda/time/tz/ZoneInfoCompiler.java || die

	edo "$(java-config -J)" \
		-cp ZoneInfoCompiler \
		org.joda.time.tz.ZoneInfoCompiler \
		-src "${JAVA_SRC_DIR}/org/joda/time/tz/src" \
		-dst src/main/res/org/joda/time/tz/data \
		africa \
		antarctica \
		asia \
		australasia \
		europe \
		northamerica \
		southamerica \
		etcetera \
		backward || die

	java-pkg-simple_src_compile
}

src_test() {
	# There was 1 error:
	# 1) testZoneInfoProviderResourceLoading(org.joda.time.TestDateTimeZone)java.lang.UnsupportedOperationException:
	# The Security Manager is deprecated and will be removed in a future release
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -lt 21 ; then
		java-pkg-simple_src_test
	else
		einfo "Tests restricted to <jdk-21"
	fi
}
